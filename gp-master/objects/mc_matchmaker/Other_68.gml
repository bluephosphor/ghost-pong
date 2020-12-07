type_event = async_load[? "type"];

switch(type_event){
	case network_type_connect:
		//get our client socket number
		var _socket = async_load[? "socket"];
		array_push(socket_data, new client(_socket));
		
		//send packet to client requesting their info
		buffer_seek(server_buffer,buffer_seek_start,0);
		buffer_write(server_buffer,buffer_u8,matchmaking.client_init);
		network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
		
		log("client id:" + string(_socket) + " connected. requesting info...");
		break;
	case network_type_disconnect:
		//remove player info from list and delete struct
		var _result = find_socket_struct(async_load[? "socket"]);
		var _client = _result.struct;
		var _index  = _result.index;
		socket_data[_index] = -1;
		socket_data = array_shrink(socket_data,-1);
		log("client id:" + string(_client.id) + " disconnected.");
		delete _client;
		break;
	case network_type_data:
		var _buffer = async_load[? "buffer"];
		var _socket	= async_load[? "id"];
		buffer_seek(_buffer,buffer_seek_start,0);
		received_packet(_buffer,_socket);
		break;
}