// Update movement from player
if(instance_exists(Ocherry)) hsp = Ocherry.hsp * global.delta_time_scale;
if(instance_exists(Ocherry)) vsp = Ocherry.vsp * global.delta_time_scale;
image_speed = 1 * global.delta_time_scale;

// Check if hitting Ojack or children (only trigger hitstop once per attack)
var _enemy = instance_place(x, y, Ojack);
if (_enemy != noone && !hitstop_triggered) {
    hitstop_triggered = true;
    
    // Oninjay dodges heavy attacks - skip impact, hitstop, and push
    var _is_dodge = (_enemy.object_index == Oninjay && heavy);
    
    if (!_is_dodge) {
        // Create impact effect at collision point (clamp slash origin to enemy bbox)
        var _impact_face = image_xscale;
        var _impact_x = clamp(x, _enemy.bbox_left, _enemy.bbox_right);
        var _impact_y = (_enemy.bbox_top + _enemy.bbox_bottom) / 2;
        with (instance_create_layer(_impact_x, _impact_y, "effects", Oimpact)) {
            image_xscale = _impact_face;
        }
        if (heavy) {
            HitStop(13);
        } else {
            HitStop(9);
        }
        // Push enemy based on attack type
        with (_enemy) {
            if (other.light_variant == 4) {
                hsp = Ocherry.face * 25;
            } else if (other.heavy && other.heavy_variant == 2) {
                hsp = Ocherry.face * 40;
            }
            if (variable_instance_exists(self, "push_state")) {
                push_state = true;
                push_state_timer = push_state_time;
            }
        }
    }
}

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
 
x += hsp;
y += vsp;
