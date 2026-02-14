//Olevel end collistion event with Ocherry
if(target == "restart")
{
    TRANS(TRANS_MODE.RESTART,"strawberry");
}
else {
    with (Ocherry) {
        if (hasControl) {
            hasControl = false;
            
            // Set spawn position for next room (will be saved when next room starts)
            global.spawn_x = other.spawn_x;
            global.spawn_y = other.spawn_y;
            global.has_checkpoint = true;
            
            // SAVE PROGRESS BEFORE TRANSITIONING
            show_debug_message("=== SAVING AT LEVEL END ===");
            
            // Make sure we save the CURRENT state before leaving
            if (instance_exists(ObloodPar)) {
                show_debug_message("Current HP: " + string(hp) + " Blood: " + string(ObloodPar.blood));
            }
            
            // Save to file IMMEDIATELY
            if (file_exists(SAVEFILE_MAIN)) file_delete(SAVEFILE_MAIN);
            var file = file_text_open_write(SAVEFILE_MAIN);
            
            // Save TARGET room (the room we're going to)
            file_text_write_real(file, other.target);
            file_text_writeln(file);
            
            // Save spawn position for target room
            file_text_write_real(file, global.spawn_x);
            file_text_writeln(file);
            file_text_write_real(file, global.spawn_y);
            file_text_writeln(file);
            
            // Save CURRENT player stats
            file_text_write_real(file, hp);
            file_text_writeln(file);
            file_text_write_real(file, instance_exists(ObloodPar) ? ObloodPar.blood : 0);
            file_text_writeln(file);
            
            // Save level
            file_text_write_real(file, player_level);
            file_text_writeln(file);
            
            // Save individual upgrade levels
            file_text_write_real(file, upgrade_attack);
            file_text_writeln(file);
            file_text_write_real(file, upgrade_speed);
            file_text_writeln(file);
            file_text_write_real(file, upgrade_range);
            file_text_writeln(file);
            file_text_write_real(file, upgrade_defence);
            file_text_writeln(file);
            file_text_write_real(file, upgrade_spell);
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
            
            show_debug_message("SAVED BEFORE TRANSITION");
            
            // Transition to next room
            if(OLevelEND.transition == 0) {
                TRANS(TRANS_MODE.GOTO,"strawberry", other.target);
            }
            if (OLevelEND.transition == 1) {
                TRANS(TRANS_MODE.GOTO,"strawberry", other.target);
            }
            if (OLevelEND.transition == 2) {
                TRANS(TRANS_MODE.GOTO,"thunder", other.target);
            }
        }
    }
}

/// Olevelend Collision with Ocherry
if (instance_exists(Ogame)) {
    // CONFIRM UPGRADES - They've beaten the room!
    Ogame.upgrades_confirmed = true;
    
    // Store the confirmed upgrade values
    global.confirmed_level = Ocherry.player_level;
    global.confirmed_upgrade_attack = Ocherry.upgrade_attack;
    global.confirmed_upgrade_speed = Ocherry.upgrade_speed;
    global.confirmed_upgrade_range = Ocherry.upgrade_range;
    global.confirmed_upgrade_defence = Ocherry.upgrade_defence;
    global.confirmed_upgrade_spell = Ocherry.upgrade_spell;
    global.confirmed_upgrade_history = global.upgrade_history;
    
    show_debug_message("UPGRADES CONFIRMED! Level: " + string(Ocherry.player_level));
    
    // Save progress with confirmed upgrades
    global.save_progress();
}

// Reset death counter for this room
Ogame.deaths_this_room = 0;