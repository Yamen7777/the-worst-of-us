if(target == "restart")
{
	TRANS(TRANS_MODE.RESTART,"strawberry");
}
else{
with (Ocherry) {
	    if (hasControl) {
	        hasControl = false;

	        // Permanent save of collected flowers
	        with (Ogame) {
	            for (var i = 0; i < ds_list_size(global.temp_flowers); i++) {
	                var fid = ds_list_find_value(global.temp_flowers, i);
	                if (!ds_map_exists(global.collected_flowers, fid)) {
	                    ds_map_add(global.collected_flowers, fid, true);
	                }
	            }
	        }

	        // Pass next room's spawn position
	        global.spawn_x = other.spawn_x;
	        global.spawn_y = other.spawn_y;

	        if(OLevelEND.transition == 0)
	        {
	            TRANS(TRANS_MODE.GOTO,"strawberry", other.target);
	        }
	            if (OLevelEND.transition == 1)
	        {
	            TRANS(TRANS_MODE.GOTO,"strawberry", other.target);
	        }
	            if (OLevelEND.transition == 2)
	        {
	            TRANS(TRANS_MODE.GOTO,"thunder", other.target);
	        }
	    }
	}
}