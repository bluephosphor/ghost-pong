enum matchmaking{
	client_init = 101,
	update		= 102,
}

globalvar debug, gamestate, colors, matchmaking_connected, client_ip, shell, selected_server, editme_loaded;

#macro ACTIONABLE	0
#macro SHELL		1
#macro PREGAME		2

debug			= false;
gamestate		= PREGAME;
colors			= [c_black,c_red,c_aqua,c_yellow,c_green,c_orange,c_fuchsia];

bg_colors = [c_fuchsia,c_blue,c_dkgray,c_white,c_white];

keyboard_string = "";
client_username = "";

sh_pixelscale([-1,"3"]);
alarm[0] = 1;

depth += 10;

ip_request = http_get("http://ipv4bot.whatismyipaddress.com/");
editme_loaded = json_parse(load_string_from_file("EDIT-ME.txt"));

//connect to the matchmaking server
matchmaking_connected = false;
matchmaking_port = 642;
matchmaking_socket = network_create_socket(network_socket_tcp);
matchmaking_server_address = "75.188.243.178";
server_list = [];
menu_index = 0;

selected_server = "";

ping = 0;
ping_step = 0;
ping_timeout = room_speed * 3;

//set config
network_set_timeout(matchmaking_socket, 2000, 2000);
network_set_config(network_config_connect_timeout,2000);