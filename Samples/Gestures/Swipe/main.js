var Observable = require("FuseJS/Observable")

var first = [ "Northern", "Red", "Eastern", "Mountain", "Desert", "Nocturnal", "Southern", 
	"Western", "Lowland", "Highland", "Snowy" ]
var last = [ "Finch", "Swallow", "Crow", "Owl", "Robin", "Pelican", "Stork", "Pidgeon", "Sparrow",
	"Crane", "Hawk", "Condor", "Ewe" ]

function Item() {
	this.height = 80 + Math.floor(Math.random() * 100)
	this.name = first[Math.floor(Math.random() * first.length)] + " " +
		last[Math.floor(Math.random() * last.length)]
	this.image = "bird" + (i%2)
	this.tintColor = [Math.random()*0.5 + 0.5, Math.random()*0.5 + 0.5, Math.random()*0.5 + 0.5, 1]
}

var loading = Observable(false)
var items = Observable()
var loadNew = function() {
	for (i=0; i < 40; i++) {
		items.add( new Item() )
	}
	loading.value = false
}

loadNew()

var deleteItem = function(arg) {
	items.tryRemove(arg.data)
}

var clear = function() {
	while (items.length > 0)
		items.removeAt(0)
}

var startLoading = function(a,b) {
	loading.value = true

	setTimeout( clear, 700 )
	setTimeout( loadNew, 1000 )
}

module.exports = {
	items: items,
	deleteItem: deleteItem,
	startLoading: startLoading,
	loading: loading,
}
