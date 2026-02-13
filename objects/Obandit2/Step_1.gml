if (hp <= 0)
{
	repeat (5)
	{
		with(instance_create_layer(x,y,layer,Odust))
		{
			image_blend = c_red;
		}
	}
	killCounter(2);
	audio_stop_sound(SNzobmie);
	
	// HEALTH POTION DROP SYSTEM
	var drop_chance = 0; // Default no drop
	
	if (potion == 1) {
	    drop_chance = 20; // 10% chance
	} else if (potion == 2) {
	    drop_chance = 100; // 100% chance, small potion
	} else if (potion == 3) {
	    drop_chance = 100; // 100% chance, big potion
	}
	
	// Roll for drop
	if (random(100) < drop_chance) {
	    var potion_inst = instance_create_layer(x, y-150, layer, Ohealth_potion);
	    
	    // Set potion size based on potion variable
	    if (potion == 3) {
	        potion_inst.is_big = true; // Force big potion
	    } else if (potion == 2) {
	        potion_inst.is_big = false; // Force small potion
	    } else {
	        // Normal drop (10% big, 90% small)
	        potion_inst.is_big = (random(100) < 20);
	    }
	    
	    // Set initial upward velocity
	    potion_inst.hsp = random_range(-5, 5);
	    potion_inst.vsp = -8; // Upward launch
	}
	
	with (instance_create_layer(x,y,layer,Obandit2D))
	{
		image_yscale = other.size;
		image_xscale = other.image_xscale;
	}
	instance_destroy();
}