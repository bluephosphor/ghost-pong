//if (last_pos.x != x or last_pos.y != y){
//	direction	= point_direction(last_pos.x,last_pos.y,x,y);
//	distance	= point_distance(last_pos.x,last_pos.y,x,y);
//	velocity.x	= lengthdir_x(distance,direction); 
//	velocity.y	= lengthdir_y(distance,direction);
//	force		= max(abs(velocity.x),abs(velocity.y));


//	last_pos.x = x;
//	last_pos.y = y;
//}

if (speeding) array_push(trail,new trail_sprite(id,0.05));

trail_sprite_update();