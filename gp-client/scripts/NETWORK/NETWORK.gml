globalvar mysocket;

function received_packet(buffer){
	//CLIENT
	msgid = buffer_read(buffer,buffer_u8);
	
	switch(msgid){
		case network.player_establish:
			var _socket = buffer_read(buffer,buffer_u8);
			mysocket = _socket;
			
			buffer_seek(client_buffer,buffer_seek_start,0);
			buffer_write(client_buffer,buffer_u8,network.player_establish);
			buffer_write(client_buffer,buffer_string,con_game.client_username);
			network_send_packet(client,client_buffer,buffer_tell(client_buffer));
			break;
		case network.player_connect:
			var _socket = buffer_read(buffer,buffer_u8);
			var _x = buffer_read(buffer,buffer_u16);
			var _y = buffer_read(buffer,buffer_u16);
			var _username = buffer_read(buffer,buffer_string);
			
			var _player = instance_create_layer(_x,_y,layer,obj_player);
			_player.socket = _socket;
			_player.username = _username;
			_player.image_blend = colors[_socket];
			
			ds_map_add(socket_to_instanceid,_socket,_player);
			break;
		case network.player_disconnect:
			var _socket = buffer_read(buffer,buffer_u8);
			var _player = socket_to_instanceid[? _socket];
			instance_destroy(_player);
			ds_map_delete(socket_to_instanceid,_socket);
			break;
		case network.text: // text
			var _message = buffer_read(buffer,buffer_string);
			ds_list_add(shell.output,_message);
			break;
		case network.move:
			var _sock   = buffer_read(buffer,buffer_u8);
			
			var _move_x = buffer_read(buffer,buffer_u16);
			var _move_y = buffer_read(buffer,buffer_u16);
			
			var _ball_x = buffer_read(buffer,buffer_u16);
			var _ball_y = buffer_read(buffer,buffer_u16);
			
			ball.x = _ball_x;
			ball.y = _ball_y;

			_player = socket_to_instanceid[? _sock];
			_player.x = _move_x;
			_player.y = _move_y;
			
			break;
		case network.player_input:
			var _sock = buffer_read(buffer,buffer_u8);
			var _move_x = buffer_read(buffer,buffer_s8);
			var _move_y = buffer_read(buffer,buffer_s8);
			var _special = buffer_read(buffer,buffer_bool);

			_player				= socket_to_instanceid[? _sock];
			_player.move.x		= _move_x;
			_player.move.y		= _move_y;
			_player.in_special	= _special;
			break;
		case network.ball_update:
			var _ball_x = buffer_read(buffer,buffer_u16);
			var _ball_y = buffer_read(buffer,buffer_u16);
			
			ball.x = _ball_x;
			ball.y = _ball_y;
			break;
	}
}

function send_string(str){
	buffer_seek(client_buffer,buffer_seek_start,0);
	buffer_write(client_buffer,buffer_u8,network.text);
	buffer_write(client_buffer,buffer_string,con_game.client_username);
	buffer_write(client_buffer,buffer_string,str);
	network_send_packet(client,client_buffer,buffer_tell(client_buffer));
}

function send_pos(_x,_y){
	buffer_seek(client_buffer,buffer_seek_start,0);
	buffer_write(client_buffer,buffer_u8,network.move);
	buffer_write(client_buffer,buffer_u16,_x);
	buffer_write(client_buffer,buffer_u16,_y);
	network_send_packet(client,client_buffer,buffer_tell(client_buffer));
}

function keyboard_update(){
	return (keyboard_check_pressed(vk_anykey) or keyboard_check_released(vk_anykey));
}