function received_packet(buffer){
	//CLIENT
	msgid = buffer_read(buffer,buffer_u8);
	
	switch(msgid){
		case network.player_connect:
			var _socket = buffer_read(buffer,buffer_u8);
			var _x = buffer_read(buffer,buffer_u16);
			var _y = buffer_read(buffer,buffer_u16);
			
			var _player = instance_create_layer(_x,_y,layer,obj_player);
			_player.socket = _socket;
			_player.image_blend = colors[_socket];
			
			ds_map_add(socket_to_instanceid,_socket,_player);
			break;
		case network.text: // text
			var _message = buffer_read(buffer,buffer_string);
			ds_list_add(shell.output,_message);
			break;
		case network.move:
			var _sock = buffer_read(buffer,buffer_u8);
			var _move_x = buffer_read(buffer,buffer_u16);
			var _move_y = buffer_read(buffer,buffer_u16);

			_player = socket_to_instanceid[? _sock];
			_player.x = _move_x;
			_player.y = _move_y;
			break;
	}
}

function send_string(str){
	buffer_seek(client_buffer,buffer_seek_start,0);
	buffer_write(client_buffer,buffer_u8,network.text);
	buffer_write(client_buffer,buffer_string,str);
	network_send_packet(client,client_buffer,buffer_tell(client_buffer));
}

function send_pos(){
	buffer_seek(client_buffer,buffer_seek_start,0);
	buffer_write(client_buffer,buffer_u8,network.move);
	buffer_write(client_buffer,buffer_u16,mouse_x);
	buffer_write(client_buffer,buffer_u16,mouse_y);
	network_send_packet(client,client_buffer,buffer_tell(client_buffer));
}