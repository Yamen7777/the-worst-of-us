//Ogame create

// Initialize random seed for different results each game
randomize();

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
    if (!instance_exists(Ocherry)) return false;
    
    // Find the first ObloodPar instance
    var blood_par = instance_find(ObloodPar, 0);
    if (!instance_exists(blood_par)) {
        show_debug_message("WARNING: Trying to save but ObloodPar doesn't exist yet");
        return false;
    }
    
    // CRITICAL: Safety check for blood value
    if (is_undefined(blood_par.blood) || !is_real(blood_par.blood)) {
        show_debug_message("ERROR: Blood is undefined! Resetting to 0");
        blood_par.blood = 0;
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
    file_text_write_real(file, blood_par.blood); // Now guaranteed to be a valid number
    file_text_writeln(file);
    
    // CONDITIONAL: Only save level/upgrades if they've been confirmed
    var save_level = Ocherry.player_level;
    var save_attack = Ocherry.upgrade_attack;
    var save_speed = Ocherry.upgrade_speed;
    var save_range = Ocherry.upgrade_range;
    var save_defence = Ocherry.upgrade_defence;
    var save_spell = Ocherry.upgrade_spell;
    var save_history = global.upgrade_history;
    
    // If upgrades haven't been confirmed yet, use the loaded values (or 0 if new game)
    if (instance_exists(Ogame) && !Ogame.upgrades_confirmed) {
        if (variable_global_exists("confirmed_level")) {
            save_level = global.confirmed_level;
            save_attack = global.confirmed_upgrade_attack;
            save_speed = global.confirmed_upgrade_speed;
            save_range = global.confirmed_upgrade_range;
            save_defence = global.confirmed_upgrade_defence;
            save_spell = global.confirmed_upgrade_spell;
            save_history = global.confirmed_upgrade_history;
        } else {
            // First room, no confirmed upgrades yet
            save_level = 0;
            save_attack = 0;
            save_speed = 0;
            save_range = 0;
            save_defence = 0;
            save_spell = 0;
            save_history = [];
        }
        show_debug_message("SAVING UNCONFIRMED - Using previous confirmed upgrades");
    } else {
        show_debug_message("SAVING CONFIRMED UPGRADES");
    }
    
    // Save level
    file_text_write_real(file, save_level);
    file_text_writeln(file);
    
    // Save individual upgrade levels
    file_text_write_real(file, save_attack);
    file_text_writeln(file);
    file_text_write_real(file, save_speed);
    file_text_writeln(file);
    file_text_write_real(file, save_range);
    file_text_writeln(file);
    file_text_write_real(file, save_defence);
    file_text_writeln(file);
    file_text_write_real(file, save_spell);
    file_text_writeln(file);
    
    // Save upgrade history
    file_text_write_string(file, json_stringify(save_history));
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
    
    show_debug_message("SAVED: Room=" + string(room) + " HP=" + string(Ocherry.hp) + " Blood=" + string(blood_par.blood) + " Level=" + string(save_level));
    
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
    
    // STORE CONFIRMED UPGRADES (these were confirmed in previous save)
    global.confirmed_level = global.loaded_level;
    global.confirmed_upgrade_attack = global.loaded_upgrade_attack;
    global.confirmed_upgrade_speed = global.loaded_upgrade_speed;
    global.confirmed_upgrade_range = global.loaded_upgrade_range;
    global.confirmed_upgrade_defence = global.loaded_upgrade_defence;
    global.confirmed_upgrade_spell = global.loaded_upgrade_spell;
    global.confirmed_upgrade_history = global.upgrade_history;
    
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

// Death counter per room (resets when entering new room)
deaths_this_room = 0;
max_deaths_before_stop = 5;  // Stop losing levels after 5 deaths in same room

// Upgrade card system
showing_upgrade_cards = false;
upgrade_cards_created = false;
upgrade_cards_animating = false;
upgrades_confirmed = false;
upgraded = false;
all_cards_popped = false; //Track when all cards are ready
extra_levels = 0;

// Queue system for multiple level-ups
pending_upgrade_points = 0; // Number of upgrade choices waiting to be shown

// Track bonus levels from enemies killed in the room
room_bonus_levels = 0; // Bonus levels to give when room is cleared

// Make persistent so it doesn't get deactivated
persistent = true;
object_set_persistent(object_index, true);

show_upgrade_cards = function() {
    if (!instance_exists(Ocherry)) return;
    
    // Don't show cards in error room or main menu
    if (room == Rerror || room == Rmain_menu) return;
    
    // If already showing cards, just increment pending counter and return
    if (showing_upgrade_cards || upgrade_cards_created) {
        pending_upgrade_points++;
        show_debug_message("Upgrade cards already showing. Added to queue. Pending: " + string(pending_upgrade_points));
        return;
    }
    
    // Reset the flag
    all_cards_popped = false;
    
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
    
    // Pop delay between cards (frames)
    var pop_delay_increment = 20; // 20 frames between each card popping
    
    for (var i = 0; i < num_cards; i++) {
        var card = instance_create_layer(start_x + (i * card_spacing), screen_center_y, "Instances", Oupgrade_cards);
        card.upgrade_type = shuffled[i];
        card.depth = -9999;
        
        // Set pop delay - first card has 0 delay, second has 20, third has 40
        card.pop_delay = i * pop_delay_increment;
        
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
    
    // Check if there are pending upgrades to show
    if (pending_upgrade_points > 0) {
        pending_upgrade_points--;
        show_debug_message("Processing queued upgrade. Remaining: " + string(pending_upgrade_points));
        // Small delay before showing next cards
        alarm[1] = 10;
    }
}


// TUTORIAL SYSTEM
tutorial_active = false;
tutorial_step = 0;
tutorial_max_steps = 4; // Total number of lessons

// Tutorial completion flags
tutorial_moved = false;
tutorial_ran = false;
tutorial_attacked = false;
tutorial_strong_attacked = false;
tutorial_blocked = false;
tutorial_filled_meter = false;
tutorial_complete = false;

// Tutorial text positions (spread horizontally across the room)
tutorial_base_y = 1900; // Y position for all text
tutorial_spacing = 450; // Distance between each lesson

// Tutorial colors
tutorial_color_incomplete = c_white;
tutorial_color_complete = c_lime;

// Function to start tutorial
start_tutorial = function() {
    tutorial_active = true;
    tutorial_step = 0;
    
    // Reset all completion flags
    tutorial_moved = false;
    tutorial_ran = false;
    tutorial_attacked = false;
    tutorial_strong_attacked = false;
    tutorial_blocked = false;
    tutorial_filled_meter = false;
    
    show_debug_message("Tutorial started");
}

// Function to check tutorial progress
check_tutorial_progress = function() {
    if (!tutorial_active) return;
    if (!instance_exists(Ocherry)) return;
    
    // Lesson 0: Movement
    if (!tutorial_moved) {
        // Check if player moved (WASD)
        if (Ocherry.left || Ocherry.right || Ocherry.up || Ocherry.down) {
            tutorial_moved = true;
        }
	}
    if (!tutorial_ran) {   
        // Check if player ran (Shift)
        if (Ocherry.run and Ocherry.hsp != 0) {
            tutorial_ran = true;
        }
    }
    
    // Lesson 1: Attacking
    if (!tutorial_attacked) {
        // Check normal attack
        if (Ocherry.attack3) {
            tutorial_attacked = true;
        }
	}
    if (!tutorial_strong_attacked) {   
        // Check strong attack (hold LMB)
        if (Ocherry.hold_attack) {
            tutorial_strong_attacked = true;
        }
    }
    
    // Lesson 2: Blocking
    if (!tutorial_blocked) {
        if (Ocherry.blocking || Ocherry.block_deflect) {
            tutorial_blocked = true;
        }
    }
    
    // Lesson 3: Fill fire meter
    if (!tutorial_filled_meter) {
        // Check if blood bar is filling up
        if (instance_exists(ObloodPar)) {
            // Find the blood bar (sprite_index == SbloodPar2)
            with (ObloodPar) {
                if (sprite_index == SbloodPar2 && blood > 10) {
                    other.tutorial_filled_meter = true;
                }
            }
        }
    }
	
	// Lesson complete
    if (tutorial_blocked and tutorial_filled_meter and tutorial_strong_attacked and tutorial_attacked and tutorial_ran and tutorial_moved) {
		tutorial_complete = true;
    }
}

// Function to draw tutorial text
draw_tutorial = function() {
    if (!tutorial_active) return;
    
    draw_set_font(Fm5x7XL);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    
    // Lesson 0: Movement
    var lesson0_complete = (tutorial_moved);
    var lesson0_color = lesson0_complete ? tutorial_color_complete : tutorial_color_incomplete;
    draw_set_color(lesson0_color);
    draw_text(500, tutorial_base_y+400, "analog stick / D-pad \nWASD to move");
	
	// Lesson 1: Running
    var lesson1_complete = (tutorial_ran);
    var lesson1_color = lesson1_complete ? tutorial_color_complete : tutorial_color_incomplete;
    draw_set_color(lesson1_color);
    draw_text(1700, tutorial_base_y+400, "L2 \nSHIFT to run");
    
    // Lesson 2: Attacking
    var lesson2_complete = (tutorial_attacked);
    var lesson2_color = lesson2_complete ? tutorial_color_complete : tutorial_color_incomplete;
    draw_set_color(lesson2_color);
    draw_text(2500, tutorial_base_y, "R2 \nLMB 3 times to attack");
	
	// Lesson 3: Hold Attack
    var lesson3_complete = (tutorial_strong_attacked);
    var lesson3_color = lesson3_complete ? tutorial_color_complete : tutorial_color_incomplete;
    draw_set_color(lesson3_color);
    draw_text(4000, tutorial_base_y, "hold R2 \nHold LMB for strong attack");
    
    // Lesson 4: Blocking
    var lesson4_complete = tutorial_blocked;
    var lesson4_color = lesson4_complete ? tutorial_color_complete : tutorial_color_incomplete;
    draw_set_color(lesson4_color);
    draw_text(6000, tutorial_base_y, "Hold R1 \nHold RMB to block (doesn't block all damage)");
    
    // Lesson 5: Fill meter
    var lesson5_complete = tutorial_filled_meter;
    var lesson5_color = lesson5_complete ? tutorial_color_complete : tutorial_color_incomplete;
    draw_set_color(lesson5_color);
    draw_text(8300, tutorial_base_y+65, "Hit enemies or players to fill your fire meter");
	draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

//danger levels
room_danger_level = 12;
danger_calculated = false;