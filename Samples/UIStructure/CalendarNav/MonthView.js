var Observable = require("FuseJS/Observable")

function dateMonthDays(date) {
    var d= new Date(date.getFullYear(), date.getMonth()+1, 0)
    return d.getDate()
}

function dateFirst(date) {
	var d = new Date(date.valueOf())
	d.setDate(1)
	return d
}

function dateDayOfWeek(date) {
	return (date.getDay() + 7) % 7 //shift to Mon-Sun
}

var date = Observable(dateFirst(new Date()))

this.Parameter.onValueChanged( function(value) {
	date.value = new Date(value.year, value.month,1)
})

exports.activated = function() {
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

function FillDay() {
	this.type = "fill"
}

function Day(dom) {
	this.type = "day"
	this.dayOfMonth = dom
}

//TODO: someway to do this with `.map`
exports.days = Observable()
date.onValueChanged( function(v) {
	var first = dateFirst(v)
	var num = dateMonthDays(v)
	
	var days = []
	
	var fill = dateDayOfWeek(first)
	for (var i=0; i < fill; ++i) {
		days.push( new FillDay() )
	}
	
	for (var i=0; i < num; ++i) {
		days.push( new Day(i+1) )
	}

	exports.days.replaceAll(days)
})

exports.month = date.map( function(v) {
	var months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
	return months[v.getMonth()]
})