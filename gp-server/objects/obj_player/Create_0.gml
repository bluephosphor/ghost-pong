enum input_packet{
	move_x,
	move_y,
	special,
	enum_length,
}

enum state {
	normal,
	teleport,
}

//id variables
username = "";
mysocket = 0;
name_height_offset = 16;
myhitbox = noone;
playerstate = state.normal;

velocity = new vec2(0,0);