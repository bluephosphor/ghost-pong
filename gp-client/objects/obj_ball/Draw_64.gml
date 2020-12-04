var _str = "speeding: " + string(direction) + "\n";

var i = 0; _str += "trail: ["; repeat(array_length(trail)){
	if (is_struct(trail[i])) _str += "o";
	else _str += ".";
	i++;
}

_str += "]";

draw_text(0,room_height-string_height(_str),_str);