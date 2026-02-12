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
        if (variable_global_exists("loaded_blood") && !is_undefined(global.loaded_blood)) {
            blood_par.blood = global.loaded_blood;
            show_debug_message("ALARM: Set blood to " + string(blood_par.blood));
        }
        
        // Safety check - ensure blood is a valid number before saving
        if (is_undefined(blood_par.blood) || !is_real(blood_par.blood)) {
            blood_par.blood = 0;
            show_debug_message("WARNING: Blood was undefined, reset to 0");
        }
        
        // NOW save progress with the correct blood value
        global.save_progress();
        show_debug_message("SAVED PROGRESS ON ALARM - Blood: " + string(blood_par.blood));
        
        // Clear the loaded variable AFTER saving
        if (variable_global_exists("loaded_blood")) {
            variable_global_set("loaded_blood", undefined);
            show_debug_message("Cleared loaded_blood variable");
        }
    } else {
        show_debug_message("WARNING: ObloodPar doesn't exist yet, retrying...");
        alarm[1] = 1; // Try again next frame
    }
}