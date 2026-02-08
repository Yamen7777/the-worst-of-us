
with(Ocherry)
{
	if(dashDirection = 0) // Right
	{
		with(OwaterBLock)
		{
			Hleap = dash_collect*4.8;
			Vleap = -dash_collect*1.1;
		}
	}
	if(dashDirection = 45) // Up-Right
	{
		with(OwaterBLock)
		{
			Hleap = dash_collect*3;
			Vleap = -dash_collect*2;
		}
	}
	if(dashDirection = 90) // Up
	{
		with(OwaterBLock)
		{
			Hleap = 0;
			Vleap = -dash_collect*2;
		}
	}
	if(dashDirection = 135) // Up-Left
	{
		with(OwaterBLock)
		{
			Hleap = -dash_collect*3;
			Vleap = -dash_collect*2;
		}
	}
	if(dashDirection = 180) // Left
	{
		with(OwaterBLock)
		{
			Hleap = -dash_collect*4.8;
			Vleap = -dash_collect*1.1;
		}
	}
	if(dashDirection = 225) // Down-Left
	{
		with(OwaterBLock)
		{
			Hleap = -dash_collect*2;
			Vleap = dash_collect*2;
		}
	}
	if(dashDirection = 270) // Down
	{
		with(OwaterBLock)
		{
			Hleap = 0;
			Vleap = dash_collect*2;
		}
	}
	if(dashDirection = 315) // Down-Right
	{
		with(OwaterBLock)
		{
			Hleap = dash_collect*2;
			Vleap = dash_collect*2;
		}
	}
}
if(timer)
{
	time--;
}
if(time == 0)
{
	Ocherry.water_push = false;
	dash_collect = 0;
	timer = false;
	time = 5;
	audio_play_sound(SNwater_push,4,false);
}