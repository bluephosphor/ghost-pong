switch(room){
	case r_game: exit;
	case r_menu:
		//picking server
		var _len = array_length(server_list);
		if (_len > 0){
			var _vinput = keyboard_check_pressed(input[key.down]) - keyboard_check_pressed(input[key.up]);
			if (_vinput != 0){
				menu_index_y += _vinput;
				menu_index_y = wrap_value(menu_index_y,0,_len - 1);
			}
		}
		//picking class
		var _len = class.enum_length;
		
		var _hinput = keyboard_check_pressed(input[key.right]) - keyboard_check_pressed(input[key.left]);
		if (_hinput != 0){
			menu_index_x += _hinput;
			menu_index_x = wrap_value(menu_index_x,0,_len - 1);
			
			with (obj_playerclass_info){
				player_set_class(other.menu_index_x);
				step_counter = 0;
				step_limit = swing_speed;
				curr_frame = 0;
				anim_limit = sprite_get_number(equipped);
				alarm[0] = 60;
			}
		}
		
		if (keyboard_check_pressed(vk_enter)){
			//confirming both choices
			if (array_length(server_list) > 0) {
				var _entry = server_list[menu_index_y];
				selected_server = _entry.ip;
			}
			if (gamestate != SHELL and selected_server != ""){
				chosen_class = menu_index_x;
				gamestate = ACTIONABLE;
				room_goto(r_game);
			}
		}
		break;
	case r_start:
		if (keyboard_check_pressed(vk_enter)){
			client_username = keyboard_string;
			network_connect_async(matchmaking_socket,matchmaking_server_address,matchmaking_port);
			room_goto(r_menu);
		}
		break;
}