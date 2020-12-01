//defining variables
image_alpha = 0.5;
username = "";
name_height_offset = 24;
socket = -1;

//movement variables

move = new vec2(0,0);
spd = new vec2(0,0);
accel = 1;
max_speed = 3;
frict = 0.5;

state = playerstate_normal;

enum input_packet{
	move_x,
	move_y,
	special,
	enum_length,
}

inputs_sent		= array_create(input_packet.enum_length,false);
input_sender	= array_create(input_packet.enum_length,false);