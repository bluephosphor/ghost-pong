function save_string_to_file(_filename, _string) {

	var _buffer = buffer_create(string_byte_length(_string) + 1, buffer_fixed, 1);
	buffer_write(_buffer, buffer_string, _string);
	buffer_save(_buffer, _filename);
	buffer_delete(_buffer);
}


function load_string_from_file(_filename) {

	var _buffer = buffer_load(_filename);
	var _string = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);

	return _string;
}

function vec2(x,y) constructor{
	self.x = x;
	self.y = y;
}

function move_and_collide(){
	var sx = self.spd.x;
	var sy = self.spd.y;
	var _moving = (sx != 0 or sy != 0);
	
	if (place_meeting(self.x + sx,self.y,obj_boundary)){
		while (!place_meeting(self.x + sign(sx),self.y,obj_boundary)){
			self.x += sign(sx);
		}
		_moving = false;
		sx = 0;
	}
	self.x += sx;
	
	if (place_meeting(self.x,self.y + sy,obj_boundary)){
		while (!place_meeting(self.x,self.y + sign(sy),obj_boundary)){
			self.y += sign(sy);
		}
		_moving = false;
		sy = 0;
	}
	self.y += sy;
	
}

function approach(a, b, amount){
	// Moves "a" towards "b" by "amount" and returns the result
	// Nice bcause it will not overshoot "b", and works in both directions
	// Examples:
	//      speed = Approach(speed, max_speed, acceleration);
	//      hp = Approach(hp, 0, damage_amount);
	//      hp = Approach(hp, max_hp, heal_amount);
	//      x = Approach(x, target_x, move_speed);
	//      y = Approach(y, target_y, move_speed);
	if (a < b) {
	    a += amount;
		if (a > b) return b;
	} else {
	    a -= amount;
	    if (a < b) return b;
	}
	return a;
}

function trail_sprite(parent_id, decrement) constructor{
	self.x				= parent_id.x;
	self.y				= parent_id.y;
	self.sprite_index	= parent_id.sprite_index;
	self.image_index	= parent_id.image_index;
	self.image_xscale	= parent_id.image_xscale;
	self.image_yscale	= parent_id.image_yscale
	self.image_angle	= parent_id.image_angle;
	self.image_blend	= parent_id.image_blend;
	self.image_alpha	= 0.4;
	self.decrement		= decrement;
	self.update			= function(){image_alpha -= self.decrement;}
}

function trail_sprite_draw(){
	var _len = array_length(trail);
	if (_len > 0){
		var i = 0, _sprite, _c; repeat(_len){
			_sprite = trail[i];
			
			if (argument_count > 0) _c = argument[0];
			else					_c = _sprite.image_blend;
			
			draw_sprite_ext(
				_sprite.sprite_index,
				_sprite.image_index,
				_sprite.x,
				_sprite.y,
				_sprite.image_xscale,
				_sprite.image_yscale,
				_sprite.image_angle,
				_c,
				_sprite.image_alpha
			);
			i++;
		}
	}
}

function trail_sprite_update(){
	var _len = array_length(trail);
	if (_len > 0){
		var i = 0; repeat(_len){
			trail[i].update();
			if (trail[i].image_alpha <= 0){
				delete trail[i];
				trail[i] = -1;
			}
			i++;
		}
		trail = array_shrink(trail,-1);
	}
}

function array_shrink(arr,remove_cells_with_value){
	var _len = array_length(arr);
	var _new_array = [];
	var i = 0, j = 0; repeat(_len){
		if (arr[i] != remove_cells_with_value) _new_array[j++] = arr[i];
		i++;
	}
	
	return _new_array;
}

function foreach()
/// @return N/A (0)
/// 
/// Executes a method call for each element of the given struct/array/data structure.
/// This iterator is shallow and will not also iterate over nested structs/arrays (though
/// you can of course call foreach() inside the specified method)
/// 
/// This function can also iterate over all members of a ds_map, ds_list, or ds_grid.
/// You will need to specify a value for [dsType] to iterate over a data structure
///
/// The specified method is passed the following parameters:
/// 
/// arg0  -  Value found in the given struct/array
/// arg1  -  0-indexed index of the value e.g. =0 for the first element, =1 for the second element etc.
/// arg2  -  When iterating over structs, the name of the variable that contains the given value; otherwise <undefined>
/// 
/// The order that values are sent into <method> is guaranteed for arrays (starting at
/// index 0 and ascending), but is not guaranteed for structs due to the behaviour of
/// GameMaker's internal hashmap
/// 
/// @param struct/array/ds   Struct/array/data structure to be iterated over
/// @param method            Method to call for each element of this given struct/array/ds
/// @param [dsType]          Data structure type if iterating over a data structure
/// 
/// @jujuadams 2020-06-16
{
    var _ds       = argument[0];
    var _function = argument[1];
    var _ds_type  = (argument_count > 2)? argument[2] : undefined;
    
    if (is_struct(_ds))
    {
        var _names = variable_struct_get_names(_ds);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            _function(variable_struct_get(_ds, _name), _i, _name);
            ++_i;
        }
    }
    else if (is_array(_ds))
    {
        var _i = 0;
        repeat(array_length(_ds))
        {
            _function(_ds[_i], _i, undefined);
            ++_i;
        }
    }
    else switch(_ds_type)
    {
        case ds_type_list:
            var _i = 0;
            repeat(ds_list_size(_ds))
            {
                _function(_ds[| _i], _i, undefined);
                ++_i;
            }
        break;
        
        case ds_type_map:
            var _i = 0;
            var _key = ds_map_find_first(_ds);
            repeat(ds_map_size(_ds))
            {
                _function(_ds[? _key], _i, _key, undefined);
                _key = ds_map_find_next(_ds, _key);
                ++_i;
            }
        break;
        
        case ds_type_grid:
            var _w = ds_grid_width( _ds);
            var _h = ds_grid_height(_ds);
            
            var _y = 0;
            repeat(_h)
            {
                var _x = 0;
                repeat(_w)
                {
                    _function(_ds[# _x, _y], _x, _y);
                    ++_x;
                }
                
                ++_y;
            }
        break;
        
        default:
            show_error("Cannot iterate over datatype \"" + string(typeof(_ds)) + "\"\n ", false);
        break;
    }
}