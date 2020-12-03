switch(state){
	case playerstate_attack: face = 3; break;
	default: face = 1;
}
script_execute(state);
animate_hands();

if (mc_client.socket_to_instanceid[? mysocket] != id) exit;

if (keyboard_update()){
	input_sender[input_packet.move_x]  = keyboard_check(input[key.right]) - keyboard_check(input[key.left]);
	input_sender[input_packet.move_y]  = keyboard_check(input[key.down]) - keyboard_check(input[key.up]);
	input_sender[input_packet.special] = keyboard_check(input[key.special]);
	input_sender[input_packet.attack]  = keyboard_check(input[key.attack]);
	var _len = array_length(input_sender);
	//checking if any control inputs have changed
	var i = 0; repeat(_len){
		if (input_sender[i] != inputs_sent[i]) {
			//if so, send input buffer and update inputs_sent
			buffer_seek(client_buffer,buffer_seek_start,0);
			buffer_write(client_buffer,buffer_u8,network.player_input);
			buffer_write(client_buffer,buffer_s8,input_sender[input_packet.move_x]);
			buffer_write(client_buffer,buffer_s8,input_sender[input_packet.move_y]);
			buffer_write(client_buffer,buffer_bool,input_sender[input_packet.special]);
			buffer_write(client_buffer,buffer_bool,input_sender[input_packet.attack]);
			network_send_packet(client,client_buffer,buffer_tell(client_buffer));
			array_copy(inputs_sent,0,input_sender,0,_len);
			break;
		}
		i++;
	}
}

send_pos(x,y);