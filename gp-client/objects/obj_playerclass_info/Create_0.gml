alarm[0] = 60;
sprite_index = spr_ghost_1;
image_speed = 0.5;
player_set_class(0);

face = 3;
name_height_offset = 16;
step_counter = 0;
step_limit = swing_speed;

curr_frame = 0;
anim_limit = sprite_get_number(equipped);

classnames = ["PUNCH","SWORD"];