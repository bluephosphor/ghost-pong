function playerstate_normal(){
	spd.x += accel * move.x;
	spd.y += accel * move.y;

	var _spd = point_distance(0,0,spd.x,spd.y);
	var _dir = point_direction(0,0,spd.x,spd.y);

	if (_spd > max_speed){
		spd.x = lengthdir_x(max_speed,_dir);
		spd.y = lengthdir_y(max_speed,_dir);
	}

	if (move.x == 0){
		spd.x = lerp(spd.x,0,frict);
	} else {
		image_xscale = move.x;
	}
	if (move.y == 0){
		spd.y = lerp(spd.y,0,frict);
	}
	if (in_special) state = playerstate_attack;
	if (myhands.animation_ended) myhands.animation_ended = false;
	move_and_collide();
}

function playerstate_attack(){
	spd.x = lerp(spd.x,0,frict);
	spd.y = lerp(spd.y,0,frict);
	move_and_collide();
	
	if (myhands.animation_ended){
		state = playerstate_normal;
		myhands.animation_ended = false;
	}
}

function hands(spr) constructor {
	idle_speed			= 15; //<
	attack_speed		= 4;  //< steps-per-frame
	idle_frame_end		= 1;
	attack_frame_end	= sprite_get_number(spr);
	curr_frame			= 0;
	step_counter		= 0;
	animation_ended		= false;
	
	update = function(){
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