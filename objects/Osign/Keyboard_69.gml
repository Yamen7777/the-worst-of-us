if (instance_exists(Ocherry)) && (point_in_circle(Ocherry.x,Ocherry.y,x,y,75)) && (!instance_exists(Otext))
{
	with (instance_create_layer(x,y-64,layer,Otext))
	{
		audio_play_sound(Snsign,8,false);
		audio_play_sound(Sntext,10,true);
		text = other.text;
		length = string_length(text);
	
	}
	
	with	(Ocamera)
	{
		follow = other.id;
	}
}
