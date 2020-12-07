function received_packet(buffer,socket){
	//SERVER
	var _header = buffer_read(buffer,buffer_u8);
	switch(_header){
		case matchmaking.client_init:
			var _client = find_socket_struct(socket).struct;
			_client.username	= buffer_read(buffer,buffer_string);
			_client.ip			= buffer_read(buffer,buffer_string);
			_client.is_server	= buffer_read(buffer,buffer_bool);
			log("client info updated: " + json_stringify(_client));
			break;
	}
}