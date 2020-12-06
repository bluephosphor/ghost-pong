globalvar debug, gamestate, colors;

#macro ACTIONABLE	0
#macro SHELL		1
#macro PREGAME		2

debug			= false;
gamestate		= PREGAME;
colors			= [c_black,c_red,c_aqua,c_yellow,c_green,c_orange,c_fuchsia];

bg_colors = [c_red,c_fuchsia,c_blue,c_dkgray,c_white,c_white];

keyboard_string = "";
client_username = "";

sh_pixelscale([-1,"3"]);
alarm[0] = 1;

depth += 10;