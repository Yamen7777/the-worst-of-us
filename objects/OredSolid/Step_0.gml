// Check if any Ocherry is dashing
if (instance_exists(Ocherry)) {
	if(Ocherry.Djumping)
	{
		should_switch = true;
	}
}

if(should_switch) 
{
	no_touch = true;
}

// Switch between solid and hollow if dashing
if (no_touch) and (!place_meeting(x,y,Ocherry)) {
    var _x = floor(x);
    var _y = floor(y);
    var _xscale = image_xscale;
    var _yscale = image_yscale;
    var _angle = image_angle;

    // Determine the new object
    var _new_block = (object_index == OredSolid) ? OredHollow : OredSolid;

    // Create the new block at the same position
    var inst = instance_create_layer(_x, _y, layer, _new_block);
    inst.image_xscale = _xscale;
    inst.image_yscale = _yscale;
    inst.image_angle = _angle;

    // Destroy the old object
	no_touch = false;
	should_switch = false;
    instance_destroy();
}