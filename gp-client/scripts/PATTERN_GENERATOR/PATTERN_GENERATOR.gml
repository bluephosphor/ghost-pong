function pattern_generator(x,y,spr,width,height,steps,color_array){
	if (!variable_instance_exists(id,"pattern_surf")) pattern_surf = -1
	if (!surface_exists(pattern_surf)) {
		pattern_surf = surface_create(width,height);
		surface_set_target(pattern_surf);
		draw_clear_alpha(c_black,0);
		
		var _spr_w = sprite_get_width(spr);
		var _spr_h = sprite_get_height(spr);
		var _spr_num = sprite_get_number(spr);
		var _c_len = array_length(color_array)-1;
		var _xx,_yy,_scale,_r,_c1,_c2,_cc,_c,_si,_a;
		var i = 0; repeat(steps){
			_xx = irandom(width);
			_yy = irandom(height);
			_scale = 1;
			
			_cc	= i / steps * _c_len 
			_c1	= color_array[floor(_cc)];
			_c2	= color_array[ceil (_cc)];
			_c  = merge_color(_c1,_c2, _cc - floor(_cc));
			
			_si = floor(i / steps * _spr_num); 
			_r  = 90 * irandom(3);
			_a  = clamp((i / steps * 1),0.5,1);
			
			draw_sprite_ext(spr,_si,_xx,_yy,_scale,_scale,_r,_c,_a);
			i++;
		}
		surface_reset_target();
		show_debug_message("pattern surface created")
	} else draw_surface(pattern_surf,x,y);
}