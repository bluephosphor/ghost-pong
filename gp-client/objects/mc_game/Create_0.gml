globalvar debug, gamestate, colors;

#macro ACTIONABLE	0
#macro SHELL		1
#macro PREGAME		2

debug			= false;
gamestate		= PREGAME;
colors			= [c_black,c_red,c_aqua,c_yellow,c_green,c_orange,c_fuchsia];

bg_colors = [c_fuchsia,c_gray,c_dkgray,c_black,c_white,c_white];

keyboard_string = "";
client_username = "";

sh_pixelscale([-1,"3"]);
alarm[0] = 1;

depth += 10;

//testing matchmaking server connect

//Global Variables
global.connected_to_server = false;

//Instance Variables
port = 642;
socket = network_create_socket(network_socket_tcp);

server_address = "75.188.243.178";

database_connected = network_connect_raw(socket,server_address,port);

ping = 0;
ping_step = 0;
ping_timeout = room_speed * 5;

//Set config.
network_set_timeout(socket, 2000, 2000);