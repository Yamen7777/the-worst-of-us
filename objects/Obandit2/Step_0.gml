//Obandit 2 step
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
if (!attacking && attack_cooldown == 0) {
    // Check if player is in attack range
    if (instance_exists(Ocherry)) {
        var _distance = point_distance(x, y, Ocherry.x, Ocherry.y);
        
        if (_distance <= attack_range) {
            // FACE THE PLAYER BEFORE SHOOTING
            var _dir_to_player = sign(Ocherry.x - x);
            if (_dir_to_player != 0) {
                face = _dir_to_player;
            }
            
            // Start attack
            attacking = true;
            sprite_index = Sbandit2S;
            image_index = 0;
            attack_created = [false, false]; // Reset attack tracking
        }
    }
}

//attack animation
if (attacking) {
    hsp = 0;
    
    // KEEP FACING THE PLAYER DURING ATTACK
    if (instance_exists(Ocherry)) {
        var _dir_to_player = sign(Ocherry.x - x);
        if (_dir_to_player != 0) {
            face = _dir_to_player;
            image_xscale = face * size;
        }
    }
    
    // First attack - at frame 6
    if (image_index >= 6 && !attack_created[0]) {
        attack_created[0] = true;
        
        // Create first attack hitbox
        var _attackX = x + (face * 165);
        with (instance_create_layer(_attackX, y - 200, "bullets", Obandit_bullet)) {
            damage = other.current_damage; // Use calculated damage
            image_xscale = other.face;
			max_distance = 2000;
        }
    }
    
    // Check if animation finished
    if (image_index >= image_number - 1) {
        attacking = false;
        attack_cooldown = attack_cooldown_time;
    }
}

//animation
if (!place_meeting(x, y + 1, wall)) {
    grounded = false;
    
    // Don't change sprite if attacking or being hit
    if (!attacking && !invincible) {
        sprite_index = Sbandit2;
        image_speed = 0;
        if (sign(vsp) > 0) image_index = 1; else image_index = 0;
    }
} else {
    grounded = true;
    
    // Don't change sprite if attacking or being hit
    if (!attacking && !invincible) {
        image_speed = 1;
        if (hsp == 0) {
            sprite_index = Sbandit2;
        } else {
            sprite_index = Sbandit2W;
        }
    }
}

// Sprite direction
if (hsp != 0 && !attacking) image_xscale = face * size;
image_yscale = size;

// Damage visual effect - handle AFTER animation logic
if (invincible) {
    invincible_timer--;
    image_alpha = 0.9;
    sprite_index = Sbandit2H;
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

// Circle detection and follow Ocherry
if (instance_exists(Ocherry) && !invincible){
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
            hsp = 0
			face = sign(Ocherry.x - x);
        }
    } else {
        flip = true;
        // Outside detection range - stop
        hsp = lerp(hsp, 0, 0.1);
		face = sign(Ocherry.x - x);
    }
}

//damage sources
for (var i = 0; i < array_length(damage_objects); i++) {
    var obj_type = damage_objects[i];
    
    if (instance_exists(obj_type)) {
        var damager = instance_place(x, y, obj_type);
        
        if (damager != noone) {
            // SPECIAL CASE 1: OfireBreath - damage every frame, no invincibility
            if (object_get_name(obj_type) == "OfireBreath") {
                hp -= damager.damage;
                if (instance_exists(ObloodPar)) {
                    ObloodPar.blood += damager.damage;
                }
                // Visual feedback but no stun
                 hsp = sign(x - damager.x); // Knockback
                    
                // Cancel attack when hit
                attacking = false;
                attack_cooldown = attack_cooldown_time;
                    
                ds_list_add(damaged_by_list, damager);
                invincible = true;
                invincible_clear_timer = invincible_clear_time;
            }
            // SPECIAL CASE 2: Ospinning_thorns - damage but no stun/knockback
            else if (object_get_name(obj_type) == "Ospinning_thorns") {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(ObloodPar)) {
                        ObloodPar.blood += damager.damage;
                    }
                    // Visual feedback only - red flash
                    image_blend = c_red;
                    
                    // Add to damaged list so it only hits once per thorn
                    ds_list_add(damaged_by_list, damager);
                    invincible_clear_timer = invincible_clear_time;
                    
                    // NO invincibility, NO knockback, NO sprite change, NO attack cancel
                }
            }
            // NORMAL CASE: All other damage sources
            else {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(ObloodPar)) {
                        ObloodPar.blood += damager.damage;
                    }
                    hsp = sign(x - damager.x); // Knockback
                    
                    // Cancel attack when hit
                    attacking = false;
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

// Attack cooldown
if (attack_cooldown > 0) {
    attack_cooldown--;
}

// TEST: Press K to increase blood
if (keyboard_check_pressed(ord("J"))) {
    hp = 1000;
}


