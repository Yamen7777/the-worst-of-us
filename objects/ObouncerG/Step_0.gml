if(place_meeting(x,y,Ocherry)) {
    audio_sound_pitch(SNbounce,random_range(0.6,0.9));
    audio_play_sound(SNbounce,5,false);
    
    // Calculate bounce direction based on rotation
    var bounce_force = 90;
    var bounce_angle = image_angle + 90; // Add 90 to correct the angle offset
    
    // Calculate direction components
    var bounce_x = lengthdir_x(bounce_force, bounce_angle);
    var bounce_y = lengthdir_y(bounce_force, bounce_angle);
    
    with(Ocherry) {
        onground(false);
        // Apply the calculated velocity with different strengths
        hsp = bounce_x * 2; // double the horizontal power (180 instead of 90)
        vsp = bounce_y;
        
        // Add small upward velocity for horizontal bounces to counter gravity
        if (abs(bounce_y) < 40) { // if vertical component is very small (horizontal bounce)
            vsp = -40; // small upward velocity to counter gravity
        }
        
        // Set down variable when bouncer pushes player downward
        if (bounce_y > 0) { // positive vsp means downward
            	with(Ocherry)
				{
					MAXgrv = 70;
				}
        }
    }
    image_index = 1;
    bounce_timer = 15;
	control_timer = true;
}

if (bounce_timer > 0) {
    bounce_timer--;
} else {
    image_index = 0;
}

if(control_timer)
{
	Ocherry.hasControl = false;
	control_time--;
}

if(control_time <= 0)
{
	control_timer = false;
	control_time = 10;
	Ocherry.hasControl = true;
}