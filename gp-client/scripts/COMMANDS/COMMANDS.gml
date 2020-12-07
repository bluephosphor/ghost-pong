function string_value(value){
	var _log = undefined;
	
	if (value == "true") return true;
	else if (value == "false") return false;
	else {
		try {
			value = real(value);
		} catch(_log) {
			show_debug_message(_log.message);
			return undefined;
		}
		if (_log == undefined) return value;
	}
}

function sh_instcount(args){
	return "instance count: " + string(instance_count);
}

function sh_pixelscale(args){
	var _num = string_value(args[1]);
	if (_num == 0) return "Can not resize to zero."
	var _w = room_width  * _num;
	var _h = room_height * _num;
	window_set_size(_w,_h);
	window_center();
	return "resized window to x: " + string(_w) + " y: " + string(_h);
}

function sh_ballreset(args){
	send_command(args[0]);
	return "ballreset command sent to SERVER..."
}

function sh_disconnect(args){
	if (room != r_game) return "not in server..."
	shell.close();
	
	network_destroy(client);
	gamestate = PREGAME;
	room_goto(r_menu);
}