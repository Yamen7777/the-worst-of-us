///@desc screenShake(magnitude,frames)
///@arg magnitude sets the length of the shake (radiues in pixels)
///@sarg frames sets the lenght of the shake in frames (60 = 1 seconds at 60 fps)

function screenShake(shake_magnitude,shake_length){
	with(Ocamera)
	{
		if(argument0 > shake_remain)
		{
			shake_magnitude = argument0;
			shake_remain = argument0;
			shake_length = argument;
		}
	}
}