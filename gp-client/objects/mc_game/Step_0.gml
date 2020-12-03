if (room != r_menu) exit;

if (keyboard_check_pressed(vk_anykey)) {
	switch (keyboard_lastkey){
	case vk_backspace: 
		if (client_username != ""){
			client_username = string_copy(client_username,0,string_length(client_username) -1); 
		}
		break;
	case vk_enter: 
		room_goto(r_game); 
		break;
	default: 
		client_username += keyboard_lastchar; 
		break;
	}
}