var fs = require('fs');
var net = require('net');
var mc = require('mc');
var types = require('./types.js');

function main() {
	console.log("Main server initiated");
	var socket;
	var connections = [];
	console.log(types);

	var memc = new mc.Client();
	memc.connect(function(){
		console.log("Connected to memcache");
	});


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

}


function connection(socket,controller) {
	var m = controller;
	var s = socket;
	var msgRegEX = /(\w+?),(.+)/ ;
	var addr;
	var isConnected = false;
	console.log("new connection created- "+socket.remoteAddress);
	s.on("connect", onConnect);
	s.on("data", onData);
	s.on("error",onError);
	s.on("close",onClose);
	return this;


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
		//s.write("Received! "+"\0","utf8",onWrite);
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


