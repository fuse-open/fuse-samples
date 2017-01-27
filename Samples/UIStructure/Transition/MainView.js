exports.goBack = function() {
	router.goBack()
}

exports.goBottomRight = function() {
	router.push( "BottomRight" )
}
exports.goTopLeft = function() {
	router.push( "TopLeft" )
}

exports.goPopup = function() {
	router.push( "Popup" )
}
exports.goPopupBottom = function() {
	router.push( "PopupBottom" )
}

var count = 0
/** Creates a unique Parameter for some pages */
function createProp() {
	return {
		id: "#" + (++count)
	}
}
exports.goRight1 = function() {
	router.push( "Right1", createProp() )
}
exports.goRight2 = function() {
	router.push( "Right2", createProp() )
}
exports.goLeft = function() {
	router.push( "Left", createProp() )
}
exports.goTop = function() {
	router.push( "Top", createProp() )
}
exports.goBottom = function() {
	router.push( "Bottom", createProp() )
}

exports.goPopupTop = function() {
	router.push( "PopupTop", createProp() )
}
exports.goSlideTop = function() {
	router.push( "SlideTop", createProp() )
}
