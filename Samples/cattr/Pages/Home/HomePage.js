var Observable = require("FuseJS/Observable");

module.exports = {
	currentPet: this.Parameter.map(function(param) {
		return param.pet;
	}),
	goBack: function() {
		router.goBack();
	}
};