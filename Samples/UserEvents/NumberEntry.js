var Observable = require( "FuseJS/Observable" )
exports.pin = Observable("####")
var init = false

exports.selected = function(args) {	
	if (!init) {
		exports.pin.value = "" + args.number
		init = true
		return
	}
	
	if (exports.pin.value.length >= 4) {
		return
	}
	
	exports.pin.value += "" + args.number
}

exports.cleared = function(args) {
	init = false
	exports.pin.value = "####"
}

exports.back = function(args) {
	var len = exports.pin.value.length
	if (len < 2) {
		exports.cleared()
		return
	}
	
	exports.pin.value = exports.pin.value.substring(0,len-1)
}
