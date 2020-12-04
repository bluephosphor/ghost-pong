if (room != r_menu) exit;

if (keyboard_check_pressed(vk_enter)){
	client_username = keyboard_string;
	gamestate		= ACTIONABLE;
	room_goto(r_game);
}