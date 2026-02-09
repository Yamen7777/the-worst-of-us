// Move in the tilted direction
x += lengthdir_x(move_speed, direction);
y += lengthdir_y(move_speed, direction);

// Check if traveled max distance from start
if (point_distance(start_x, start_y, x, y) >= max_distance) {
    instance_destroy();
}

// Check collision with wall
if (place_meeting(x, y, Owall)) {
    instance_destroy();
}

if(!Ocherry.fire_mode) sprite_index = Sspinning_blade;
if( Ocherry.fire_mode) sprite_index = Sspinning_fire;