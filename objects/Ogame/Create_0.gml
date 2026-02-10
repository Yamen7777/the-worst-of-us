// Replace the single SAVEFILE macro with multiple save files
#macro SAVEFILE_CHAPTER1 "chapter1.sav"
#macro SAVEFILE_CHAPTER2 "chapter2.sav" 
#macro SAVEFILE_MAIN "main.sav"

global.chapter = noone;

// Keep all your existing global variables...
global.flower = 0;
global.collected_flowers = ds_map_create();
global.temp_flowers = ds_list_create();
global.flowers_collected_this_room = 0;

//save icon
// Track visited rooms (this persists until "reset all progress")
global.visited_rooms = ds_list_create();

// Main save flower tracking (persists until "New Save")
global.main_collected_flowers = ds_map_create();
global.main_flower_count = 0;

global.room_flower_counts = ds_map_create(); // Track main flower count per room
global.room_flower_snapshots = ds_map_create(); // Track collected flower snapshot per room

global.spawn_x = 1408;
global.spawn_y = 1248;
global.has_checkpoint = false;

// Add chapter-specific flower counts
global.flower_chapter1 = 0;
global.flower_chapter2 = 0;
global.collected_flowers_chapter1 = ds_map_create();
global.collected_flowers_chapter2 = ds_map_create();

// Chapter unlock progress
open_chapter2 = false;
open_chapter3 = false;


global.get_current_chapter_savefile = function() {
    if (global.chapter1) return SAVEFILE_CHAPTER1;
    if (global.chapter2) return SAVEFILE_CHAPTER2;
    return SAVEFILE_CHAPTER1; // Default fallback
}

global.save_chapter_progress = function() {
    var savefile = global.get_current_chapter_savefile();
    
    if (file_exists(savefile)) file_delete(savefile);
    var file = file_text_open_write(savefile);
    file_text_write_real(file, global.flower);
    file_text_write_real(file, room);
    file_text_write_real(file, global.spawn_x);
    file_text_write_real(file, global.spawn_y);
    file_text_write_string(file, json_encode(global.collected_flowers));
    file_text_close(file);
}

global.load_chapter_progress = function() {
    var savefile = global.get_current_chapter_savefile();
    
    if (!file_exists(savefile)) return false;
    
    var file = file_text_open_read(savefile);
    global.flower = file_text_read_real(file);
    var target_room = file_text_read_real(file);
    global.spawn_x = file_text_read_real(file);
    global.spawn_y = file_text_read_real(file);
    
    var flower_data = file_text_read_string(file);
    if (flower_data != "" && flower_data != "undefined") {
        ds_map_clear(global.collected_flowers);
        var json_map = json_decode(flower_data);
        var keys = ds_map_keys_to_array(json_map);
        for (var i = 0; i < array_length(keys); i++) {
            var key = keys[i];
            ds_map_add(global.collected_flowers, key, true);
        }
        ds_map_destroy(json_map);
    }
    file_text_close(file);
    
    global.has_checkpoint = (global.spawn_x != -1);
    return target_room;
}

global.save_main_progress = function() {
    if (file_exists(SAVEFILE_MAIN)) file_delete(SAVEFILE_MAIN);
    var file = file_text_open_write(SAVEFILE_MAIN);
    file_text_write_real(file, open_chapter2 ? 1 : 0);
    file_text_write_real(file, open_chapter3 ? 1 : 0);
    
    // Save the main flower data
    file_text_write_string(file, json_encode(global.main_collected_flowers));
    file_text_close(file);
}

global.load_main_progress = function() {
    if (!file_exists(SAVEFILE_MAIN)) return false;
    
    var file = file_text_open_read(SAVEFILE_MAIN);
    open_chapter2 = file_text_read_real(file) == 1;
    open_chapter3 = file_text_read_real(file) == 1;
    
    // Load main flower data
    var flower_data = file_text_read_string(file);
    if (flower_data != "" && flower_data != "undefined") {
        ds_map_clear(global.main_collected_flowers);
        var json_map = json_decode(flower_data);
        var keys = ds_map_keys_to_array(json_map);
        for (var i = 0; i < array_length(keys); i++) {
            var key = keys[i];
            ds_map_add(global.main_collected_flowers, key, ds_map_find_value(json_map, key));
        }
        ds_map_destroy(json_map);
    }
    file_text_close(file);
    return true;
}

global.reset_chapter_progress = function() {
    var savefile = global.get_current_chapter_savefile();
    if (file_exists(savefile)) file_delete(savefile);
    
    // Reset current chapter variables
    global.flower = 0;
    ds_map_clear(global.collected_flowers);
    global.spawn_x = -1;
    global.spawn_y = -1;
    global.has_checkpoint = false;
    
    // Update room snapshots to reflect the reset state (empty flowers)
    var key = ds_map_find_first(global.main_collected_flowers);
    while (!is_undefined(key)) {
        // If this is a room snapshot key, update it to empty
        if (string_pos("_flowers_snapshot", key) > 0) {
            ds_map_set(global.main_collected_flowers, key, "");
        }
        key = ds_map_find_next(global.main_collected_flowers, key);
    }
    
    // Save the updated main progress
    global.save_main_progress();
}

global.reset_all_progress = function() {
    // Delete all save files
    if (file_exists(SAVEFILE_CHAPTER1)) file_delete(SAVEFILE_CHAPTER1);
    if (file_exists(SAVEFILE_CHAPTER2)) file_delete(SAVEFILE_CHAPTER2);
    if (file_exists(SAVEFILE_MAIN)) file_delete(SAVEFILE_MAIN);
    if (file_exists("visited_rooms.sav")) file_delete("visited_rooms.sav");
    if (file_exists("main_flowers.sav")) file_delete("main_flowers.sav"); // Add this
    
    // Reset all global variables to starting state
    global.flower = 0;
    ds_map_clear(global.collected_flowers);
    global.spawn_x = -1;
    global.spawn_y = -1;
    global.has_checkpoint = false;
    
    // Reset chapter unlock status
    open_chapter2 = false;
    open_chapter3 = false;
    
    // Clear temporary data
    ds_list_clear(global.temp_flowers);
    global.flowers_collected_this_room = 0;
    
    // Clear visited rooms and main flowers
    ds_list_clear(global.visited_rooms);
    ds_map_clear(global.main_collected_flowers); // Add this
    global.main_flower_count = 0; // Add this
}

global.load_visited_rooms = function() {
    var visited_file = "visited_rooms.sav";
    if (!file_exists(visited_file)) return false;
    
    var file = file_text_open_read(visited_file);
    var count = file_text_read_real(file);
    ds_list_clear(global.visited_rooms);
    
    for (var i = 0; i < count; i++) {
        var room_id = file_text_read_real(file);
        ds_list_add(global.visited_rooms, room_id);
    }
    file_text_close(file);
    return true;
}

global.save_visited_rooms = function() {
    var visited_file = "visited_rooms.sav";
    if (file_exists(visited_file)) file_delete(visited_file);
    
    var file = file_text_open_write(visited_file);
    // Write the count first
    file_text_write_real(file, ds_list_size(global.visited_rooms));
    // Write each room ID
    for (var i = 0; i < ds_list_size(global.visited_rooms); i++) {
        file_text_write_real(file, ds_list_find_value(global.visited_rooms, i));
    }
    file_text_close(file);
}

global.is_room_visited = function(room_id) {
    return ds_list_find_index(global.visited_rooms, room_id) >= 0;
}

global.add_room_to_visited = function(room_id) {
    if (!global.is_room_visited(room_id)) {
        ds_list_add(global.visited_rooms, room_id);
        global.save_visited_rooms();
    }
}

global.mark_room_visited = function(room_id) {
    if (!global.is_room_visited(room_id)) {
        ds_list_add(global.visited_rooms, room_id);
        global.save_visited_rooms();
        return true; // First time visiting
    }
    return false; // Already visited
}

global.save_main_flowers = function() {
    var main_flower_file = "main_flowers.sav";
    if (file_exists(main_flower_file)) file_delete(main_flower_file);
    
    var file = file_text_open_write(main_flower_file);
    file_text_write_real(file, global.main_flower_count);
    
    // Save collected flower IDs
    var flower_keys = ds_map_keys_to_array(global.main_collected_flowers);
    file_text_write_real(file, array_length(flower_keys));
    for (var i = 0; i < array_length(flower_keys); i++) {
        file_text_write_string(file, flower_keys[i]);
    }
    file_text_close(file);
}

global.load_main_flowers = function() {
    var main_flower_file = "main_flowers.sav";
    if (!file_exists(main_flower_file)) return false;
    
    var file = file_text_open_read(main_flower_file);
    global.main_flower_count = file_text_read_real(file);
    
    var flower_count = file_text_read_real(file);
    ds_map_clear(global.main_collected_flowers);
    for (var i = 0; i < flower_count; i++) {
        var flower_id = file_text_read_string(file);
        ds_map_add(global.main_collected_flowers, flower_id, true);
    }
    file_text_close(file);
    return true;
}

// Load main flowers on game start
global.load_main_flowers();

// Load visited rooms on game start
global.load_visited_rooms();

// Load main progress on game start
global.load_main_progress();

//destroy wanted objects
to_destroy = noone;

//intro
intro = false;

start_running = false;

//kill counter
global.kill_counter = 0;

hitstop_timer = 0;           // Countdown timer for freeze
normal_room_speed = 60;      // Store normal room speed
hitstop_kill_pitch = 1.0;    // Pitch for SNkill sound
hitstop_score_pitch = 1.0;   // Pitch for SNscore sound

// (Keep your existing variables too)
kill_counter_scale = 1;
kill_counter_target_scale = 1;
kill_counter_rotation = 0;
kill_counter_target_rotation = 0;
kill_counter_jump_power = 0;
room_start_kill_count = 0;

//key
global.key = false;

// Initialize blade spot tracking ONCE at game start
global.blade_spots = ds_list_create();
show_debug_message("=== BLADE SPOT SYSTEM INITIALIZED ===");

//essance room
essance_room = false;
essance_objects_created = false;
fragment1 = false;
fragment2 = false;
slot1 = 0;
slot2 = 0;
fuse_option = false;
fuse = false;
global.fling = false;
global.burst = false;
global.grasp = false;
global.slot1 = 0;
global.slot2 = 0;
global.fuse = false;
global.fusing = false;

//fusing scene
fusing_step = 0;
fusing_timer = 0;
fusion_center_x = 0;
fusion_center_y = 0;
essance_moving = false;
fragments_moving = ds_list_create();
fusion_fragment = noone;

//tutorial room
tutorial = false;
fragment_explain = true;

// Tutorial action latch flags
tutorial_action_detected = false;

// tutorial globals
global.dummy_dialogue_finished = false;
global.extra_dummies = false;
create_dummies = false;


tutorial = false;
tutorial_step = 0;
tutorial_done = false;

tutorial_step_complete = false;
tutorial_hold_timer = 0;

tutorial_dj_complete = false;
tutorial_air_complete = false;
tutorial_finish_timer = 0;

current_character = "";


// Upgrade card system
showing_upgrade_cards = false;
upgrade_cards_created = false;
upgrade_cards_animating = false;

show_upgrade_cards = function() {
    if (!instance_exists(Ocherry)) return;
    
    // FREEZE PLAYER FIRST - BEFORE ANYTHING ELSE
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
    
    // Determine how many cards to show (max 3, but only show what's available)
    var num_cards = min(3, array_length(available_upgrades));
    
    if (num_cards == 0) return; // No upgrades available
    
    // Shuffle available upgrades
    var shuffled = available_upgrades;
    for (var i = array_length(shuffled) - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = temp;
    }
    
    // Create the upgrade cards in GUI space
    var gui_width = 3733;
    var gui_height = 2240;
    
    var screen_center_x = gui_width / 2;
    var screen_center_y = gui_height / 2;
    
    // Spacing between cards
    var card_spacing = 750;
    var total_width = (num_cards - 1) * card_spacing;
    var start_x = screen_center_x - (total_width / 2);
    
    // Create cards
    for (var i = 0; i < num_cards; i++) {
        var card = instance_create_layer(start_x + (i * card_spacing), screen_center_y, "Instances", Oupgrade_cards);
        card.upgrade_type = shuffled[i];
        card.depth = -9999;
        
        // Set sprite based on upgrade type
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

// Function to hide all upgrade cards (only used for cleanup, not during animation)
hide_upgrade_cards = function() {
    with (Oupgrade_cards) {
        instance_destroy();
    }
    
    showing_upgrade_cards = false;
    upgrade_cards_created = false;
    upgrade_cards_animating = false;
    
    // RE-ENABLE CONTROLS AND MOVEMENT
    if (instance_exists(Ocherry)) {
        Ocherry.STATE = Ocherry.STATE_FREE;
    }
}

