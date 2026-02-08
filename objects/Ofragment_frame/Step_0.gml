LMB = mouse_check_button_pressed(mb_left);
var mouse_is_over = position_meeting(mouse_x, mouse_y, id);

// Update empty state based on image_index
is_empty = (image_index == 0);

// FILLING SLOTS - frame is NOT empty
if(!global.fuse)
{
	if (mouse_is_over && LMB) and (!is_empty) and (Oslots1.is_empty) and (!Oslots1.emptying) and (!Oslots2.emptying)
	{
		audio_play_sound(Essence_room_slot,4,false);
		audio_play_sound(Essence_room_fling,5,false);
		if !instance_exists(Oselect_effect) with(instance_create_layer(x-35,y-35,"effects",Oselect_effect)) sprite_index = Sselect_effect3;
		if !instance_exists(Oselect_effect2) with(instance_create_layer(Oslots1.x-15,Oslots1.y-15,"effects",Oselect_effect2)) sprite_index = Sselect_effect2;
	    Oslots1.image_index = image_index;
	    Oslots1.fragment_type = image_index;
	    Oslots1.is_empty = false;
	    original_fragment = image_index;
	    image_index = 0;
	    is_empty = true;
	    selecting = true;
		global.slot1 = fragment;
	}
	else if (mouse_is_over && LMB) and (!is_empty) and (!Oslots1.is_empty) and (Oslots2.is_empty) and (Oslots1.image_index != fragment) and (!Oslots1.emptying) and (!Oslots2.emptying)
	{
		audio_play_sound(Essence_room_slot,4,false);
		audio_play_sound(Essence_room_burst,5,false);
		if !instance_exists(Oselect_effect) with(instance_create_layer(x-35,y-35,"effects",Oselect_effect)) sprite_index = Sselect_effect3;
		if !instance_exists(Oselect_effect2) with(instance_create_layer(Oslots2.x-15,Oslots2.y-15,"effects",Oselect_effect2)) sprite_index = Sselect_effect2;
	    Oslots2.image_index = image_index;
	    Oslots2.fragment_type = image_index;
	    Oslots2.is_empty = false;
	    original_fragment = image_index;
	    image_index = 0;
	    is_empty = true;
		global.slot2 = fragment;
	}

	// emptying SLOTS - frame is empty
	else if (mouse_is_over && LMB) and (is_empty) and (!Oslots1.is_empty) and (Oslots1.image_index == fragment) and (!Oslots1.emptying)
	{
		audio_play_sound(Essence_room_slot,4,false);
		audio_play_sound(Essence_room_attract,5,false);
		if !instance_exists(Oselect_effect) with(instance_create_layer(x-35,y-35,"effects",Oselect_effect)) sprite_index = Sselect_effect3;
		if !instance_exists(Oselect_effect2) with(instance_create_layer(Oslots1.x-15,Oslots1.y-15,"effects",Oselect_effect2)) sprite_index = Sselect_effect2;
	    Oslots1.emptying = true;
	}
	else if (mouse_is_over && LMB) and (is_empty) and (!Oslots2.is_empty) and (Oslots2.image_index == fragment) and (!Oslots1.emptying)
	{
		audio_play_sound(Essence_room_slot,4,false);
		if !instance_exists(Oselect_effect) with(instance_create_layer(x-35,y-35,"effects",Oselect_effect)) sprite_index = Sselect_effect3;
		if !instance_exists(Oselect_effect2) with(instance_create_layer(Oslots2.x-15,Oslots2.y-15,"effects",Oselect_effect2)) sprite_index = Sselect_effect2;
	    Oslots2.emptying = true;
	}
}