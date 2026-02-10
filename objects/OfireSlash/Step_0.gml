// Move in the tilted direction
x += lengthdir_x(move_speed, direction);
y += lengthdir_y(move_speed, direction);
    
// Check if traveled max distance from start
if (point_distance(start_x, start_y, x, y) >= max_distance) {
    instance_destroy();
}
    
// Check collision with wall - IGNORE enemies that are dodging
var should_explode = false;
if (place_meeting(x, y, _obstacle)) {
    // Check if we hit a dodging enemy
    var hit_dodging = false;
    with (Ojack) {
        if (place_meeting(x, y, other) && variable_instance_exists(id, "dodge_invincible") && dodge_invincible) {
            hit_dodging = true;
        }
    }
}

//fire mode
if(Ocherry.fire_spells) sprite_index = SfireSlash2;
else sprite_index = SfireSlash1;