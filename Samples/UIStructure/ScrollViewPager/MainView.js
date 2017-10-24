var Observable = require("FuseJS/Observable")

//the list of items we are displaying in the ScrollView
exports.items = Observable()

//a flag indicating that data is currently being loaded (simulated with a timeout in this example)
exports.isLoading = Observable(false)

var count = 0
function loadSome() {
	for (var i=0; i < 10; ++i ) {
		exports.items.add( {
			id: count,
			value: "#" + count,
			color: [ Math.random() * 0.3 + 0.7, Math.random() * 0.3 + 0.7, Math.random() * 0.3 + 0.7, 1 ],
			size: Math.random() * 100,
		})
		count++
	}

	exports.isLoading.value = false
	
	//ensure the ScrollViewPager knows to check it's state again
	svp.check()
}

//longer delays increases the likelihood the user will reach the end of the list and see the loading placeholder
var maxSimulatedDelay = 1.5
var minSimulatedDelay = 0.25

exports.loadMore = function() {
	//it's possible this gets called again before the previous loading is complete
	if (exports.isLoading.value) {
		return
	}
	exports.isLoading.value = true
	
	//simulate a delay in loading data from a remote request
	var delay = Math.random() * (maxSimulatedDelay - minSimulatedDelay) + minSimulatedDelay
	setTimeout( loadSome, delay * 1000 )
}
