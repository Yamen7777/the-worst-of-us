/// @desc HitStop(duration, target, x, y)
/// @arg duration Number of frames to freeze (default: 3)
/// @arg target 0 = player, 1 = enemy, 2 = both
/// @arg x Collision x position (optional)
/// @arg y Collision y position (optional)
function HitStop(_duration = 3, _target = 2, _x = undefined, _y = undefined) {
    // Target 0: player only
    // Target 1: enemy only  
    // Target 2: both player and enemy
    
    if (_target == 0 || _target == 2) {
        // Freeze player
        if (instance_exists(Ocherry)) {
            Ocherry.hitstop_timer = _duration;
        }
        // Freeze slash
        with (Oslash) {
            hitstop_timer = _duration;
        }
    }
    
    if (_target == 1 || _target == 2) {
        // Freeze this enemy (Ojack)
        hitstop_timer = _duration;
        
        // Spawn particles at collision point
        var _spawn_x = is_undefined(_x) ? x : _x;
        var _spawn_y = is_undefined(_y) ? y : _y;
        
        repeat(3) {
            with(instance_create_layer(_spawn_x, _spawn_y, layer, Odust)) {
                image_blend = c_blue;
            }
        }
    }
    
    // Play hit sound
    audio_play_sound(SNkill, 10, false);
}
