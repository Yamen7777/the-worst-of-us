if(image_index == 2) 
{
	//fire mode
	if(Ocherry.fire_range) var _sprite = Sspinning_fire;
	else var _sprite = Sspinning_blade;
	
	if(Ocherry.hold_attack)
	{
		// Create large spinning blade ONLY if range upgrade is 1 or higher
		if (Ocherry.upgrade_range >= 1) {
			with(instance_create_layer(Ocherry.x + 75, Ocherry.y - 175, "bullets", Ospinning_blade)) 
			{
				sprite_index = _sprite;
				// Calculate damage based on range upgrade
				// Scales: 3.2, 4.4, 5.6, 6.8, 8 (doubled for hold)
                damage = (2 + (Ocherry.upgrade_range * 1.2)) * 2;
                
				// Calculate max distance based on range upgrade
				// Range scales from 400 (level 1) to 2000 (level 5)
				max_distance = 400 * Ocherry.upgrade_range; // 400, 800, 1200, 1600, 2000
                
				image_xscale = 2; // doule size
				image_yscale = 2; // double size
			}
		}
	}
	else
	{
		// Create spinning blade ONLY if range upgrade is 1 or higher
		if (Ocherry.upgrade_range >= 1) {
			with(instance_create_layer(Ocherry.x + 75, Ocherry.y - 175, "bullets", Ospinning_blade)) 
			{
				sprite_index = _sprite;
				// Calculate damage based on range upgrade
				// Scales: 3.2 -> 4.4 -> 5.6 -> 6.8 -> 8
                damage = 2 + (Ocherry.upgrade_range * 1.2);
                
				// Calculate max distance based on range upgrade
				// Range scales from 400 (level 1) to 2000 (level 5)
				max_distance = 400 * Ocherry.upgrade_range; // 400, 800, 1200, 1600, 2000
			}
		}
	}
}


