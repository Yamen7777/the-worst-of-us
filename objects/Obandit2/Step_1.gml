 if (hp <= 0)
{
	repeat (5)
	{
		with(instance_create_layer(x,y,layer,Odust))
		{
			image_blend = c_red;
		}
	}
	killCounter(2);
	audio_stop_sound(SNzobmie);
	with (instance_create_layer(x,y,layer,Obandit2D))
	{
		image_yscale = other.size;
		image_xscale = other.image_xscale;
	}
	instance_destroy();
}