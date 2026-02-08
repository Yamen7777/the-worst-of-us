
// Define collision check data: [offset_x, offset_y, valid_directions]
var collision_checks = [
    [-2, 0, [0, 45, 315]],     // Left side
    [2, 0, [180, 135, 225]],   // Right side  
    [0, -3, [270, 225, 315]],  // Up side
    [0, 2, [90, 45, 135]]      // Down side
];

// Check each direction
for (var i = 0; i < array_length(collision_checks); i++) {
    var check = collision_checks[i];
    var offset_x = check[0];
    var offset_y = check[1];
    var valid_directions = check[2];
    
    if (place_meeting(x + offset_x, y + offset_y, Ocherry)) {
        with (Ocherry) {
            // Check if dashing in valid direction
            var is_valid_direction = false;
            for (var j = 0; j < array_length(valid_directions); j++) {
                if (dashDirection == valid_directions[j]) {
                    is_valid_direction = true;
                    break;
                }
            }
            
            if (dashing && is_valid_direction) {
                // Create dust particles
                repeat (5) {
                    with (instance_create_layer(x, y, "powerups", Odust)) {
                        hsp = (offset_y == 0) ? 0 : hsp; // Set hsp to 0 for horizontal collisions
                        vsp = (offset_x == 0) ? 0 : vsp; // Set vsp to 0 for vertical collisions
                    }
                }
                
                timer = true;
                
                // Find and destroy the specific bubble block that was hit
                var target = instance_place(other.x + offset_x, other.y + offset_y, ObubbleBlock);
                if (target != noone) {
                    with (target) {
                        if (!pop) {
                            audio_sound_pitch(SNpoping, random_range(0.9, 0.6));
                            audio_play_sound(SNpoping, 4, false);
                            pop = true;
                        }
                        instance_destroy();
                    }
                }
            }
        }
    }
}