//Ojack step
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
if(place_meeting(x,y-1,wall)) y -= 3;

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
            sprite_index = Szombie4AT;
            image_index = 0;
            attack_created = [false, false]; // Reset attack tracking
        }
    }
}

//attack animation
if (attacking) {
	hsp = 0;
    // First attack - at frame 0 (immediately)
    if (image_index >= 7 && !attack_created[0]) {
        attack_created[0] = true;
        
        // Create first attack hitbox
        var _attackX = x + (face * 175); // Adjust offset as needed
        with (instance_create_layer(_attackX, y - 200, "bullets", OZ1attack)) {
			damage = 15;
            image_xscale = other.face;
			image_angle += 35*other.face;
			image_yscale = -1;
        }
    }
    
    // Check if animation finished (reached frame 5)
    if (image_index >= 9) { // Frame 4 is the last frame
        attacking = false;
        attack_cooldown = attack_cooldown_time;
    }
}

//animation
if (!place_meeting(x, y + 1, wall)) {
    grounded = false;
    
    // Don't change sprite if attacking or being hit
    if (!attacking && !invincible) {
        sprite_index = Szombie4;
        image_speed = 0;
        if (sign(vsp) > 0) image_index = 1; else image_index = 0;
    }
} else {
    grounded = true;
    
    // Don't change sprite if attacking or being hit
    if (!attacking && !invincible) {
        image_speed = 1;
        if (hsp == 0) {
            sprite_index = Szombie4;
        } else {
            sprite_index = Szombie4W;
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
    sprite_index = Szombie4HT;
    image_speed = 1; // Make sure animation plays
    
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

// Circle detection and follow Ocherry
if (instance_exists(Ocherry) && !invincible) {
    var _cherry = Ocherry;
    var _detectionRadius = 2500;
    var _distance = point_distance(x, y, _cherry.x, _cherry.y);
    
    var _maxspd = 13;
    var _accel = 0.1;
    
    // Check if Ocherry is within detection range
    if (_distance <= _detectionRadius) {
        audio_sound_pitch(SNzobmie, 1);
        if (!audio_is_playing(SNzobmie) && hp > 0) audio_play_sound(SNzobmie, 3, true);
        flip = false;
        
        // Calculate horizontal distance to Ocherry
        var _dx = _cherry.x - x;
        var _horizontal_distance = abs(_dx);
        var _cherryDirection = sign(_dx);
        
        // Always face Ocherry
        if (_cherryDirection != 0) {
            face = _cherryDirection;
        }
        
        // Movement logic - stop at stop_distance (150), but can still attack from attack_range
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
        // SPECIAL CASE: Oblade_back - check ALL colliding instances
        if (object_get_name(obj_type) == "Oblade_back") {
            with (obj_type) {
                if (place_meeting(x, y, other)) {
                    if (ds_list_find_index(other.damaged_by_list, id) == -1) {
                        other.hp -= damage;
                        if (instance_exists(Owerewolf) && !Owerewolf.transform) {
                            ObloodPar.blood += damage;
                        }
                        other.hsp = sign(other.x - x) * 10;
                        
                        // Cancel attack when hit
                        other.attacking = false;
                        other.attack_cooldown = other.attack_cooldown_time;
                        
                        ds_list_add(other.damaged_by_list, id);
                        other.invincible = true;
                        other.invincible_clear_timer = other.invincible_clear_time;
                    }
                }
            }
        }
        // NORMAL CASE: Other damage sources
        else {
            var damager = instance_place(x, y, obj_type);
            if (damager != noone) {
                if (ds_list_find_index(damaged_by_list, damager) == -1) {
                    hp -= damager.damage;
                    if (instance_exists(Owerewolf) && !Owerewolf.transform) {
                        ObloodPar.blood += damager.damage;
                    }
                    hsp = sign(x - damager.x) * 10;
                    
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



