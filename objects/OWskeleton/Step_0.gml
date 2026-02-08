vsp = vsp + grv;

// Shield delay countdown
if (shield_delay > 0) {
    shield_delay--;
    if (shield_delay == 0) {
        can_shield = true;
    }
}

// Block cooldown countdown
if (block_cooldown > 0) {
    block_cooldown--;
}

// Shield hold timer - counts down when shielding
if (shield_hold_timer > 0) {
    shield_hold_timer--;
    shielding = true;
    hsp = 0;
    
    if (shield_hold_timer <= 0) {
        shielding = false;
    }
} else {
    shielding = false;
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

// Running cooldown
if (run_cooldown > 0) {
    run_cooldown--;
}

// State machine
if (instance_exists(Ocherry) && !invincible) {
    var _cherry = Ocherry;
    var _distance = point_distance(x, y, _cherry.x, _cherry.y);
    var _dx = _cherry.x - x;
    var _horizontal_distance = abs(_dx);
    var _cherryDirection = sign(_dx);
    
    // Always face player when detected (but NOT during attacks)
    if (_distance <= detection_radius && _cherryDirection != 0 && !attacking && !running_attack) {
        face = _cherryDirection;
    }
    
    // RUNNING ATTACK STATE
    if (running_attack) {
        hsp = 0;
        
        // Start shield delay when running attack starts
        if (image_index == 0 && shield_delay == 0) {
            shield_delay = shield_delay_time;
            can_shield = false;
            run_cooldown = run_cooldown_time;
        }
        
        // Nudge up by 1 pixel when starting animation to prevent getting stuck
        if (image_index == 0 && place_meeting(x, y + 1, wall)) {
            y -= 1;
        }
        
        // CREATE ATTACK AT FRAME 3
        if (image_index >= 3 && !attack_created[0]) {
            attack_created[0] = true;
            var _attackX = x + (face * 250);
            with (instance_create_layer(_attackX, y - 200, "bullets", OZ1attack)) {
                damage = 5;
                image_xscale = other.face;
                image_angle -= 35 * other.face;
            }
        }
        
        // Check if animation finished
        if (image_index >= image_number - 1) {
            running_attack = false;
            state = "walking";
            attack_cooldown = attack_cooldown_time;
            attack_created[0] = false;
        }
    }
    // ATTACKING STATE (3-part attack)
    else if (attacking) {
        hsp = 0;
        
        // Nudge up by 1 pixel when starting each attack part to prevent getting stuck
        if (image_index == 0 && place_meeting(x, y + 1, wall)) {
            y -= 1;
        }
        
        // PART 1 - SWskeletonAT1
        if (current_attack_part == 0) {
            if (image_index >= 4 && !attack_created[0]) {
                attack_created[0] = true;
                var _attackX = x + (face * 250);
                with (instance_create_layer(_attackX, y - 200, "bullets", OZ1attack)) {
                    damage = 5;
                    image_xscale = other.face;
                    image_angle += 35 * other.face;
                    image_yscale = -1;
                }
            }
            
            if (image_index >= image_number - 1) {
                current_attack_part = 1;
                y -= 1;
                sprite_index = SWskeletonAT2;
                image_index = 0;
            }
        }
        // PART 2 - SWskeletonAT2
        else if (current_attack_part == 1) {
            if (image_index >= 3 && !attack_created[1]) {
                attack_created[1] = true;
                var _attackX = x + (face * 250);
                with (instance_create_layer(_attackX, y - 200, "bullets", OZ1attack)) {
                    damage = 5;
                    image_xscale = other.face;
                    image_angle -= 35 * other.face;
                }
            }
            
            if (image_index >= image_number - 1) {
                current_attack_part = 2;
                y -= 3;
                sprite_index = SWskeletonAT3;
                image_index = 0;
            }
        }
        // PART 3 - SWskeletonAT3
        else if (current_attack_part == 2) {
            if (image_index >= 2 && !attack_created[2]) {
                attack_created[2] = true;
                var _attackX = x + (face * 250);
                with (instance_create_layer(_attackX, y - 200, "bullets", OZ1attack)) {
                    damage = 5;
                    image_xscale = other.face;
                    image_angle += 35 * other.face;
                    image_yscale = -1;
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
            
            // Check if in attack range
            if (_horizontal_distance <= attack_range && attack_cooldown == 0) {
                // If running, do running attack
                if (state == "running" && !running_attack_triggered) {
                    running_attack = true;
                    running_attack_triggered = true;
                    y -= 1;
                    sprite_index = SWskeletonRA;
                    image_index = 0;
                }
                // Otherwise do normal 3-part attack
                else if (state == "walking") {
                    attacking = true;
                    current_attack_part = 0;
                    y -= 1;
                    sprite_index = SWskeletonAT1;
                    y -= 1;
                    image_index = 0;
                    attack_created = [false, false, false];
                }
            }
            // Not in attack range - decide whether to run or walk
            else if (_horizontal_distance > stop_distance) {
                // Can run if: cooldown is done AND (never triggered OR player is far away)
                if (run_cooldown == 0 && (!running_attack_triggered || _distance > run_trigger_distance)) {
                    state = "running";
                    running_attack_triggered = false;
                    if (_cherryDirection == -1) {
                        hsp = lerp(hsp, -run_speed, 0.1);
                    } else if (_cherryDirection == 1) {
                        hsp = lerp(hsp, run_speed, 0.1);
                    }
                }
                // Otherwise just walk
                else {
                    state = "walking";
                    if (_cherryDirection == -1) {
                        hsp = lerp(hsp, -walk_speed, 0.1);
                    } else if (_cherryDirection == 1) {
                        hsp = lerp(hsp, walk_speed, 0.1);
                    }
                }
            }
            // In stop distance - stop and wait
            else {
                state = "walking";
                hsp = lerp(hsp, 0, 0.2);
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
    
    if (!attacking && !running_attack && !invincible && !shielding) {
        sprite_index = SWskeleton;
        image_speed = 0;
        if (sign(vsp) > 0) image_index = 1; else image_index = 0;
    }
} else {
    grounded = true;
    
    // SHIELD takes priority over everything except attacking and invincible
    if (shielding && !attacking && !running_attack && !invincible) {
        y -= 2;
        sprite_index = SWskeletonSH;
        image_speed = 1;
        image_xscale = face * size;
    }
    else if (!attacking && !running_attack && !invincible) {
        image_speed = 1;
        
        if (hsp == 0) {
            sprite_index = SWskeleton;
        } else {
            // Choose walk or run sprite based on state
            if (state == "running") {
                sprite_index = SWskeletonR;
            } else {
                sprite_index = SWskeletonW;
            }
        }
    }
}

// Sprite direction
if (hsp != 0 && !attacking && !running_attack && !shielding) image_xscale = face * size;
if (!shielding) image_yscale = size;

// Damage visual effect
if (invincible) {
    invincible_timer--;
    image_alpha = 0.9;
    sprite_index = SWskeletonHT;
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

//damage sources (ONLY ONCE!)
for (var i = 0; i < array_length(damage_objects); i++) {
    var obj_type = damage_objects[i];
    
    if (instance_exists(obj_type)) {
        if (object_get_name(obj_type) == "Oblade_back") {
            with (obj_type) {
                if (place_meeting(x, y, other)) {
                    if (ds_list_find_index(other.damaged_by_list, id) == -1) {
                        // Check shield conditions
                        var can_block = other.can_shield && 
                                       !other.attacking && 
                                       !other.running_attack &&
                                       !other.invincible &&
                                        other.block_cooldown == 0;
                        
                        // Check if attack is from front
                        var attack_from_front = (sign(x - other.x) == other.face);
                        
                        if (can_block && attack_from_front) {
                            // BLOCKED - activate shield and RESET timer
                            other.shielding = true;
                            other.shield_hold_timer = other.shield_hold_time;
                            other.hsp = 0;
                            ds_list_add(other.damaged_by_list, id);
                            other.invincible_clear_timer = other.invincible_clear_time;
                        } else {
                            // NOT BLOCKED - take damage
                            other.hp -= damage;
                            if (instance_exists(Owerewolf) && !Owerewolf.transform) {
                                ObloodPar.blood += damage;
                            }
                            other.hsp = sign(other.x - x) * 10;

                            // Cancel all attacks when hit
                            other.attacking = false;
                            other.running_attack = false;
                            other.running_attack_triggered = false;
                            other.attack_cooldown = other.attack_cooldown_time;
                            other.state = "walking";

                            ds_list_add(other.damaged_by_list, id);
                            other.invincible = true;
                            other.block_cooldown = other.block_cooldown_time; 
                            other.invincible_clear_timer = other.invincible_clear_time;
                        }
                    }
                }
            }
        } else {
            var damager = instance_place(x, y, obj_type);
            if (damager != noone) {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    // Check shield conditions
                    var can_block = can_shield && 
                                   !attacking && 
                                   !running_attack &&
                                   !invincible &&
                                   block_cooldown == 0;
                    
                    // Check if attack is from front
                    var attack_from_front = (sign(damager.x - x) == face);
                    
                    if (can_block && attack_from_front) {
                        // BLOCKED - activate shield and RESET timer
                        shielding = true;
                        shield_hold_timer = shield_hold_time;
                        hsp = 0;
                        ds_list_add(damaged_by_list, damager);
                        invincible_clear_timer = invincible_clear_time;
                    } else {
                        // NOT BLOCKED - take damage
                        hp -= damager.damage;
                        if (instance_exists(Owerewolf) && !Owerewolf.transform) {
                            ObloodPar.blood += damager.damage;
                        }
                        hsp = sign(x - damager.x) * 10;

                        // Cancel all attacks when hit
                        attacking = false;
                        running_attack = false;
                        running_attack_triggered = false;
                        attack_cooldown = attack_cooldown_time;
                        state = "walking";

                        ds_list_add(damaged_by_list, damager);
                        invincible = true;
                        block_cooldown = block_cooldown_time;
                        invincible_clear_timer = invincible_clear_time;
                    }
                }
            }
        }
    }
}

//destroy if blue fire charge
if (place_meeting(x, y, Oblue_fire)) Oblue_fire.destroy = true;

// Clear the damaged list after timer expires
if (invincible_clear_timer > 0) {
    invincible_clear_timer--;
    if (invincible_clear_timer <= 0) {
        ds_list_clear(damaged_by_list);
    }
}