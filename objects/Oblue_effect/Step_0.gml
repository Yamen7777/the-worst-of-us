if(sprite_index == Sblue_effect1) and (image_index == 5) with (instance_create_layer(x,y,"bullets",Oblue_fire))
{
	image_xscale = Oyokai.face;
	sprite_index = Sblue_fire1;
}
if(sprite_index == Sblue_effect2) and (image_index == 5) with (instance_create_layer(x,y,"bullets",Oblue_fire))
{
	image_xscale = Oyokai.face;
	sprite_index = Sblue_fire1;
}
if(sprite_index == Sblue_effect3) and (image_index == 8) with (instance_create_layer(x,y,"bullets",Oblue_fire))
{
	image_xscale = Oyokai.face;
	sprite_index = Sblue_fire2;
}

//hold attack
if(sprite_index == Sblue_effect4) and (image_index == 1) with (instance_create_layer(x,y,"bullets",Oblue_fire))
{
	sprite_index = Sblue_fire3;
	charge = other.charge;
	image_xscale = charge * Oyokai.face;
	image_yscale = charge;
}

//super attack
if(sprite_index == Sblue_effect5) and (image_index == 1) with (instance_create_layer(x,y,"bullets",Oblue_fire))
{
	blue_sprit = other.blue_spirit;
	sprite_index = Sblue_fire4;
	image_xscale = Oyokai.face;
}
	