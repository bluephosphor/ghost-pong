x = myplayer.x
y = myplayer.y

strength = hitbox_data[? sprite_index][image_index-1];

var _inst = instance_place(x,y,obj_player);

if (_inst == noone)		exit;
if (_inst == myplayer)	exit;

var _dir = point_direction(x,y,_inst.x,_inst.y);
var _x_inf = lengthdir_x(strength,_dir);
var _y_inf = lengthdir_y(strength,_dir);

send_hitstun(_inst.mysocket,strength,_x_inf,_y_inf);