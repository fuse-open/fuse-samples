using Experimental.TextureLoader;
using Fuse.Scripting;
using Fuse.Resources;
using Uno.Graphics;
using Uno.Platform;
using Uno.Threading;
using Uno.UX;
using Uno;

public class TextureSetterTransferListener: TransferListener
{
	public override void OnStateChanged(string fileName, string state)
	{
		if (state == "COMPLETED")
		{
			debug_log "Download of " + fileName + " completed";
			var bytes = Uno.IO.File.ReadAllBytes(fileName);
			var buffer = new Buffer(bytes);
			Fuse.UpdateManager.Dispatcher.Invoke2<Buffer, string>(LoadTexture, buffer, fileName);
		}
		else
		{
			debug_log "Download of " + fileName + " state changed to: " + state;
		}
	}

	void LoadTexture(Buffer buffer, string fileName)
	{
		TextureLoader.ByteArrayToTexture2DFilename(buffer, fileName, SetImageTexture);
	}

	void SetImageTexture(texture2D tex)
	{
		MainView.PictureTexture.Texture = tex;
	}

	public override void OnProgressChanged(long bytesCurrent, long bytesTotal)
	{
		debug_log "Download progress: " + ((bytesCurrent * 100) / bytesTotal) + "%";
	}

	public override void OnError(string error)
	{
		throw new Exception(error);
	}
}

[UXGlobalModule]
public class S3ImageDownloader : NativeModule
{
	public S3ImageDownloader()
	{
		Resource.SetGlobalKey(this, "S3ImageDownloader");
		AddMember(new NativeFunction("start", (NativeCallback)StartDownloader));
	}

	public object StartDownloader(Context c, object[] args)
	{
		Start();
		return null;
	}

	static void Start()
	{
		var s3 = new AmazonS3("<MY-POOLID>");
		s3.Download("<MY-BUCKET>", "<MY-FILEKEY>", "tempfile.jpg", new TextureSetterTransferListener());
	}
}
