
var types = {

	Messages: {
		LOGIN: 1,
		LOGOUT: 2,

	},
	
	Terrain: {
		GRASS: 1,
		FOREST: 2,
		WATER: 3
	},
	Entities: {
		PC: 1,
		ORC: 2,
		PEON: 3
	},
	Buildings: {
		HOUSE: 1
	}


};

if(!(typeof exports === 'undefined')){
	module.exports = types;
}
