// damage sources
for (var i = 0; i < array_length(damage_objects); i++) {
    var obj_type = damage_objects[i];
    
    if (instance_exists(obj_type)) {
        var damager = instance_place(x, y, obj_type);
        if (damager != noone) {
            if (ds_list_find_index(damaged_by_list, damager) == -1) {
                ds_list_add(damaged_by_list, damager);
                invincible = true;
                invincible_clear_timer = invincible_clear_time;
				
                hit = true;
				
                // Check if this is a fire-based attack (these DON'T give blood - they cost blood to use)
                var obj_name = object_get_name(obj_type);
                var is_fire_attack = (obj_name == "Ofireball" || obj_name == "OfireBreath" || 
                                      obj_name == "OfireExplode" || obj_name == "OfireSlash" ||
                                      obj_name == "Oblue_fire" || obj_name == "Oblue_explode");
                
                if (instance_exists(Owerewolf) && !Owerewolf.transform && !is_fire_attack)
                    ObloodPar.blood += damager.damage;
				
                hp -= damager.damage;
				
                // Start hit animation
                hit_animating = true;
                image_index = 0;
                image_speed = 1;
            }
            else hit = false;
        }
    }
}

//destroy if blue fire charge
if(place_meeting(x,y,Oblue_fire)) Oblue_fire.destroy = true; 

// Clear the damaged list after timer expires
if (invincible_clear_timer > 0) {
    invincible_clear_timer--;
    if (invincible_clear_timer <= 0) {
        ds_list_clear(damaged_by_list);
    }
}

// Hit animation control
if (hit_animating) {
    // Check if animation reached frame 3
    if (image_index >= 3) {
        // Freeze back at frame 0
        image_index = 0;
        image_speed = 0;
        hit_animating = false;
        hit = false;
    }
}
