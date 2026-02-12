// Movement
move_speed = 40;

// Calculate direction to player (with Y offset)
if (instance_exists(Ocherry)) {
    var target_x = Ocherry.x;
    var target_y = Ocherry.y - 200; // Aim 200 pixels above player
    
    // Calculate base direction toward target
    var base_direction = point_direction(x, y, target_x, target_y);
    
    // Random angle tilt (-2 to +2 degrees)
    var angle_tilt = random_range(-2, 2);
    
    // Final direction with tilt
    direction = base_direction + angle_tilt;
} else {
    // Fallback if player doesn't exist - shoot in facing direction
    var base_direction = Obandit2.face == 1 ? 0 : 180;
    var angle_tilt = random_range(-2, 2);
    direction = base_direction + angle_tilt;
}

// Starting position
start_x = x;
start_y = y;
max_distance = 1000;

//enemies and walls
_obstacle = [Owall, Ocherry];

damage = 5;