if (done == 0)
{
	vsp = vsp + grv;

	//horizontal collision
	if (place_meeting(x+hsp,y,Owall))
	{
		while (!place_meeting(x+sign(hsp),y,Owall))
		{
			x = x + sign(hsp*2)
		}
		hsp = 0;
	}
	x = x+hsp;

	//vertica collision  
	if (place_meeting(x,y+vsp,Owall))
	{
		if (vsp > 0)
		{
			done = 1;
			image_index = 1;
		}
		while (!place_meeting(x,y+sign(vsp),Owall))
		{
			y = y + sign(vsp);
		}
		vsp = 0;
	}
	y = y + vsp;
}

image_alpha = lerp(image_alpha,0,0.005);
if(image_alpha <= 0.01) instance_destroy();