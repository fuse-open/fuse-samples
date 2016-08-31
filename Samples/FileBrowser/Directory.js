
var FileSystem = require('FuseJS/FileSystem');
var Observable = require('FuseJS/Observable');

function pathToName(str) {
	if (str === "/")
		return str;
	var lastSep = str.lastIndexOf("/");
	if (lastSep === null)
		return str;
	return str.substring(lastSep + 1);
}

function toHumanFriendly(length) {
	var kib = 1024.0;
	var mib = 1024.0 * kib;
	var gib = 1024.0 * mib;
	if (length > gib)
		return (length / gib).toFixed(2) + "G";
	if (length > mib)
		return (length / mib).toFixed(2) + "M";
	if (length > kib)
		return (length / kib).toFixed(2) + "K";
	return length;
}

var currentDir = this.Parameter;

var title = currentDir.map(function(path) { return pathToName(path); });

var hasListError = Observable(false);
var lastListError = Observable("");

var directories = currentDir.map(function(path) {
	var entries = Observable();
	FileSystem.listDirectories(path)
		.then(function(res) {
			entries.replaceAll(res.sort());
			hasListError.value = false;
		}).catch(function(error) {
			hasListError.value = true;
			lastListError.value = error.toString();
			console.log("Got error while listing directories: " + error);
		});
	return entries;
}).inner()
.where(function(path) { return path !== undefined; }) // can be removed when https://github.com/fusetools/fuselibs/pull/2749/files is merged
.map(function(path) {
	return {
		clicked: function() { router.push("directory", path); },
		name: pathToName(path),
		path: path
	};
});

var files = currentDir.map(function(path) {
	var entries = Observable();
	FileSystem.listFiles(path)
		.then(function(res) {
			entries.replaceAll(res.sort());
		}).catch(function(error) { console.log("Got error while listing files: " + error); });
	return entries;
}).inner()
.where(function(path) { return path !== undefined; }) // can be removed when https://github.com/fusetools/fuselibs/pull/2749/files is merged
.map(function(path) {
	var length = Observable("");
	FileSystem.getFileInfo(path).then(function(info) {
		length.value = toHumanFriendly(info.length);
	});
	return {
		name: pathToName(path),
		path: path,
		length: length
	};
});

module.exports = {
	title: title,
	directories: directories,
	files: files,
	hasListError: hasListError,
	lastListError: lastListError
};
