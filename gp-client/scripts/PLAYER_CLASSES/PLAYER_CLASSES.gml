globalvar class_info;

enum class {
	punch,
	sword,
	enum_length,
}

function player_set_class(index){
	switch(index){
		case class.punch:
			equipped	= spr_ghost_hands;
			accel		= {normal: 0.5,	 teleport: 1}
			max_speed	= {normal: 4,	 teleport: 12};
			frict		= 0.2;

			swing_speed = 4;

			teleport_length			= 10;
			teleport_regen_speed	= 0.3;
			phase_speed				= 0.3;
		break;
		
		case class.sword:
			equipped	= spr_ghost_sword;
			accel		= {normal: 0.4,	 teleport: 1}
			max_speed	= {normal: 3,	 teleport: 10};
			frict		= 0.2;

			swing_speed = 3;

			teleport_length			= 8;
			teleport_regen_speed	= 0.2;
			phase_speed				= 0.3;
		break;
	}
	
	if (object_index == obj_player) myhands = new hands(equipped,swing_speed);
}