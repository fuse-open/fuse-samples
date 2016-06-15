var pets = [
	{
		"name": "Dozer",
		"height": "1'3\"",
		"liteInfo": "Dozer is an adorable little fluffball!",
		"info": "Dozer likes to do cat things like play with cat toys and eat cat food. His hobbies include purring, laying near the window, and knocking things off the table.",
		"pictures": [
			{
				"file": "assets/kitten1.jpg",
				"info": "So round, so fluffy!"
			},
			{
				"file": "assets/kitten2.jpg",
				"info": "What a thoughtful little kitty."
			},
			{
				"file": "assets/kitten3.jpg",
				"info": "Don't worry, Dozer. It's only a mild existential crisis."
			}
		]
	},
	{
		"name": "Fluffy",
		"height": "1'1\"",
		"liteInfo": "Fluffy is short!",
		"info": "Fluffy is your best friend! He likes to play and chew on toys. He also likes to play tug-of-war with bits of rope and socks. Did I mention he's fluffy?",
		"pictures": [
			{
				"file": "assets/puppy2.jpg",
				"info": "What a cute pup!"
			},
			{
				"file": "assets/puppy1.jpg",
				"info": "He was even cuter when he was little!"
			},
			{
				"file": "assets/puppy3.jpg",
				"info": "This was taken right after his first bath. So cute!"
			}
		]
	},
	{
		"name": "Otto",
		"height": "0'8\"",
		"liteInfo": "Wh'otter you waiting for?",
		"info": "Otto loves the water. He also loves smiling, eating snacks, and holding hands. Catch him if you can!",
		"pictures": [
			{
				"file": "assets/otter1.jpg",
				"info": "Isn't he cute??"
			},
			{
				"file": "assets/otter2.jpg",
				"info": "Snack time!"
			},
			{
				"file": "assets/otter3.jpg",
				"info": "Look at those mischievous little hands!"
			}
		]
	}
];

function clone(obj) {
	return JSON.parse(JSON.stringify(obj));
}

function getPets() {
	return clone(pets);
}

function getPet(name) {
	var ret = pets.find(function(pet) {
		return pet.name == name;
	});
	return ret ? clone(ret) : null;
}

module.exports = {
	getPets: getPets,
	getPet: getPet
};