/// Ocherry Alarm 1 Event
// Save progress now that everything is initialized
if (instance_exists(Ogame)) {
    // Find the blood bar (the one with sprite SbloodPar2)
    var blood_par = noone;
    with (ObloodPar) {
        if (sprite_index == SbloodPar2) {
            blood_par = id;
            break;
        }
    }
    
    if (instance_exists(blood_par)) {
        // Apply loaded blood if it exists
        if (variable_global_exists("loaded_blood")) {
            blood_par.blood = global.loaded_blood;
            show_debug_message("ALARM: Set blood to " + string(blood_par.blood));
            
            // Clear the loaded variable
            variable_global_set("loaded_blood", undefined);
        }
        
        // NOW save progress with the correct blood value
        global.save_progress();
        show_debug_message("SAVED PROGRESS ON ALARM");
    } else {
        show_debug_message("WARNING: ObloodPar doesn't exist yet, retrying...");
        alarm[1] = 1; // Try again next frame
    }
}