/// @desc HitStop(duration, target, x, y)
/// @arg duration Number of frames to freeze (default: 3)
function HitStop(_duration) {
    global.delta_time_scale = 0;
    global.hitstop_timer = _duration;
    
    // Spawn particles
    repeat(3) {
        with(instance_create_layer(x, y, layer, Odust)) {
            image_blend = c_blue;
        }
    }
	
	screenShake(5,10);
    
    // Play hit sound
    audio_play_sound(SNkill, 5, false);
}
