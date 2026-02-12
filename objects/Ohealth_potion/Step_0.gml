/// Ohealth_potion Step Event

if (!is_settled) {
    // Apply gravity
    vsp += grv;
    
    // Apply friction to horizontal movement
    hsp = lerp(hsp, 0, 0.05);
    
    // Move
    x += hsp;
    y += vsp;
    
    // Ground collision
    if (place_meeting(x, y + vsp, Owall) || place_meeting(x, y + vsp, Ossplat)) {
        // Land on ground
        while (!place_meeting(x, y + 1, Owall) && !place_meeting(x, y + 1, Ossplat)) {
            y += 1;
        }
        
        bounce_count++;
        
        if (bounce_count == 1) {
            // First bounce - small hop
            vsp = -4;
            hsp *= 0.5; // Reduce horizontal speed
        } else if (bounce_count >= max_bounces) {
            // Final landing - settle down
            vsp = 0;
            hsp = 0;
            is_settled = true;
            can_collect = true;
            originY = y; // Store final position for wave
            
            // Particle effect when settled
            repeat(3) {
                with (instance_create_layer(x, y, "Instances", Odust)) {
                    image_blend = c_lime;
                }
            }
        }
    }
    
    // Wall collision
    if (place_meeting(x + hsp, y, Owall)) {
        while (!place_meeting(x + sign(hsp), y, Owall)) {
            x += sign(hsp);
        }
        hsp = -hsp * 1; // Bounce off wall
    }
}
else {
    // Settled - do wave movement
    wave_angle += wave_speed;
    y = originY + sin(wave_angle) * wave_height;
}

// Collection by player
if (can_collect && place_meeting(x, y, Ocherry)) {
    if (instance_exists(Ocherry)) {
        if (is_big) {
            // Big potion - restore to max health
            Ocherry.hp = 100; // Set to max HP
            
            // Visual feedback
            repeat(10) {
                with (instance_create_layer(x, y, "Instances", Odust)) {
                    image_blend = c_lime;
                    hspeed = random_range(-3, 3);
                    vspeed = random_range(-3, 3);
                }
            }
        } else {
            // Small potion - restore 25% of max health
            var heal_amount = 100 * 0.25; // 25% of max HP (100)
            Ocherry.hp = min(Ocherry.hp + heal_amount, 100); // Don't exceed max
            
            // Visual feedback
            repeat(5) {
                with (instance_create_layer(x, y, "Instances", Odust)) {
                    image_blend = c_aqua;
                    hspeed = random_range(-2, 2);
                    vspeed = random_range(-2, 2);
                }
            }
        }
        
        // Destroy potion
        instance_destroy();
    }
}

// Set sprite based on size
if (is_big) {
    sprite_index = Shealth_big;
} else {
    sprite_index = Shealth_small;
}