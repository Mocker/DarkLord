var fs = require('fs');
var net = require('net');

function main() {
	var socket;
	var connections = [];

	var server = net.createServer(function(socket)){
		var con = new connection(socket);
		connections.push(con);
	}

	server.on("error",onServerError);

	var onServerError = function(e)
	{
		console.log("server error");
		console.log(e);
	}

}


function connection(socket) {
	var s = socket;
	var addr;
	var isConnected = false;
	console.log("new connection created- "+socket.remoteAddress());
	s.on("connect", onConnect);
	s.on("data", onData);
	s.on("error",onError);
	return this;

	var onConnect = function(s)
	{
		console.log("connection socket connected to "+s.remoteAddress() );
		addr = s.remoteAddress();
		isConnected = true;
	}

	var onData = function(d)
	{
		console.log(s.remoteAddress()+" "+d);
	}

	var onError = function(e)
	{
		console.log("socket error");
		if(isConnected) console.log(addr);
		console.log(e);
	}
}

main();


