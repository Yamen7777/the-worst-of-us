if (!is_activated && place_meeting(x, y, Ocherry)) {
    is_activated = true;
    
    // Set checkpoint flag and position
    global.has_checkpoint = true;
    global.spawn_x = x;  // Or your specific offset
    global.spawn_y = y - 32;
    
    // PERMANENTLY save ALL collected flowers
    with (Ogame) {
        // Move temp flowers to permanent collection
        for (var i = 0; i < ds_list_size(global.temp_flowers); i++) {
            var fid = ds_list_find_value(global.temp_flowers, i);
            if (!ds_map_exists(global.collected_flowers, fid)) {
                ds_map_add(global.collected_flowers, fid, true);
            }
        }
        
        // Clear temporary collection
        ds_list_clear(global.temp_flowers);
        global.flowers_collected_this_room = 0;
    }
    
    // Save to the appropriate chapter file
    global.save_chapter_progress();
    
    // Visual feedback
	animation = true; // Switch to activated frame
    audio_sound_pitch(SNcheckpoint,random_range(0.9,1.1));
    audio_play_sound(SNcheckpoint,4,false);
    repeat (15) {
        instance_create_layer(x,y,"powerups",Odust);
    }
}
