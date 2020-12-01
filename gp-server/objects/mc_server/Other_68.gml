type_event = async_load[? "type"];

switch (type_event){
	case network_type_connect:
		var _socket = async_load[? "socket"];
		ds_list_add(socket_list,_socket);
		ds_list_add(shell.output,"client ID [" + string(_socket) + "] connected.");
		
		var _player = instance_create_layer(player_spawn_x,player_spawn_y,layer,obj_player);
		var _color_id = player_count++;
		_player.image_blend = colors[_color_id];
		ds_map_add(socket_to_instanceid,_socket,_player);
		
		buffer_seek(server_buffer,buffer_seek_start,0);
		buffer_write(server_buffer,buffer_u8,network.player_connect);
		buffer_write(server_buffer,buffer_u8,_socket);
		buffer_write(server_buffer,buffer_u8,_color_id);
		buffer_write(server_buffer,buffer_u16,_player.x);
		buffer_write(server_buffer,buffer_u16,_player.y);
		network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
		break;
	case network_type_disconnect:
		var _socket = async_load[? "socket"];
		ds_list_delete(socket_list,ds_list_find_index(socket_list,_socket));
		ds_list_add(shell.output,"client ID [" + string(_socket) + "] disconnected.");
		
		with (socket_to_instanceid[? _socket]) instance_destroy();
		break;
	case network_type_data:
		var _buffer = async_load[? "buffer"];
		var _socket = async_load[? "id"];
		buffer_seek(_buffer,buffer_seek_start,0);
		received_packet(_buffer,_socket);
		break;
}