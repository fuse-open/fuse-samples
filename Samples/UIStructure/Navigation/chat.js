var Observable = require("FuseJS/Observable")
var contacts = require("App/contacts.js")

exports.leave = function() {
	router.goBack();
}

exports.viewProfile = function(e) {
	router.push( "home", {}, "contacts", {}, "view", exports.contact.value.name )
}

exports.contact = chat.Parameter.flatMap( function(param) {
	var currentContact = exports.contact.value || contacts.empty;
	
	if(contacts.isSame(currentContact, param)) {
		return Observable(currentContact);
	}
	
	var newContact = Observable(contacts.empty);
	contacts.lookupContact(param, function(contact) {
   		newContact.value = contact;
   	});
	return newContact;
});