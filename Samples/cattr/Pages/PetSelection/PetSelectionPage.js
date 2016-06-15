var Backend = require("Backend.js");

module.exports = {
	pets: Backend.getPets().map(function(pet) {
		pet.mainPicture = pet.pictures[0];
		pet.clicked = function() {
			router.push("home", { pet: pet.name }, "details");
		}
		return pet;
	}),
};