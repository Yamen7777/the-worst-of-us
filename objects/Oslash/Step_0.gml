if(image_index == 2) 
{
	if(Ocherry.hold_attack)
	{
		// Create large spinning blade ONLY if range upgrade is 1 or higher
		if (Ocherry.upgrade_range >= 1) {
			with(instance_create_layer(Ocherry.x + 75, Ocherry.y - 175, "bullets", Ospinning_blade)) 
			{
				// Calculate damage based on range upgrade
				// Base damage 2 + (upgrade_range * 2)
				damage = 2 + (Ocherry.upgrade_range * 2) * 1.5;
                
				// Calculate max distance based on range upgrade
				// Range scales from 400 (level 1) to 2000 (level 5)
				max_distance = 400 * Ocherry.upgrade_range; // 400, 800, 1200, 1600, 2000
                
				image_xscale = 1.5; // 1.5x size
				image_yscale = 1.5; // 1.5x size
			}
		}
	}
	else
	{
		// Create spinning blade ONLY if range upgrade is 1 or higher
		if (Ocherry.upgrade_range >= 1) {
			with(instance_create_layer(Ocherry.x + 75, Ocherry.y - 175, "bullets", Ospinning_blade)) 
			{
				// Calculate damage based on range upgrade
				// Base damage 2 + (upgrade_range * 2)
				damage = 2 + (Ocherry.upgrade_range * 2);
                
				// Calculate max distance based on range upgrade
				// Range scales from 400 (level 1) to 2000 (level 5)
				max_distance = 400 * Ocherry.upgrade_range; // 400, 800, 1200, 1600, 2000
			}
		}
	}
}


