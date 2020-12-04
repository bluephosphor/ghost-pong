globalvar debug, gamestate;

#macro ACTIONABLE 0
#macro SHELL 1

debug = false;
gamestate = ACTIONABLE;

sh_pixelscale([-1,"3"]);
alarm[0] = 1;
client_username = "";