exports.monthDays = function(date) {
    var d= new Date(date.getFullYear(), date.getMonth()+1, 0)
    return d.getDate()
}

exports.first = function(date) {
	var d = new Date(date.valueOf())
	d.setDate(1)
	return d
}

exports.nextDay = function(date) {
	var d = new Date(date.valueOf())
	d.setDate( d.getDate() + 1)
	return d
}

exports.dayOfWeek = function(date) {
	return (date.getDay() + 6) % 7 //shift to Mon-Sun
}
