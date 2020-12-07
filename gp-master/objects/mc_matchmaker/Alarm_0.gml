alarm[0] = 60;

var _clients_online = ds_list_size(socket_data);
var _client_list_str = "";

if (_clients_online > 0){
	var i = 0; repeat(_clients_online){
		var _client = socket_data[| i];
		_client_list_str += _client.username + "\n";
		i++;
	}
}

buffer_seek(server_buffer,buffer_seek_start,0);
buffer_write(server_buffer,buffer_u8,matchmaking.update);
buffer_write(server_buffer,buffer_string,_client_list_str);

var i = 0; repeat (_clients_online){
	var _socket = socket_data[| i].id;
	network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
	i++;
}