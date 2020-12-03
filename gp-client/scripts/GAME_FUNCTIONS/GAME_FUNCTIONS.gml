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

function approach(a, b, amount){
	// Moves "a" towards "b" by "amount" and returns the result
	// Nice bcause it will not overshoot "b", and works in both directions
	// Examples:
	//      speed = Approach(speed, max_speed, acceleration);
	//      hp = Approach(hp, 0, damage_amount);
	//      hp = Approach(hp, max_hp, heal_amount);
	//      x = Approach(x, target_x, move_speed);
	//      y = Approach(y, target_y, move_speed);
	if (a < b) {
	    a += amount;
		if (a > b) return b;
	} else {
	    a -= amount;
	    if (a < b) return b;
	}
	return a;
}