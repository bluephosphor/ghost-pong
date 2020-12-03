//defining variables
//image_alpha = 0.5;
username = "";
name_height_offset = 24;
socket = -1;
equipped = spr_ghost_hands;
in_special = 0;

hands = {
	idle_speed:			15, //<
	attack_speed:		4,  //< steps-per-frame
	idle_frame_end:		1,
	attack_frame_end:	sprite_get_number(equipped),
	curr_frame:			0,
	step_counter:		0,
	animation_ended:	false,
	
	update: function(){
		var _id = mc_client.socket_to_instanceid[? mysocket];
		var _attacking		= (_id.state == playerstate_attack);
		var _step_limit		= _attacking ? self.attack_speed : self.idle_speed;
		var _anim_limit		= _attacking ? self.attack_frame_end : self.idle_frame_end;
		
		self.step_counter++;
		if (self.step_counter < _step_limit) return;
		
		self.curr_frame++;
		self.step_counter = 0;
		if (self.curr_frame > _anim_limit) {
			self.curr_frame = 0;
			self.animation_ended = true;
		}
	}
}

//movement variables
move = new vec2(0,0);
spd = new vec2(0,0);
accel = 0.5;
max_speed = 4;
frict = 0.2;

state = playerstate_normal;
face = 1;

enum input_packet{
	move_x,
	move_y,
	special,
	enum_length,
}
inputs_sent		= array_create(input_packet.enum_length,false);
input_sender	= array_create(input_packet.enum_length,false);