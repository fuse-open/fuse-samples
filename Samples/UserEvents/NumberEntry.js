var Observable = require( "FuseJS/Observable");
var pin = Observable("####");
var init = false;

function selected(args) {	
	if (!init) {
		pin.value = "" + args.number;
		init = true;
		return;
	}
	if (pin.value.length >= 4) {
		return;
	}
	pin.value += "" + args.number;
};

function cleared(args) {
	init = false;
	pin.value = "####";
};

function back(args) {
	var len = pin.value.length;
	if (len < 2) {
		cleared();
		return;
	}
	pin.value = pin.value.substring(0,len-1);
};

module.exports = {
	pin: pin,
	selected: selected,
	cleared: cleared,
	back: back
};
