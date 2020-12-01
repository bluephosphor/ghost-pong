//defining variables
image_alpha = 0.5;
username = "";
name_height_offset = 24;
socket = -1;

//movement variables

move = new vec2(0,0);
spd = new vec2(0,0);
accel = 3;
max_speed = 6;
frict = 0.5;

state = playerstate_normal;
resync_counter = 30;
alarm[0] = resync_counter;

enum input_packet{
	move_x,
	move_y,
	special,
	enum_length,
}

inputs_sent		= array_create(input_packet.enum_length,false);
input_sender	= array_create(input_packet.enum_length,false);