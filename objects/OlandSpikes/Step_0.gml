if(place_meeting(x,y,Ocherry))
{
	timer = true;
}

if(timer)
{
	time--;
}

if(time = 0)
{
	time = 20;
	audio_play_sound(SNspike,3,false);
    var _x = floor(x);
    var _y = floor(y);
    var _xscale = image_xscale;
    var _yscale = image_yscale;
    var _angle = image_angle; // Store the rotation

    // Determine the new object
    var _new_block = Ospikes;

    // Create the new block at the same position, on the same layer
    var inst = instance_create_layer(_x, _y, layer, _new_block);
    inst.image_xscale = _xscale;
    inst.image_yscale = _yscale;
    inst.image_angle = _angle; // Apply the rotation
    with(inst) depth = 2; // Match the depth of the old land spike
    // Destroy the old object
    instance_destroy();
}
