with (Ocherry) {
    if (hasControl) {
        hasControl = false;
        // Deduct flowers from current attempt
        global.flower -= global.flowers_collected_this_room;
    
        // Clear temporary collection (makes flowers collectible again)
        ds_list_clear(global.temp_flowers);
        global.flowers_collected_this_room = 0;
        // Pass next room's spawn position
        global.spawn_x = other.spawn_x;
        global.spawn_y = other.spawn_y;
        // Just transition - no saving (this is intentional)
        TRANS(TRANS_MODE.GOTO,"strawberry",other.target);
    }
}