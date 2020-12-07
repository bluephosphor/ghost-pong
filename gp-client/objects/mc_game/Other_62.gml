if ( ds_map_find_value(async_load, "id") == ip_request ) {
    if ( ds_map_find_value(async_load, "status") == 0 ) {
        client_ip = ds_map_find_value(async_load, "result");
    }
}