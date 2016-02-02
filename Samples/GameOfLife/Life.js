var Observable = require("FuseJS/Observable")

var cells = Observable()
exports.cells = cells

var numColumns = 30
var numRows = 30
exports.numColumns = Observable(numColumns)
exports.numRows = Observable(numRows)
exports.autoStep = Observable(true)

function Cell(on) {
	this.on = Observable(on)
	this.count = 0
}

for (var i=0; i < numRows; ++i) {
	for (var j=0; j < numColumns; ++j) {
		cells.add( new Cell( Math.random() > 0.8 ? true : false ) )
	}
}

/**
	Get the cell at these coordinates (with wrap-around).
*/
function getCell(row,col) {
	if (row < 0) {
		row += numRows
	}
	row = row % numRows
	if (col < 0) {
		col += numColumns
	}
	col = col % numColumns
	
	return cells.getAt(row * numColumns + col)
}

/**
	How many neighbours of this cell are "on"
*/
function liveCount(row,col) {
	var c = 0
	for (var i=-1; i <= 1; ++i) {
		for (var j=-1; j <= 1; ++j) {
			if (i==0 && j==0) {
				continue;
			}
			
			if (getCell(i+row,j+col).on.value)
				c++
		}
	}
	
	return c
}

function autoStep() {
	step()
	//check speed change now instead of with valueChagned to avoid 
	//odd time stretching while the user is interacting
	updateTimer(exports.autoStep.value, exports.speed.value)
}

function step() {
	
	//count neighbours prior to changing anything
	for (var i=0; i < numRows; ++i) {
		for (var j=0; j < numColumns; ++j) {
			var c = getCell(i,j)
			c.count = liveCount(i,j)
		}
	}

	for (var i=0; i < numRows; ++i) {
		for (var j=0; j < numColumns; ++j) {
			var c = getCell(i,j)
			if (!c.on.value) {
				c.on.value = c.count == 3
			} else if (c.count <2) {
				c.on.value = false
			} else if (c.count > 3) {
				c.on.value = false
			}
		}
	}
}

/**
	This callback is done in the context of a cell item in the UI, thus the `data` property is the Cell object.
*/
exports.toggleCell = function(args) {
	args.data.on.value = !args.data.on.value
}

/**
	Turn off all cells.
*/
exports.clear = function(args) {
	for (var i=0; i < cells.length; ++i) {
		cells.getAt(i).on.value = false
	}
}

exports.step = step


//timer control
var intervalSpeed = 0 //0 indicates no interval setup
var interval = null
exports.speed = Observable(500)
updateTimer(exports.autoStep.value,exports.speed.value)

exports.autoStepChanged = function(args) {
	//we must use the `args.value` since `exports.autoStep.value` may not yet be updated
	updateTimer(args.value, exports.speed.value)
	//it feels more responsive to do something immediately when turning on
	if (args.value) {
		step()
	}
}

/**
	Match the actual interval timer to the desired timer.
*/
function updateTimer(on, speed) {
	if (!on) {
		speed = 0
	}
	
	if (speed == intervalSpeed) {
		return
	}
	
	if (interval != null) {
		clearInterval(interval)
	}
	
	intervalSpeed = speed
	if (speed > 0) {
		interval = setInterval( autoStep, intervalSpeed )
	}
}
