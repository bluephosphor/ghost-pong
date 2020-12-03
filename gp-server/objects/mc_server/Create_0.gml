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

port = 682;
max_clients = 6;

network_create_server(network_socket_tcp,port,max_clients);

globalvar server, shell, server_buffer, socket_list, ball, hitbox_data;
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
			var _message = "}" + buffer_read(buffer,buffer_string) + ": " + buffer_read(buffer,buffer_string);
			ds_list_add(shell.output,_message);
			send_string(_message);
			break;
		case network.player_command:
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
		
					network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
				} else {
					buffer_seek(server_buffer,buffer_seek_start,0);
					buffer_write(server_buffer,buffer_u8,network.ball_update);
					buffer_write(server_buffer,buffer_f32,ball.x);
					buffer_write(server_buffer,buffer_f32,ball.y);
		
					network_send_packet(_sock,server_buffer,buffer_tell(server_buffer));
				}
				i++;
			}
			break;
		case network.player_input:
			var _move_x = buffer_read(buffer,buffer_s8);
			var _move_y = buffer_read(buffer,buffer_s8);
			var _special = buffer_read(buffer,buffer_bool);
			
			var _player = socket_to_instanceid[? socket];
			if (_move_x != 0) _player.image_xscale = _move_x;
			if (_special) with (_player){
				if (myhitbox = noone) {
					myhitbox = instance_create_layer(_player.x,_player.y,layer,obj_hitbox);
					myhitbox.sprite_index = spr_hitbox_punch;
					myhitbox.image_xscale = image_xscale;
					myhitbox.myplayer = id;
				}
			}
				
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

players_online		= "0";
player_spawns[0]	= new vec2(room_width div 2, room_height div 2); //this shouldn't get used
player_spawns[1]	= new vec2(room_width * 0.25, room_height * 0.25); 
player_spawns[2]	= new vec2(room_width * 0.75, room_height * 0.25); 
player_spawns[3]	= new vec2(room_width * 0.25, room_height * 0.75); 
player_spawns[4]	= new vec2(room_width * 0.75, room_height * 0.75); 
player_spawns[5]	= new vec2(room_width * 0.25, room_height * 0.5); 
player_spawns[6]	= new vec2(room_width * 0.75, room_height * 0.5); 
colors				= [c_black,c_red,c_blue,c_yellow,c_green,c_orange,c_fuchsia];
ball = {
	init: function(){
		self.radius = 8;
		self.x = room_width div 2;
		self.y = room_height div 2;
		self.spd = {x: 0, y: 0,};
		self.frict = 0.005;
		self.colbuffer = 30;
		self.punchbuffer = 30;
	},
	
	update: function(){
		var _collided = collision_circle(self.x,self.y,self.radius,obj_hitbox,true,false);
		if (punchbuffer > 0) _collided = noone; 
		if (_collided != noone){
			var _frame = _collided.image_index;
			var _power = hitbox_data[? _collided.sprite_index][_frame];
			var _dir = point_direction(_collided.x,_collided.y,self.x,self.y);
			self.spd.x = lengthdir_x(_power,_dir);
			self.spd.y = lengthdir_y(_power,_dir);
			punchbuffer = 20;
		}
		var _collided = collision_circle(self.x,self.y,self.radius,obj_player,false,false);
		if (colbuffer > 0) _collided = noone; 
		if (_collided != noone) {
			//self.spd.x = -self.spd.x;
			//self.spd.y = -self.spd.y;
			self.spd.x += _collided.velocity.x;
			self.spd.y += _collided.velocity.y;
			colbuffer = 20;
		}
		self.spd.x = lerp(self.spd.x,0,self.frict);
		self.spd.y = lerp(self.spd.y,0,self.frict);
		self.x += self.spd.x;
		self.y += self.spd.y;
		if (self.x > room_width  - 8 or self.x < 8) self.spd.x = -self.spd.x;
		if (self.y > room_height - 8 or self.y < 8) self.spd.y = -self.spd.y;
		if (self.colbuffer > 0)		self.colbuffer--;
		if (self.punchbuffer > 0)	self.punchbuffer--;
		
	},
	draw: function(){
		draw_circle(self.x,self.y,self.radius,(!self.colbuffer <= 0));
	}
}

ball.init();