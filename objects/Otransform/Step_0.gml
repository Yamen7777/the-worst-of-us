// Check collision with Ojack
if (place_meeting(x, y, Ojack)) {
    with (Ojack) {
        // Calculate push direction (away from explosion)
        var push_dir = point_direction(other.x, other.y, x, y);
        
        // Set push force (adjust these values to your liking)
        var push_force = 5; // Horizontal push strength
        
        // Apply push to Ojack's velocity
        hsp += lengthdir_x(push_force, push_dir);
    }
}