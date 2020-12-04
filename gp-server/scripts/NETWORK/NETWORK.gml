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
			send_string("}" + _message);
			break;
		case network.server_command:
			var _name	 = buffer_read(buffer,buffer_string);
			var _command = buffer_read(buffer,buffer_string);
			ds_list_add(shell.output,_name + "excecuted server command /" + _command);
			switch(_command){
				case "ballreset":
					ball.init();
					break;
			}
			break;
		case network.move:
			var _move_x = buffer_read(buffer,buffer_u16);
			var _move_y = buffer_read(buffer,buffer_u16);
			
			var _player = socket_to_instanceid[? socket];
			with (_player){
				var _dir = point_direction(x,y,_move_x,_move_y);
				velocity.x = lengthdir_x(1,_dir) * abs(_move_x - x); 
				velocity.y = lengthdir_y(1,_dir) * abs(_move_y - y);
				x = _move_x;
				y = _move_y;
			}
			
			var _ball_speeding = (ball.force > 4);
			var _ball_last_hit = ball.last_hit;
				
			var i = 0; repeat (ds_list_size(socket_list)){
				var _sock = socket_list[| i];
				if (_sock != socket){
					buffer_seek(server_buffer,buffer_seek_start,0);
					buffer_write(server_buffer,buffer_u8,network.move);
					buffer_write(server_buffer,buffer_u8,socket);
					buffer_write(server_buffer,buffer_u16,_move_x);
					buffer_write(server_buffer,buffer_u16,_move_y);
					buffer_write(server_buffer,buffer_f32,ball.x);
					buffer_write(server_buffer,buffer_f32,ball.y);
					buffer_write(server_buffer,buffer_bool,_ball_speeding);
					buffer_write(server_buffer,buffer_u8,_ball_last_hit);
		
					network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
				} else {
					buffer_seek(server_buffer,buffer_seek_start,0);
					buffer_write(server_buffer,buffer_u8,network.ball_update);
					buffer_write(server_buffer,buffer_f32,ball.x);
					buffer_write(server_buffer,buffer_f32,ball.y);
					buffer_write(server_buffer,buffer_bool,_ball_speeding);
					buffer_write(server_buffer,buffer_u8,_ball_last_hit);
		
					network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
				}
				i++;
			}
			break;
		case network.player_input:
			var _move_x  = buffer_read(buffer,buffer_s8);
			var _move_y  = buffer_read(buffer,buffer_s8);
			var _special = buffer_read(buffer,buffer_bool);
			var _attack  = buffer_read(buffer,buffer_bool);
			
			var _player = socket_to_instanceid[? socket];
			if (_move_x != 0) _player.image_xscale = _move_x;
			with (_player){
				if (_attack) {
					if (myhitbox = noone) {
						myhitbox = instance_create_layer(_player.x,_player.y,layer,obj_hitbox);
						myhitbox.sprite_index = spr_hitbox_punch;
						myhitbox.image_xscale = image_xscale;
						myhitbox.myplayer = id;
					}
				}
				playerstate = _special ? state.teleport : state.normal;
			}
				
			var i = 0; repeat (ds_list_size(socket_list)){
				var _socket = socket_list[| i];
				buffer_seek(server_buffer,buffer_seek_start,0);
				buffer_write(server_buffer,buffer_u8,network.player_input);
				buffer_write(server_buffer,buffer_u8,socket);
				buffer_write(server_buffer,buffer_s8,_move_x);
				buffer_write(server_buffer,buffer_s8,_move_y);
				buffer_write(server_buffer,buffer_bool,_special);
				buffer_write(server_buffer,buffer_bool,_attack);
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

function send_command(str){
	buffer_seek(server_buffer,buffer_seek_start,0);
	buffer_write(server_buffer,buffer_u8,network.server_command);
	buffer_write(server_buffer,buffer_string,str);
	var i = 0; repeat (ds_list_size(socket_list)){
		var _socket = socket_list[| i];
		network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
		i++;
	}
}

function network_player_join(username){
	
	//create obj_player in server
	var _player = instance_create_layer(player_spawns[socket].x,player_spawns[socket].y,layer,obj_player);
	_player.username = username; //give player username
	_player.image_blend = colors[socket]; //set player color
	_player.mysocket = socket;
	
	//add instance id of player to socket map
	ds_map_add(socket_to_instanceid,socket,_player);
		
	//create obj_player for connecting client
	buffer_seek(server_buffer,buffer_seek_start,0);
	buffer_write(server_buffer,buffer_u8,network.player_connect);
	buffer_write(server_buffer,buffer_u8,socket);
	buffer_write(server_buffer,buffer_u16,_player.x);
	buffer_write(server_buffer,buffer_u16,_player.y);
	buffer_write(server_buffer,buffer_string,_player.username);
	network_send_packet(socket,server_buffer,buffer_tell(server_buffer));
		
	//send in-game clients to the connecting client
	var i = 0; repeat (ds_list_size(socket_list)){
		var _sock = socket_list[| i];
		if (_sock != socket){
			var _otherplayer = socket_to_instanceid[? _sock];
			buffer_seek(server_buffer,buffer_seek_start,0);
			buffer_write(server_buffer,buffer_u8,network.player_connect);
			buffer_write(server_buffer,buffer_u8,_sock);
			buffer_write(server_buffer,buffer_u16,_otherplayer.x);
			buffer_write(server_buffer,buffer_u16,_otherplayer.y);
			buffer_write(server_buffer,buffer_string,_otherplayer.username);
			network_send_packet(socket,server_buffer,buffer_tell(server_buffer));
		}
		i++;
	}
	
	//send the client that just joined to the in-game clients
	var i = 0; repeat (ds_list_size(socket_list)){
		var _sock = socket_list[| i];
		if (_sock != socket){
			buffer_seek(server_buffer,buffer_seek_start,0);
			buffer_write(server_buffer,buffer_u8,network.player_connect);
			buffer_write(server_buffer,buffer_u8,socket);
			buffer_write(server_buffer,buffer_u16,_player.x);
			buffer_write(server_buffer,buffer_u16,_player.y);
			buffer_write(server_buffer,buffer_string,_player.username);
			network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
		}
		i++;
	}
	ds_list_add(shell.output,"player: " + username + " | client ID [" + string(socket) + "] connected.");
	send_string(username + " joined the game.");
}

function vec2(x,y) constructor{
	self.x = x;
	self.y = y;
}