type_event = async_load[? "type"];

switch (type_event){
	case network_type_connect:
		var _socket = async_load[? "socket"];
		ds_list_add(socket_list,_socket);
		ds_list_add(shell.output,"client ID [" + string(_socket) + "] connected.");
		break;
	case network_type_disconnect:
		var _socket = async_load[? "socket"];
		ds_list_delete(socket_list,ds_list_find_index(socket_list,_socket));
		ds_list_add(shell.output,"client ID [" + string(_socket) + "] disconnected.");
		break;
	case network_type_data:
		var _buffer = async_load[? "buffer"];
		var _socket = async_load[? "id"];
		buffer_seek(_buffer,buffer_seek_start,0);
		received_packet(_buffer,_socket);
		break;
}