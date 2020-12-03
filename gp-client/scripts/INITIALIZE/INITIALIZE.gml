globalvar input, client_controller;

enum key {
	left,
	right,
	up,
	down,
	special,
	attack,
	chat,
	enum_length
}

input[key.left]		= vk_left;
input[key.right]	= vk_right;
input[key.up]		= vk_up;
input[key.down]		= vk_down;
input[key.special]	= ord("Z");
input[key.attack]	= ord("X");
input[key.chat]		= ord("T");

enum input_packet{
	move_x,
	move_y,
	special,
	attack,
	enum_length,
}