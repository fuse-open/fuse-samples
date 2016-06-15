var Observable = require("FuseJS/Observable")
var state = require("App/state.js")

var contacts = Observable({
	name: "mortoray", 
	color: [1,0.9,1,1],
}, {
	name: "duckers",
	color: [0.9,1,1,1],
}, {
	name: "vegard",
	color: [1,1,0.9,1],
}, {
	name: "erik",
	color: [0.9,0.9,1],
}, {
	name: "remi",
	color: [1,0.9,1,1],
})
exports.contacts = contacts

/**
	Simulates a dynamic loading function to retrieve a user.
*/
exports.lookupContact = function(name, done) {
	for (var i=0; i < contacts.length; ++i ) {
		var contact = contacts.getAt(i)
		if (name == contact.name) {
			state.setLoading(true)
			setTimeout( function() {
				state.setLoading(false)
				done( contact )
			}, 1000 * Math.random() )
			break
		}
	}
}

exports.isSame = function(contact, param) {
	return contact.name == param
}

//https://github.com/fusetools/fuselibs/issues/1817
//We cannot  just use {} placeholders
exports.empty = {
	name: "",
	color: [0.8,0.8,0.8,1],
}
