function received_packet(buffer,socket){
	//SERVER
	var _header = buffer_read(buffer,buffer_u8);
	switch(_header){
		case matchmaking.client_init:
			var _client = find_socket_struct(socket).struct;
			_client.username	= buffer_read(buffer,buffer_string);
			_client.ip			= buffer_read(buffer,buffer_string);
			_client.is_server	= buffer_read(buffer,buffer_bool);
			if (_client.is_server) _client.players_online = 0;
			log("client info updated: " + json_stringify(_client));
			break;
		case matchmaking.update:
			var _client = find_socket_struct(socket).struct;
			var _oldnum = _client.players_online;
			_client.players_online = buffer_read(buffer,buffer_string);
			if (_client.players_online != _oldnum){
				log(_client.username + "ID : " + string(_client.id) + " now has " + string(_client.players_online) + " players.");
			}
			break;
	}
}