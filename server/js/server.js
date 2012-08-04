var net = require('net');
var mySocket;

// create the server and register event listeners
var server = net.createServer(function(socket) {
	mySocket = socket;
	mySocket.on("connect", onConnect);
	mySocket.on("data", onData);
});

function onConnect()
{
	console.log("Connected to Flash");
}

// When flash sends us data, this method will handle it
function onData(d)
{
	if(d == "exit\0")
	{
		console.log("exit");
		mySocket.end();
		server.close();
	}
	else
	{
		console.log("From Flash = " + d);
		mySocket.write(d, 'utf8');
	}
}

// listen for connections
server.listen(9001, "127.0.0.1");
