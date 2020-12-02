enum network{
	player_establish,
	player_connect,
	player_disconnect,
	player_input,
	ball_update,
	text,
	move,
}

port = 682;
max_clients = 6;

network_create_server(network_socket_tcp,port,max_clients);

globalvar server, shell, server_buffer, socket_list, socket_to_instanceid;
server = id;
shell  = instance_create_layer(0,0,layer,obj_shell);
shell.open();

server_buffer			= buffer_create(1024,buffer_fixed,1);
socket_list				= ds_list_create();
socket_to_instanceid	= ds_map_create();

function received_packet(buffer,socket){
	//SERVER
	msgid = buffer_read(buffer,buffer_u8);
	switch(msgid){
		case network.player_establish:
			var _username = buffer_read(buffer,buffer_string);
			network_player_join(_username);
			break;
		case network.text: // chat
			var _message = buffer_read(buffer,buffer_string) + ": " + buffer_read(buffer,buffer_string);
			ds_list_add(shell.output,_message);
			send_string(_message);
			break;
		case network.move:
			var _move_x = buffer_read(buffer,buffer_u16);
			var _move_y = buffer_read(buffer,buffer_u16);
			
			var _player = socket_to_instanceid[? socket];
			_player.x = _move_x;
			_player.y = _move_y;
				
			var i = 0; repeat (ds_list_size(socket_list)){
				var _sock = socket_list[| i];
				if (_sock != socket){
					buffer_seek(server_buffer,buffer_seek_start,0);
					buffer_write(server_buffer,buffer_u8,network.move);
					buffer_write(server_buffer,buffer_u8,socket);
					buffer_write(server_buffer,buffer_u16,_move_x);
					buffer_write(server_buffer,buffer_u16,_move_y);
					network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
				}
				i++;
			}
			break;
		case network.player_input:
			var _move_x = buffer_read(buffer,buffer_s8);
			var _move_y = buffer_read(buffer,buffer_s8);
			var _special = buffer_read(buffer,buffer_bool);
			
			//var _player = socket_to_instanceid[? socket];
			//_player.x = _move_x;
			//_player.y = _move_y;
				
			var i = 0; repeat (ds_list_size(socket_list)){
				var _socket = socket_list[| i];
				buffer_seek(server_buffer,buffer_seek_start,0);
				buffer_write(server_buffer,buffer_u8,network.player_input);
				buffer_write(server_buffer,buffer_u8,socket);
				buffer_write(server_buffer,buffer_s8,_move_x);
				buffer_write(server_buffer,buffer_s8,_move_y);
				buffer_write(server_buffer,buffer_bool,_special);
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

players_online = "0";
player_spawn_x	= 100;
player_spawn_y	= 100;
colors			= [c_black,c_red,c_blue,c_yellow,c_green,c_orange,c_fuchsia];
ball = {
	radius: 5,
	x: room_width div 2,
	y: room_width div 2,
	spd: {x: 1, y: 0.5,},
	frict: 0.1,
	
	update: function(){
		self.x += self.spd.x;
		self.y += self.spd.y;
		if (self.x > room_width  or self.x < 0) self.spd.x = -self.spd.x;
		if (self.y > room_height or self.y < 0) self.spd.y = -self.spd.y;
		
		buffer_seek(server_buffer,buffer_seek_start,0);
		buffer_write(server_buffer,buffer_u8,network.ball_update);
		buffer_write(server_buffer,buffer_u16,ceil(self.x));
		buffer_write(server_buffer,buffer_u16,ceil(self.y));
		var i = 0; repeat (ds_list_size(socket_list)){
			var _socket = socket_list[| i];
			network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
			i++;
		}
	},
	draw: function(){
		draw_circle(self.x,self.y,self.radius,false);
	}
}