var Observable = require("FuseJS/Observable");
var Backend = require("Backend.js");

module.exports = {
	pet: this.CurrentPet.map(function(name) {
		return Backend.getPet(name);
	})
};