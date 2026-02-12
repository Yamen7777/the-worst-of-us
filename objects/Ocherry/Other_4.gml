/// Ocherry Room Start Event
show_debug_message("=== OCHERRY ROOM START ===");
show_debug_message("Current room: " + string(room));

// Reset death transition flag
death_transition_done = false;

// Load from save file if it exists
if (file_exists(SAVEFILE_MAIN)) {
    show_debug_message("Loading from save file...");
    
    var file = file_text_open_read(SAVEFILE_MAIN);
    
    // Load saved room (should match current room)
    var saved_room = file_text_read_real(file);
    file_text_readln(file);
    
    // Load spawn position
    global.spawn_x = file_text_read_real(file);
    file_text_readln(file);
    global.spawn_y = file_text_read_real(file);
    file_text_readln(file);
    global.has_checkpoint = true;
    
    // Load and apply stats DIRECTLY
    hp = file_text_read_real(file);
    file_text_readln(file);
    
    var loaded_blood = file_text_read_real(file);
    file_text_readln(file);
    
    player_level = file_text_read_real(file);
    file_text_readln(file);
    
    upgrade_attack = file_text_read_real(file);
    file_text_readln(file);
    upgrade_speed = file_text_read_real(file);
    file_text_readln(file);
    upgrade_range = file_text_read_real(file);
    file_text_readln(file);
    upgrade_defence = file_text_read_real(file);
    file_text_readln(file);
    upgrade_spell = file_text_read_real(file);
    file_text_readln(file);
    
    // Load upgrade history
    var history_json = file_text_read_string(file);
    file_text_readln(file);
    if (history_json != "" && history_json != "undefined") {
        global.upgrade_history = json_parse(history_json);
    }
    
    global.kill_counter = file_text_read_real(file);
    file_text_readln(file);
    
    // Load visited rooms
    ds_list_clear(global.visited_rooms);
    var visited_count = file_text_read_real(file);
    file_text_readln(file);
    for (var i = 0; i < visited_count; i++) {
        var room_id = file_text_read_real(file);
        file_text_readln(file);
        ds_list_add(global.visited_rooms, room_id);
    }
    
    file_text_close(file);
    
    // Recalculate all stats based on loaded upgrades
    calculate_stats();
    
    // Store blood for ObloodPar (it gets created later)
    global.loaded_blood = loaded_blood;
    
    // Apply spawn position
    x = global.spawn_x;
    y = global.spawn_y;
    
    show_debug_message("LOADED: HP=" + string(hp) + " Blood=" + string(loaded_blood) + " Level=" + string(player_level));
} else {
    show_debug_message("No save file found - using defaults");
}

// Save kill counter at room start (for death reset)
if (instance_exists(Ogame)) {
    Ogame.room_start_kill_count = global.kill_counter;
}

// Mark room as visited (first time only)
var first_visit = !global.is_room_visited(room);
if (first_visit) {
    global.mark_room_visited(room);
    show_debug_message("First time visiting this room - showing save icon");
    instance_create_layer(0, 0, layer, Osave_icon);
}

// Set room speed
room_speed = 60;

// Set alarm to save progress after everything initializes
alarm[1] = 2;