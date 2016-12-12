var Observable = require("FuseJS/Observable")

var date = Observable(new Date())

this.Parameter.onValueChanged( function(value) {
	date.value = new Date(value.year, value.month,value.day)
})

exports.label = date.map(function(day) {
	return "" + day
})