//id variables
username = "";
name_height_offset = 24;

enum input_packet{
	move_x,
	move_y,
	special,
	enum_length,
}

x_last = x;
y_last = y;

velocity = new vec2(0,0);