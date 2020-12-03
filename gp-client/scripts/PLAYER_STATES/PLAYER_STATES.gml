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
	if (hands.animation_ended) hands.animation_ended = false;
	move_and_collide();
}

function playerstate_attack(){
	spd.x = lerp(spd.x,0,frict);
	spd.y = lerp(spd.y,0,frict);
	move_and_collide();
	
	if (hands.animation_ended){
		state = playerstate_normal;
		hands.animation_ended = false;
	}
}