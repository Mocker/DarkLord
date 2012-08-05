var fs = require('fs');
var net = require('net');
var mc = require('mc');
var types = require('./types.js');
var dl = {} ; //global namespace to store.. everythiiing

function main() {
	console.log("Main server initiated");
	var socket;
	dl.connections = [];
	dl.events = { //events queue. global and per player
		global: []
	};
	dl.map = {
		map : types.FakeMap,
		buildings : []
	};
	dl.mobs = [];
	dl.pcs = {};
	populateMap();

	dl.memc = new mc.Client();
	dl.memc.connect(function(){
		console.log("Connected to memcache");
	});

	setInterval(update,30);

	var server = net.createServer(function(socket){
		var con = new connection(socket,this);
		dl.connections.push(con);
	});

	console.log("Listening to port 9001");
	server.listen(9001);
	//server.on("error",main.onServerError);

	var onServerError = function(e)
	{
		console.log("server error");
		console.log(e);
	}

	//add shit at random to the map
	function populateMap()
	{
		var numOrcs = Math.floor(Math.random()*20+50);
		for(var i=0;i<numOrcs;i++){
			var orc = {
				type: types.Entities.ORC,
				hp: 10,
				mobID: "orc"+i,
				mapX: Math.floor(Math.random()*(types.FakeMap.length-1)),
				mapY: Math.floor(Math.random()*(types.FakeMap.length-1)),
				x: Math.floor(Math.random()*(types.FakeMap[0].length-1)),
				y: Math.floor(Math.random()*(types.FakeMap[0].length-1))
			};
			var chkStatus = Math.random();
			if(chkStatus < 0.5) orc.status = "wandering";
			else orc.status = "sleeping";
			dl.mobs.push(orc);
		}
		console.log("added "+numOrcs+" orcs");
		console.log(dl.mobs);
	}

	function update()
	{
		//each game tick update game world

		//process mobs (orcs)
		for(var i in dl.mobs)
		{
			var mob = dl.mobs[i];
			var decide = Math.random();
			var oldMapX = mob.mapX, oldMapY = mob.mapY; //track these if they change push update
			var oldStatus = mob.status;
			if(mob.status && mob.status == 'wandering'){
				//move or go to sleep
				if(decide >0.9) mob.status = "sleeping";
				else if(decide > 0.75 && mob.x > 1) moveMob("west",mob);
				else if(decide > 0.6 && mob.x < types.FakeMap.length-2) moveMob("east",mob);
				else if(decide > 0.45 && mob.y > 1) moveMob("south",mob);
				else if(decide > 0.3 && mob.y < types.FakeMap.length-2) moveMob("north",mob);
			}
			else if(mob.status && mob.status == "sleeping"){
				if(decide > 0.9) mob.status = "wandering";
			}
			if(oldMapX != mob.mapX || oldMapY != mob.mapY || oldStatus != mob.status){
				updatePlayersMobs(mob);
			}
		}
	}



}

//mob changed - push update to players in same mapx,mapy
function updatePlayersMobs(mob)
{
	if(!dl.pcs) return;
	//console.log("update map "+mob.mapX+","+mob.mapY);
	for(var user in dl.pcs){
		var pc = dl.pcs[user];
		if(pc.mapX == mob.mapX && pc.mapY == mob.mapY){
			var mobStr = JSON.stringify(mob);
			pc.s.write(types.Messages.MOB_MOVE+','+mobStr+"\0",'utf8');
			console.log("updated "+user);
		}
	}
	
}
//attempt to move a mob or npc speed units in the direction
//if at edge of map tile attempt to move to next map, if can't return false
// dir- "north,south,west,east"
function moveMob(dir,mob)
{
	//var newX = false, newY = false;
	if(dir=="north"){
		if(mob.y < types.FakeMap[0].length-1) mob.y += 1;
		else if(mob.mapY < types.FakeMap.length-1){
			mob.mapY += 1;
			mob.y = 0;
		}
		else return false;
	}
	else if(dir=="south"){
		if(mob.y > 0) mob.y -= 1;
		else if(mob.mapY > 0){
			mob.mapY -= 1;
			mob.y = types.FakeMap[0].length-1;
		}
		else return false;

	}
	else if(dir=="west"){
		if(mob.x > 0) mob.x -= 1;
		else if(mob.mapX> 0){
			mob.mapX -= 1;
			mob.x = types.FakeMap[0].length-1;
		}
		else return false;
	}
	else if(dir=="east"){
		if(mob.x < types.FakeMap[0].length-1) mob.x += 1;
		else if(mob.mapX < types.FakeMap.length-1){
			mob.mapX += 1;
			mob.x = 0;
		}
		else return false;
	}
}


//get a list of mobs on the current submap
function getMobs(mapX,mapY)
{
	var moblist = [];
	for(var i in dl.mobs)
	{
		if(dl.mobs[i].mapX==mapX && dl.mobs[i].mapY==mapY){

		}
	}
}

function connection(socket,controller) {
	var m = controller;
	var s = socket;
	var msgRegEX = /(\w+?),(.+)/ ;
	var loginRegEX = /(.+?)~(.+)/;
	var addr;
	var isConnected = false;
	var player = false;
	console.log("new connection created- "+socket.remoteAddress);
	console.log(m.memc);
	s.on("connect", onConnect);
	s.on("data", onData);
	s.on("error",onError);
	s.on("close",onClose);
	return this;

	//checkTick - main update loop per connect
	//checks for events affecting this player
	function checkTick()
	{
		
	}


	function onClose(e)
	{
		if(player && player.user){
			 delete dl.pcs[player.user];
		}
		console.log(addr+" disconnected");
		isConnected = false;
	}

	function onEvent(e)
	{
		console.log("onEvent fired"); console.log(e);
	}

	function onConnect(e)
	{
		console.log("connection socket connected to " );
		console.log(s.remoteAddress);
		addr =s.remoteAddress;
		//addr = s.remoteAddress;
		isConnected = true;
		send("hello "+addr);
		//s.write('hello '+addr+"\0",'utf8',onWrite);
	}

	function onData(d)
	{
		var parts = msgRegEX.exec(d);
		if(!parts){ console.log(addr+" INVALID "+d); return; }
		console.log(addr+" "+parts[1]+" "+parts[2]);
		
		if(!player)
		{
			if(parts[1] == types.Messages.LOGIN)
			{
				if(parts.length < 3){ console.log("Invalid login length");  return; }
				var logins = loginRegEX.exec(parts[2]);
				if(!logins || logins.length < 3){
					console.log("Error: username/pwd invalid format: "+parts[2]);
					send("0,Error: Username/Password invalid format");
					return;
				}
				//check cache for user info
				var whiteReg = /\s/;
				if(whiteReg.test(logins[1])){
					console.log("username cant contain whitespace");
					send("0,Username cannot contain spaces");
				}
				dl.memc.get('PLAYER_'+logins[1], function(err, response) {
					if(err){ // create user
						if(err.type!='NOT_FOUND'){
						console.log('Login error');console.log(err);
						send("0,Error fetching player");
						return;
						}
						console.log('Creating Player '+logins[1]);
						player = {
						user: logins[1],
						pwd: logins[2],
						queue: [],
						events: []
						};
						player.mapX = Math.floor(Math.random()*types.FakeMap.length);
						player.mapY = Math.floor(Math.random()*types.FakeMap.length);
						player.x = Math.floor(Math.random()*types.FakeMap[0].length);
						player.y = Math.floor(Math.random()*types.FakeMap[0].length);
						dl.pcs[logins[1]] = player;
					
						dl.memc.set('PLAYER_'+logins[1],JSON.stringify(player),function(err,response){
						if(err){ console.log("error setting player info"); console.log(err); return; }
						console.log("player saved");
						send("1,Player logged in");
						player.con = this;
						player.s = s;
						dl.pcs[player.user] = player;
						console.log(dl.pcs);
});

					} else { //user loaded into response
						console.log("Player found");
						console.log(response);
						var pstring = response['PLAYER_'+logins[1]];
					  chkplayer = JSON.parse(pstring );
					  console.log(chkplayer);
					  if(!chkplayer){
						console.log("invalid json");
						send("0,player data invalid");
						return;
					  }
					  if(chkplayer.pwd != logins[2]){
						console.log("passmismatch: "+chkplayer.pwd+" ~ "+logins[2]);
						send("0,Invalid password");
						return;
					 }
					 player = chkplayer;
					 console.log("Player loaded");
					 send("1,Player logged in");
					 player.con = this;
					 player.s = s;
					 if(player.mapX == undefined){
					 player.x=2; player.y = 2;
					 player.mapX = 2; player.mapY = 2;
					}
					dl.pcs[player.user] = player;
					 console.log(dl.pcs);
					}

				});
			}
		} else { //user logged in - game related events


		}
	}



	function onError(e)
	{
		console.log("socket error");
		if(isConnected) console.log(addr);
		console.log(e);
	}
	function send(d)
	{
		if(!isConnected) return;
		s.write(d+"\0","utf8");
	}
	function onWrite(e)
	{
		//console.log("Finished writing to "+addr);
	}
}

//helper function cause i keep mixing up as3's trace and console.log
function trace(obj)
{
	console.log(obj);
}

var central = new main();


