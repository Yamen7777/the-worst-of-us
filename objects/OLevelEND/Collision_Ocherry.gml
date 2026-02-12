/// Olevelend Collision with Ocherry

// Only trigger once
if (triggered) exit;
triggered = true;

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
    
    // Update spawn point for next room
    global.spawn_x = Ocherry.x;
    global.spawn_y = Ocherry.y;
    global.has_checkpoint = true;
    
    // Save progress with confirmed upgrades
    global.save_progress();
}

// Level up the player
if (instance_exists(Ocherry)) {
    Ocherry.level_up();
}

// Transition to next room (adjust room name as needed)
// TRANS(TRANS_MODE.GOTO, "strawberry", next_room_name);