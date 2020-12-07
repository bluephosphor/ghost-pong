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

globalvar client, connected, client_buffer, ball;

var _json		= json_parse(load_string_from_file("EDIT-ME.txt"));

mysocket		= "";
client			= network_create_socket(network_socket_tcp);
connected		= network_connect(client,_json.host_ip,_json.port); //local IPv4: "192.168.1.187"
client_buffer	= buffer_create(1024,buffer_fixed,1);
ball			= instance_create_layer(room_width div 2,room_height div 2,layer,obj_ball);

delete _json;

socket_to_instanceid = ds_map_create();

