var Observable = require("FuseJS/Observable")

exports.numbers = Observable()
var items = ['1','2','3',
	'4','5','6',
	'7','8','9',
	'*','0','c']
items.forEach( function(c) {
	exports.numbers.add(c)
})

exports.select = function(args) {
	if (args.data == '*') {
		NumberBack.raise()
	} else if( args.data == 'c' ) {
		NumberCleared.raise()
	} else {
		NumberSelected.raise({ 
			number: args.data,
		})
	}
}