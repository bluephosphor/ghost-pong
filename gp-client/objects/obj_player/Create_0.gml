enum dir {
	up		= 90,
	down	= 270,
	left	= 180,
	right	= 0
}

//defining variables
//image_alpha = 0.5;
username = "";
name_height_offset = 16;
socket = -1;
player_number = 0;
player_class = 0;
equipped = spr_ghost_hands;
in_special = 0;
in_attack = 0;
swing_speed = 4;

//movement variables
move = new vec2(0,0);
spd = new vec2(0,0);
accel =		{normal: 0.5,teleport: 1}
max_speed = {normal: 4,	 teleport: 12};
frict = 0.2;

last_dir = dir.down;
startup_frames = 0;

teleport_length = 10;
teleport_counter = 0;
teleport_regen_speed = 0.3;
phase_speed = 0.3;

state = playerstate_normal;
face = 1;
hitstun = 0;
blink = false;

inputs_sent		= array_create(input_packet.enum_length,false);
input_sender	= array_create(input_packet.enum_length,false);

trail = [];