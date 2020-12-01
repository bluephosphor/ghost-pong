if (room != r_menu) exit;

draw_set_font(font_console);
draw_set_halign(fa_center);
draw_set_color(c_white)

draw_text(room_width/2,200,"Please enter a username.");
draw_text_ext_transformed(room_width/2,400,client_username,20,room_width,2,2,0);