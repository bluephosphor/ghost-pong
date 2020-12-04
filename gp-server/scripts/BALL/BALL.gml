ball = {
	init: function(){
		self.radius = 8;
		self.x = room_width div 2;
		self.y = room_height div 2;
		self.spd = {x: 0, y: 0,};
		self.frict = 0.005;
		self.colbuffer = 30;
		self.punchbuffer = 30;
		self.force = 0;
		self.speeding = false;
		self.last_hit = 0;
		self.last_hit_color = c_white;
	},
	
	update: function(){
		var _collided = collision_circle(self.x,self.y,self.radius,obj_hitbox,true,false);
		if (punchbuffer > 0) _collided = noone; 
		if (_collided != noone){
			self.last_hit = _collided.myplayer.mysocket
			self.last_hit_color = colors[last_hit];
			var _frame = _collided.image_index;
			var _power = hitbox_data[? _collided.sprite_index][_frame]; 
			var _dir = point_direction(_collided.x,_collided.y,self.x,self.y);
			if (_collided.myplayer.tp_cooldown) _power *= 2;
			self.spd.x = lengthdir_x(_power,_dir);
			self.spd.y = lengthdir_y(_power,_dir);
			punchbuffer = 20;
		}
		var _collided = collision_circle(self.x,self.y,self.radius,obj_player,false,false);
		if (colbuffer > 0) _collided = noone; 
		if (_collided != noone and _collided.playerstate != state.teleport and !_collided.tp_cooldown) {
			//self.last_hit = _collided.mysocket;
			//self.spd.x = -self.spd.x;
			//self.spd.y = -self.spd.y;
			self.spd.x += _collided.velocity.x;
			self.spd.y += _collided.velocity.y;
			colbuffer = 20;
		}
		
		self.force = max(abs(self.spd.x),abs(self.spd.y));
		self.speeding = (self.force > 4);
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
		var _c = (self.speeding) ? self.last_hit_color : c_white;
		draw_circle_color(self.x,self.y,self.radius,_c,_c,(!self.colbuffer <= 0));
	}
}