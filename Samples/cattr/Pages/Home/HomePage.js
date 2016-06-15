var Observable = require("FuseJS/Observable");

var currentPet = Observable("");

this.onParameterChanged(function(param) {
	currentPet.value = param.pet;
});

module.exports = {
	currentPet: currentPet,

	goBack: function() {
		router.goBack();
	}
};