type_event = async_load[? "type"];

switch (type_event){
	case network_type_connect:
		socket = async_load[? "socket"];
		ds_list_add(socket_list,socket);
		
		buffer_seek(server_buffer,buffer_seek_start,0);
		buffer_write(server_buffer,buffer_u8,network.player_establish);
		buffer_write(server_buffer,buffer_u8,socket);
		network_send_packet(socket,server_buffer,buffer_tell(server_buffer));
		break;
	case network_type_disconnect:
		socket = async_load[? "socket"];
		ds_list_delete(socket_list,ds_list_find_index(socket_list,socket));
		
		var i = 0; repeat (ds_list_size(socket_list)){
			var _sock = socket_list[| i];
			buffer_seek(server_buffer,buffer_seek_start,0);
			buffer_write(server_buffer,buffer_u8,network.player_disconnect);
			buffer_write(server_buffer,buffer_u8,socket);
			network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
			i++;
		}
		
		var _player = socket_to_instanceid[? socket];
		ds_list_add(shell.output,"player: " + _player.username + " | client ID [" + string(socket) + "] disconnected.");
		send_string(_player.username + " left the game.");
		instance_destroy(_player);
		ds_map_delete(socket_to_instanceid,socket);
		break;
	case network_type_data:
		var _buffer = async_load[? "buffer"];
		socket		= async_load[? "id"];
		buffer_seek(_buffer,buffer_seek_start,0);
		received_packet(_buffer,socket);
		break;
}

players_online = string(ds_list_size(socket_list));