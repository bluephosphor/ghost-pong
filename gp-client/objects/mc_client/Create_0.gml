enum network{
	player_establish,
	player_connect,
	player_disconnect,
	player_input,
	player_command,
	ball_update,
	text,
	move,
}

globalvar port, client, connected, client_buffer, shell, colors, ball;

port			= 682;
mysocket = "";
client			= network_create_socket(network_socket_tcp);
connected		= network_connect(client,"192.168.1.187",port); //local IPv4: "192.168.1.187"
client_buffer	= buffer_create(1024,buffer_fixed,1);

socket_to_instanceid = ds_map_create();

shell			= instance_create_layer(0,0,layer,obj_shell);
ball			= instance_create_layer(0,0,layer,obj_ball);
colors			= [c_black,c_red,c_aqua,c_yellow,c_green,c_orange,c_fuchsia];