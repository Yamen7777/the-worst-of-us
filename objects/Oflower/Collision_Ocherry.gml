if (!collected) {
    collected = true;
    
    audio_play_sound(SNcollictable,5,false);

    // Update both counters
    global.flower++;
    global.flowers_collected_this_room++;
    
    // Add to temporary collection
    ds_list_add(global.temp_flowers, my_id);
    
    // Add to main save (persistent across "New Game")
    var flower_key = string(room) + "_" + string(my_id);
    if (!ds_map_exists(global.main_collected_flowers, flower_key)) {
        ds_map_add(global.main_collected_flowers, flower_key, true);
        global.main_flower_count++;
        global.save_main_flowers();
        global.just_collected_flower = true; // Set flag for next room
    }
	with(OcheckPoint) is_activated = false;
}