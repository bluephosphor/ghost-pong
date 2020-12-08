/*
*  here we're just defining the "power" each hitbox sprite has per frame
*  so when adding an attack we just count the sprite frames, and make
*  an array setting values for each frame, then storing this in a map
*  with the sprites index as the keys
*/

enum class {
	punch,
	sword,
}

class_data[class.punch] = {spr: spr_hitbox_punch, frames: [0,0,7,6,4],			spd: 4};
class_data[class.sword] = {spr: spr_hitbox_sword, frames: [0,0,0,0,6,5,4,2],	spd: 3};

function animate_hitbox(){
	step_counter++;
	if (step_counter < step_limit) return;
		
	
	step_counter = 0;
	if (image_index +1 >= anim_limit) {
		myplayer.myhitbox = noone;
		instance_destroy();
	}
	image_index++;
}