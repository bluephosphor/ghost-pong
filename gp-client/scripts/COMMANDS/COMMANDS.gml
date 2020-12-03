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
	return string(clamp(instance_count - 2,0,10));
}

function sh_pixelscale(args){
	var _num = string_value(args[1]);
	if (_num == 0) return "Can not resize to zero."
	var _w = room_width * _num;
	var _h = room_height * _num;
	window_set_size(_w,_h);
	surface_resize(application_surface,_w,_h);
	window_center();
}