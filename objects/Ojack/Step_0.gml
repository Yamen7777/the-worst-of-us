//Ojack step
 // Hitstop: skip movement and freeze on current frame
if (hitstop_timer > 0) {
    hitstop_timer--;
    image_index = hitstop_frame; // Stay on the frame where hitstop started
    // Keep applying gravity but don't move horizontally
    vsp = vsp + grv;
    if (place_meeting(x, y + vsp, wall)) {
        vsp = 0;
    }
    return; // Skip all behavior
}
hitstop_frame = image_index; // Store current frame for next hitstop

 vsp = vsp + grv;

//afraid of height (AFH)
if (AFH) && (grounded) && (!place_meeting(x+hsp,y+1,wall))
{
	if(flip)
	{
		hsp = -hsp;
		face = sign(hsp); // Add this line - make face flip when hitting wall
	}
	else
	{
		// Small knockback when chasing player and hitting wall
		hsp = -sign(hsp) * 20; // Knockback speed (adjust as needed)
	}
}

//horizontal collision
if (place_meeting(x+hsp,y,wall))
{
	while (!place_meeting(x+sign(hsp),y,wall))
	{
		x = x + sign(hsp);
	}
	if(flip)
	{
		hsp = -hsp;
		face = sign(hsp);
	}
	else
	{
		// Small knockback when chasing player and hitting wall
		hsp = -sign(hsp) * 20; // Knockback speed (adjust as needed)
	}
}

x += hsp;

//vertica collision  
if (place_meeting(x,y+vsp,wall))
{
	while (!place_meeting(x,y+sign(vsp),wall))
	{
		y = y + sign(vsp);
	}
	vsp = 0;
}
y = y + vsp;

//get out if stuck
if(place_meeting(x,y,wall)) y -= 3;

// Attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

// Attack logic - only if not attacking and cooldown is done
if (!attacking && attack_cooldown == 0) and (!invincible) and (hit_stun <= 0) {
    // Check if player is in attack range
    if (instance_exists(Ocherry)) {
        var _distance = point_distance(x, y, Ocherry.x, Ocherry.y);
        
        if (_distance <= attack_range) {
            // Start attack
            attacking = true;
            sprite_index = Sbandit1A;
            image_index = 0;
            attack_created = [false, false]; // Reset attack tracking
        }
    }
}

//attack animation
if (attacking) {
	hsp = 0;
    // First attack - at frame 2
    if (image_index >= 3 && !attack_created[0]) {
        attack_created[0] = true;
        
        // Create first attack hitbox
        var _attackX = x + (face * 165);
        with (instance_create_layer(_attackX, y - 200, "bullets", Obandit_attacks)) {
			sprite_index = Saxe_attack;
			damage = other.current_damage; // Use calculated damage
            image_xscale = other.face;
			image_angle += 35*other.face;
        }
    }
    
    // Check if animation finished
    if (image_index >= image_number -1) {
        attacking = false;
        attack_cooldown = attack_cooldown_time;
    }
}

//animation
if (!place_meeting(x, y + 1, wall)) {
    grounded = false;
    
    // Don't change sprite if attacking or being hit
    if (!attacking && !invincible) {
        sprite_index = Sbandit1;
        image_speed = 0;
        if (sign(vsp) > 0) image_index = 1; else image_index = 0;
    }
} else {
    grounded = true;
    
    // Don't change sprite if attacking or being hit
    if (!attacking && !invincible) {
        image_speed = 1;
        if (hsp == 0) {
            sprite_index = Sbandit1;
        } else {
            sprite_index = Sbandit1W;
        }
    }
}

// Sprite direction
if (hsp != 0 && !attacking) image_xscale = face * size;
image_yscale = size;

// Damage visual effect - handle AFTER animation logic
if (invincible) and (!attacking) {
    invincible_timer--;
    image_alpha = 0.9;
    sprite_index = Sbandit1H;
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
    // Only reset to white if not being damaged by fire/thorns
    if (image_blend == c_red) {
        // Fade red back to white quickly
        image_blend = merge_color(image_blend, c_white, 0.3);
    } else {
        image_blend = c_white;
    }
}

// Push state handling
if (push_state) {
    // Count down timer
    push_state_timer--;
    if (push_state_timer <= 0) {
        push_state = false;
    }
    
    // Show yellow blend during push state
    image_blend = c_yellow;
    
    // Check for horizontal wall collision
    if (hsp != 0) {
        var _wall_check = noone;
        if (hsp > 0) {
            _wall_check = instance_place(x + abs(hsp) + 5, y, wall);
        } else {
            _wall_check = instance_place(x - abs(hsp) - 5, y, wall);
        }
        
        if (_wall_check != noone) {
            // Hit a wall - calculate damage based on hsp
            var _impact_speed = abs(hsp);
            var _damage = 0;
            
            if (_impact_speed >= 3) {
                // Scale damage from 1 to 10 based on speed (3 to 50+)
                _damage = floor(lerp(1, 10, clamp((_impact_speed - 3) / 47, 0, 1)));
            }
            
            if (_damage > 0) {
                hp -= _damage;
                show_damage_number(x, y, -_damage, -370);
            }
            
            // Stop horizontal movement
            hsp = 0;
            
            // End push state early
            push_state = false;
            image_blend = c_white;
        }
        
        // Check for collision with other Ojack enemies
        var _other_enemy = noone;
        if (hsp > 0) {
            _other_enemy = instance_place(x + abs(hsp) + 10, y, Ojack);
        } else {
            _other_enemy = instance_place(x - abs(hsp) - 10, y, Ojack);
        }
        
        if (_other_enemy != noone && _other_enemy != id) {
            // Hit another Ojack - calculate damage (half each)
            var _impact_speed = abs(hsp);
            var _damage = 0;
            
            if (_impact_speed >= 3) {
                // Scale damage from 1 to 10 based on speed (3 to 50+)
                _damage = floor(lerp(1, 10, clamp((_impact_speed - 3) / 47, 0, 1)));
            }
            
            var _half_damage = ceil(_damage / 2);
            
            // This enemy takes half damage
            if (_half_damage > 0) {
                hp -= _half_damage;
                show_damage_number(x, y, -_half_damage, -370);
            }
            
            // Other enemy takes half damage
            if (_half_damage > 0) {
                _other_enemy.hp -= _half_damage;
                with (_other_enemy) {
                    show_damage_number(x, y, -_half_damage, -370);
                }
            }
            
            // Give other enemy a small knockback (10 at 50+ hsp, 1 at 3 hsp)
            var _other_knockback = 0;
            if (_impact_speed >= 3) {
                // Scale knockback from 1 to 25 based on speed (3 to 50+)
                _other_knockback = floor(lerp(2, 35, clamp((_impact_speed - 3) / 47, 0, 1)));
            }
            _other_enemy.hsp = sign(hsp) * _other_knockback;
            
            // Give other enemy push state
            if (abs(_other_knockback) >= 1) {
                _other_enemy.push_state = true;
                _other_enemy.push_state_timer = _other_enemy.push_state_time;
            }
            
            // Stop horizontal movement
            hsp = 0;
            
            // End push state early
            push_state = false;
            image_blend = c_white;
        }
    }
} else {
    image_blend = c_white;
}

// Circle detection and follow Ocherry
if (clinched) {
    // Clinch movement - pull towards slash position
    if (clinch_timer > 0) {
        clinch_timer--;
        // Find the slash that clinched us
        var _slash = instance_find(Oslash, 0);
        if (_slash != noone && variable_instance_exists(_slash, "clinch") && _slash.clinch) {
            // Pull enemy to slash position minus offset
            var _targetX = _slash.x - (sign(_slash.image_xscale));
            x = lerp(x, _targetX, 0.1);
            hsp = 0;
            // Face the direction of the pull
            face = sign(_slash.image_xscale);
        }
    } else {
        clinched = false;
    }
} else if (instance_exists(Ocherry) && !invincible) and (!attacking) {
    var _cherry = Ocherry;
    var _detectionRadius = 2500;
    var _distance = point_distance(x, y, _cherry.x, _cherry.y);
    
    var _maxspd = 10;
    var _accel = 0.1;
    
    // Check if Ocherry is within detection range
    if (_distance <= _detectionRadius) {
        //audio_sound_pitch(SNzobmie, 0.8);
        //if (!audio_is_playing(SNzobmie) && hp > 0) audio_play_sound(SNzobmie, 3, true);
        flip = false;
        
        // Calculate horizontal distance to Ocherry
        var _dx = _cherry.x - x;
        var _horizontal_distance = abs(_dx);
        var _cherryDirection = sign(_dx);
        
        // Always face Ocherry
        if (_cherryDirection != 0) {
            face = _cherryDirection;
        }
        
        // Movement logic - stop at stop_distance (150), but can still attack from attack_range (250)
        if (_horizontal_distance > stop_distance) {
            // Too far - move towards Ocherry
            if (_cherryDirection == -1) {
                hsp = lerp(hsp, -_maxspd, _accel);
            } else if (_cherryDirection == 1) {
                hsp = lerp(hsp, _maxspd, _accel);
            }
        } else {
            // Within stop distance - stop moving (but can still attack if within 250)
            hsp = lerp(hsp, 0, 0.2);
        }
    } else {
        flip = true;
        // Outside detection range - stop
        hsp = lerp(hsp, 0, 0.1);
    }
}

//damage sources
for (var i = 0; i < array_length(damage_objects); i++) {
    var obj_type = damage_objects[i];
    
    if (instance_exists(obj_type)) {
        var damager = instance_place(x, y, obj_type);
        
        if (damager != noone) {
            // Check if this is a fire-based attack (these DON'T give blood - they cost blood to use)
            var obj_name = object_get_name(obj_type);
            var is_fire_attack = (obj_name == "Ofireball" || obj_name == "OfireBreath" || 
                                  obj_name == "OfireExplode" || obj_name == "OfireSlash" ||
                                  obj_name == "Oblue_fire" || obj_name == "Oblue_explode");
            
            // SPECIAL CASE 1: OfireBreath - damage every frame, no invincibility
            if (obj_name == "OfireBreath") {
                hp -= damager.damage;
                if (instance_exists(ObloodPar) && !is_fire_attack) {
                    ObloodPar.blood += damager.damage;
                }
                // Visual feedback but no stun
                hsp = Ocherry.face * 5; // Knockback
				 
				// Show that same damage number above head
				show_damage_number(x, y, damager.damage, -370);
                    
                // Cancel attack only if it was a heavy attack
                if (variable_instance_exists(damager, "heavy") && damager.heavy == true) {
                    attacking = false;
                    attack_cooldown = attack_cooldown_time;
                }
                    
                ds_list_add(damaged_by_list, damager);
                invincible = true;
                invincible_clear_timer = invincible_clear_timer;
				HitStop(2, 2, damager.x, damager.y); // Short hitstop for fire breath
            }
            // SPECIAL CASE 2: Ospinning_thorns - damage but no stun/knockback
            else if (obj_name == "Ospinning_thorns") {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(ObloodPar) && !is_fire_attack) {
                        ObloodPar.blood += damager.damage;
                    }
                    // Visual feedback only - red flash
                    image_blend = c_red;
					
					// Show that same damage number above head
					show_damage_number(x, y, damager.damage, -370);
                    
                    // Add to damaged list so it only hits once per thorn
                    ds_list_add(damaged_by_list, damager);
                    invincible_clear_timer = invincible_clear_time;
					HitStop(1, 2, damager.x, damager.y); // Very short hitstop for thorns
                    
                    // NO invincibility, NO knockback, NO sprite change, NO attack cancel
                }
            }
            // NORMAL CASE: All other damage sources
            else {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(ObloodPar) && !is_fire_attack) {
                        ObloodPar.blood += damager.damage;
                    }
                    
                    // Cancel attack for all attacks (both light and heavy)
                    attacking = false;
                    attack_cooldown = attack_cooldown_time;
                    
                    // Check variant for different knockback
                    if (variable_instance_exists(damager, "heavy") && damager.heavy == true) {
                        // Heavy attacks
                        if (variable_instance_exists(damager, "heavy_variant")) {
                            if (damager.heavy_variant == 1) {
                                // Heavy 1: small forward knockback
                                hsp = 0;
                            } else if (damager.heavy_variant == 2) {
                                // Heavy 2: double knockback (push further)
                                hsp = Ocherry.face * 30;
                            } else {
                                hsp = Ocherry.face * 1;
                            }
                        } else {
                            hsp = Ocherry.face * 1;
                        }
                    } else if (variable_instance_exists(damager, "light_variant")) {
                        // Check light variant for knockback
                        if (damager.light_variant == 3) {
                            // Light 3: knockback of 50
                            hsp = Ocherry.face * 10;
                        } else {
                            hsp = Ocherry.face * 1;
                        }
                    } else {
                        hsp = Ocherry.face * 1;
                    }
                    
                    // Apply clinch if this is a clinch attack
                    if (variable_instance_exists(damager, "clinch") && damager.clinch == true) {
                        clinched = true;
                        clinch_timer = 30;
                    }
                    
                    // Apply push state if there's knockback
                    if (abs(hsp) >= 1) {
                        push_state = true;
                        push_state_timer = push_state_time;
                    }
                    
                    // Apply hitstop - freeze both player and enemy
                    var _hitstop_duration = 5;
                    if (variable_instance_exists(damager, "heavy") && damager.heavy == true) {
                        // Heavy attack - longer hitstop
                        _hitstop_duration = 7;
                    }
                    HitStop(_hitstop_duration, 2, damager.x, damager.y); // 2 = freeze both player and enemy
					
					// Show that same damage number above head
					show_damage_number(x, y, damager.damage, -370);
                    
                    ds_list_add(damaged_by_list, damager);
                    invincible = true;
                    invincible_clear_timer = invincible_clear_time;
					hit_stop = true;
                }
            }
        }
    }
}

//destroy if blue fire charge
if(place_meeting(x,y,Oblue_fire)) Oblue_fire.destroy = true; 

// Clear the damaged list after timer expires
if (invincible_clear_timer > 0) {
    invincible_clear_timer--;
    if (invincible_clear_timer <= 0) {
        ds_list_clear(damaged_by_list);
    }
}

//hit stun
if(hit_stun > 0)
{
	hit_stun--;
}

// Attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

