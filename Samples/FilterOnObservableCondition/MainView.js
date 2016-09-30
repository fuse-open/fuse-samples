var Observable = require('FuseJS/Observable');

function Color(color, name, category){
	this.color = color;
	this.name = name;
	this.category = category;
}

var COLOR_TYPES = {
	REDS: 'reds',
	GREENS: 'greens',
	OTHER: 'other',
	ALL: 'all'
};

var currentCategory = Observable(COLOR_TYPES.REDS);

var items = Observable(
	new Color('#D32F2F', 'Red 1', COLOR_TYPES.REDS),
	new Color('#E91E63', 'Red 2', COLOR_TYPES.REDS),
	new Color('#E57373', 'Red 3', COLOR_TYPES.REDS),
	new Color('#E91E63', 'Red 4', COLOR_TYPES.REDS),
	new Color('#D50000', 'Red 5', COLOR_TYPES.REDS),

	new Color('#26A69A', 'Green 1', COLOR_TYPES.GREENS),
	new Color('#00ACC1', 'Green 2', COLOR_TYPES.GREENS),
	new Color('#26A69A', 'Green 3', COLOR_TYPES.GREENS),
	new Color('#004D40', 'Green 4', COLOR_TYPES.GREENS),
	new Color('#1DE9B6', 'Green 5', COLOR_TYPES.GREENS),

	new Color('#FFC107', 'Other 1', COLOR_TYPES.OTHER),
	new Color('#FBC02D', 'Other 2', COLOR_TYPES.OTHER),
	new Color('#039BE5', 'Other 3', COLOR_TYPES.OTHER),
	new Color('#90A4AE', 'Other 4', COLOR_TYPES.OTHER),
	new Color('#FFFF00', 'Other 5', COLOR_TYPES.OTHER)
);

var filteredItems = currentCategory.flatMap(function(category){
	return items.where(function(item){
		return item.category === category || category === COLOR_TYPES.ALL;
	});
});

function gotoReds(){ currentCategory.value = COLOR_TYPES.REDS; }
function gotoGreens(){ currentCategory.value = COLOR_TYPES.GREENS; }
function gotoOther(){ currentCategory.value = COLOR_TYPES.OTHER; }
function gotoAll() { currentCategory.value = COLOR_TYPES.ALL; }

module.exports = {
	filteredItems: filteredItems,
	gotoReds:	gotoReds,
	gotoGreens: gotoGreens,
	gotoOther: gotoOther,
	gotoAll: gotoAll

};
