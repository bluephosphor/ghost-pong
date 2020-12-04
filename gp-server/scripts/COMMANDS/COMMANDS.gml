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

function sh_set_fps(args){
	var _value = string_value(args[1]);
	
	if (!is_real(_value)) return "invalid type, use a number. ex: 'set_fps 60'."
	
	buffer_seek(server_buffer,buffer_seek_start,0);
	buffer_write(server_buffer,buffer_u8,network.server_command);
	buffer_write(server_buffer,buffer_string,args[0]);
	buffer_write(server_buffer,buffer_u8,args[1]);
	var i = 0; repeat (ds_list_size(socket_list)){
		var _socket = socket_list[| i];
		network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
		i++;
	}
	game_set_speed(_value,gamespeed_fps);
	return "set FPS to " + args[1];
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
	surface_resize(application_surface,_w,_h);
	view_width = _w;
	view_height = _w;
	window_center();
	return "resized window to x: " + string(_w) + " y: " + string(_h);
}