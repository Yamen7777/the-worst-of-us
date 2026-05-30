//Ojack step
// Preemptive heavy dodge check - handles BEFORE physics/knockback
if (!invincible) {
    var _dodge_slash = instance_place(x, y, Oslash);
    if (_dodge_slash != noone && variable_instance_exists(_dodge_slash, "heavy") && _dodge_slash.heavy) {
        if (ds_list_find_index(damaged_by_list, _dodge_slash) == -1) {
            hsp = -face * 20;
            push_state = true;
            push_state_timer = push_state_time;
            show_damage_number(x, y, 0, -370, "dodge");
            ds_list_add(damaged_by_list, _dodge_slash);
            invincible = true;
            invincible_clear_timer = invincible_clear_time;
        }
    }
}

 vsp = vsp + (grv * global.delta_time_scale);
 vsp *= global.delta_time_scale;
 image_speed = 1 * global.delta_time_scale;

//afraid of height (AFH)
if (AFH && grounded) {
    var _edge_ahead = false;
    for (var i = 0; i < array_length(wall); i++) {
        if (place_meeting(x+hsp, y+1, wall[i])) {
            _edge_ahead = true;
            break;
        }
    }
    if (!_edge_ahead) {
        if (flip) {
            hsp = -hsp;
            face = sign(hsp);
        } else {
            hsp = -sign(hsp) * 20;
        }
    }
}

//horizontal collision
var _hcollide = false;
for (var i = 0; i < array_length(wall); i++) {
    if (place_meeting(x+hsp, y, wall[i])) {
        _hcollide = true;
        break;
    }
}
if (_hcollide) {
    while (true) {
        var _can_move = true;
        for (var i = 0; i < array_length(wall); i++) {
            if (place_meeting(x+sign(hsp), y, wall[i])) {
                _can_move = false;
                break;
            }
        }
        if (_can_move) {
            x += sign(hsp);
        } else {
            break;
        }
    }
    if (flip) {
        hsp = -hsp;
        face = sign(hsp);
    } else {
        hsp = -sign(hsp) * 20;
    }
}

x += hsp * global.delta_time_scale;

//vertica collision  
var _vcollide = false;
for (var i = 0; i < array_length(wall); i++) {
    if (place_meeting(x, y+vsp, wall[i])) {
        _vcollide = true;
        break;
    }
}
if (_vcollide) {
    while (true) {
        var _can_move = true;
        for (var i = 0; i < array_length(wall); i++) {
            if (place_meeting(x, y+sign(vsp), wall[i])) {
                _can_move = false;
                break;
            }
        }
        if (_can_move) {
            y += sign(vsp);
        } else {
            break;
        }
    }
    vsp = 0;
}
y += vsp;

//get out if stuck
var _stuck = false;
for (var i = 0; i < array_length(wall); i++) {
    if (place_meeting(x, y, wall[i])) {
        _stuck = true;
        break;
    }
}
if (_stuck) y -= 3;

// Attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

// Attack logic - only if not attacking and cooldown is done
if (!attacking && attack_cooldown == 0) {
    // Check if player is in attack range
    if (instance_exists(Ocherry)) {
        var _distance = point_distance(x, y, Ocherry.x, Ocherry.y);
        
        if (_distance <= attack_range) {
            // Start attack
            attacking = true;
            sprite_index = SninjayA;
            image_index = 0;
            attack_created = false;
            var _flash = instance_create_layer(x, y - 350, "effects", Odanger_flash);
            _flash.sprite_index = Sflash_orange;
        }
    }
}

// Attack animation
if (attacking) {
    hsp = 0;
    if (image_index >= 7 && !attack_created) {
        attack_created = true;
        var _attackX = x + (face * 165);
        with (instance_create_layer(x, y, "bullets", Obandit_attacks)) {
            sprite_index = Sninjay_attack;
            damage = other.current_damage;
            image_xscale = other.face;
        }
    }
    if (image_index >= image_number - 1) {
        attacking = false;
        attack_cooldown = attack_cooldown_time;
    }
}

//animation
if (!place_meeting(x, y + 1, wall)) {
    grounded = false;
    
    // Don't change sprite if attacking, charging, or being hit
    if (!attacking && !invincible) {
        sprite_index = Sninjay;
        image_speed = 0;
        if (sign(vsp) > 0) image_index = 1; else image_index = 0;
    }
} else {
    grounded = true;
    
    if (!attacking && !invincible) {
        image_speed = 1;
        if (hsp == 0) {
            sprite_index = Sninjay;
        } else {
            sprite_index = SninjayW;
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
    sprite_index = SninjayH;
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
} else if (instance_exists(Ocherry) && !invincible && !attacking) {
    var _cherry = Ocherry;
    var _detectionRadius = 2500;
    var _distance = point_distance(x, y, _cherry.x, _cherry.y);
    
    var _maxspd = 10;
    var _accel = 0.1;
    
    // Check if Ocherry is within detection range
    if (_distance <= _detectionRadius) {
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
                hsp = face * 5; // Knockback
				 
				// Show that same damage number above head
				show_damage_number(x, y, damager.damage, -370);
                    
                // Only cancel if forced (heavy attacks don't cancel Ogolem)
                if (variable_instance_exists(damager, "heavy") && damager.heavy == true) {
                    // Even heavy attacks don't cancel - Ogolem is unbreakable during attack
                }
                    
                ds_list_add(damaged_by_list, damager);
                invincible = true;
                invincible_clear_timer = invincible_clear_timer;
				HitStop(2);
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
					HitStop(1);
                    
                    // NO invincibility, NO knockback, NO sprite change, NO attack cancel
                }
            }
            // NORMAL CASE: All other damage sources
            else {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    // HEAVY ATTACK: Oninjay dodges
                    if (variable_instance_exists(damager, "heavy") && damager.heavy == true) {
                        hsp = -Ocherry.face * 50;
                        push_state = true;
                        push_state_timer = push_state_time;
                        show_damage_number(x, y, 0, -370, "dodge");
                    } else {
                        hp -= damager.damage;
                        if (instance_exists(ObloodPar) && !is_fire_attack) {
                            ObloodPar.blood += damager.damage;
                        }
                        hsp = Ocherry.face * 1;
                        if (abs(hsp) >= 1) {
                            push_state = true;
                            push_state_timer = push_state_time;
                        }
                        show_damage_number(x, y, damager.damage, -370);
                        
                        // Apply clinch if this is a clinch attack
                        if (variable_instance_exists(damager, "clinch") && damager.clinch == true) {
                            clinched = true;
                            clinch_timer = 30;
                        }
                    }
                    
                    ds_list_add(damaged_by_list, damager);
                    invincible = true;
                    invincible_clear_timer = invincible_clear_time;
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