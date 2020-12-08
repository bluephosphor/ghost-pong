//draw background
draw_set_alpha(0.6)
var _c = c_black;
draw_rectangle_color(3,3,room_width-3,room_height-3,_c,_c,_c,_c,false);
draw_set_alpha(1)

//draw vars
draw_text(4,4,"choose a class: <"+classnames[mc_game.menu_index_x]+">\n");
var _list = ["accel","max_speed","frict","swing_speed","teleport_length","teleport_regen_speed"];
var _str = "";

var i = 0; repeat(array_length(_list)){
	var _name = _list[i];
	if (variable_instance_exists(id,_name)) {
		_str += _name + ": " + string(variable_instance_get(id,_name)) + "\n";
	}
	i++;
}

draw_text(4,room_height-string_height(_str)+4,_str);

//draw player preview
var _res = shader_get_uniform(sh_outline,"resolution");
shader_set(sh_outline);
var _tex = sprite_get_texture(sprite_index,image_index);
var _resolution_x = texture_get_texel_width(_tex);
var _resolution_y = texture_get_texel_height(_tex);
shader_set_uniform_f(_res, _resolution_x, _resolution_y);

//body
draw_sprite_ext(
	sprite_index,
	image_index,
	x,y,
	image_xscale,
	image_yscale,
	image_angle,
	image_blend,
	0.5
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
	curr_frame,
	x,y,
	image_xscale,
	image_yscale,
	image_angle,
	image_blend,
	1
);
shader_reset();

draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_text(x,y-name_height_offset,mc_game.client_username);
draw_set_halign(fa_left);
draw_set_valign(fa_left);