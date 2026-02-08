if (!has_stuck && can_stick) {
    // Check if touching any solid object (or specific object types)
    var touching_object = instance_place(x, y, all); // You can replace 'all' with specific object types
    
    if (touching_object != noone && touching_object != self && touching_object.object_index != Ocherry) {
        // Stick to this object
        stuck_to = touching_object;
        offset_x = x - touching_object.x;
        offset_y = y - touching_object.y;
        has_stuck = true;
        
        // Stop any movement
        hsp = 0;
        vsp = 0;
    }
}

// If stuck to an object, follow it
if (stuck_to != noone && instance_exists(stuck_to)) {
    x = stuck_to.x + offset_x;
    y = stuck_to.y + offset_y;
} else if (stuck_to != noone) {
    // The object we were stuck to no longer exists
    stuck_to = noone;
    has_stuck = false;
}