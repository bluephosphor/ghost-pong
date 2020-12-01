enum network{
	player_connect,
	text,
	move,
}

port = 682;
max_clients = 6;

network_create_server(network_socket_tcp,port,max_clients);

server_buffer			= buffer_create(1024,buffer_fixed,1);
socket_list				= ds_list_create();
socket_to_instanceid	= ds_map_create();

globalvar server, shell, player_count; 
server = id;
shell  = instance_create_layer(0,0,layer,obj_shell);
shell.open();

function received_packet(buffer,socket){
	//SERVER
	msgid = buffer_read(buffer,buffer_u8);
	switch(msgid){
		case network.text: // text
			var _message = string(socket) + ": " + buffer_read(buffer,buffer_string);
			ds_list_add(shell.output,_message);
			send_string(_message);
			break;
		case network.move:
			var _id = buffer_read(buffer,buffer_u8);
			var _move_x = buffer_read(buffer,buffer_u16);
			var _move_y = buffer_read(buffer,buffer_u16);
			
			var _player = socket_to_instanceid[? socket];
			_player.x = _move_x;
			_player.y = _move_y;
				
			buffer_seek(server_buffer,buffer_seek_start,0);
			buffer_write(server_buffer,buffer_u8,network.move);
			buffer_write(server_buffer,buffer_u8,_id);
			buffer_write(server_buffer,buffer_u16,_move_x);
			buffer_write(server_buffer,buffer_u16,_move_y);
			var i = 0; repeat (ds_list_size(socket_list)){
				var _socket = socket_list[| i];
				network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
				i++;
			}
			break;
	}
}

function send_string(str){
	buffer_seek(server_buffer,buffer_seek_start,0);
	buffer_write(server_buffer,buffer_u8,network.text);
	buffer_write(server_buffer,buffer_string,str);
	var i = 0; repeat (ds_list_size(socket_list)){
		var _socket = socket_list[| i];
		network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
		i++;
	}
}

player_count	= 0;
player_spawn_x	= 100;
player_spawn_y	= 100;
colors			= [c_red,c_blue,c_yellow,c_green];