port = 682;
max_clients = 6;

network_create_server(network_socket_tcp,port,max_clients);

server_buffer = buffer_create(1024,buffer_fixed,1);
socket_list = ds_list_create();

globalvar server, shell; 
shell = instance_create_layer(0,0,layer,obj_shell);
shell.open();
server = id;

function received_packet(buffer,socket){
	//SERVER
	msgid = buffer_read(buffer,buffer_u8);
	switch(msgid){
		case 1: // text
			var _message = string(socket) + ": " + buffer_read(buffer,buffer_string);
			ds_list_add(shell.output,_message);
			send_string(_message);
			break;
	}
}

function send_string(str){
	var i = 0; repeat (ds_list_size(socket_list)){
		var _socket = socket_list[| i];
		buffer_seek(server_buffer,buffer_seek_start,0);
		buffer_write(server_buffer,buffer_u8,1);
		buffer_write(server_buffer,buffer_string,str);
		network_send_packet(_socket,server_buffer,buffer_tell(server_buffer));
		i++;
	}
}