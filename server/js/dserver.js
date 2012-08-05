var fs = require('fs');
var net = require('net');
var mc = require('mc');

function main() {
	console.log("Main server initiated");
	var socket;
	var connections = [];

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
	var addr;
	var isConnected = false;
	console.log("new connection created- "+socket.remoteAddress);
	s.on("connect", onConnect);
	s.on("data", onData);
	s.on("error",onError);
	return this;

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
		s.write('hello '+addr,'utf8');
	}

	function onData(d)
	{
		console.log(addr+" "+d);
	}

	function onError(e)
	{
		console.log("socket error");
		if(isConnected) console.log(addr);
		console.log(e);
	}
}

var central = new main();


