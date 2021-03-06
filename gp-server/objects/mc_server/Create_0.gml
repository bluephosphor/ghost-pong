enum network{
	player_establish,
	player_connect,
	player_disconnect,
	player_input,
	player_hitstun,
	server_command,
	ball_update,
	text,
	move,
}

port = 682;
max_clients = 6;

var _connected = network_create_server(network_socket_tcp,port,max_clients);
var _str = (_connected >= 0)? "local server online." : "local server connection was unsuccessful!";

globalvar server, shell, server_buffer, socket_list, ball, class_data, hitbox_list, view_width, view_height, colors;

server = id;

ds_list_add(shell.output,_str);

server_buffer			= buffer_create(1024,buffer_fixed,1);
socket_list				= ds_list_create();
socket_to_instanceid	= ds_map_create();

players_online		= "0";
player_spawns[0]	= new vec2(room_width div 2,  room_height div 2); //this shouldn't get used
player_spawns[1]	= new vec2(room_width * 0.25, room_height * 0.25); 
player_spawns[2]	= new vec2(room_width * 0.75, room_height * 0.25); 
player_spawns[3]	= new vec2(room_width * 0.25, room_height * 0.75); 
player_spawns[4]	= new vec2(room_width * 0.75, room_height * 0.75); 
player_spawns[5]	= new vec2(room_width * 0.25, room_height * 0.5); 
player_spawns[6]	= new vec2(room_width * 0.75, room_height * 0.5); 
colors				= [c_black,c_red,c_blue,c_yellow,c_green,c_orange,c_fuchsia];

ball.init();