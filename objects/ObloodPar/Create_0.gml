/// ObloodPar Create Event
sprite_index = SbloodPar2;

// Initialize defaults
fullBlood = 50;
blood = 0;

// Get max blood from player if exists
if (instance_exists(Ocherry)) {
    fullBlood = Ocherry.current_max_blood;
}

// Check if we're loading blood from a save
if (variable_global_exists("loaded_blood")) {
    blood = global.loaded_blood;
    show_debug_message("ObloodPar CREATE: Applied loaded blood = " + string(blood));
}