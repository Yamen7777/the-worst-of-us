if (hp <= 0)
{
	repeat (5)
	{
		with(instance_create_layer(x,y,layer,Odust))
		{
			image_blend = c_red;
		}
	}
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
	
	var _new_dead = instance_create_layer(x,y,layer,OcrystalD);
	_new_dead.image_yscale = other.size;
	_new_dead.image_xscale = other.image_xscale;
	// Create blood effect at half the dead body's height
	var _blood_y = (_new_dead.bbox_top + _new_dead.bbox_bottom) / 2;
	instance_create_layer(x, _blood_y, "effects", Oblood);
	audio_sound_pitch(SNsword, 0.6)
	audio_play_sound(SNkill, 1, false);
	instance_destroy();
}