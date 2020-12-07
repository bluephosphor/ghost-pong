pattern_generator(0,0,spr_background_patterns,room_width,room_height,400,bg_colors);

switch(room){
	case r_menu:
		var i = 0; repeat(array_length(matchmaking_list)){
			draw_text(8,8,matchmaking_list[i].username + " : " + matchmaking_list[i].ip);
		}
		
		var _c = matchmaking_connected ? c_green : c_red;
		var _str = "ping_count: " + string(ping_count) + " | matchmaking server status: ";
		draw_circle_color(room_width - 6, room_height - 6, 4, _c,_c, false);
		draw_text(room_width - 8 - string_width(_str), room_height - 10, _str);
		break;

	case r_start:
		draw_set_font(font_console);
		draw_set_halign(fa_center);
		draw_set_color(c_white)

		draw_text(room_width div 2,room_height div 2 - 16,"Please enter a username.\n(Enter to confirm.)");
		draw_text_ext_transformed(room_width/2,room_height div 2 + 8,keyboard_string,20,room_width,2,2,0);

		draw_set_halign(fa_left);
		break;
}