globalvar debug, gamestate;

#macro ACTIONABLE	0
#macro SHELL		1
#macro PREGAME		2

debug			= false;
gamestate		= PREGAME;

keyboard_string = "";
client_username = "";

sh_pixelscale([-1,"3"]);
alarm[0] = 1;