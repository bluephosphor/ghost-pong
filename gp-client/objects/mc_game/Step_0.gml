switch(room){
	case r_game: exit;
	case r_menu:
		var _len = array_length(server_list);
		if (_len > 0){
			var _vinput = keyboard_check_pressed(input[key.down]) - keyboard_check_pressed(input[key.up]);
			if (_vinput != 0){
				menu_index += _vinput;
				menu_index = wrap_value(menu_index,0,_len - 1);
			}
		}
		
		if (keyboard_check_pressed(vk_enter)){
			//network_destroy(matchmaking_socket);
			if (array_length(server_list) > 0) selected_server = server_list[menu_index].ip;
			if (selected_server != ""){
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