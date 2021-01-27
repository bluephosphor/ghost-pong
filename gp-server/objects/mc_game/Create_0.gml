enum matchmaking{
	client_init = 101,
	update		= 102,
}

globalvar shell, matchmaking_connected, server_ip, server_username;
sh_pixelscale([-1,"3"]);
shell  = instance_create_layer(0,0,layer,obj_shell);
shell.open();
alarm[0] = 1;

///OLD CONNECT CODE

server_username = "gp-server";
ip_request = http_get("http://ipv4bot.whatismyipaddress.com/");
matchmaking_request = false;

////connect to the matchmaking server
matchmaking_connected = false;
matchmaking_port = 642;
//matchmaking_socket = network_create_socket(network_socket_tcp);
matchmaking_server_address = "75.188.243.178";
//matchmaking_list = [];
//ping = 0;
//ping_step = 0;
//ping_timeout = room_speed * 3;

//ping_count = 0;

////set config
//network_set_timeout(matchmaking_socket, 2000, 2000);
//network_set_config(network_config_connect_timeout,2000);


net_init();
log("INITIALIZE. requesting ip...");

net_cmd_add_handler("connected",function(data){
	matchmaking_connected = true;
	log("matchmaking server connect successful. sending info to server...");
	net_cmd_send_struct ({
		command: "client_initialize",
		username: server_username,
		ip: server_ip,
	});
	room_goto(R_SERVER);
})

net_cmd_add_handler("log",function(data){
	log(data[? "_message"]);
})