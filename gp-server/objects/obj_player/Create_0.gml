enum input_packet{
	move_x,
	move_y,
	special,
	enum_length,
}

enum state {
	normal,
	teleport,
	hitstun,
}
//id variables
username = "";
mysocket = 0;
name_height_offset = 16;
myhitbox = noone;
playerstate = state.normal;
player_class = -1;

velocity = new vec2(0,0);
tp_start = new vec2(x,y);
tp_end = new vec2(x,y);
tp_cooldown = 0;