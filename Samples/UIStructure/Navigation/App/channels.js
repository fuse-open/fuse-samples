var Observable = require("FuseJS/Observable")
var state = require("./state.js")

var channels = Observable({
	name: "#news",
	color: [0.5,1,0.5,1],
	members: [ "mortoray", "duckers", "vegard", "erik" ],
},{
	name: "#gamenight",
	color: [1,1,0.5,1],
	members: [ "mortoray", "vegard", "erik" ],
},{
	name: "#meta",
	color: [0.5,0.5,0.5,1],
	members: [ "duckers", "remi" ],
})
exports.channels = channels

/**
	Simulates a dynamic loading function to retrieve a channel.
*/
exports.lookupChannel = function(name, done) {
	for (var i=0; i < channels.length; ++i ) {
		var channel = channels.getAt(i)
		if (name == channel.name) {
			state.setLoading(true)
			setTimeout( function() {
				state.setLoading(false)
				done( channel )
			}, 1000 * Math.random() )
			break
		}
	}
}

