 vsp = vsp + grv;

//afraid of height (AFH)
if (AFH) && (grounded) && (!place_meeting(x+hsp,y+1,Owall))
{
	if(flip)
	{
		hsp = -hsp;
		face = sign(hsp); // Add this line - make face flip when hitting wall
	}
	else
	{
		// Small knockback when chasing player and hitting wall
		hsp = -sign(hsp) * 20; // Knockback speed (adjust as needed)
	}
}

//horizontal collision
if (place_meeting(x+hsp,y,Owall))
{
	while (!place_meeting(x+sign(hsp),y,Owall))
	{
		x = x + sign(hsp);
	}
	if(flip)
	{
		hsp = -hsp;
		face = sign(hsp);
	}
	else
	{
		// Small knockback when chasing player and hitting wall
		hsp = -sign(hsp) * 20; // Knockback speed (adjust as needed)
	}
}

x += hsp;

//vertica collision  
if (place_meeting(x,y+vsp,Owall))
{
	while (!place_meeting(x,y+sign(vsp),Owall))
	{
		y = y + sign(vsp);
	}
	vsp = 0;
}
y = y + vsp;

//aniamtion
if (!place_meeting(x, y + 1, Owall))
{
	grounded = false
    sprite_index = SwilsonJ;
    image_speed = 0;
if (sign(vsp) > 0) image_index = 1; else image_index = 0;

}
else
{
	grounded = true;
	image_speed = 1;
	if (hsp == 0)
	{
		sprite_index = Swilson;
	}
	else 
	{
			sprite_index = SwilsonR;
	}
}
if (hsp != 0) image_xscale = face * size;
image_yscale = size;

// Circle detection around Owilson - check if Ocherry enters the circle
if (instance_exists(Ocherry))
{
	var _cherry = Ocherry;
	var _detectionRadius = 2500; // Radius of detection circle (adjust as needed)
	var _distance = point_distance(x, y, _cherry.x, _cherry.y);
	
	var _maxspd = 20;          // Max speed
	var _accel = 0.1;          // Acceleration factor for smooth transition
	var _deccel = 0.05;         // Deceleration factor for smooth stop
	
	// Check if Ocherry is within the circle
	if (_distance <= _detectionRadius)
	{
		audio_sound_pitch(SNzobmie,0.7);
		if(!audio_is_playing(SNzobmie)) and (hp > 0) audio_play_sound(SNzobmie,3,true);
		flip = false;
		// Determine which side Ocherry is on (left or right)
		var _cherryDirection = sign(_cherry.x - x); // -1 for left, 1 for right
		
		// Make face immediately turn towards cherry
		if (_cherryDirection != 0)
		{
			face = _cherryDirection;
		}
		
		// Make hsp smoothly accelerate towards cherry (with slip)
		if(_cherryDirection == -1) hsp = lerp(hsp, -_maxspd, _accel);
		if(_cherryDirection == 1) hsp = lerp(hsp, _maxspd, _accel);
	}
	else flip = true;
}

// Check if Ocherry is dashing
if instance_exists(Ocherry)
{
	if place_meeting(x,y,Ocherry)
	{
		with (Ocherry)
		{
			if(damage)
			{
				repeat (3)
				{
					with(instance_create_layer(x,y,"powerups",Odust))
					{
						image_blend = c_red;
					}
				}
				audio_sound_pitch(SNzobmie_damage,0.7);
				audio_play_sound(SNzobmie_damage,2,false);
				if(poke_damage) {other.hp -= 3; other.hsp = -sign(other.hsp) * 45;} // Knockback
				if(dash_damage) {other.hp -= 5;} // Knockback
				
				// Store the current state and direction BEFORE changing state
				var _wasPoke = (STATE == STATE_POKE);
				var _pokeDir = pokeDircation;
				var _dashDir = dashDirection;

				onground(false);
				POtimer = true;
				
				// Calculate knockback based on attack direction
				var _knockbackSpeedH = 40; // Horizontal knockback speed
				var _knockbackSpeedV = 30; // Vertical knockback speed (upward)
				var _attackDir = 0;
				
				if (poke_damage)
				{
					_attackDir = _pokeDir;
					
					// Special case: downward poke (around 90 degrees)
					if (_attackDir >= 80 and _attackDir <= 100)
					{
						// Downward poke: knockback only upward, no horizontal
						// Stronger since there's no horizontal component
						hsp = 0;
						vsp = -_knockbackSpeedV * 2.5; // Much stronger vertical knockback (75)
					}
					else
					{
						// Get horizontal component of poke direction
						// Right poke (0°) = +1, Left poke (180°) = -1
						var _pokeH = lengthdir_x(1, _attackDir);
						
						// Knockback goes opposite horizontal direction
						hsp = -_pokeH * _knockbackSpeedH;
						
						// Always upward knockback
						// If poke was more downward, add more upward force
						var _pokeV = lengthdir_y(1, _attackDir);
						if (_pokeV > 0) // Poke was downward
						{
							// More upward for downward pokes
							vsp = -_knockbackSpeedV * (1 + abs(_pokeV) * 0.5);
						}
						else // Poke was upward or horizontal
						{
							vsp = -_knockbackSpeedV;
						}
					}
					STATE = STATE_FREE;
					damage = false;
					dash_damage = false;
					poke_damage = false;
				}
				else if(dash_damage)
				{
					if(place_meeting(x,y,other)) dashEnergy++;
				}
			}
			else	STATE = STATE_DEAD;
		}
	}
}
