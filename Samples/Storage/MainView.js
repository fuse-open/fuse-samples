var Observable = require("FuseJS/Observable");
var Storage = require("FuseJS/Storage");

var SAVENAME = "localStorage.json";

var welcomeText = Observable("Loading...");
var message = Observable("");
var hasStored = Observable(false);
debug_log("Js initialized");

Storage.read(SAVENAME).then(function(content) {
    var data = JSON.parse(content);
    welcomeText.value = "Stored data: "  + data.message;
}, function(error) {
    //For now, let's expect the error to be because of the file not being found.
    welcomeText.value = "There is currently no local data stored";
});
 
function saveMessage() {
    var storeObject = {message: message.value};
    Storage.write(SAVENAME, JSON.stringify(storeObject));
    hasStored.value = true;
}

module.exports = {
    welcomeText: welcomeText,
    message: message,
    saveMessage: saveMessage,
    hasStored: hasStored
};
