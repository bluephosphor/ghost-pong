if (room != r_menu) exit;

draw_set_font(font_console);
draw_set_halign(fa_center);
draw_set_color(c_white)

draw_text(room_width div 2,room_height div 2 - 16,"Please enter a username.\n(Enter to confirm.)");
draw_text_ext_transformed(room_width/2,room_height div 2 + 8,keyboard_string,20,room_width,2,2,0);

draw_set_halign(fa_left);