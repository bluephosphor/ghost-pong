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
	selected_server = "";
	room_goto(r_menu);
}

function sh_pattern_regen(args){
	with (mc_game){
		surface_free(pattern_surf);
		pattern_surf = noone;
	}
	return "backround pattern regenerated";
}

function sh_direct_connect(args){
	if (room != r_menu) return "you must be in the menu to use this command...";
	selected_server = (array_length(args) > 1) ? args[1] : editme_loaded.host_ip; 
	gamestate = ACTIONABLE;
	room_goto(r_game);
	
}