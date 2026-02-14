//kill counter 
// Handle hitstop countdown
if (hitstop_timer > 0) {
    hitstop_timer--;
    
    // When freeze is over, restore normal room speed and play end sounds
    if (hitstop_timer <= 0) {
        room_speed = normal_room_speed;
        
        // Debug - show what pitch values we're using
        show_debug_message("SNkill pitch: " + string(hitstop_kill_pitch));
        show_debug_message("SNscore pitch: " + string(hitstop_score_pitch));
        
        // Try using audio_play_sound instead with audio_sound_pitch
        var snd_kill = audio_play_sound(SNkill, 10, false);
        audio_sound_pitch(snd_kill, hitstop_kill_pitch);
        
        var snd_score = audio_play_sound(SNscore, 10, false);
        audio_sound_pitch(snd_score, hitstop_score_pitch);
    }
}


// Animate kill counter scale
kill_counter_scale = lerp(kill_counter_scale, kill_counter_target_scale, 0.2);

// Animate kill counter rotation
kill_counter_rotation = lerp(kill_counter_rotation, kill_counter_target_rotation, 0.15);

// Decay the jump power and return to normal
kill_counter_jump_power = lerp(kill_counter_jump_power, 0, 0.1);
kill_counter_target_scale = 1 + kill_counter_jump_power;
kill_counter_target_rotation = lerp(kill_counter_target_rotation, 0, 0.1);

// Clamp values to prevent floating point drift
if (abs(kill_counter_scale - 1) < 0.01) kill_counter_scale = 1;
if (abs(kill_counter_rotation) < 0.5) kill_counter_rotation = 0;


if(room == Rmain_menu)
{
	// Remove the effect by setting the slot to undefined
    if (audio_bus_main.effects[0] != undefined)
    {
        audio_bus_main.effects[0] = undefined;
    }
}

//into
if(room == Rintro)
{
	// Ensure we have a clean state for new players
	if(!file_exists("main.sav"))
	{
		// This is a first-time player, ensure clean state
	}
}

//key
//check for enemies 
if(room != Rtutorial) and room != Rerror and room != Rmain_menu
{
	if(!instance_exists(Ojack)) and (!instance_exists(Owillson)) and (!instance_exists(Ojaison)) and (!instance_exists(Oflying)) and (!global.key) and (room != Rmain_menu)
	{
		if(!audio_is_playing(SNcheckpoint)) audio_play_sound(SNcheckpoint,11,false);
		global.key = true
	}
}
else
{
	if(!instance_exists(Ojack)) and (!global.key) and (room != Rmain_menu) and (tutorial_complete)
	{
		if(!audio_is_playing(SNcheckpoint)) audio_play_sound(SNcheckpoint,11,false);
		global.key = true
	}
}

// Tutorial system
if (room == Rtutorial) {
    if (!tutorial_active) {
        start_tutorial();
    }
    
    check_tutorial_progress();
} else {
    // Disable tutorial in other rooms
    if (tutorial_active) {
        tutorial_active = false;
    }
}

// Only give levels if player hasn't reached max level
if (instance_exists(Ocherry) && Ocherry.player_level < Ocherry.max_level) {
    if(global.key) and (!upgraded) 
    {
        Ocherry.level_up();
        upgraded = true;
    }

    if(global.key) and (extra_levels > 0)
    {
        show_debug_message("Room cleared! Giving " + string(extra_levels) + " bonus level(s)");
        repeat(extra_levels)
        {
            extra_levels--;
            Ocherry.level_up();
        }
    }
} else if (global.key) {
    // Player at max level, just mark as upgraded without giving levels
    upgraded = true;
    extra_levels = 0;
}