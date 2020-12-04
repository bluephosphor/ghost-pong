switch(playerstate){
	case state.normal: 
		tp_cooldown = approach(tp_cooldown,0,1);
		image_alpha = 1; 
		break;
	case state.teleport: 
		image_alpha = 0.3;
		break;
}