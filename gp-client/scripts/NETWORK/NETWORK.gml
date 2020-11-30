function send_string(str){
	buffer_seek(client_buffer,buffer_seek_start,0);
	buffer_write(client_buffer,buffer_u8,1);
	buffer_write(client_buffer,buffer_string,str);
	network_send_packet(client,client_buffer,buffer_tell(client_buffer));
}