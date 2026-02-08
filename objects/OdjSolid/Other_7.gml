// Check if any Ocherry is dashing
var should_switch = false;
if (instance_exists(Ocherry))
{
	should_switch = true;
}
// Switch between solid and hollow if dashing
if (should_switch) {
    var _x = floor(x);
    var _y = floor(y);
    var _xscale = image_xscale;
    var _yscale = image_yscale;
    var _angle = image_angle;

    // Determine the new object
    var _new_block = (object_index == OdjSolid) ? OdjHollow : OdjSolid;

    // Create the new block at the same position
    var inst = instance_create_layer(_x, _y, layer, _new_block);
    inst.image_xscale = _xscale;
    inst.image_yscale = _yscale;
    inst.image_angle = _angle;

    // Destroy the old object
    instance_destroy();
}
