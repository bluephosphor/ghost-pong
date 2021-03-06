function playerstate_normal(){
	
	face = 1;
	image_alpha		 = approach(image_alpha,1,phase_speed);
	teleport_counter = approach(teleport_counter,0,teleport_regen_speed);
	
	spd.x += accel.normal * move.x;
	spd.y += accel.normal * move.y;

	var _spd = point_distance(0,0,spd.x,spd.y);
	var _dir = point_direction(0,0,spd.x,spd.y);

	if (_spd > max_speed.normal){
		spd.x = lengthdir_x(max_speed.normal,_dir);
		spd.y = lengthdir_y(max_speed.normal,_dir);
	}

	if (move.x == 0){
		spd.x = lerp(spd.x,0,frict);
	} else {
		image_xscale = move.x;
	}
	if (move.y == 0){
		spd.y = lerp(spd.y,0,frict);
	}
	if (in_special and teleport_counter == 0) {
		spd.x *= 3;
		spd.y *= 3;
		state = playerstate_teleport;
	}
	if (in_attack)  state = playerstate_attack;
	if (myhands.animation_ended) myhands.animation_ended = false;
	move_and_collide();
}

function playerstate_teleport(){
	
	array_push(trail,new trail_sprite(id,0.03));
	
	face = 2;
	image_alpha		 = approach(image_alpha,0,phase_speed);
	teleport_counter = approach(teleport_counter,teleport_length,1);
	
	spd.x += accel.teleport * move.x;
	spd.y += accel.teleport * move.y;

	var _spd = point_distance(0,0,spd.x,spd.y);
	var _dir = point_direction(0,0,spd.x,spd.y);

	if (_spd > max_speed.teleport){
		spd.x = lengthdir_x(max_speed.teleport,_dir);
		spd.y = lengthdir_y(max_speed.teleport,_dir);
	}
	
	
	if (in_attack)  {
		startup_frames = 3;
		state = playerstate_attack;
	}
	if (teleport_counter == teleport_length) or (!in_special) {
		state = playerstate_normal;
	}
	if (myhands.animation_ended) myhands.animation_ended = false;
	
	move_and_collide();
}

function playerstate_attack(){
	if (startup_frames){
		//giving_player a small window to turn around out of teleport into attack
		if (last_dir_recieved == dir.right) image_xscale = 1;
		if (last_dir_recieved == dir.left)  image_xscale = -1;
	}
	face = 3
	image_alpha		 = approach(image_alpha,1,phase_speed);
	teleport_counter = approach(teleport_counter,0,1);
	spd.x = lerp(spd.x,0,frict);
	spd.y = lerp(spd.y,0,frict);
	move_and_collide();
	
	if (myhands.animation_ended){
		state = playerstate_normal;
		myhands.animation_ended = false;
	}
}

function playerstate_hitstun(){
	face			 = 4;
	image_alpha		 = approach(image_alpha,1,phase_speed);
	teleport_counter = approach(teleport_counter,0,1);
	spd.x = lerp(spd.x,0,frict/2);
	spd.y = lerp(spd.y,0,frict/2);
	input_sender[input_packet.move_x] = 0;
	input_sender[input_packet.move_y] = 0;
	move_and_collide();
	
	
	if (myhands.animation_ended){
		myhands.animation_ended = false;
	}
	
	hitstun--;
	blink = ((hitstun div 4) mod 2 == 0);
	if (!hitstun) {
		blink = false;
		state = playerstate_normal;
	}
}

function hands(spr,attack_spd) constructor {
	idle_speed			= 15; //<
	attack_speed		= attack_spd;  //< steps-per-frame
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