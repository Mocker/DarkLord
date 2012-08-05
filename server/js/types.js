//submaps is prebuilt map sections used for pasting together a fake map



var types = {

	Messages: {
		LOGIN: 1,
		LOGOUT: 2,

	},
	Events: {
		BROADCAST: 1, //server wide broadcast
		CHAT: 2, //player chat
		PM: 3, //player to player message
		MOB_GONE: 14, //mob is no longer visible
		MOB_SPAWN: 15, //mob appears (moved into range or spawn)
		MOB_TALK: 16, //
		MOB_MOVE: 17, //mob moves within rnage of player
		MOB_ATTACK: 18,
		MOB_HURT: 19,
		MOB_DIE: 10
		PLAYER_HURT: 20,
		PLAYER_STATUS: 21, //status change-health or status effect
		PLAYER_POSITION: 22,
		PLAYER_LOOT: 23, //player receives loot
		PLAYER_ATTACK: 24, //player attacks
		ITEM_SPAN: 31
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
	},



	


};

//create a fake static map for testing
//submaps is prebuilt map sections
var submaps = {
	GRASS : [ 
		[types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS],
		[types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS],
		[types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS],
		[types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS],
		[types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS]
			],
	FOREST: [
		[types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST],
		[types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST],
		[types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST],
		[types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST],
		[types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST,types.Terrain.FOREST]
	],
	STREAM : [ 
		[types.Terrain.WATER,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS],
		[types.Terrain.GRASS,types.Terrain.WATER,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS],
		[types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.WATER,types.Terrain.GRASS,types.Terrain.GRASS],
		[types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.WATER,types.Terrain.GRASS],
		[types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.GRASS,types.Terrain.WATER]
			]
}

//a 2d array pointing to map sections to laod
//do 10x10 map sections for testing
types.FakeMap = [
	[submaps.FOREST,submaps.STREAM,submaps.FOREST,submaps.FOREST,submaps.FOREST,submaps.FOREST,submaps.FOREST,submaps.FOREST,submaps.FOREST,submaps.FOREST],
	[submaps.FOREST,submaps.GRASS,submaps.STREAM,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.FOREST],
	[submaps.FOREST,submaps.GRASS,submaps.GRASS,submaps.STREAM,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.FOREST],
	[submaps.FOREST,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.STREAM,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GFOREST],
	[submaps.FOREST,submaps.FOREST,submaps.FOREST,submaps.GRASS,submaps.GRASS,submaps.STREAM,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS],
	[submaps.FOREST,submaps.GRASS,submaps.FOREST,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.STREAM,submaps.GRASS,submaps.GRASS,submaps.GRASS],
	[submaps.FOREST,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.STREAM,submaps.GRASS,submaps.GRASS],
	[submaps.FOREST,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.STREAM,submaps.GRASS],
	[submaps.FOREST,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.STREAM],
	[submaps.FOREST,submaps.FOREST,submaps.FOREST,submaps.FOREST,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS,submaps.GRASS]
];

if(!(typeof exports === 'undefined')){
	module.exports = types;
}
