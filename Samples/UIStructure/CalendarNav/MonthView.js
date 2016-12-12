var Observable = require("FuseJS/Observable")
var DateTime = require("Lib/DateTime")

var date = Observable(DateTime.first(new Date()))

this.Parameter.onValueChanged( function(value) {
	date.value = new Date(value.year, value.month,1)
})

exports.activated = function() {
	console.log( "Activated: " + date.value )
	
	var p = new Date(date.value.valueOf())
	p.setMonth( p.getMonth() - 1)
	router.bookmark({
		name: "prevMonth",
		path: [ "month", { month: p.getMonth(), year: p.getFullYear() } ]
	})
	
	p = new Date(date.value.valueOf())
	p.setMonth( p.getMonth() + 1)
	router.bookmark({
		name: "nextMonth",
		path: [ "month", { month: p.getMonth(), year: p.getFullYear() } ]
	})
}

function FillDay(day) {
	this.type = "fill"
	this.day = day
}

function Day(day) {
	this.type = "day"
	this.day = day
	this.dayOfMonth = day.getDate()
}

//TODO: someway to do this with `.map`
exports.days = Observable()
date.onValueChanged( function(v) {
	var first = DateTime.first(v)
	var num = DateTime.monthDays(v)
	
	var days = []
	
	var day = first
	var start = DateTime.dayOfWeek(first)
	day.setDate(day.getDate() - start)
	for (var i=0; i < start; ++i) {
		days.push( new FillDay(day) )
		day = DateTime.nextDay(day)
	}

	for (var i=0; i < num; ++i) {
		days.push( new Day(day) )
		day = DateTime.nextDay(day)
	}
	
	var end = (num + start) % 7
	if (end > 0) {
		for (var i=end; i < 7; ++i) {
			days.push( new FillDay(day) );
			day = DateTime.nextDay(day)
		}
	}

	exports.days.replaceAll(days)
})

exports.monthLabel = date.map( function(v) {
	var months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
	return months[v.getMonth()] + " " + v.getFullYear()
})

exports.daysOfWeek = [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]

exports.openDay = function(args) {
	var day = args.data.day
	router.push( "day", { month: day.getMonth(), year: day.getFullYear(), day: day.getDate() })
}