if (!switch_done) and (Ocherry.dashing) {  // Prevents infinite switching
    var _x = floor(x);
    var _y = floor(y);
    var _xscale = image_xscale;
    var _yscale = image_yscale;

    var _new_block;
        _new_block = OwaterBallH;

    var inst = instance_create_layer(_x, _y, "wall", _new_block);
    inst.image_xscale = _xscale;
    inst.image_yscale = _yscale;
    inst.image_index = image_index; // Preserve animation frame
    inst.image_speed = image_speed; // Preserve animation speed

    switch_done = true;
    instance_destroy();
}
