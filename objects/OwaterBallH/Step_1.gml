if(place_meeting(x,y,Ocherry))
{
	if(!water_pause)
	{
		with(Ocherry) if(STATE = STATE_DASH)
		{
			// This waterball instance sets its own properties
			other.water_pause = true;
			other.timer = true;
			
			STATE = STATE_PAUSE;
			x = other.x; 
			y = other.y + (other.sprite_height / 2) - (sprite_height / 2) + 10;
		}
	}
} 
else
{
	water_pause = false;
}
if(timer)
{
	time--;
}
if(time <= 0)
{
	with(Ocherry)
	{
		audio_sound_pitch(SNdash,random_range(1.3,1.1));
		audio_play_sound(SNdash,4,false);
		dashing = true;
		vsp = -2;
		onground(false);
	    canDash = false;
		
		D_inputs = right or left or up or down;
	    // If the player is holding a movement key, use the input direction
	    if (D_inputs) {
	        dashDirection = point_direction(0, 0, right - left, down - up);
	    } else {
	        // No input, dash in the direction the sprite is facing
	        dashDirection = (face == -1) ? 180 : 0; 
	    }
		
	    dashSPD = (dashDistance*3) / (dashTime*1.7);
	    dashEnergy = dashDistance;
	    STATE = STATE_DASH;
	}
	timer = false;
	time = 35
}