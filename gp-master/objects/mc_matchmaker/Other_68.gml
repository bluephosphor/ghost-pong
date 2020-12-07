type_event = async_load[? "type"];

switch(type_event){
	case network_type_connect:
		//get our client socket number
		var _socket = async_load[? "socket"];
		ds_list_add(socket_data, new client(_socket));
		
		//send packet to client requesting their info
		buffer_seek(server_buffer,buffer_seek_start,0);
		buffer_write(server_buffer,buffer_u8,matchmaking.client_init);
		network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
		
		log("client id:" + string(_socket) + " connected. requesting info...");
		break;
	case network_type_disconnect:
		//remove player info from list and delete struct
		var _client = find_socket_struct(async_load[? "socket"]);
		ds_list_delete(socket_data,ds_list_find_index(socket_data,_client));
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