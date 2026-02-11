//Ogame create

//SAVEFILE
#macro SAVEFILE_MAIN "player_progress.sav"

// Spawn position
global.spawn_x = 832;
global.spawn_y = 3008;
global.has_checkpoint = false;

// Upgrade history - tracks the order of upgrades chosen
global.upgrade_history = []; // Array of upgrade types in order chosen

// Visited rooms tracking
global.visited_rooms = ds_list_create();

// Save player progress (called at the START of each room)
global.save_progress = function() {
    if (!instance_exists(Ocherry)) {
        show_debug_message("ERROR: Cannot save - Ocherry doesn't exist");
        return false;
    }
    
    // Find the blood bar instance (sprite_index == SbloodPar2)
    var blood_par = noone;
    with (ObloodPar) {
        if (sprite_index == SbloodPar2) {
            blood_par = id;
            break;
        }
    }
    
    if (!instance_exists(blood_par)) {
        show_debug_message("WARNING: Trying to save but blood bar doesn't exist yet");
        return false;
    }
    
    // Extra safety check - make sure blood is a valid number
    if (is_undefined(blood_par.blood)) {
        show_debug_message("ERROR: Blood bar exists but blood value is undefined!");
        blood_par.blood = 0; // Set to 0 as fallback
    }
    
    if (file_exists(SAVEFILE_MAIN)) file_delete(SAVEFILE_MAIN);
    var file = file_text_open_write(SAVEFILE_MAIN);
    
    // Save current room
    file_text_write_real(file, room);
    file_text_writeln(file);
    
    // Save spawn position
    file_text_write_real(file, global.spawn_x);
    file_text_writeln(file);
    file_text_write_real(file, global.spawn_y);
    file_text_writeln(file);
    
    // Save player stats
    file_text_write_real(file, Ocherry.hp);
    file_text_writeln(file);
    
    // Save blood (with extra safety)
    var blood_value = is_undefined(blood_par.blood) ? 0 : blood_par.blood;
    file_text_write_real(file, blood_value);
    file_text_writeln(file);
    
    // Save level
    file_text_write_real(file, Ocherry.player_level);
    file_text_writeln(file);
    
    // Save individual upgrade levels
    file_text_write_real(file, Ocherry.upgrade_attack);
    file_text_writeln(file);
    file_text_write_real(file, Ocherry.upgrade_speed);
    file_text_writeln(file);
    file_text_write_real(file, Ocherry.upgrade_range);
    file_text_writeln(file);
    file_text_write_real(file, Ocherry.upgrade_defence);
    file_text_writeln(file);
    file_text_write_real(file, Ocherry.upgrade_spell);
    file_text_writeln(file);
    
    // Save upgrade history
    file_text_write_string(file, json_stringify(global.upgrade_history));
    file_text_writeln(file);
    
    // Save kill counter
    file_text_write_real(file, global.kill_counter);
    file_text_writeln(file);
    
    // Save visited rooms list
    var visited_count = ds_list_size(global.visited_rooms);
    file_text_write_real(file, visited_count);
    file_text_writeln(file);
    for (var i = 0; i < visited_count; i++) {
        file_text_write_real(file, ds_list_find_value(global.visited_rooms, i));
        file_text_writeln(file);
    }
    
    file_text_close(file);
    
    show_debug_message("SAVED: Room=" + string(room) + " HP=" + string(Ocherry.hp) + " Blood=" + string(blood_value) + " Level=" + string(Ocherry.player_level));
    
    return true;
}

// Add room to visited list (used by save icon)
global.add_room_to_visited = function(room_id) {
    if (!global.is_room_visited(room_id)) {
        ds_list_add(global.visited_rooms, room_id);
        // Save progress when adding a new room
        global.save_progress();
    }
}

// Load player progress
global.load_progress = function() {
    if (!file_exists(SAVEFILE_MAIN)) {
        show_debug_message("No save file found");
        return false;
    }
    
    show_debug_message("Loading save file...");
    
    var file = file_text_open_read(SAVEFILE_MAIN);
    
    // Load target room
    var target_room = file_text_read_real(file);
    file_text_readln(file);
    show_debug_message("Loading room: " + string(target_room));
    
    // Load spawn position
    global.spawn_x = file_text_read_real(file);
    file_text_readln(file);
    global.spawn_y = file_text_read_real(file);
    file_text_readln(file);
    global.has_checkpoint = true;
    
    // Store stats to apply after player is created
    global.loaded_hp = file_text_read_real(file);
    file_text_readln(file);
    global.loaded_blood = file_text_read_real(file);
    file_text_readln(file);
    
    show_debug_message("Loaded HP: " + string(global.loaded_hp) + " Blood: " + string(global.loaded_blood));
    
    global.loaded_level = file_text_read_real(file);
    file_text_readln(file);
    
    global.loaded_upgrade_attack = file_text_read_real(file);
    file_text_readln(file);
    global.loaded_upgrade_speed = file_text_read_real(file);
    file_text_readln(file);
    global.loaded_upgrade_range = file_text_read_real(file);
    file_text_readln(file);
    global.loaded_upgrade_defence = file_text_read_real(file);
    file_text_readln(file);
    global.loaded_upgrade_spell = file_text_read_real(file);
    file_text_readln(file);
    
    // Load upgrade history
    var history_json = file_text_read_string(file);
    file_text_readln(file);
    if (history_json != "" && history_json != "undefined") {
        global.upgrade_history = json_parse(history_json);
    } else {
        global.upgrade_history = [];
    }
    
    global.loaded_kill_counter = file_text_read_real(file);
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
    
    show_debug_message("Load complete! Target room: " + string(target_room));
    
    return target_room;
}

// Apply loaded stats to player (call this in player's Room Start)
global.apply_loaded_stats = function() {
    if (!instance_exists(Ocherry)) return;
    
    if (variable_global_exists("loaded_hp")) {
        Ocherry.hp = global.loaded_hp;
        Ocherry.player_level = global.loaded_level;
        Ocherry.upgrade_attack = global.loaded_upgrade_attack;
        Ocherry.upgrade_speed = global.loaded_upgrade_speed;
        Ocherry.upgrade_range = global.loaded_upgrade_range;
        Ocherry.upgrade_defence = global.loaded_upgrade_defence;
        Ocherry.upgrade_spell = global.loaded_upgrade_spell;
        
        // Recalculate stats based on loaded upgrades
        Ocherry.calculate_stats();
        
        if (instance_exists(ObloodPar)) {
            ObloodPar.blood = global.loaded_blood;
        }
        
        global.kill_counter = global.loaded_kill_counter;
        
        // Clear loaded variables
        variable_global_set("loaded_hp", undefined);
    }
}

// Reset all progress (for new game)
global.reset_all_progress = function() {
    // Delete save file
    if (file_exists(SAVEFILE_MAIN)) file_delete(SAVEFILE_MAIN);
    
    // Reset spawn to default starting position
    global.spawn_x = 832;  // Your tutorial room spawn X
    global.spawn_y = 3008; // Your tutorial room spawn Y
    global.has_checkpoint = false;
    
    // Reset upgrade history
    global.upgrade_history = [];
    
    // Reset kill counter
    global.kill_counter = 0;
    
    // Clear visited rooms
    ds_list_clear(global.visited_rooms);
    
    show_debug_message("RESET PROGRESS: Spawn set to " + string(global.spawn_x) + ", " + string(global.spawn_y));
}

// Function to undo last upgrade (called on death)
global.undo_last_upgrade = function() {
    if (!instance_exists(Ocherry)) return;
    if (array_length(global.upgrade_history) == 0) return;
    
    // Get the last upgrade type
    var last_upgrade = global.upgrade_history[array_length(global.upgrade_history) - 1];
    
    // Remove it from history
    array_pop(global.upgrade_history);
    
    // Decrease the corresponding upgrade level
    switch(last_upgrade) {
        case "attack":
            Ocherry.upgrade_attack = max(0, Ocherry.upgrade_attack - 1);
            break;
        case "speed":
            Ocherry.upgrade_speed = max(0, Ocherry.upgrade_speed - 1);
            break;
        case "range":
            Ocherry.upgrade_range = max(0, Ocherry.upgrade_range - 1);
            break;
        case "defence":
            Ocherry.upgrade_defence = max(0, Ocherry.upgrade_defence - 1);
            break;
        case "spell":
            Ocherry.upgrade_spell = max(0, Ocherry.upgrade_spell - 1);
            break;
    }
    
    // Decrease level
    Ocherry.player_level = max(0, Ocherry.player_level - 1);
    
    // Recalculate stats
    Ocherry.calculate_stats();
    
    // Save the updated progress
    global.save_progress();
}

// Check if room was visited
global.is_room_visited = function(room_id) {
    return ds_list_find_index(global.visited_rooms, room_id) >= 0;
}

// Mark room as visited
global.mark_room_visited = function(room_id) {
    if (!global.is_room_visited(room_id)) {
        ds_list_add(global.visited_rooms, room_id);
        return true; // First time visiting
    }
    return false; // Already visited
}

// Add room to visited list (used by save icon)
global.add_room_to_visited = function(room_id) {
    if (!global.is_room_visited(room_id)) {
        ds_list_add(global.visited_rooms, room_id);
        // Save progress when adding a new room
        global.save_progress();
    }
}

//destroy wanted objects
to_destroy = noone;

//kill counter
global.kill_counter = 0;

hitstop_timer = 0;
normal_room_speed = 60;
hitstop_kill_pitch = 1.0;
hitstop_score_pitch = 1.0;

kill_counter_scale = 1;
kill_counter_target_scale = 1;
kill_counter_rotation = 0;
kill_counter_target_rotation = 0;
kill_counter_jump_power = 0;
room_start_kill_count = 0;

// Upgrade card system
showing_upgrade_cards = false;
upgrade_cards_created = false;
upgrade_cards_animating = false;

show_upgrade_cards = function() {
    if (!instance_exists(Ocherry)) return;
    
    // FREEZE PLAYER FIRST
    Ocherry.hsp = 0;
    Ocherry.vsp = 0;
    Ocherry.hasControl = false;
    Ocherry.Cpause = true;
    Ocherry.STATE = Ocherry.STATE_PAUSE;
    
    // Get list of available upgrades (not maxed)
    var available_upgrades = [];
    
    if (Ocherry.upgrade_attack < Ocherry.max_upgrade_level) {
        array_push(available_upgrades, "attack");
    }
    if (Ocherry.upgrade_defence < Ocherry.max_upgrade_level) {
        array_push(available_upgrades, "defence");
    }
    if (Ocherry.upgrade_range < Ocherry.max_upgrade_level) {
        array_push(available_upgrades, "range");
    }
    if (Ocherry.upgrade_speed < Ocherry.max_upgrade_level) {
        array_push(available_upgrades, "speed");
    }
    if (Ocherry.upgrade_spell < Ocherry.max_upgrade_level) {
        array_push(available_upgrades, "spell");
    }
    
    var num_cards = min(3, array_length(available_upgrades));
    if (num_cards == 0) return;
    
    // Shuffle
    var shuffled = available_upgrades;
    for (var i = array_length(shuffled) - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = temp;
    }
    
    // Create cards
    var gui_width = 3733;
    var gui_height = 2240;
    var screen_center_x = gui_width / 2;
    var screen_center_y = gui_height / 2;
    var card_spacing = 750;
    var total_width = (num_cards - 1) * card_spacing;
    var start_x = screen_center_x - (total_width / 2);
    
    for (var i = 0; i < num_cards; i++) {
        var card = instance_create_layer(start_x + (i * card_spacing), screen_center_y, "Instances", Oupgrade_cards);
        card.upgrade_type = shuffled[i];
        card.depth = -9999;
        
        switch(shuffled[i]) {
            case "attack":
                card.sprite_index = Supgrade_damage;
                break;
            case "defence":
                card.sprite_index = Supgrade_defence;
                break;
            case "range":
                card.sprite_index = Supgrade_range;
                break;
            case "speed":
                card.sprite_index = Supgrade_swiftness;
                break;
            case "spell":
                card.sprite_index = Supgrade_energy;
                break;
        }
    }
    
    showing_upgrade_cards = true;
    upgrade_cards_created = true;
}

hide_upgrade_cards = function() {
    with (Oupgrade_cards) {
        instance_destroy();
    }
    
    showing_upgrade_cards = false;
    upgrade_cards_created = false;
    upgrade_cards_animating = false;
    
    if (instance_exists(Ocherry)) {
        Ocherry.STATE = Ocherry.STATE_FREE;
    }
}