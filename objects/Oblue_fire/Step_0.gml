//blue fire step
if(instance_exists(Oyokai))
if (sprite_index == Sblue_fire1) {
    damage = 12;
    // Move in the tilted direction
    x += lengthdir_x(move_speed, direction);
    y += lengthdir_y(move_speed, direction);
    
    // Check if traveled max distance from start
    if (point_distance(start_x, start_y, x, y) >= max_distance) {
        with(instance_create_layer(x, y, layer, Oblue_explode)) {
            sprite_index = Sblue_explode;
            damage = 4;
			audio_sound_pitch(SNexplotion1,random_range(0.9,1.1));
		    audio_play_sound(SNexplotion1, 3, false);
        }
        instance_destroy();
    }
    
    // Check collision with wall - IGNORE enemies that are dodging
    var should_explode = false;
    if (place_meeting(x, y, _obstacle)) {
        // Check if we hit a dodging enemy
        var hit_dodging = false;
        with (Ojack) {
            if (place_meeting(x, y, other) && variable_instance_exists(id, "dodge_invincible") && dodge_invincible) {
                hit_dodging = true;
            }
        }
        
        if (!hit_dodging) {
            should_explode = true;
        }
    }
    
    if (should_explode) {
        explode = true;
        if(explode) {
            explode_time--;
            if(explode_time <= 0) {
                with(instance_create_layer(x, y, layer, Oblue_explode)) {
                    sprite_index = Sblue_explode;
                    damage = 3;
					audio_sound_pitch(SNexplotion1,random_range(0.9,1.1));
				    audio_play_sound(SNexplotion1, 3, false);
                }
                instance_destroy();
                explode_time = explode_timer;
                explode = false;
            }
        }
    }
}
else if (sprite_index == Sblue_fire2) {
    damage = 3;
    // Arc projectile movement
    arc_progress += arc_speed;
    
    // Calculate position along parabolic arc
    var horizontal_distance = arc_distance * arc_progress;
    var vertical_offset = -arc_height * sin(arc_progress * pi);
    
    // Update position
    x = start_x + (horizontal_distance * arc_direction);
    y = start_y + vertical_offset;
    
    // Rotate sprite to face movement direction
    var next_x = start_x + (arc_distance * (arc_progress + 0.01) * arc_direction);
    var next_y = start_y + (-arc_height * sin((arc_progress + 0.01) * pi));
    image_angle = point_direction(x, y, next_x, next_y);
    
    // Check if reached the end
    if (arc_progress >= 1) {
        with(instance_create_layer(x, y, layer, Oblue_explode)) {
            sprite_index = Sblue_explode;
            damage = 3;
			audio_sound_pitch(SNexplotion1,random_range(0.9,1.1));
		    audio_play_sound(SNexplotion1, 3, false);
        }
        instance_destroy();
    }
    
    // Check collision - IGNORE dodging enemies
    var should_explode = false;
    if (place_meeting(x, y, _obstacle)) {
        var hit_dodging = false;
        with (Ojack) {
            if (place_meeting(x, y, other) && variable_instance_exists(id, "dodge_invincible") && dodge_invincible) {
                hit_dodging = true;
            }
        }
        
        if (!hit_dodging) {
            should_explode = true;
        }
    }
    
    if (should_explode) {
        explode = true;
        if(explode) {
            explode_time--;
            if(explode_time <= 0) {
                with(instance_create_layer(x, y, layer, Oblue_explode)) {
                    sprite_index = Sblue_explode;
                    damage = 3;
					audio_sound_pitch(SNexplotion1,random_range(0.9,1.1));
				    audio_play_sound(SNexplotion1, 3, false);
                }
                instance_destroy();
                explode_time = explode_timer;
                explode = false;
            }
        }
    }
}
if (sprite_index == Sblue_fire3) {
    damage = 80*charge;
    // Move in the tilted direction
    x += lengthdir_x(move_speed, direction);
    y += lengthdir_y(move_speed, direction);
    
    // Check if traveled max distance from start
    if (point_distance(start_x, start_y, x, y) >= max_distance) {
        with(instance_create_layer(x, y, layer, Oblue_explode)) {
            sprite_index = Sblue_explode2;
            charge = other.charge
            damage = 18 * charge;
            image_xscale = charge;
            image_yscale = charge;
			audio_sound_pitch(SNexplotion1,random_range(0.8,0.7));
		    audio_play_sound(SNexplotion1, 3, false);
        }
        instance_destroy();
    }
    
    // Check collision - IGNORE dodging enemies
    var should_explode = false;
    if (place_meeting(x, y, _obstacle) || destroy) {
        var hit_dodging = false;
        with (Ojack) {
            if (place_meeting(x, y, other) && variable_instance_exists(id, "dodge_invincible") && dodge_invincible) {
                hit_dodging = true;
            }
        }
        
        if (!hit_dodging) {
            should_explode = true;
        }
    }
    
    if (should_explode) {
        explode = true;
        if(explode) {
            explode_time--;
            if(explode_time <= 0) {
                with(instance_create_layer(x, y, layer, Oblue_explode)) {
                    sprite_index = Sblue_explode2;
                    charge = other.charge;
                    damage = 18 * charge;
                    image_xscale = charge;
                    image_yscale = charge;
					audio_sound_pitch(SNexplotion1,random_range(0.8,0.7));
				    audio_play_sound(SNexplotion1, 3, false);
                }
                instance_destroy();
                explode_time = explode_timer;
                explode = false;
            }
        }
    }
}
if (sprite_index == Sblue_fire4) {
    damage = 10;
    // Move in the tilted direction
    x += lengthdir_x(move_speed/1.5, direction);
    y += lengthdir_y(move_speed/1.5, direction);
    
    // Check if traveled max distance from start
    if (point_distance(start_x, start_y, x, y) >= max_distance) {
        with(instance_create_layer(x, y, layer, Oblue_explode)) {
            sprite_index = Sblue_explode3;
            blue_sprit = other.blue_sprit;
            damage = 15*blue_sprit;
            image_xscale = blue_sprit/8;
            image_yscale = blue_sprit/8;
			audio_sound_pitch(SNexplotion2,random_range(0.9,1.1));
			audio_play_sound(SNexplotion2, 3, false);
        }
        instance_destroy();
    }
    
    // Check collision - IGNORE dodging enemies
    var should_explode = false;
    if (place_meeting(x, y, _obstacle)) {
        var hit_dodging = false;
        with (Ojack) {
            if (place_meeting(x, y, other) && variable_instance_exists(id, "dodge_invincible") && dodge_invincible) {
                hit_dodging = true;
            }
        }
        
        if (!hit_dodging) {
            should_explode = true;
        }
    }
    
    if (should_explode) {
        explode = true;
        if(explode) {
            explode_time--;
            if(explode_time <= 0) {
                with(instance_create_layer(x, y, layer, Oblue_explode)) {
                    sprite_index = Sblue_explode3;
                    blue_sprit = other.blue_sprit;
                    damage = 15*blue_sprit;
                    image_xscale = blue_sprit/8;
                    image_yscale = blue_sprit/8;
					audio_sound_pitch(SNexplotion2,random_range(0.9,1.1));
					audio_play_sound(SNexplotion2, 3, false);
					
                }
                instance_destroy();
                explode_time = explode_timer;
                explode = false;
            }
        }
    }
}