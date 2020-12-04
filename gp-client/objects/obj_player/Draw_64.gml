if (!debug) exit;

var _str = "| tpcounter: "+ string(teleport_counter) + "\n| state: ";

switch(state){
	case playerstate_normal: _str += "normal"; break;
	case playerstate_attack: _str += "attack"; break;
	case playerstate_teleport: _str += "teleport";break;
}

draw_text((room_width / 4) * (socket - 1),room_height-string_height(_str),_str);