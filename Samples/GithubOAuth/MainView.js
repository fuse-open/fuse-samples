var Observable = require("FuseJS/Observable");
var InterApp = require("FuseJS/InterApp");
var Auth = require("Auth");

var clientID = Auth.clientID;
var clientSecret = Auth.clientSecret;

function startGithubAuth(){
	var uri = "https://github.com/login/oauth/authorize?client_id=" + clientID + "&scope=repo" + "&redirect_uri=fusegithub://fusegithub/code";
	InterApp.launchUri(uri);
}

function extractCode(uri){
	var codeStart = uri.substring(uri.search("code="), uri.length);
	var codeEnd = codeStart.search("&");
	if (codeEnd === -1)
		codeEnd = codeStart.length;
	code = codeStart.substring(0, codeEnd).split("=")[1];
	return code;
}

function submitCodeForAccessToken(c){
	var uri = "https://github.com/login/oauth/access_token?";
	uri += "client_id=" + clientID;
	uri += "&client_secret=" + clientSecret;
	uri += "&code=" + c;

	fetch(uri, {
		method: "POST",
		headers: { "Accept": "application/json"}
	}).then(function(response){
		return response.json();
	}).then(function(responseObject){
		accessToken.value = responseObject.access_token;
	}).catch(function(err){
		console.log(JSON.stringify(err));
	});
}

InterApp.onReceivedUri = function(uri){
	var c = extractCode(uri);
	submitCodeForAccessToken(c);
};

var accessToken = Observable("");
var baseUri = "https://api.github.com";

var issues = Observable();
function getIssuesForRepo(owner, repo){
	var uri = baseUri + "/repos/"+owner+"/"+repo+"/issues?";
	uri += "access_token=" + accessToken.value;
	uri += "&state=all";
	fetch(uri,{
		method: "GET",
		headers: { "Accept": "application/json"}
	}).then(function(response){
		return response.json();
	}).then(function(json){
		issues.clear();
		for (var i = 0; i < json.length; i++){
			var item = json[i];
			issues.add({
				title: Observable(item.title),
				body: Observable(item.body),
				author: Observable(item.user.login),
				state: Observable(item.state)
			});
		}
	});
}

function Repo(name, owner){
	this.name = Observable(name);
	this.owner = Observable(owner);
	this.clicked_handler = function(){
		getIssuesForRepo(this.owner.value, this.name.value);
	}.bind(this);
}

var repos = Observable();
function getRepos(){
	var uri = baseUri + "/user/repos?";
	uri += "access_token=" + accessToken.value;
	fetch(uri,{
		method: "GET",
		headers: { "Accept": "application/json"}
	}).then(function(response){
		return response.json();
	}).then(function(json){
		repos.clear();
		for (var i = 0; i < json.length; i++){
			var item = json[i];
			repos.add(new Repo(item.name, item.owner.login));
		}
	});
}



module.exports = {
	startGithubAuth: startGithubAuth,
	getRepos: getRepos,
	issues:issues,
	repos:repos
};
