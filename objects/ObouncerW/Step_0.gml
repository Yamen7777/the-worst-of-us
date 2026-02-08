if (place_meeting(x, y, Ocherry)) 
{
	audio_sound_pitch(SNbounce,random_range(0.6,0.9));
	audio_play_sound(SNbounce,5,false);
    with (Ocherry) 
    {
        // Check if the object is touching only Ocherry's legs
        if (other.y > y)
        {
            onground(false);
            vsp = -90;
            other.image_index = 1;
            other.bounce_timer = 15;
        }
    }
}

//bounce timer
if (bounce_timer > 0) {
    bounce_timer--;
} else {
    image_index = 0;
}
