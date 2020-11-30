globalvar port, client, connected, client_buffer, shell;

port = 682;
client = network_create_socket(network_socket_tcp);
connected = network_connect(client,"127.168.1.187",port); //local IPv4: "192.168.187"
client_buffer = buffer_create(1024,buffer_fixed,1);

shell = instance_create_layer(0,0,layer,obj_shell);

function received_packet(buffer){
	//CLIENT
	msgid = buffer_read(buffer,buffer_u8);
	
	switch(msgid){
		case 1: // text
			var _message = buffer_read(buffer,buffer_string);
			ds_list_add(shell.output,_message);
			break;
	}
}