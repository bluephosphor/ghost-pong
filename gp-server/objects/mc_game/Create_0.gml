enum matchmaking{
	client_init = 101,
	update		= 102,
}

globalvar shell, matchmaking_connected, server_ip, server_username;
sh_pixelscale([-1,"3"]);
shell  = instance_create_layer(0,0,layer,obj_shell);
shell.open();
alarm[0] = 1;

server_username = "gp-server";
ip_request = http_get("http://ipv4bot.whatismyipaddress.com/");
matchmaking_request = undefined;

//connect to the matchmaking server
matchmaking_connected = false;
matchmaking_port = 642;
matchmaking_socket = network_create_socket(network_socket_tcp);
matchmaking_server_address = "75.188.243.178";
matchmaking_list = [];
ping = 0;
ping_step = 0;
ping_timeout = room_speed * 3;

ping_count = 0;

//set config
network_set_timeout(matchmaking_socket, 2000, 2000);
network_set_config(network_config_connect_timeout,2000);