if (gamestate == ACTIONABLE){
	//positions baybeeeeeeee
	var _draw_x		= (room_width / 6) * (socket - 1);
	var _offset		= 8;
	var _bar_width	= 40;
	var _margin		= 2;
	var _bar_length = _bar_width * teleport_counter / teleport_length;
	var _c			= (teleport_counter == 0) ? image_blend : c_gray;

	//draw outer rectangle
	draw_rectangle_color(
		_draw_x + _offset - _margin,
		room_height - 12 - _margin, 
		_draw_x + _offset + _bar_width + _margin,
		room_height - _offset + _margin,
		_c,_c,_c,_c,
		true
	);
	//draw inner rectangle
	draw_rectangle_color(
		_draw_x + _offset,
		room_height - 12, 
		_draw_x + _offset + _bar_width - _bar_length, 
		room_height - _offset,
		_c,_c,_c,_c,
		false
	);
}

if (!debug) exit;

var _str = "| tpcounter: "+ string(teleport_counter) + "\n| state: ";

switch(state){
	case playerstate_normal: _str += "normal"; break;
	case playerstate_attack: _str += "attack"; break;
	case playerstate_teleport: _str += "teleport";break;
}

draw_text(_draw_x,room_height-string_height(_str),_str);