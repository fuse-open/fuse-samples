module.exports = {
	OAuthRoot: "https://login.microsoftonline.com/",

	Tentant: "<Tentant>",							//Replace with info from Azure Portal
	ClientID: "<ClientId>",							//Replace with info from Azure Portal
	ClientSecret: "<ClientSecret>",					//Replace with info from Azure Portal

	Scope: "offline_access",

	SignUpPolicy: "B2C_1_Signup",					//Replace with your Extensible policy for signup label
	SignInPolicy: "B2C_1_SignIn",					//Replace with your Extensible policy for signin label
	EditProfilePolicy: "B2C_1_EditProfile",			//Replace with your Extensible policy for editing label

	OAuthResponseType: "code",
	OAuthResponseMode: "query",

	RedirectUri: "urn:ietf:wg:oauth:2.0:oob"		// Oauth 2.0 Default URI
};
