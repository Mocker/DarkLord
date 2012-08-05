var fs = require('fs');
var net = require('net');

function main() {
	var socket;
	var connections = [];

	var server = net.createServer(function(socket){
		var con = new connection(socket);
		connections.push(con);
	});

	server.listen(9001);
	//server.on("error",main.onServerError);

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

main();


