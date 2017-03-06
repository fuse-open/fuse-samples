/* ---------------------------------------------------------------------------------------------
                                  Azure AD B2C OAuth v0.9
                          Contributed to fuse-samples by snap608 :)
               	 This code is not 100% failsafe. Contributions is welcome.
--------------------------------------------------------------------------------------------- */

var Observable = require("FuseJS/Observable");
var FileSystem = require("FuseJS/FileSystem");
var InterApp = require("FuseJS/InterApp");
var Base64 = require("FuseJS/Base64");
var Auth = require("Auth");

var userOAuthStoragePath = FileSystem.dataDirectory + "/OAuthInfo.txt";

var IsUserLoggingIn = Observable(false);
var IsUserLoggedIn = Observable(false);
var UserFirstName = Observable("");
var UserLastName = Observable("");
var UserEmail = Observable("");

function OAuthSignUp(){
	IsUserLoggingIn.value = true;
	checkListeners();
	var uri = Auth.OAuthRoot + Auth.Tentant + "/oauth2/v2.0/authorize?client_id=" + Auth.ClientID + "&response_type=" + Auth.OAuthResponseType + "&response_mode=" + Auth.OAuthResponseMode + "&redirect_uri="+ encodeURIComponent(Auth.RedirectUri) +"&scope=" + Auth.ClientID + "+"+ Auth.Scope +"&state=signup&p="+ Auth.SignUpPolicy;
	InterApp.launchUri(uri);
	return true;
}

function OAuthSignIn(){
	IsUserLoggingIn.value = true;
	checkListeners();
	var uri = Auth.OAuthRoot + Auth.Tentant + "/oauth2/v2.0/authorize?client_id=" + Auth.ClientID + "&response_type=" + Auth.OAuthResponseType + "&response_mode=" + Auth.OAuthResponseMode + "&redirect_uri="+ encodeURIComponent(Auth.RedirectUri) +"&scope=" + Auth.ClientID + "+"+ Auth.Scope +"&state=signin&p="+ Auth.SignInPolicy;
	InterApp.launchUri(uri);
	return true;
}

function OAuthEditProfile(){
	var uri = Auth.OAuthRoot + Auth.Tentant + "/oauth2/v2.0/authorize?client_id=" + Auth.ClientID + "&response_type=" + Auth.OAuthResponseType + "&response_mode=" + Auth.OAuthResponseMode + "&redirect_uri="+ encodeURIComponent(Auth.RedirectUri) +"&scope=" + Auth.ClientID + "+"+ Auth.Scope +"&state=editprofile&p="+ Auth.EditProfilePolicy;
	checkListeners();
	InterApp.launchUri(uri);
	return true;
}

function OAuthLogout() {
	IsUserLoggedIn.value = false;
	IsUserLoggingIn.value = false;

	UserFirstName.value = "";
	UserLastName.value = "";
	UserEmail.value = "";

	if(FileSystem.existsSync(userOAuthStoragePath))
	{
		FileSystem.deleteSync(userOAuthStoragePath);
	}
}

function OAuthInfo() {
	if(FileSystem.existsSync(userOAuthStoragePath))
	{
		var oAuthInfo = FileSystem.readTextFromFileSync(userOAuthStoragePath);
		var info = JSON.parse(oAuthInfo);
		validateState(info);
		extractUserInfo(info);
		return info;
	} else {
		return null;
	}
}

function extractUserInfo(info) {
	if(info != null && info.access_token != null)
	{
		var payloadParts = info.access_token.split(".");
		if(payloadParts.length > 2)
		{
			var jwtPayload = base64UrlDecode(payloadParts[1]);
			var infoString = Base64.decodeUtf8(jwtPayload);
			var info = JSON.parse(infoString);
			UserFirstName.value = info.given_name;
			UserLastName.value = info.family_name;
			UserEmail.value = info.emails[0];
		}
	}
}

function checkListeners() {
	InterApp.removeAllListeners("receivedUri");

	InterApp.on("receivedUri", function (uri) {
		var code = extractCode(uri);
		submitCodeForOAuthInfo("code", code).then(function(oAuthInfo) {
			IsUserLoggedIn.value = true;
		});
		IsUserLoggingIn.value = false;
	});
};

function validateState(oAuthInfo) {

	var expire = new Date(0); //Epoc
	expire.setUTCSeconds(oAuthInfo.expires_on);

	if(Date.now() > expire)
	{
		submitCodeForOAuthInfo("refreshToken", oAuthInfo.refresh_token).then(function() {
			IsUserLoggedIn.value = true;
		});
	} else {
		IsUserLoggedIn.value = true;
	}

}

function extractCode(uri){
	var codeStart = uri.substring(uri.search("code="), uri.length);
	var codeEnd = codeStart.search("&");
	if (codeEnd === -1)
		codeEnd = codeStart.length;
	code = codeStart.substring(0, codeEnd).split("=")[1];
	return code;
}

function submitCodeForOAuthInfo(type, code){
	var uri = Auth.OAuthRoot + Auth.Tentant + "/oauth2/v2.0/token?p="+ Auth.SignInPolicy;
	var body = {};
	if(type == "code") {
	 	body = createUrlParams({
				"grant_type": "authorization_code",
				"client_id": Auth.ClientID,
				"scope": Auth.ClientID +" "+ Auth.Scope,
				"code": code
			});
	 } else {
	 	 	body = createUrlParams({
				"grant_type": "refresh_token",
				"client_id": Auth.ClientID,
				"scope": Auth.ClientID +" "+ Auth.Scope,
				"refresh_token": code
			});

	 }

	return new Promise(function(resolve, reject){

		fetch(uri, {
			method: "POST",
			headers: {
				"Content-Type":"application/x-www-form-urlencoded"
			},
			body: body
		}).then(function(response){
			return response.json();
		}).then(function(responseObject){
			FileSystem.writeTextToFileSync(FileSystem.dataDirectory + "/OAuthInfo.txt", JSON.stringify(responseObject));
			extractUserInfo(responseObject);
			resolve(responseObject);
		}).catch(function(err){
			reject(JSON.stringify(err));
		});

	});
}

//Since JWT Standard is processed striping all illegal chars
//we need to add them again before Base64 decoding
function base64UrlDecode(s)
{
	s = s.replace('-', '+'); // 62nd char of encoding
	s = s.replace('_', '/'); // 63rd char of encoding
	switch (s.length % 4)
	{
		case 0: break; // No pad chars in this case
		case 2: s += "=="; break; // Two pad chars
		case 3: s += "="; break; // One pad char
	}
	return s; // Standard base64 format
}

function createUrlParams(obj) {
    var str = [];
    for(var p in obj)
    str.push(p + "=" + encodeURIComponent(obj[p]));
    return str.join("&");
}

module.exports = {
	OAuthSignUp: OAuthSignUp,
	OAuthSignIn: OAuthSignIn,
	OAuthEditProfile: OAuthEditProfile,
	OAuthInfo: OAuthInfo,
	OAuthLogout: OAuthLogout,
	IsUserLoggingIn: IsUserLoggingIn,
	IsUserLoggedIn: IsUserLoggedIn,
	UserFirstName: UserFirstName,
	UserLastName: UserLastName,
	UserEmail: UserEmail
};