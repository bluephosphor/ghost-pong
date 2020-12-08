step_counter++;
if (step_counter < step_limit) exit;
		
curr_frame++;
step_counter = 0;
if (curr_frame >= anim_limit) {
	anim_limit = 2;
	step_limit = 10;
	curr_frame = 0;
}
