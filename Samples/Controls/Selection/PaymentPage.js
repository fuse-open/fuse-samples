var Observable = require("FuseJS/Observable")

var paymentOpts = {
	cash: { label: "Cash", desc: "Have cash ready at the door." },
	credit: { label: "Credit Card", desc: "Pay now with a credit card." },
	paypal: { label: "PayPal",  desc: "Pay in advance with PayPal." },
	coupon: { label: "Coupon", desc: "Have your coupon ready at the door." },
	}
exports.payment = Observable("cash")
exports.paymentOpts = mapOptions(paymentOpts)
	
var deliveryOpts = {
	normal: { label: "Normal (<1hr)", cost: 0 },
	express: { label: "Express (<30min)", cost: 5 },
	drone: { label: "Drone (<15min)", cost: 10 },
	}
exports.delivery = Observable("express")
exports.deliveryOpts = mapOptions(deliveryOpts)


// shows how to get original objects from selected values
exports.notice = Observable("")
function update() {
	var q = paymentOpts[exports.payment.value].desc
	
	var cost = deliveryOpts[exports.delivery.value].cost
	if (cost > 0) {
		q += " An extra delivery fee of $" + cost + " applies."
	}
	
	exports.notice.value = q
}
exports.delivery.onValueChanged(module, update)
exports.payment.onValueChanged(module, update)
update()


// converts our own options object into an array of options for an `Each`
function mapOptions(opts) {
	return Object.keys(opts).map( function(key) {
		return { value: key, label: opts[key].label }
	})
}
