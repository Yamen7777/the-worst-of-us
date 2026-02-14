//bandit 3 step 
vsp = vsp + grv;

//afraid of height (AFH)
if (AFH) && (grounded) && (!place_meeting(x+hsp,y+1,wall))
{
	if(flip)
	{
		hsp = -hsp;
		face = sign(hsp);
	}
	else
	{
		hsp = -sign(hsp) * 20;
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
		hsp = -sign(hsp) * 20;
	}
}

x += hsp;

//vertical collision  
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

// CANCEL SHOOTING if player gets too close (within 350)
if (shooting && instance_exists(Ocherry)) {
    var _distance = point_distance(x, y, Ocherry.x, Ocherry.y);
    if (_distance <= 350) {
        // Player got too close - cancel shooting
        shooting = false;
        shoot_created = [false];
        attack_cooldown = 0; // Reset cooldown so can melee immediately
        show_debug_message("Cancelled shooting - player too close!");
    }
}

// COMBINED ATTACK/SHOOT LOGIC - Check distance and decide which attack to use
if (!attacking && !shooting && attack_cooldown == 0) {
    if (instance_exists(Ocherry)) {
        var _distance = point_distance(x, y, Ocherry.x, Ocherry.y);
        
        // PRIORITY 1: Close range - Melee attack
        if (_distance <= attack_range) {
            // Start melee attack
            attacking = true;
            sprite_index = Sbandit3A;
            image_index = 0;
            attack_created = [false, false]; // Reset attack tracking
        }
        // PRIORITY 2: Medium/Far range - Shoot (only if distance > 350)
        else if (_distance > 350 && _distance <= shoot_range) {
            // FACE THE PLAYER BEFORE SHOOTING
            var _dir_to_player = sign(Ocherry.x - x);
            if (_dir_to_player != 0) {
                face = _dir_to_player;
            }
            
            // Start shooting
            shooting = true;
            sprite_index = Sbandit3S;
            image_index = 0;
            shoot_created = [false]; // Reset attack tracking
        }
    }
}

// MELEE ATTACK animation
if (attacking) {
	hsp = 0;
    
    // First attack - at frame 2
    if (image_index >= 2 && !attack_created[0]) {
        attack_created[0] = true;
        
        // Create first attack hitbox
        var _attackX = x + (face * 165);
        with (instance_create_layer(_attackX, y - 200, "bullets", Obandit_attacks)) {
			sprite_index = Sknife_attack;
			damage = other.current_damage; // Use calculated damage
            image_xscale = other.face;
        }
    }
    
    // Check if animation finished
    if (image_index >= image_number - 1) {
        attacking = false;
        attack_cooldown = attack_cooldown_time;
    }
}
// SHOOT animation
else if (shooting) {
    hsp = 0;
    
    // KEEP FACING THE PLAYER DURING ATTACK
    if (instance_exists(Ocherry)) {
        var _dir_to_player = sign(Ocherry.x - x);
        if (_dir_to_player != 0) {
            face = _dir_to_player;
            image_xscale = face * size;
        }
    }
    
    // Shoot at frame 6
    if (image_index >= 6 && !shoot_created[0]) {
        shoot_created[0] = true;
        
        // Create bullet
        var _attackX = x + (face * 165);
        with (instance_create_layer(_attackX, y - 200, "bullets", Obandit_bullet)) {
            damage = other.current_damage; // Use calculated damage
            image_xscale = 0.75*other.face;
            image_yscale = 0.75;
			max_distance = 1000;
        }
    }
    
    // Check if animation finished
    if (image_index >= image_number - 1) {
        shooting = false;
        attack_cooldown = attack_cooldown_time;
    }
}

//animation
if (!place_meeting(x, y + 1, wall)) {
    grounded = false;
    
    // Don't change sprite if attacking, shooting, or being hit
    if (!attacking && !shooting && !invincible) {
        sprite_index = Sbandit3;
        image_speed = 0;
        if (sign(vsp) > 0) image_index = 1; else image_index = 0;
    }
} else {
    grounded = true;
    
    // Don't change sprite if attacking, shooting, or being hit
    if (!attacking && !shooting && !invincible) {
        image_speed = 1;
        if (hsp == 0) {
            sprite_index = Sbandit3;
        } else {
            sprite_index = Sbandit3W;
        }
    }
}

// Sprite direction
if (hsp != 0 && !attacking && !shooting) image_xscale = face * size;
image_yscale = size;

// Damage visual effect
if (invincible) {
    invincible_timer--;
    image_alpha = 0.9;
    sprite_index = Sbandit3H;
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

// Circle detection and follow Ocherry
if (instance_exists(Ocherry) && !invincible){
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
        
        // Always face Ocherry (when not attacking/shooting)
        if (_cherryDirection != 0 && !attacking && !shooting) {
            face = _cherryDirection;
        }
        
        // UPDATED MOVEMENT LOGIC
        // Priority 1: If in melee range, stop at stop_distance (200)
        if (_distance <= attack_range) {
            if (_horizontal_distance > stop_distance) {
                // Move towards player (to get in melee position)
                if (_cherryDirection == -1) {
                    hsp = lerp(hsp, -_maxspd, _accel);
                } else if (_cherryDirection == 1) {
                    hsp = lerp(hsp, _maxspd, _accel);
                }
            } else {
                // Close enough for melee - stop
                hsp = 0;
                if (!attacking && !shooting) face = sign(Ocherry.x - x);
            }
        }
        // Priority 2: If between 350-900 (shooting range), stop at shoot_stop_distance (800)
        else if (_distance > 350 && _distance <= shoot_range) {
            if (_horizontal_distance > shoot_stop_distance) {
                // Move towards player (to get in shooting position)
                if (_cherryDirection == -1) {
                    hsp = lerp(hsp, -_maxspd, _accel);
                } else if (_cherryDirection == 1) {
                    hsp = lerp(hsp, _maxspd, _accel);
                }
            } else {
                // Good shooting distance - stop
                hsp = 0;
                if (!attacking && !shooting) face = sign(Ocherry.x - x);
            }
        }
        // Priority 3: If between attack_range and 350 (transition zone) - chase to get closer for melee
        else if (_distance > attack_range && _distance <= 350) {
            // In transition zone - move towards player
            if (_cherryDirection == -1) {
                hsp = lerp(hsp, -_maxspd, _accel);
            } else if (_cherryDirection == 1) {
                hsp = lerp(hsp, _maxspd, _accel);
            }
        }
        // Priority 4: Too far - chase
        else {
            if (_cherryDirection == -1) {
                hsp = lerp(hsp, -_maxspd, _accel);
            } else if (_cherryDirection == 1) {
                hsp = lerp(hsp, _maxspd, _accel);
            }
        }
    } else {
        flip = true;
        // Outside detection range - stop
        hsp = lerp(hsp, 0, 0.1);
        if (!attacking && !shooting) face = sign(Ocherry.x - x);
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
                hsp = sign(x - damager.x);
                    
                // Cancel BOTH attacks when hit
                attacking = false;
                shooting = false;
                attack_cooldown = attack_cooldown_time;
                    
                ds_list_add(damaged_by_list, damager);
                invincible = true;
                invincible_clear_timer = invincible_clear_time;
            }
            // SPECIAL CASE 2: Ospinning_thorns - damage but no stun/knockback
            else if (obj_name == "Ospinning_thorns") {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(ObloodPar) && !is_fire_attack) {
                        ObloodPar.blood += damager.damage;
                    }
                    image_blend = c_red;
                    
                    ds_list_add(damaged_by_list, damager);
                    invincible_clear_timer = invincible_clear_time;
                }
            }
            // NORMAL CASE: All other damage sources
            else {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(ObloodPar) && !is_fire_attack) {
                        ObloodPar.blood += damager.damage;
                    }
                    hsp = sign(x - damager.x);
                    
                    // Cancel BOTH attacks when hit
                    attacking = false;
                    shooting = false;
                    attack_cooldown = attack_cooldown_time;
                    
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
