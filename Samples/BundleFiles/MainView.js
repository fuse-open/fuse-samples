var Observable = require('FuseJS/Observable');
var Bundle = require('FuseJS/Bundle');


var people = Observable();
Bundle.read('people.json').then(
	function(peopleRaw){
		var json = JSON.parse(peopleRaw);
		people.clear();
		for (var i = 0; i < json.people.length; i++){
			people.add(json.people[i]);
		}
	},function(e){
		console.log('error');
	}
);



var peopleView = people.map(function(item,index){
	return {
		firstName : item.firstName,
		lastName : item.lastName,
		color : (index % 2 === 0) ? "#00BCD4" : "#B3E5FC"
	};
});

module.exports = {
	people: peopleView
};
