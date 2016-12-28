using Fuse;
using Fuse.Platform;
using Uno;
using Uno.Compiler.ExportTargetInterop;

[extern(iOS) Require("Xcode.FrameworkDirectory", "@('FacebookSDKs-iOS':Path)")]
[extern(iOS) Require("Xcode.Framework", "@('FacebookSDKs-iOS/FBSDKCoreKit.framework':Path)")]
[extern(iOS) Require("Xcode.Framework", "@('FacebookSDKs-iOS/FBSDKLoginKit.framework':Path)")]
[extern(iOS) ForeignInclude(Language.ObjC, "FBSDKCoreKit/FBSDKCoreKit.h")]
[extern(iOS) ForeignInclude(Language.ObjC, "FBSDKLoginKit/FBSDKLoginKit.h")]
[Require("Gradle.Dependency","compile('com.facebook.android:facebook-android-sdk:4.8.+') { exclude module: 'support-v4' }")]
[Require("Gradle.Repository","mavenCentral()")]
[ForeignInclude(Language.Java, "android.content.Intent")]
[ForeignInclude(Language.Java, "com.facebook.*")]
[ForeignInclude(Language.Java, "com.facebook.appevents.AppEventsLogger")]
[ForeignInclude(Language.Java, "org.json.JSONObject")]
[ForeignInclude(Language.Java, "org.json.JSONException")]
[ForeignInclude(Language.Java, "android.os.Bundle")]
[ForeignInclude(Language.Java, "com.facebook.login.*")]
[ForeignInclude(Language.Java, "com.fuse.Activity")]
public class FacebookLogin
{
	public FacebookLogin()
	{
		Lifecycle.Started += Started;
		Lifecycle.EnteringInteractive += OnEnteringInteractive;
		Lifecycle.ExitedInteractive += OnExitedInteractive;
		InterApp.ReceivedURI += OnReceivedUri;
	}

	[Foreign(Language.ObjC)]
	extern(iOS) void Started(ApplicationState state)
	@{
		[[FBSDKApplicationDelegate sharedInstance]
			application: [UIApplication sharedApplication]
			didFinishLaunchingWithOptions: nil];
	@}

	extern(Android) Java.Object _callbackManager;

	[Foreign(Language.Java)]
	extern(Android) void Started(ApplicationState state)
	@{
		FacebookSdk.sdkInitialize(Activity.getRootActivity());
		final CallbackManager callbackManager = CallbackManager.Factory.create();
		@{FacebookLogin:Of(_this)._callbackManager:Set(callbackManager)};
		Activity.subscribeToResults(new Activity.ResultListener()
		{
			@Override
			public boolean onResult(int requestCode, int resultCode, Intent data)
			{
				return callbackManager.onActivityResult(requestCode, resultCode, data);
			}

		});
	@}

	extern(!iOS && !Android) void Started(ApplicationState state)
	{
	}

	[Foreign(Language.ObjC)]
	static extern(iOS) void OnEnteringInteractive(ApplicationState state)
	@{
		[FBSDKAppEvents activateApp];
	@}

	[Foreign(Language.Java)]
	static extern(Android) void OnEnteringInteractive(ApplicationState state)
	@{
		AppEventsLogger.activateApp(Activity.getRootActivity());
	@}

	static extern(!iOS && !Android) void OnEnteringInteractive(ApplicationState state)
	{
	}

	[Foreign(Language.Java)]
	static extern(Android) void OnExitedInteractive(ApplicationState state)
	@{
		AppEventsLogger.deactivateApp(Activity.getRootActivity());
	@}

	static extern(!Android) void OnExitedInteractive(ApplicationState state)
	{
	}

	static void OnReceivedUri(string uri)
	{
		debug_log "Received Uri: " + uri;
		if (uri.StartsWith("fb"))
		{
			OpenFacebookURL(uri);
		}
	}

	[Foreign(Language.ObjC)]
	static extern(iOS) void OpenFacebookURL(string url)
	@{
		[[FBSDKApplicationDelegate sharedInstance]
			application: [UIApplication sharedApplication]
			openURL: [NSURL URLWithString:url]
			sourceApplication: @"com.apple.mobilesafari"
			annotation: nil];
	@}

	static extern(!iOS) void OpenFacebookURL(string url)
	{
	}

	public class AccessToken
	{
		extern(iOS) ObjC.Object _token;
		extern(Android) Java.Object _token;
		public extern(iOS) AccessToken(ObjC.Object token)
		{
			_token = token;
		}
		public extern(Android) AccessToken(Java.Object token)
		{
			_token = token;
		}
	}

	public class User
	{
		extern(Android) string _id;
		extern(Android) string _name;
		extern(Android) string _email;

		public extern(Android) User(String id, String name, String email)
		{
			_id = id;
			_name = name;
			_email = email;
		}

		public extern(Android) string getId() {
			return _id;
		}

		public extern(Android) string getName() {
			return _name;
		}

		public extern(Android) string getEmail() {
			return _email;
		}
	}

	[Foreign(Language.ObjC)]
	public extern(iOS) void Login(Action<AccessToken> onSuccess, Action onCancelled, Action<string> onError)
	@{
		FBSDKLoginManager* login = [[FBSDKLoginManager alloc] init];
		[login
			logInWithReadPermissions: @[@"public_profile"]
			fromViewController: [[[UIApplication sharedApplication] keyWindow] rootViewController]
			handler: ^(FBSDKLoginManagerLoginResult* result, NSError* error)
			{
				if (error)
				{
					onError([error localizedDescription]);
					return;
				}
				if (result.isCancelled)
				{
					onCancelled();
					return;
				}
				id<UnoObject> unoAccessToken = @{AccessToken(ObjC.Object):New(result.token)};
				onSuccess(unoAccessToken);
			}
		];
	@}

	[Foreign(Language.Java)]
	[Require("Entity", "User(string, string, string)")]
	public extern(Android) void Login(Action<User> onSuccess, Action onCancelled, Action<string> onError)
	@{
		CallbackManager callbackManager = (CallbackManager)@{FacebookLogin:Of(_this)._callbackManager:Get()};
		LoginManager.getInstance().registerCallback(callbackManager,
			new FacebookCallback<LoginResult>()
			{
				@Override
				public void onSuccess(LoginResult loginResult)
				{
					AccessToken accessToken = loginResult.getAccessToken();
					// TODO this should be UnoObject when https://github.com/fusetools/uno/issues/602
					// has been fixed
					//UnoObject unoAccessToken = @{AccessToken(Java.Object):New(accessToken)};
					//onSuccess.run(unoAccessToken);

					GraphRequest request = GraphRequest.newMeRequest(
                        loginResult.getAccessToken(),
                        new GraphRequest.GraphJSONObjectCallback() {
                            @Override
                            public void onCompleted(
                                    JSONObject object,
                                    GraphResponse response) {
                                try {
                                    String fbUserId = object.getString("id");
                                    String fbUserName = object.getString("name");
                                    String fbEmail = object.getString("email");

									UnoObject user = @{User(string, string, string):New(fbUserId, fbUserName, fbEmail)};
									onSuccess.run(user);
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }
                        });
	                Bundle parameters = new Bundle();
	                parameters.putString("fields", "id,name,email");
	                request.setParameters(parameters);
	                request.executeAsync();
				}

				@Override
				public void onCancel()
				{
					onCancelled.run();
				}

				@Override
				public void onError(FacebookException exception)
				{
					onError.run(exception.toString());
				}
			}
		);
		LoginManager.getInstance().logInWithReadPermissions(Activity.getRootActivity(), java.util.Arrays.asList("public_profile", "email"));
	@}
}
