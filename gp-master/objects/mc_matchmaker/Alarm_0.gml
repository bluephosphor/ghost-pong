///@description ping event
alarm[0] = 60;

var _clients_online = array_length(socket_data);
var _client_list_str = json_stringify(socket_data);

buffer_seek(server_buffer,buffer_seek_start,0);
buffer_write(server_buffer,buffer_u8,matchmaking.update);
buffer_write(server_buffer,buffer_string,_client_list_str);

var i = 0; repeat (_clients_online){
	var _socket = socket_data[i].id;
	network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
	i++;
}