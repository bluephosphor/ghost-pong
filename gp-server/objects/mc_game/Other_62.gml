if ( ds_map_find_value(async_load, "id") == ip_request ) {
    if ( ds_map_find_value(async_load, "status") == 0 ) {
		server_ip = ds_map_find_value(async_load, "result");
		log("success. server ip address: " + server_ip);
		log("attempting to connect to matchmaking server...");
		net_connect(matchmaking_server_address,matchmaking_port);
		//matchmaking_request = network_connect_async(matchmaking_socket,matchmaking_server_address,matchmaking_port);
		alarm[1] = 60; //timeout alarm
    }
}