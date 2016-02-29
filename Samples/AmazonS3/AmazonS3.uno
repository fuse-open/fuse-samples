using Uno;
using Uno.Compiler.ExportTargetInterop;
using Android.Base.Wrappers;

public extern (!Android && !iOS) class AmazonS3
{
	public AmazonS3(string poolId)
	{
	}

	public void Download(string bucket, string key, string suggestedFileName, TransferListener listener)
	{
		listener.OnError("Operation not supported on this platform");
	}
}

public abstract class TransferListener
{
	public abstract void OnStateChanged(string fileName, string state);
	public abstract void OnProgressChanged(long bytesCurrent, long bytesTotal);
	public abstract void OnError(string error);
}

[TargetSpecificImplementation]
public extern(Android) class AmazonS3
{
	Java.Object _transferUtility;
	Java.Object _credentialsProvider;
	Java.Object _s3Client;

	public AmazonS3(string poolId)
	{
		Init(poolId);
	}

	[Foreign(Language.Java)]
	void Init(string poolId)
	@{
		com.amazonaws.auth.CognitoCachingCredentialsProvider credentialsProvider = new com.amazonaws.auth.CognitoCachingCredentialsProvider(
			com.fuse.Activity.getRootActivity(),
			poolId,
			com.amazonaws.regions.Regions.EU_WEST_1);

		com.amazonaws.services.s3.AmazonS3 s3 = new com.amazonaws.services.s3.AmazonS3Client(credentialsProvider);
		s3.setRegion(com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.EU_WEST_1));

		com.amazonaws.mobileconnectors.s3.transferutility.TransferUtility transferUtility
			= new com.amazonaws.mobileconnectors.s3.transferutility.TransferUtility(
				s3,
				com.fuse.Activity.getRootActivity());

		@{AmazonS3:Of(_this)._transferUtility:Set(transferUtility)};
		@{AmazonS3:Of(_this)._credentialsProvider:Set(credentialsProvider)};
		@{AmazonS3:Of(_this)._s3Client:Set(s3)};
	@}

	[Foreign(Language.Java)]
	public void Download(string bucket, string key, string suggestedFileName, TransferListener listener)
	@{
		com.amazonaws.mobileconnectors.s3.transferutility.TransferUtility transferUtility
			= (com.amazonaws.mobileconnectors.s3.transferutility.TransferUtility)@{AmazonS3:Of(_this)._transferUtility:Get()};
		java.io.File file = new java.io.File(
			com.fuse.Activity.getRootActivity().getFilesDir(),
			suggestedFileName);
		final String fileName = file.getAbsolutePath();
		com.amazonaws.mobileconnectors.s3.transferutility.TransferObserver transferObserver
			= transferUtility.download(bucket, key, file);
		transferObserver.setTransferListener(new com.amazonaws.mobileconnectors.s3.transferutility.TransferListener()
		{
			@Override
			public void onStateChanged(int id, com.amazonaws.mobileconnectors.s3.transferutility.TransferState state)
			{
				@{TransferListener:Of(listener).OnStateChanged(string, string):Call(fileName, state.name())};
			}

			@Override
			public void onProgressChanged(int id, long bytesCurrent, long bytesTotal)
			{
				@{TransferListener:Of(listener).OnProgressChanged(long, long):Call(bytesCurrent, bytesTotal)};
			}

			@Override
			public void onError(int id, Exception ex)
			{
				@{TransferListener:Of(listener).OnError(string):Call(ex.getMessage())};
			}
		});
	@}
}

[Require("Xcode.FrameworkDirectory", "@('aws-ios-sdk-2.3.5/frameworks':Path)")]
[Require("Xcode.Framework", "@('aws-ios-sdk-2.3.5/frameworks/AWSCore.framework':Path)")]
[Require("Xcode.Framework", "@('aws-ios-sdk-2.3.5/frameworks/AWSS3.framework':Path)")]
[Require("Source.Include", "AWSCore/AWSCore.h")]
[Require("Source.Include", "AWSS3/AWSS3.h")]
public extern(iOS) class AmazonS3
{
	public AmazonS3(string poolId)
	{
		Init(poolId);
	}

	[Foreign(Language.ObjC)]
	void Init(string poolId)
	@{
		[AWSLogger defaultLogger].logLevel
			= AWSLogLevelVerbose;
		AWSCognitoCredentialsProvider* credentialsProvider
			= [[AWSCognitoCredentialsProvider alloc]
				initWithRegionType: AWSRegionEUWest1
				identityPoolId: poolId];
		AWSServiceConfiguration* configuration
			= [[AWSServiceConfiguration alloc]
				initWithRegion: AWSRegionEUWest1
				credentialsProvider: credentialsProvider];
		AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
	@}

	[Foreign(Language.ObjC)]
	public void Download(string bucket, string key, string suggestedFileName, TransferListener listener)
	@{
		NSString *documentsDirectory
			= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

		NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, suggestedFileName];
		NSLog(@"filePath %@", filePath);

		NSFileManager* fileManager = [NSFileManager defaultManager];

		NSError* error;
		BOOL success = [fileManager removeItemAtPath: filePath error: &error];
		if (!success)
		{
			NSLog(@"%@", error.localizedDescription);
		}

		if (![fileManager isWritableFileAtPath: filePath])
		{
			    NSLog(@"File not writable");
		}

		AWSS3TransferManager* transferManager
			= [AWSS3TransferManager defaultS3TransferManager];
		AWSS3TransferManagerDownloadRequest* downloadRequest
			= [AWSS3TransferManagerDownloadRequest new];
		downloadRequest.bucket = bucket;
		downloadRequest.key = key;
		downloadRequest.downloadingFileURL = [NSURL fileURLWithPath: filePath];
		downloadRequest.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
			@{TransferListener:Of(listener).OnProgressChanged(long, long):Call(totalBytesWritten, totalBytesExpectedToWrite)};
		};
		[[transferManager download:downloadRequest]
			continueWithBlock: ^ id(AWSTask* task)
			{
				if (task.error)
				{
					@{TransferListener:Of(listener).OnError(string):Call(task.error.localizedDescription)};
				}
				else
				{
					NSString* path = [[task.result body] path];
					@{TransferListener:Of(listener).OnStateChanged(string, string):Call(path, @"COMPLETED")};
				}
				return nil;
			}];
	@}
}
