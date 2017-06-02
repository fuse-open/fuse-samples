var Observable = require("FuseJS/Observable")
var DateTime = require("Lib/DateTime")

var date = Observable(new Date())

this.Parameter.onValueChanged(module, function(value) {
	date.value = new Date(value.year, value.month,value.day)
})

exports.label = date.map(function(day) {
	return "" + DateTime.dayLabels[day.getDay()] + " " + day.getDate() + " " + 
		DateTime.monthLabels[day.getMonth()] + " " + day.getFullYear()
})
