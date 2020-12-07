switch(room){
	case r_game: exit;
	case r_menu:
		if (keyboard_check_pressed(vk_enter)){
			//network_destroy(matchmaking_socket);
			gamestate = ACTIONABLE;
			room_goto(r_game);
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