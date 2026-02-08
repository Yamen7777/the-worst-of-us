 if (hp <= 0)
{
	repeat (8)
	{
		with(instance_create_layer(x,y,"powerups",Odust))
		{
			image_blend = c_red;
		}
	}
	killCounter(7);
	instance_destroy(Oshuild)
	audio_sound_pitch(SNkill,random_range(0.6,0.9));
	audio_play_sound(SNkill,5,false);
	instance_create_layer(x,y-100,"powerups",Obanana)
	with (instance_create_layer(x,y,layer,OjaisonD))
	{
		direction = other.hitfrom;
		hsp =lengthdir_x(3,direction);
		vsp =lengthdir_y(3,direction)-2;
		if (sign(hsp) != 0) image_xscale = sign(hsp) * other.size;
		image_yscale = other.size;
	}
	instance_destroy();
}