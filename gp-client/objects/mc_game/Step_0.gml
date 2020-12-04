if (room != r_menu) exit;

if (keyboard_check_pressed(vk_anykey)) {
	switch (keyboard_lastkey){
	
	case 50: exit;
	case vk_lcontrol:
	case vk_control:
	case vk_alt:
	case vk_tab:
	case vk_escape:
	case vk_shift: break;
	
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