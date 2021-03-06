var _res = shader_get_uniform(sh_outline,"resolution");
shader_set(sh_outline);
var _tex = sprite_get_texture(sprite_index,image_index);
var _resolution_x = texture_get_texel_width(_tex);
var _resolution_y = texture_get_texel_height(_tex);
shader_set_uniform_f(_res, _resolution_x, _resolution_y);

trail_sprite_draw();

var _a = (blink)? 0.3 : image_alpha;

//body
draw_sprite_ext(
	sprite_index,
	image_index,
	x,y,
	image_xscale,
	image_yscale,
	image_angle,
	image_blend,
	_a
);

//face
shader_reset();
draw_sprite_ext(
	asset_get_index("spr_ghost_face_" + string(face)),
	-1,x,y,
	image_xscale,
	image_yscale,
	image_angle,
	c_white,
	1
);

//hands
shader_set(sh_outline);
draw_sprite_ext(
	equipped,
	myhands.curr_frame,
	x,y,
	image_xscale,
	image_yscale,
	image_angle,
	image_blend,
	_a
);
shader_reset();

draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_text(x,y-name_height_offset,username);
draw_set_halign(fa_left);
draw_set_valign(fa_left);