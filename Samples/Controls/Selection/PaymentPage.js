var Observable = require("FuseJS/Observable")

var paymentOpts = {
	cash: { label: "Cash", desc: "Have cash ready at the door." },
	credit: { label: "Credit Card", desc: "Pay now with a credit card." },
	paypal: { label: "PayPal",  desc: "Pay in advance with PayPal." },
	coupon: { label: "Coupon", desc: "Have your coupon ready at the door." },
};

var deliveryOpts = {
	normal: { label: "Normal (<1hr)", cost: 0 },
	express: { label: "Express (<30min)", cost: 5 },
	drone: { label: "Drone (<15min)", cost: 10 },
};

var payment = Observable("cash");
var delivery = Observable("express");
var notice = Observable("");

payment.onValueChanged(module, update);
delivery.onValueChanged(module, update);

function update() {
	var payOpt = paymentOpts[payment.value];
	var delOpt = deliveryOpts[delivery.value];

	//safety check (a binding may reset the value to null during rooting/unrooting)
	if (!payOpt || !delOpt) {
		return;
	}
	
	var q = payOpt.desc;
	var cost = delOpt.cost;
	if (cost > 0) {
		q += " An extra delivery fee of $" + cost + " applies.";
	}
	
	notice.value = q;
};

// converts our own options object into an array of options for an `Each`
function mapOptions(opts) {
	return Object.keys(opts).map(function(key) {
		return { value: key, label: opts[key].label };
	});
};

update();

module.exports = {
	payment: payment,
	delivery: delivery,
	paymentOpts: mapOptions(paymentOpts),
	deliveryOpts: mapOptions(deliveryOpts),
	notice: notice
};
