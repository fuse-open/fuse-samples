var Observable = require("FuseJS/Observable")
var contacts = require("App/contacts.js")

exports.leave = function() {
	router.goBack();
}

exports.viewProfile = function(e) {
	router.push( "home", {}, "contacts", {}, "view", exports.contact.value.name )
}

exports.contact = Observable(contacts.empty)

chat.onParameterChanged( function(param) {
 	if (contacts.isSame(exports.contact.value, param)) {	
 		return
 	}
 	
 	exports.contact.value = contacts.empty
   	contacts.lookupContact(param, function(contact) {
   		exports.contact.value = contact
   	})
})
