// Always track Ocherry's current position
if (instance_exists(Ocherry)) {
    target_x = Oyokai.x;
    target_y = Oyokai.y-150;
}

// Move towards the target
var dir = point_direction(x, y, target_x, target_y);
var dist = point_distance(x, y, target_x, target_y);

if (dist > return_speed) {
    x += lengthdir_x(return_speed, dir);
    y += lengthdir_y(return_speed, dir);
    
    // Rotate to face the target direction
    image_angle = dir;
    
    // Flip sprite if facing left (optional, depends on your sprite orientation)
    if (dir > 90 && dir < 270) {
        image_yscale = -abs(image_yscale); // Flip vertically when facing left
    } else {
        image_yscale = abs(image_yscale);
    }
} else {
	Oyokai.blue_spirit += 1;
    instance_destroy();
}