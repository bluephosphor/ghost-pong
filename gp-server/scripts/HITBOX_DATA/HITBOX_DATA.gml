/*
*  here we're just defining the "power" each hitbox sprite has per frame
*  so when adding an attack we just count the sprite frames, and make
*  an array setting values for each frame, then storing this in a map
*  with the sprites index as the keys
*/

hitbox_data = ds_map_create();
hitbox_data[? spr_hitbox_punch] = [0,0,7,6,4];