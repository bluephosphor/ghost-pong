//defining variables
//image_alpha = 0.5;
username = "";
name_height_offset = 16;
socket = -1;
equipped = spr_ghost_hands;
in_special = 0;

myhands = new hands(equipped);

//movement variables
move = new vec2(0,0);
spd = new vec2(0,0);
accel = 0.5;
max_speed = 4;
frict = 0.2;

state = playerstate_normal;
face = 1;

enum input_packet{
	move_x,
	move_y,
	special,
	enum_length,
}
inputs_sent		= array_create(input_packet.enum_length,false);
input_sender	= array_create(input_packet.enum_length,false);

