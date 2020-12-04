enum network{
	player_establish,
	player_connect,
	player_disconnect,
	player_input,
	server_command,
	ball_update,
	text,
	move,
}

globalvar port, client, connected, client_buffer, shell, colors, ball;

var _str  = load_string_from_file("EDIT-ME.txt")
var _json = json_parse(_str);

port			= 682;
mysocket = "";
client			= network_create_socket(network_socket_tcp);
connected		= network_connect(client,_json.host_ip,port); //local IPv4: "192.168.1.187"
client_buffer	= buffer_create(1024,buffer_fixed,1);

delete _json;

socket_to_instanceid = ds_map_create();

shell			= instance_create_layer(0,0,layer,obj_shell);
ball			= instance_create_layer(room_width div 2,room_height div 2,layer,obj_ball);
colors			= [c_black,c_red,c_aqua,c_yellow,c_green,c_orange,c_fuchsia];