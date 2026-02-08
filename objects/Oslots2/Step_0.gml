LMB = mouse_check_button_pressed(mb_left);
var mouse_is_over = position_meeting(mouse_x, mouse_y, id);

// Update empty state
is_empty = (image_index == 0);

if(!global.fusing) and (room == Ressance)
{
	if (mouse_is_over && LMB && !is_empty) or (emptying)
	{
		audio_play_sound(Essence_room_slot,5,false);
		if !instance_exists(Oselect_effect2) with(instance_create_layer(x-15,y-15,"effects",Oselect_effect2)) sprite_index = Sselect_effect2;
		emptying = false;
	    // Find the frame that originally had this fragment
	    with (Ofragment_frame)
	    {
	        if (original_fragment == other.fragment_type && is_empty)
	        {
	            // Give fragment back to the frame
	            image_index = original_fragment;
	            is_empty = false;
	            other.image_index = 0;
	            other.fragment_type = 0;
	            other.is_empty = true;
				global.slot2 = 0;
	            exit;
	        }
	    }
	}
}
else if(!effect) and (room == Ressance) and (!global.fusing)
{
	effect = true;
	with(instance_create_layer(x,y,"player",Oselect_effect2)) sprite_index = Sselect_effect1;
}