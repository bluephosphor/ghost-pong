if (room != r_menu) exit;

draw_set_font(font_console);
draw_set_halign(fa_center);
draw_set_color(c_white)

draw_text(room_width/2,100,"Please enter a username.\n(Enter to confirm.)");
draw_text_ext_transformed(room_width/2,150,client_username,20,room_width,2,2,0);

draw_set_halign(fa_left);