enum matchmaking{
	client_init = 101,
	update		= 102,
}

port = 642;
max_clients = 100;

var _connected = network_create_server(network_socket_tcp,port,max_clients);

globalvar server, shell, server_buffer, socket_data;

server = id;
shell  = instance_create_layer(0,0,layer,obj_shell);
shell.open();

var _str = (_connected >= 0)? "matchmaking server started." : "connection was unsuccessful!";
ds_list_add(shell.output,_str);

server_buffer	= buffer_create(1024,buffer_fixed,1);
socket_data		= [];

function client(socket) constructor{
	id			= socket;
	username	= undefined;
	ip			= undefined;
	is_server	= undefined;
}

alarm[0] = 60; //ping timer