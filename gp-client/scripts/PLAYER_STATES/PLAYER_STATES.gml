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
}

function animate_hands(){
	var _attacking		= (state == playerstate_attack);
	var _step_limit		= _attacking ? myhands.attack_speed : myhands.idle_speed;
	var _anim_limit		= _attacking ? myhands.attack_frame_end : myhands.idle_frame_end;
		
	myhands.step_counter++;
	if (myhands.step_counter < _step_limit) return;
		
	myhands.curr_frame++;
	myhands.step_counter = 0;
	if (myhands.curr_frame > _anim_limit) {
		myhands.curr_frame = 0;
		myhands.animation_ended = true;
	}
}