pattern_generator(0,0,spr_background_patterns,room_width,room_height,400,bg_colors);

switch(room){
	case r_menu:
		draw_text(8,8, "servers online:");
		var i = 0, _str, _entry, _c; repeat(array_length(server_list)){
			_c = (i == menu_index) ? c_red : c_white;
			_entry = server_list[i];
			_str = _entry.ip;
			if (variable_struct_exists(_entry,"players_online")) _str += " (" + string(_entry.players_online) + "/6) in game.";
			draw_text_color(8,20 + (12*i),_str,_c,_c,_c,_c,1);
			i++;
		}
		
		var _c = matchmaking_connected ? c_green : c_red;
		var _str = "matchmaking server status: ";
		draw_circle_color(room_width - 6, room_height - 6, 4, _c,_c, false);
		draw_text(room_width - 8 - string_width(_str), room_height - 10, _str);
		break;

	case r_start:
		draw_set_font(font_console);
		draw_set_halign(fa_center);
		draw_set_color(c_white)

		draw_text(room_width div 2,room_height div 2 - 16,"please enter a username.\n(enter to confirm.)");
		draw_text_ext_transformed(room_width/2,room_height div 2 + 8,keyboard_string,20,room_width,2,2,0);

		draw_set_halign(fa_left);
		break;
}