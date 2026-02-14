 if (hp <= 0)
{
	repeat (5)
	{
		with(instance_create_layer(x,y,"powerups",Odust))
		{
			image_blend = c_red;
		}
	}
	killCounter(5);
	audio_stop_sound(SNzobmie);
	instance_create_layer(x,y-100,"powerups",Obanana)
	// Add bonus level to room tracker if this enemy gives bonus levels
	if (level_upgrade > 0 && instance_exists(Ogame)) {
		Ogame.room_bonus_levels += level_upgrade;
		show_debug_message("Enemy gives " + string(level_upgrade) + " bonus level(s). Total bonus: " + string(Ogame.room_bonus_levels));
	}
	
	with (instance_create_layer(x,y-50,layer,OwillsonD))
	{
		direction = other.hitfrom;
		hsp =lengthdir_x(3,direction);
		vsp =lengthdir_y(3,direction)-2;
		if (sign(hsp) != 0) image_xscale = sign(hsp) * other.size;
		image_yscale = other.size;
	}
	instance_destroy();
}