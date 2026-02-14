//Ofire step - Intelligent Enemy AI
vsp = vsp + grv;

// ========== COOLDOWN MANAGEMENT ==========
if (attack_cooldown > 0) attack_cooldown--;
if (jump_cooldown > 0) jump_cooldown--;
if (special_cooldown > 0) special_cooldown--;

// ========== WALL DETECTION & JUMPING ==========
// Only jump when there's a wall ahead (not to follow player vertically)
if (!flip && !is_jumping && !attacking && !using_special && !jump_attacking && jump_cooldown == 0 && grounded) {
    var _wall_ahead = place_meeting(x + (face * wall_check_distance), y, wall);
    
    // Jump ONLY if wall ahead
    if (_wall_ahead) {
        is_jumping = true;
        jump_stopped_by_wall = false;
        jump_cooldown = jump_cooldown_time;
        vsp = jump_speed;
        hsp = face * jump_forward_speed; // Jump forward in facing direction
    }
}

// ========== HORIZONTAL COLLISION ==========
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
    else if (!is_jumping)
    {
        // When chasing on ground, stop horizontal movement when hitting wall
        hsp = 0;
    }
    else
    {
        // When jumping and hitting wall, stop temporarily but remember to resume
        hsp = 0;
        jump_stopped_by_wall = true;
    }
}

x += hsp;

// ========== VERTICAL COLLISION ==========
if (place_meeting(x,y+vsp,wall))
{
    while (!place_meeting(x,y+sign(vsp),wall))
    {
        y = y + sign(vsp);
    }
    vsp = 0;
    is_jumping = false; // Landed
}
y = y + vsp;

//get out if stuck
if(place_meeting(x,y,wall)) y -= 3;

// ========== RESUME JUMP MOMENTUM AFTER CLEARING WALL ==========
if (is_jumping && jump_stopped_by_wall) {
    // Check if we're no longer hitting a wall in front
    var _wall_still_ahead = place_meeting(x + (face * 10), y, wall);
    
    if (!_wall_still_ahead) {
        // Wall is cleared, resume forward momentum
        hsp = face * jump_forward_speed;
        jump_stopped_by_wall = false;
    }
}

// ========== JUMP ATTACK (Mid-air attack) ==========
// Only trigger jump attack if we're in the air and attack is ready
if (!grounded && !attacking && !jump_attacking && !using_special && vsp > -5 && attack_cooldown == 0) {
    if (instance_exists(Ocherry)) {
        var _distance = point_distance(x, y, Ocherry.x, Ocherry.y);
        var _player_in_front = (sign(Ocherry.x - x) == face);
        
        // If mid-air, player is in range AND in front of us
        if (_distance <= jump_attack_range && _player_in_front) {
            jump_attacking = true;
            sprite_index = SwindJA;
            image_index = 0;
            hsp = face * 10; // Strong lunge forward during jump attack
            vsp = -3; // Slight upward boost
            attack_cooldown = attack_cooldown_time; // Share cooldown with normal attacks
        }
    }
}

// ========== JUMP ATTACK ANIMATION ==========
if (jump_attacking) {
    // Create attack hitbox during animation
    if (image_index >= 1 && !attack_created[0]) {
        attack_created[0] = true;
        
        with (instance_create_layer(x, y, "bullets", Owind_attacks)) {
            sprite_index = Swind_slash4; // Temporary - until SwindJA sprite has its own hitbox
            damage = other.current_damage;
            image_xscale = other.face;
        }
    }
    
    // End jump attack when animation finishes
    if (image_index >= image_number - 1) {
        jump_attacking = false;
        attack_created = [false, false, false];
    }
}

// ========== ATTACK LOGIC WITH LEVEL UNLOCKS ==========
var _max_phases = get_max_attack_phases();
var _can_use_special = is_special_unlocked() && special_cooldown == 0;

// Only check for attacks if grounded and not already attacking
if (!attacking && !using_special && !jump_attacking && attack_cooldown == 0 && grounded) {
    if (instance_exists(Ocherry)) {
        var _distance = point_distance(x, y, Ocherry.x, Ocherry.y);
        
        // Check if player is in attack range
        if (_distance <= attack_range) {
            
            // DECISION: Special vs Normal Attack
            // If level 4+ and special is available, ALWAYS use special when in range
            var _use_special = false;
            if (_can_use_special && _distance <= special_range) {
                _use_special = true; // 100% chance at level 4+
            }
            
            if (_use_special) {
                // Use Special Attack
                using_special = true;
                sprite_index = SwindSP;
                image_index = 0;
                special_cooldown = special_cooldown_time;
                hsp = 0;
            } else {
                // Use Normal Attack based on level
                attacking = true;
                hsp = 0;
                
                // Choose attack sprite based on unlocked phases
                switch(_max_phases) {
                    case 1:
                        sprite_index = SwindA1;  // Level 1: Basic attack
                        break;
                    case 2:
                        sprite_index = SwindA2;  // Level 2: second combo 
                        break;
                    case 3:
                        sprite_index = SwindA3; // Level 3+: Full combo
                        break;
                }
                
                image_index = 0;
                attack_created = [false, false, false];
            }
        }
    }
}

// ========== SPECIAL ATTACK ANIMATION ==========
if (using_special) {
    hsp = 0;
    
    // Create special attack hitbox
    if (image_index >= 9 && !attack_created[0]) {
        attack_created[0] = true;
        
        with (instance_create_layer(x, y, "bullets", Owind_attacks)) {
            sprite_index = Swind_slash5; // Temporary until you make the special sprite
            damage = other.current_damage * 1.5; // Special does 1.5x damage
            image_xscale = other.face;
        }
    }
    
    // End special when animation finishes
    if (image_index >= image_number - 1) {
        using_special = false;
        attack_created = [false, false, false];
        attack_cooldown = attack_cooldown_time;
    }
}

// ========== NORMAL ATTACK ANIMATION (Level-based) ==========
if (attacking) {
    var _max_phases = get_max_attack_phases();
    
    // Only stop movement if not in lunge phase (attack 2 is frames 10-15)
    // During lunge, hsp is controlled by the attack 2 code below
    var _in_lunge_phase = (_max_phases >= 2 && image_index >= 10 && image_index < 15);
    if (!_in_lunge_phase) {
        hsp = 0;
    }
    
    // ATTACK 1: Always available (Level 1+)
    if (_max_phases >= 1 && image_index >= 1 && !attack_created[0]) {
        attack_created[0] = true;
        
        with (instance_create_layer(x, y, "bullets", Owind_attacks)) {
            sprite_index = Swind_slash1;
            damage = other.current_damage;
            image_xscale = other.face;
        }
    }
    
    // ATTACK 2: Level 2+ 
    // Lunge forward during frames 10-15
    if (_max_phases >= 2 && image_index >= 9 && image_index < 15) {
        hsp = 10 * face; // Small lunge forward
    }
    
    // Create slash 2 hitbox at frame 12
    if (_max_phases >= 2 && image_index >= 9 && !attack_created[1]) {
        attack_created[1] = true;
        
        with (instance_create_layer(x, y, "bullets", Owind_attacks)) {
            sprite_index = Swind_slash2;
            damage = other.current_damage;
            image_xscale = other.face;
        }
    }
    
    // ATTACK 3: Level 3+
    if (_max_phases >= 3 && image_index >= 18 && !attack_created[2]) {
        attack_created[2] = true;
        
        with (instance_create_layer(x, y, "bullets", Owind_attacks)) {
            sprite_index = Swind_slash3;
            damage = other.current_damage;
            image_xscale = other.face;
        }
    }
    
    // Check if animation finished
    if (image_index >= image_number - 1) {
        attacking = false;
        attack_cooldown = attack_cooldown_time;
    }
}

// ========== ANIMATION SYSTEM ==========
if (!place_meeting(x, y + 1, wall)) {
    grounded = false;
    
    // MID-AIR ANIMATIONS
    if (!attacking && !invincible && !jump_attacking && !using_special) {
        if (vsp < 0) {
            // Going UP - use jump sprite
            sprite_index = SwindJ;
        } else {
            // Going DOWN - use fall sprite  
            sprite_index = SwindF;
        }
    }
} else {
    grounded = true;
    is_jumping = false;
    jump_stopped_by_wall = false; // Reset when landed
    
    // GROUNDED ANIMATIONS
    if (!attacking && !invincible && !using_special && !jump_attacking) {
        image_speed = 1;
        if (hsp == 0) {
            sprite_index = Swind;
        } else {
            sprite_index = SwindR;
        }
    }
}

// Sprite direction
if (!attacking && !using_special && !jump_attacking) {
    if (hsp != 0) image_xscale = face * size;
}
image_yscale = size;

// ========== DAMAGE VISUAL EFFECT ==========
if (invincible) {
    invincible_timer--;
    image_alpha = 0.9;
    
    // UNSTOPPABLE: Don't switch to hurt animation when attacking
    if (!attacking && !using_special && !jump_attacking) {
        sprite_index = SwindH;
    }
    
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
    if (image_blend == c_red) {
        image_blend = merge_color(image_blend, c_white, 0.3);
    } else {
        image_blend = c_white;
    }
}

// ========== PERSISTENT AGGRO - ONCE SEEN, NEVER STOP ==========
// Track if player has ever been seen
if (!variable_instance_exists(id, "player_seen")) {
    player_seen = false;
}

// Check if player is in detection range and set persistent aggro
if (instance_exists(Ocherry)) {
    var _detectionRadius = 2500;
    var _distance = point_distance(x, y, Ocherry.x, Ocherry.y);
    
    if (_distance <= _detectionRadius) {
        player_seen = true; // Once seen, never forget
    }
}

// ========== AI - FOLLOW OCHERRY PERSISTENTLY ==========
if (instance_exists(Ocherry) && !invincible && !attacking && !using_special && !jump_attacking) {
    var _cherry = Ocherry;
    var _distance = point_distance(x, y, _cherry.x, _cherry.y);
    
    var _maxspd = 10;
    var _accel = 0.1;
    
    // If player was ever seen, keep following forever (until Ofire dies)
    if (player_seen) {
        flip = false;
        
        // Calculate horizontal distance to Ocherry
        var _dx = _cherry.x - x;
        var _horizontal_distance = abs(_dx);
        var _cherryDirection = sign(_dx);
        
        // Always face Ocherry
        if (_cherryDirection != 0) {
            face = _cherryDirection;
        }
        
        // Movement logic - stop at stop_distance
        if (_horizontal_distance > stop_distance) {
            // Too far - move towards Ocherry
            if (!is_jumping) { // Don't override jump momentum
                if (_cherryDirection == -1) {
                    hsp = lerp(hsp, -_maxspd, _accel);
                } else if (_cherryDirection == 1) {
                    hsp = lerp(hsp, _maxspd, _accel);
                }
            }
        } else {
            // Within stop distance - stop moving
            if (!is_jumping) {
                hsp = lerp(hsp, 0, 0.2);
            }
        }
    } else {
        // Player never seen - patrol mode (flip behavior)
        flip = true;
        if (!is_jumping) {
            hsp = lerp(hsp, 0, 0.1);
        }
    }
}

// ========== DAMAGE SOURCES ==========
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
            
            // SPECIAL CASE 1: OfireBreath - damage every frame
            if (obj_name == "OfireBreath") {
                hp -= damager.damage;
                if (instance_exists(ObloodPar) && !is_fire_attack) {
                    ObloodPar.blood += damager.damage;
                }
                hsp = sign(x - damager.x);
                
                // UNSTOPPABLE: Never cancel attacks when hit - he takes damage but keeps attacking
                // Show that same damage number above head
				show_damage_number(x, y, damager.damage, -420);
                ds_list_add(damaged_by_list, damager);
                invincible = true;
                invincible_clear_timer = invincible_clear_time;
            }
            // SPECIAL CASE 2: Ospinning_thorns
            else if (obj_name == "Ospinning_thorns") {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(ObloodPar) && !is_fire_attack) {
                        ObloodPar.blood += damager.damage;
                    }
                    image_blend = c_red;
					// Show that same damage number above head
					show_damage_number(x, y, damager.damage, -420);
                    
                    ds_list_add(damaged_by_list, damager);
                    invincible_clear_timer = invincible_clear_time;
                }
            }
            // NORMAL CASE
            else {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(ObloodPar) && !is_fire_attack) {
                        ObloodPar.blood += damager.damage;
                    }
                    hsp = sign(x - damager.x);
					
					// Show that same damage number above head
					show_damage_number(x, y, damager.damage, -420);
                    
                    // UNSTOPPABLE: Never cancel attacks when hit - he takes damage but keeps attacking
                    
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
