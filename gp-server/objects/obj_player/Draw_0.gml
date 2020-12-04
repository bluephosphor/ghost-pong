var _c = (tp_cooldown) ? c_white : image_blend;

draw_sprite_ext(
	sprite_index,
	image_index,
	x,
	y,
	image_xscale,
	image_yscale,
	image_angle,
	_c,
	image_alpha
)

draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_text(x,y-name_height_offset,username);
draw_set_halign(fa_left);
draw_set_valign(fa_left);