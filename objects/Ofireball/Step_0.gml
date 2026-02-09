// Move in the tilted direction
x += lengthdir_x(move_speed, direction);
y += lengthdir_y(move_speed, direction);
    
// Check if traveled max distance from start
if (point_distance(start_x, start_y, x, y) >= max_distance) {
    with(instance_create_layer(x + (230*image_xscale), y, layer, OfireExplode)) {
		audio_sound_pitch(SNexplotion1,random_range(0.9,1.1));
		audio_play_sound(SNexplotion1, 3, false);
    }
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
        
    if (!hit_dodging) {
        should_explode = true;
    }
}

if (should_explode) {
    explode = true;
    if(explode) {
        explode_time--;
        if(explode_time <= 0) {
            with(instance_create_layer(x + (230*image_xscale), y, layer, OfireExplode)) {
                damage = 3;
				audio_sound_pitch(SNexplotion1,random_range(0.9,1.1));
				audio_play_sound(SNexplotion1, 3, false);
            }
            instance_destroy();
            explode_time = explode_timer;
            explode = false;
        }
    }
}