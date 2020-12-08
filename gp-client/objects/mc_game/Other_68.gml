if (room == r_game) exit;

type_event = async_load[? "type"];

switch (type_event){
	case network_type_non_blocking_connect:
		var _success = ds_map_find_value(async_load, "succeeded");
            if (_success == 0){            
                //Failure connection. Retry.
                matchmaking_connected = false;
            } else {
                //Succesful connection.
                matchmaking_connected = true;
			}
		break;
	case network_type_data:
		var _buffer = async_load[? "buffer"];
		var _header = buffer_read(_buffer,buffer_u8);
		switch(_header){
			case matchmaking.client_init:
				var _buff = buffer_create(64,buffer_fixed,1);
				buffer_seek(_buff,buffer_seek_start,0);
				buffer_write(_buff,buffer_u8,matchmaking.client_init);
				buffer_write(_buff,buffer_string,client_username);
				buffer_write(_buff,buffer_string,client_ip);
				buffer_write(_buff,buffer_bool,false); //is_server
				network_send_packet(matchmaking_socket,_buff,buffer_tell(_buff));
				buffer_delete(_buff);
				break;
			case matchmaking.update:
				var _list = json_parse(buffer_read(_buffer,buffer_string));
				var _len  = array_length(_list);
				server_list = [];
				var i = 0, j = 0; repeat(_len){
					if (_list[i].is_server) server_list[j++] = _list[i];
					i++;
				}
				menu_index_x = wrap_value(menu_index_x,0,_len - 1);
				break;
		}
		break;

}