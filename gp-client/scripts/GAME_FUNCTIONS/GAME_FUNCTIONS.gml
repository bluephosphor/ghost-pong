function vec2(x,y) constructor{
	self.x = x;
	self.y = y;
}

function move_and_collide(){
	var sx = self.spd.x;
	var sy = self.spd.y;
	var _moving = (sx != 0 or sy != 0);
	
	if (place_meeting(self.x + sx,self.y,obj_boundary)){
		while (!place_meeting(self.x + sign(sx),self.y,obj_boundary)){
			self.x += sign(sx);
		}
		_moving = false;
		sx = 0;
	}
	self.x += sx;
	
	if (place_meeting(self.x,self.y + sy,obj_boundary)){
		while (!place_meeting(self.x,self.y + sign(sy),obj_boundary)){
			self.y += sign(sy);
		}
		_moving = false;
		sy = 0;
	}
	self.y += sy;
	
}

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
	move_and_collide();
}