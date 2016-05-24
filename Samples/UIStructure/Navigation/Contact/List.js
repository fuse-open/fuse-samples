var Observable = require("FuseJS/Observable")
var contacts = require("App/contacts.js")

exports.openChat = function(e) {
	router.push("chat", e.data.name )
}

exports.view = function(e) {
	router.push("home", {}, "contacts", {}, "view", e.data.name )
}

exports.contacts = contacts.contacts
