if(sprite_index == Sbandit_bullet)
{
	// Move in the calculated direction
	x += lengthdir_x(move_speed, direction);
	y += lengthdir_y(move_speed, direction);
    
	// Check if traveled max distance from start
	if (point_distance(start_x, start_y, x, y) >= max_distance) {
	    sprite_index = Sbullet_impact;
	    audio_sound_pitch(SNexplotion1, random_range(0.9, 1.1));
	    audio_play_sound(SNexplotion1, 3, false);
	}
    
	// Check collision with obstacles - IGNORE enemies that are dodging
	var should_explode = false;
	if (place_meeting(x, y, _obstacle)) {
	    // Check if we hit a dodging player
	    var hit_dodging = false;
	    with (Ocherry) {
	        if (place_meeting(x, y, other) && variable_instance_exists(id, "dodge_invincible") && dodge_invincible) {
	            hit_dodging = true;
	        }
	    }
        
	    if (!hit_dodging) {
	        should_explode = true;
	    }
	}
    
	if (should_explode) {
	    sprite_index = Sbullet_impact;
	    audio_sound_pitch(SNexplotion1, random_range(0.9, 1.1));
	    audio_play_sound(SNexplotion1, 3, false);
	}
}