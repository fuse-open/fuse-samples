var Observable = require("FuseJS/Observable");
var Auth = require("Auth");

function stringContainsString(s1, s2){
	return s1.indexOf(s2) > -1;
}

var showWebView = Observable(false);

var accessToken = Observable("");

var client_id = Auth.client_id;
var url = Observable("about:blank");

function login(){
	url.value = "https://www.facebook.com/dialog/oauth?client_id=" + client_id + "&response_type=token&redirect_uri=https://www.facebook.com/connect/login_success.html";

	showWebView.value = true;
}

function pageLoaded(res){
	var uri = JSON.parse(res.json).url;
	console.log("Final URI: " + uri);
	if (stringContainsString(uri, "access_token=")){
		var tmp = uri.split("access_token=")[1];
		var at = tmp.split("&")[0];
		accessToken.value = at;
		showWebView.value = false;
		getMe();
	}
}

var myName = Observable("");
var myPicture = Observable();
var hasProfile = Observable(false);
function getMe(){
	var url = "https://graph.facebook.com/v2.5/me?fields=name&";
	url += "access_token=" + accessToken.value;

	fetch(url,{
		method:"GET"
	}).then(function(result){
		return result.json();
	}).then(function(resultJson){
		myName.value = resultJson.name;
	}).catch(function(error){
		console.log("Error: " + error);
	});


	console.log("Trying to get picture");
	var pictureUrl = "https://graph.facebook.com/v2.5/me/picture?type=large&redirect=false&access_token=" + accessToken.value;
	fetch(pictureUrl, {
		method:"GET"
	}).then(function(result){
		return result.json();
	}).then(function(resultJson){
		myPicture.value = resultJson.data.url;
		hasProfile.value = true;
	}).catch(function(error){
		console.log("Error: " + error);
	});



}


module.exports = {
	login:login,
	pageLoaded: pageLoaded,
	url: url,
	getMe : getMe,
	myName: myName,
	myPicture: myPicture,
	showWebView: showWebView,
	hasProfile: hasProfile
};
