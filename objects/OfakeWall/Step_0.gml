if(place_meeting(x,y,Ocherry))
{
	sound = true;
	discovored = true;
}

if(discovored)
{
	image_alpha -= 0.1;
	if(image_alpha <= 0)
	{
		discovored = false;
		instance_destroy();
	}
}

with(Ogame)
{
	if(tile = 0)
	{
		other.sprite_index = SgrassBlock_1;
	}
	else if(tile = 1)
	{
		other.sprite_index = Srockblock;
	}
}

if(sound)
{
	if(show_sound == 0)
	{
		if(!audio_is_playing(SNfakewall)) audio_play_sound(SNfakewall,4,false);
	}
	if(show_sound == 1)
	{
		if(!audio_is_playing(SNbreaking)) audio_play_sound(SNbreaking,4,false);
	}
	sound = false;
}
