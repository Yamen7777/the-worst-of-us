vsp = vsp + grv;

// Dodge timer countdown
if (dodge_timer > 0) {
    dodge_timer--;
    dodging = true;
    hsp = 0; // Stop moving during dodge
    dodge_invincible = true; // Invincible during dodge
    
    if (dodge_timer <= 0) {
        dodging = false;
        dodge_invincible = false;
    }
} else {
    dodging = false;
    dodge_invincible = false;
}

//get out if stuck
if(place_meeting(x,y,wall)) y -= 3;

// Dodge cooldown
if (dodge_cooldown > 0) {
    dodge_cooldown--;
}

//afraid of height (AFH)
if (AFH && grounded && !place_meeting(x + hsp, y + 1, wall)) {
    if (flip) {
        hsp = -hsp;
        face = sign(hsp);
    } else {
        hsp = -sign(hsp) * 20;
    }
}

//horizontal collision
if (place_meeting(x + hsp, y, wall)) {
    while (!place_meeting(x + sign(hsp), y, wall)) {
        x = x + sign(hsp);
    }
    if (flip) {
        hsp = -hsp;
        face = sign(hsp);
    } else {
        hsp = -sign(hsp) * 20;
    }
}

x += hsp;



//vertical collision  
if (place_meeting(x, y + vsp, wall)) {
    while (!place_meeting(x, y + sign(vsp), wall)) {
        y = y + sign(vsp);
    }
    vsp = 0;
}
y = y + vsp;

// Attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

// Arrow cooldown
if (arrow_cooldown > 0) {
    arrow_cooldown--;
}

// State machine
if (instance_exists(Ocherry) && !invincible && !dodging) {
    var _cherry = Ocherry;
    var _distance = point_distance(x, y, _cherry.x, _cherry.y);
    var _dx = _cherry.x - x;
    var _horizontal_distance = abs(_dx);
    var _cherryDirection = sign(_dx);
    
    // Always face player when detected (but NOT during attacks)
    if (_distance <= detection_radius && _cherryDirection != 0 && !attacking && !arrow_attacking) {
        face = _cherryDirection;
    }
    
    // ARROW ATTACKING STATE
    if (arrow_attacking) {
        hsp = 0;
        
        // Nudge up to prevent getting stuck
        if (place_meeting(x, y + 1, wall)) {
            y -= 1;
        }
        
        // ARROW 1 - SAskeletonA1
        if (arrow_shot_count == 0) {
            if (image_index >= 12 && !arrow_created[0]) {
                arrow_created[0] = true;
                // Create arrow
				var _arrowX = x + (face * 100);
				var _arrowY = y - 200;
				with (instance_create_layer(_arrowX, _arrowY, "bullets", Oarrow)) {
				    // Calculate direction to player
				    var target_dir = point_direction(x, y, Ocherry.x, Ocherry.y - 200);
    
				    // Set the arrow's direction
				    direction = target_dir;
				    image_angle = target_dir;
    
				    // Calculate movement
				    arrow_speed = 50;
				    move_x = lengthdir_x(arrow_speed, target_dir);
				    move_y = lengthdir_y(arrow_speed, target_dir);
    
				    damage = 5;
				}
            }
            
            if (image_index >= image_number - 1) {
                arrow_shot_count = 1;
                y -= 1;
                sprite_index = SAskeletonA2;
                image_index = 0;
            }
        }
        // ARROW 2 - SAskeletonA2
        else if (arrow_shot_count == 1) {
            if (image_index >= 12 && !arrow_created[1]) {
                arrow_created[1] = true;
                // Create arrow
				var _arrowX = x + (face * 100);
				var _arrowY = y - 200;
				with (instance_create_layer(_arrowX, _arrowY, "bullets", Oarrow)) {
				    // Calculate direction to player
				    var target_dir = point_direction(x, y, Ocherry.x, Ocherry.y - 200);
    
				    // Set the arrow's direction
				    direction = target_dir;
				    image_angle = target_dir;
    
				    // Calculate movement
				    arrow_speed = 50;
				    move_x = lengthdir_x(arrow_speed, target_dir);
				    move_y = lengthdir_y(arrow_speed, target_dir);
    
				    damage = 5;
				}
            }
            
            if (image_index >= image_number - 1) {
                arrow_attacking = false;
                arrow_shot_count = 0;
                arrow_cooldown = arrow_cooldown_time;
                state = "walking";
            }
        }
    }
    // MELEE ATTACKING STATE (close range)
    else if (attacking) {
        hsp = 0;
        
        // Nudge up to prevent getting stuck
        if (place_meeting(x, y + 1, wall)) {
            y -= 1;
        }
        
        // PART 1 - SAskeletonAT1
        if (current_attack_part == 0) {
            if (image_index >= 3 && !attack_created[0]) {
                attack_created[0] = true;
                var _attackX = x + (face * 230);
                with (instance_create_layer(_attackX, y - 200, "bullets", OZ1attack)) {
                    damage = 8;
                    image_xscale = other.face;
                }
            }
            
            if (image_index >= image_number - 1) {
                current_attack_part = 1;
                y -= 5;
                sprite_index = SAskeletonAT2;
                image_index = 0;
            }
        }
        // PART 2 - SAskeletonAT2
        else if (current_attack_part == 1) {
            if (image_index >= 2 && !attack_created[1]) {
                attack_created[1] = true;
                var _attackX = x + (face * 230);
                with (instance_create_layer(_attackX, y - 200, "bullets", OZ1attack)) {
                    damage = 8;
                    image_xscale = -other.face;
                    image_yscale = -1;
                    image_angle = 45 * other.face;
                }
            }
            
            if (image_index >= image_number - 1) {
                current_attack_part = 2;
                y -= 5;
                sprite_index = SAskeletonAT3;
                image_index = 0;
            }
        }
        // PART 3 - SAskeletonAT3
        else if (current_attack_part == 2) {
            if (image_index >= 1 && !attack_created[2]) {
                attack_created[2] = true;
                var _attackX = x + (face * 230);
                with (instance_create_layer(_attackX, y - 200, "bullets", OZ1attack)) {
                    damage = 8;
                    image_xscale = other.face;
                }
            }
            
            if (image_index >= image_number - 1) {
                attacking = false;
                current_attack_part = 0;
                attack_cooldown = attack_cooldown_time;
                state = "walking";
            }
        }
    }
    // NOT ATTACKING - Movement logic
	else {
	    // Player detected and within range
	    if (_distance <= detection_radius) {
	        audio_sound_pitch(SNzobmie, 0.6);
	        if (!audio_is_playing(SNzobmie) && hp > 0) audio_play_sound(SNzobmie, 3, true);
	        flip = false;
        
	        // PRIORITY 1: MELEE ATTACK (0-250 pixels)
	        if (_horizontal_distance <= attack_range && attack_cooldown == 0) {
	            attacking = true;
	            current_attack_part = 0;
	            y -= 1;
	            sprite_index = SAskeletonAT1;
	            image_index = 0;
	            attack_created = [false, false, false];
	        }
	        // PRIORITY 1.5: IN MELEE RANGE BUT ON COOLDOWN - STOP MOVING
	        else if (_horizontal_distance <= attack_range && attack_cooldown > 0) {
	            state = "walking";
	            hsp = lerp(hsp, 0, 0.2); // Stop and wait for attack cooldown
	        }
	        // PRIORITY 2: WALK TO MELEE RANGE (250-500 pixels)
	        else if (_horizontal_distance > attack_range && _horizontal_distance < walk_threshold) {
	            state = "walking";
	            hsp = lerp(hsp, _cherryDirection * walk_speed, 0.1); // Walk towards player
	        }
	        // PRIORITY 3: ARROW ATTACK (500-1500 pixels)
	        else if (_horizontal_distance >= walk_threshold && _horizontal_distance <= arrow_range && arrow_cooldown == 0) {
	            arrow_attacking = true;
	            arrow_shot_count = 0;
	            face = _cherryDirection;
	            y -= 1;
	            sprite_index = SAskeletonA1;
	            image_index = 0;
	            image_xscale = face * size;
	            arrow_created = [false, false];
	        }
	        // PRIORITY 4: WAIT IN ARROW RANGE (on cooldown)
	        else if (_horizontal_distance >= walk_threshold && _horizontal_distance <= arrow_range) {
	            state = "walking";
	            hsp = lerp(hsp, 0, 0.2); // Stop moving, wait for arrow cooldown
	        }
	        // PRIORITY 5: TOO FAR - WALK TOWARDS PLAYER (1500-2500 pixels)
	        else if (_horizontal_distance > arrow_range) {
	            state = "walking";
	            hsp = lerp(hsp, _cherryDirection * walk_speed, 0.1); // Walk closer to arrow range
	        }
	    }
	    // Player not detected - walk around
	    else {
	        state = "walking";
	        flip = true;
	        hsp = lerp(hsp, 0, 0.1);
	    }
	}
}

//animation
if (!place_meeting(x, y + 1, wall)) {
    grounded = false;
    
    if (!attacking && !arrow_attacking && !dodging && !invincible) {
        sprite_index = SAskeleton;
        image_speed = 0;
        if (sign(vsp) > 0) image_index = 1; else image_index = 0;
    }
} else {
    grounded = true;
    
    // DODGE takes priority
    if (dodging) {
        sprite_index = SAskeletonE;
        image_speed = 1;
        image_xscale = face * size;
    }
    // ARROW ATTACKING - make sure animation plays
    else if (arrow_attacking) {
        image_speed = 1; // ADD THIS
    }
    // Then check if not in any special state
    else if (!attacking && !invincible) {
        image_speed = 1;
        
        if (hsp == 0) {
            sprite_index = SAskeleton;
        } else {
            sprite_index = SAskeletonW;
        }
    }
}

// Sprite direction
if (hsp != 0 && !attacking && !arrow_attacking && !dodging) image_xscale = face * size;
if (!arrow_attacking && !dodging) image_yscale = size;

// Damage visual effect
if (invincible) {
    invincible_timer--;
    image_alpha = 0.9;
    sprite_index = SAskeletonHT;
    image_speed = 1;
    image_blend = c_red;
    
    if (invincible_timer <= 0) {
        invincible_timer = invincible_time;
        invincible = false;
        image_alpha = 1;
        image_blend = c_white;
    }
} else {
    image_alpha = 1;
    image_blend = c_white;
}

//damage sources with DODGE system
for (var i = 0; i < array_length(damage_objects); i++) {
    var obj_type = damage_objects[i];
    
    if (instance_exists(obj_type)) {
        // Check if this is a dodgeable ranged attack
        var is_dodgeable = false;
        for (var j = 0; j < array_length(dodgeable_objects); j++) {
            if (obj_type == dodgeable_objects[j]) {
                is_dodgeable = true;
                break;
            }
        }
        
        if (object_get_name(obj_type) == "OfireBreath") {
            with (obj_type) {
                if (place_meeting(x, y, other)) {
                    // Check if dodging (invincible during dodge)
                    if (other.dodge_invincible) {
                        // DODGED - don't damage, don't add to list, projectile continues
                        continue;
                    }
                    
                    if (ds_list_find_index(other.damaged_by_list, id) == -1) {
                        // Try to dodge if possible
                        if (is_dodgeable && other.dodge_cooldown == 0 && !other.attacking && random(1) < other.dodge_chance) {
                            // TRIGGER DODGE
                            other.dodging = true;
                            other.dodge_timer = other.dodge_duration;
                            other.dodge_cooldown = other.dodge_cooldown_time;
                            // Don't take damage, projectile continues
                        } else {
                            // FAILED TO DODGE - take damage
							other.hp -= damage;
							if (instance_exists(ObloodPar)) {
							    ObloodPar.blood += damage;
							}
							other.hsp = sign(other.x - x) * 2;

							other.attacking = false;
							other.arrow_attacking = false; // ADD THIS
							other.attack_cooldown = other.attack_cooldown_time;
							other.arrow_cooldown = other.arrow_cooldown_time; // ADD THIS
							other.state = "walking";

							ds_list_add(other.damaged_by_list, id);
							other.invincible = true;
							other.invincible_clear_timer = other.invincible_clear_time;
                        }
                    }
                }
            }
        } else {
            var damager = instance_place(x, y, obj_type);
            if (damager != noone) {
                // Check if dodging (invincible during dodge)
                if (dodge_invincible) {
                    // DODGED - projectile continues, don't explode blue fire
                    if (object_get_name(obj_type) == "Oblue_fire") {
                        damager.destroy = false; // Prevent explosion
                    }
                    continue;
                }
                
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    // Try to dodge if possible
                    if (is_dodgeable && dodge_cooldown == 0 && !attacking && random(1) < dodge_chance) {
                        // TRIGGER DODGE
                        dodging = true;
                        dodge_timer = dodge_duration;
                        dodge_cooldown = dodge_cooldown_time;
                        // Prevent blue fire explosion
                        if (object_get_name(obj_type) == "Oblue_fire") {
                            damager.destroy = false;
                        }
                    } else {
                        // FAILED TO DODGE - take damage
						hp -= damager.damage;
						if (instance_exists(ObloodPar)) {
							    ObloodPar.blood += damager.damage;
							}
						hsp = sign(x - damager.x) * 2;

						attacking = false;
						arrow_attacking = false; // ADD THIS
						attack_cooldown = attack_cooldown_time;
						arrow_cooldown = arrow_cooldown_time; // ADD THIS
						state = "walking";

						ds_list_add(damaged_by_list, damager);
						invincible = true;
						invincible_clear_timer = invincible_clear_time;
                    }
                }
            }
        }
    }
}

//destroy if blue fire charge - ONLY if NOT dodging
if (place_meeting(x, y, Oblue_fire) && !dodge_invincible) {
    Oblue_fire.destroy = true;
}

// Clear the damaged list after timer expires
if (invincible_clear_timer > 0) {
    invincible_clear_timer--;
    if (invincible_clear_timer <= 0) {
        ds_list_clear(damaged_by_list);
    }
}