

pattern_generator(0,0,spr_background_patterns,room_width,room_height,800,bg_colors);


if (room != r_menu) exit;

var _c = (database_connected >= 0) ? c_green : c_red;

var _str = "matchmaking server status: ";
draw_text(room_width-string_width(_str)-8, room_height-8,_str);
draw_circle_color(room_width-6,room_height-6,4,_c,_c,false);

draw_set_font(font_console);
draw_set_halign(fa_center);
draw_set_color(c_white)

draw_text(room_width div 2,room_height div 2 - 16,"Please enter a username.\n(Enter to confirm.)");
draw_text_ext_transformed(room_width/2,room_height div 2 + 8,keyboard_string,20,room_width,2,2,0);

draw_set_halign(fa_left);