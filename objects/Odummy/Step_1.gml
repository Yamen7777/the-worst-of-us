if (hp <= 0)
{
	repeat (3) if(instance_exists(Oyokai)) instance_create_layer(x,y-100,layer,Oblue_spirit);
	repeat (5)
	{
		with(instance_create_layer(x,y,layer,Odust))
		{
			image_blend = c_yellow;
		}
	}
	killCounter(2);
	instance_destroy();
}