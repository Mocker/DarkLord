var fs = require('fs');
var net = require('net');
var mc = require('mc');
var types = require('./types.js');

function main() {
	console.log("Main server initiated");
	var socket;
	var connections = [];
	var events = { //events queue. global and per player
		global: []
	};
	var map = {
		map = types.FakeMap,
		buildings = []
	};
	var mobs = [];
	var pcs = [];
	populateMap();

	var memc = new mc.Client();
	memc.connect(function(){
		console.log("Connected to memcache");
	});

	setInterval(10,update);

	var server = net.createServer(function(socket){
		var con = new connection(socket,this);
		connections.push(con);
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
	var populateMap = function()
	{
		var numOrcs = Math.floor(Math.random()*20+10);
		for(var i=0;i<numOrcs;i++){
			var orc = {
				type: types.Entities.ORC,
				hp: 10,
				x: Math.floor(Math.random()*(types.FakeMap.length-1)),
				y: Math.floor(Math.random()*(types.FakeMap.length-1))
			};
			var chkStatus = Math.random();
			if(chkStatus < 0.5) orc.status = "wandering";
			else orc.status = "sleeping";
			mobs.push(orc);
		}
		console.log("added "+numOrcs+" orcs");
		console.log(mobs);
	}

	var update = function()
	{
		//each game tick update game world

		//process mobs (orcs)
		for(var i in mobs)
		{
			var mob = mobs[i];
			var decide = Math.random();
			if(mob.status && mob.status == 'wandering'){
				//move or go to sleep
				if(decide >0.9) mob.status = "sleeping";
				else if(decide > 0.75 && mob.x > 1) mob.x -= 1;
				else if(decide > 0.6 && mob.x < types.FakeMap.length-2) mob.x += 1;
				else if(decide > 0.45 && mob.y > 1) mob.y -= 1;
				else if(decide > 0.3 && mob.y < types.FakeMap.length-2) mob.y += 1;
			}
			else if(mob.status && mob.status == "sleeping"){
				if(decide > 0.9) mob.status = "wandering";
			}
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
	var userInfo = false;
	console.log("new connection created- "+socket.remoteAddress);
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
		console.log(addr+" "+parts[1]+" "+parts[2]);
		
		if(!userInfo)
		{
			if(parts[1] == types.Messages.LOGIN)
			{
				if(parts.length < 3){ console.log("Invalid login length");  return; }
				var logins = loginRegEx.exec(parts[2]);
				if(!logins || logins.length < 3){
					console.log("Error: username/pwd invalid format: "+parts[2]);
					send("0,Error: Username/Password invalid format");
					return;
				}
				//check cache for user info
				m.memc.get('PLAYER '+logins[1], function(err, response) {
					if(err){ // create user
						console.log(err);

					} else { //user loaded into response
						console.log("Player loaded");
						console.log(response);

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


