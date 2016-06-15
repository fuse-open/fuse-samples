var Observable = require("FuseJS/Observable")
var contacts = require("App/contacts.js")

exports.contact = Observable(contacts.empty)

view.onParameterChanged( function(param) {
	exports.contact.value = contacts.empty
	contacts.lookupContact(param, function(contact) {
		exports.contact.value = contact
	})
})
