using Uno;
using Uno.Permissions;
using Fuse.Controls;

public class FacebookLoginButton : Button
{
	Facebook _facebook;
	public FacebookLoginButton()
		: base()
	{
		_facebook = new Facebook();
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
		_facebook.Login(OnSuccess, OnCancelled, OnError);
	}

	extern(Android) void OnPermissionsPermitted(PlatformPermission p)
	{
		Login();
	}

	void OnSuccess(Facebook.AccessToken token)
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
