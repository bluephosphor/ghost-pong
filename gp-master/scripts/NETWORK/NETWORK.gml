function received_packet(buffer,socket){
	//SERVER
	var _header = buffer_read(buffer,buffer_u8);
	switch(_header){
		case matchmaking.client_init:
			var _client = find_socket_struct(socket);
			_client.username	= buffer_read(buffer,buffer_string);
			_client.ip			= buffer_read(buffer,buffer_string);
			log("client info updated: " + json_stringify(_client));
			break;
	}
}

function log(str){
	ds_list_add(shell.output, str);
	show_debug_message(str);
}

function find_socket_struct(socket){
	var i = 0, _struct; repeat(ds_list_size(socket_data)){
		_struct = socket_data[| i];
		if (_struct.id == socket) return _struct;
		i++;
	}
}