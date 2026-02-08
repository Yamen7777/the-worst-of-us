/// @desc killCounter(amount)
/// @arg amount Number of kills to add (default: 1)
function killCounter(_amount = 1) {
    // Add to the global counter
    global.kill_counter += _amount;
    
    // Update Ogame animation variables
    if (instance_exists(Ogame))
    {
        Ogame.kill_counter_jump_power += _amount * 0.3;
        Ogame.kill_counter_jump_power = min(Ogame.kill_counter_jump_power, 2);
        Ogame.kill_counter_target_scale = 1 + Ogame.kill_counter_jump_power;
        Ogame.kill_counter_target_rotation = Ogame.kill_counter_jump_power * 15 * choose(-1, 1);
        
        // HITSTOP/FRAME FREEZE based on kill value
        var freeze_duration = 2;  // Always 2 frames
        var freeze_room_speed = 7;  // Default slowest
        var kill_pitch = 1.0;
        var score_pitch = 1.0;
        
        if (_amount >= 10) {
            freeze_room_speed = 4;  // Epic kills - SUPER slow
            kill_pitch = 0.5;
            score_pitch = 1.8;
        }
        else if (_amount >= 7) {
            freeze_room_speed = 5;  // Big kills - very slow
            kill_pitch = 0.7;
            score_pitch = 1.5;
        }
        else if (_amount >= 5) {
            freeze_room_speed = 6;  // Medium kills - slow
            kill_pitch = 0.80;
            score_pitch = 1.3;
        }
        else if (_amount >= 3) {
            freeze_room_speed = 7;  // Small kills - faster
            kill_pitch = 0.90;
            score_pitch = 1.15;
        }
        else if (_amount >= 1) {
            freeze_room_speed = 8;  // Regular kills - fastest freeze
            kill_pitch = 1.0;
            score_pitch = 1.0;
        }
        
        // Apply the hitstop ONLY if not already in hitstop
        if (freeze_duration > 0) {
            // Play SNhit BEFORE the freeze starts
            audio_play_sound(SNhit, 10, false);
            
            // ONLY apply hitstop if we're not already in one, OR if this kill is bigger
            if (Ogame.hitstop_timer <= 0 || freeze_room_speed < room_speed) {
                // Store sound data in Ogame to play after freeze
                Ogame.hitstop_timer = freeze_duration;
                Ogame.hitstop_kill_pitch = kill_pitch;
                Ogame.hitstop_score_pitch = score_pitch;
                Ogame.normal_room_speed = room_speed;
                
                // Start the freeze with variable intensity
                room_speed = freeze_room_speed;
            }
        }
    }
}