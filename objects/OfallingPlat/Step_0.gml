if (instance_exists(Ocherry)) {
    // If the player is touching the platform and animation hasn't started yet
    if( (place_meeting(x, y - 10, Ocherry)) 
	 or (place_meeting(x + 10, y, Ocherry)) 
	 or (place_meeting(x - 10, y, Ocherry)) )
	and (!animation_started) {
		audio_sound_pitch(SNbreaking,random_range(0.6,0.8));
		audio_play_sound(SNbreaking,4,false);
        animation_started = true; // Start the animation
    }
}

// If the animation has started, update the image index
if (animation_started) {
    // Check if animation is completed (reached the last frame)
    if (image_index == image_number - 1) {  // If the animation has reached the last frame
		// Store properties before switching
        var _x = floor(x);
        var _y = floor(y);
        var _xscale = image_xscale;
        var _yscale = image_yscale;

        // Create the new block at the same position
        var inst = instance_create_layer(_x,_y,layer,OfallingHollow);
        inst.image_xscale = _xscale;
        inst.image_yscale = _yscale;

        // Destroy the old object
        instance_destroy();
    }
} else {
    // If the player is not touching, stay at the first frame
    image_index = 0; // Keep on the first frame
}
