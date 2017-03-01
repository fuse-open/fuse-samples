var Observable = require("FuseJS/Observable");

var numbers = Observable();
var items = [
	'1','2','3',
	'4','5','6',
	'7','8','9',
	'*','0','c'
];
items.forEach(function(c) {
	numbers.add(c);
});

function select(args) {
	if (args.data == '*') {
		numberBack.raise();
	} else if (args.data == 'c') {
		numberCleared.raise();
	} else {
		numberSelected.raise({number: args.data});
	}
};

module.exports = {
	numbers: numbers,
	select: select
};
