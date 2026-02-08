// Move using the calculated velocities
x += move_x;
y += move_y;

// Check if traveled max distance
if (point_distance(start_x, start_y, x, y) >= max_distance) {
    instance_destroy();
}

// Destroy if hit wall
if (place_meeting(x, y, Owall)) {
    instance_destroy();
}