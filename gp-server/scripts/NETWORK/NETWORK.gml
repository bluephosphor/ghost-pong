function network_player_join(username){
	
	//create obj_player in server
	var _player = instance_create_layer(player_spawns[socket].x,player_spawns[socket].y,layer,obj_player);
	_player.username = username; //give player username
	_player.image_blend = colors[socket]; //set player color
	
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