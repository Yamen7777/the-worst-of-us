//Check if any Ocherry is double jumping
if (instance_exists(Ocherry))
{
	if(place_meeting(x,y,Ocherry))
	{
	    with (Ocherry) {
	        if (Jcount >= 2)
			{
	            other.should_switch = true;
	        }
	    }
	}
}

// Switch between solid and hollow if dashing
if (should_switch) and (!place_meeting(x,y,Ocherry))
{
    var _x = floor(x);
    var _y = floor(y);
    var _xscale = image_xscale;
    var _yscale = image_yscale;
    var _angle = image_angle;

    // Determine the new object
    var _new_block = (object_index == OdjSolid) ? OdjHollow : OdjSolid;

    // Create the new block at the same position
    var inst = instance_create_layer(_x, _y, layer, _new_block);
    inst.image_xscale = _xscale;
    inst.image_yscale = _yscale;
    inst.image_angle = _angle;
	
	//sound and particals
	audio_sound_pitch(SNstopping,random_range(1.2,1.4));
	audio_play_sound(SNstopping,4,false);
	repeat (20)
	{
		instance_create_layer(Ocherry.x,Ocherry.y,"powerups",Odust)
	}

    // Destroy the old object
	should_switch = false;
    instance_destroy();
}
