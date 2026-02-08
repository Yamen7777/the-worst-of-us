timer--;
if(timer <= 0)
{
// Store properties before switching
        var _x = floor(x);
        var _y = floor(y);
        var _xscale = image_xscale;
        var _yscale = image_yscale;

        // Create the new block at the same position
        var inst = instance_create_layer(_x,_y,layer,OfallingPlat);
        inst.image_xscale = _xscale;
        inst.image_yscale = _yscale;

        // Destroy the old object
        instance_destroy();
}
