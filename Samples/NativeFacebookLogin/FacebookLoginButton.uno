using Uno;
using Uno.Permissions;
using Fuse.Controls;

public class FacebookLoginButton : Button
{
	FacebookLogin _facebookLogin;
	public FacebookLoginButton()
		: base()
	{
		_facebookLogin = new FacebookLogin();
		Fuse.Gestures.Clicked.AddHandler(this, ClickHandler);
	}

	public void ClickHandler(object x, object y)
	{
		if defined(Android)
		{
			Permissions.Request(Permissions.Android.INTERNET).Then(
				OnPermissionsPermitted,
				OnPermissionsRejected);
		}
		else
		{
			Login();
		}
	}

	void Login()
	{
		_facebookLogin.Login(OnSuccess, OnCancelled, OnError);
	}

	extern(Android) void OnPermissionsPermitted(PlatformPermission p)
	{
		Login();
	}

	void OnSuccess(FacebookLogin.AccessToken token)
	{
		debug_log "Login successful";
	}

	void OnCancelled()
	{
		debug_log "Login cancelled";
	}

	void OnError(string reason)
	{
		debug_log "Login failed: " + reason;
	}

	extern(Android) void OnPermissionsRejected(Exception e)
	{
		debug_log "Permission rejected: " + e.Message;
	}
}
