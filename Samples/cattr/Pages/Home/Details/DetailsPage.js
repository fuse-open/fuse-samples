var Observable = require("FuseJS/Observable");
var Backend = require("Backend.js");

var isDialogShowing = Observable(false);

function bookDate() {
	isDialogShowing.value = true;
}

function closeDialog() {
	isDialogShowing.value = false;
}

module.exports = {
	pet: this.CurrentPet.map(function(name) {
		var pet = Backend.getPet(name);
		if (pet) {
			pet.mainPicture = pet.pictures[0];
		}
		return pet;
	}),

	isDialogShowing: isDialogShowing,

	bookDate: bookDate,
	closeDialog: closeDialog
};