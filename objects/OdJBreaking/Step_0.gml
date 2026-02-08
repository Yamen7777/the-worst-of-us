if (instance_exists(Ocherry) && place_meeting(x, y + 10, Ocherry) && Ocherry.Jcount == 2) {
    if (!is_destroyed) { // Only destroy if not already destroyed
        audio_sound_pitch(SNbreaking, random_range(0.6, 0.8));
        audio_play_sound(SNbreaking, 4, false);
			var mid_x = x + random_range(0, sprite_width);
			var mid_y = y + random_range(0, sprite_height);
			repeat (30)
			{
				instance_create_layer(mid_x,mid_y,"powerups",Odust)
			}
        is_destroyed = true;
    }
}

if(is_destroyed)
{
	instance_destroy();
}