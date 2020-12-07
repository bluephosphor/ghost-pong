function array_shrink(arr,remove_cells_with_value){
	var _len = array_length(arr);
	var _new_array = [];
	var i = 0, j = 0; repeat(_len){
		if (arr[i] != remove_cells_with_value) _new_array[j++] = arr[i];
		i++;
	}
	
	return _new_array;
}

function log(str){
	ds_list_add(shell.output, str);
	show_debug_message(str);
}

function find_socket_struct(socket){
	var i = 0, _struct; repeat(array_length(socket_data)){
		_struct = socket_data[i];
		if (_struct.id == socket) return {struct: _struct, index: i};
		i++;
	}
}