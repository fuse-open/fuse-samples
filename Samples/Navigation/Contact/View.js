var Observable = require("FuseJS/Observable")
var contacts = require("App/contacts.js")

exports.contact = view.Parameter.flatMap( function(param) {
	var newContact = Observable(contacts.empty);
	
	contacts.lookupContact(param, function(contact) {
		newContact.value = contact;
	});
	
	return newContact;
});