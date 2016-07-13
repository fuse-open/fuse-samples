using Fuse.Scripting;
using Uno.Permissions;
using Uno.Threading;
using Uno.UX;
using Uno;

[UXGlobalModule]
public class FacebookLoginModule : NativeModule
{
	class FacebookLoginPromise : Promise<FacebookLogin.AccessToken>
	{
		readonly FacebookLogin _facebookLogin;

		public FacebookLoginPromise(FacebookLogin facebookLogin)
		{
			_facebookLogin = facebookLogin;
			if defined(Android)
			{
				Permissions.Request(Permissions.Android.INTERNET).Then(
					OnPermissionsPermitted,
					OnPermissionsRejected);
			}
			else
			{
				Fuse.UpdateManager.AddOnceAction(Login);
			}
		}

		void Login()
		{
			if defined(iOS || Android)
				_facebookLogin.Login(this.Resolve, OnCancelled, OnError);
			else
				throw new NotImplementedException();
		}

		void OnCancelled()
		{
			Reject(new Exception("Cancelled"));
		}

		void OnError(string error)
		{
			Reject(new Exception(error));
		}

		extern(Android) void OnPermissionsPermitted(PlatformPermission p)
		{
			Fuse.UpdateManager.AddOnceAction(Login);
		}

		extern(Android) void OnPermissionsRejected(Exception e)
		{
			Reject(e);
		}
	}

	static readonly FacebookLoginModule _instance;
	readonly FacebookLogin _facebookLogin;

	public FacebookLoginModule()
	{
		if (_instance != null)
			return;

		_facebookLogin = new FacebookLogin();

		_instance = this;
		Resource.SetGlobalKey(_instance, "FacebookLogin");
		AddMember(new NativePromise<FacebookLogin.AccessToken, External>("login", Login, Converter));
	}

	Future<FacebookLogin.AccessToken> Login(object[] args)
	{
		return new FacebookLoginPromise(_facebookLogin);
	}

	External Converter(Context context, FacebookLogin.AccessToken accessToken)
	{
		return new External(accessToken);
	}
}
