// Check if we should show save icon
var show_save_icon = false;
var had_new_flowers = (ds_list_size(global.temp_flowers) > 0);

//killcounter 
// Reset kill counter to what it was at room start (when player dies and restarts)
if (instance_exists(Ogame)) {
    global.kill_counter = Ogame.room_start_kill_count;
}

// First time visiting this room?
if (!global.is_room_visited(room)) {
    show_save_icon = true;
}
// Or collected flowers in previous room?
else if (had_new_flowers) {
    show_save_icon = true;
}
// Or do we have more MAIN flowers than when we last visited this room?
else {
    var room_key = "room_" + string(room) + "_main_flower_count";
    var main_flowers_when_last_here = 0;
    
    // Get main flower count from when we last visited this room
    if (ds_map_exists(global.collected_flowers, room_key)) {
        main_flowers_when_last_here = ds_map_find_value(global.collected_flowers, room_key);
    }
    
    // If our current main flower count is higher, show save icon
    if (global.main_flower_count > main_flowers_when_last_here) {
        show_save_icon = true;
    }
    
    // Update the main flower count for this room visit
    ds_map_set(global.collected_flowers, room_key, global.main_flower_count);
}

// Show save icon if needed
if (show_save_icon) {
    instance_create_layer(0, 0, layer, Osave_icon);
}

// Apply checkpoint position if it exists
if (global.has_checkpoint && global.spawn_x != -1 && global.spawn_y != -1) {
    x = global.spawn_x;
    y = global.spawn_y;
} else {
    x = global.spawn_x;
    y = global.spawn_y;
}

// Reset temporary collection
ds_list_clear(global.temp_flowers);
global.flowers_collected_this_room = 0;

room_speed = 60;