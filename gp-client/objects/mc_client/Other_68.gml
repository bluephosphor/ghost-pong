type_event = async_load[? "type"];

switch(type_event){
	case network_type_data:
		var _buffer = async_load[? "buffer"];
		buffer_seek(_buffer,buffer_seek_start,0);
		received_packet(_buffer);
		break;
}