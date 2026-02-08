// Impulse-based push system - applies force only once per collision
var push_impulse = 75; // Single push strength (adjust as needed)
var max_vel = 75; // Maximum velocity cap for player

// Decrease cooldown timer
if (collision_cooldown > 0) {
    collision_cooldown--;
}

// Check for collision with player - using place_meeting for reliable detection
if (place_meeting(x, y, Ocherry)) {
    var player = instance_place(x, y, Ocherry);
    if (player != noone && collision_cooldown <= 0) {
        
        with (player) {
            onground(false);
            
            // Calculate direction from waterball to player
            var dx = x - other.x;
            var dy = y - other.y;
            
            // Prevent division by zero - if same position, push right
            if (dx == 0 && dy == 0) {
                dx = 1;
                dy = 0;
                var dist = 1;
            } else {
                var dist = point_distance(other.x, other.y, x, y);
            }
            
            var nx = dx / dist;
            var ny = dy / dist;
            
            // Apply single impulse push
            hsp += nx * push_impulse;
            vsp += ny * push_impulse;
            
            // Cap velocity to prevent excessive speed
            var current_speed = point_distance(0, 0, hsp, vsp);
            if (current_speed > max_vel) {
                var speed_ratio = max_vel / current_speed;
                hsp *= speed_ratio;
                vsp *= speed_ratio;
            }
        }
        
        // Set cooldown to prevent multiple pushes (adjust frames as needed)
        collision_cooldown = 10;
        
        // Play sound
        audio_sound_pitch(SNbounce, random_range(1.1, 1.3));
        audio_sound_gain(SNbounce, 0.2, 0);
        audio_play_sound(SNbounce, 2, false);
        push = true;
    }
}
else {
    push = false;
}