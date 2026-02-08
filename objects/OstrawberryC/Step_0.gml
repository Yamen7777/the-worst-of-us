timer--;

if(half)
{
	half = false;
	timer = 75;
}

if(timer <= 0)
{
	audio_sound_pitch(SNpop,random_range(0.6,0.9));
	audio_play_sound(SNpop,5,false);
	// Store properties before switching
        var _x = floor(x);
        var _y = floor(y);
        var _xscale = image_xscale;
        var _yscale = image_yscale;

        // Create the new block at the same position
        var inst = instance_create_layer(_x,_y,layer,Ostrawberry);
        inst.image_xscale = _xscale;
        inst.image_yscale = _yscale;

        // Destroy the old object
        instance_destroy();
}
