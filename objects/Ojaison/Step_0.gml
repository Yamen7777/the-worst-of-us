 vsp = vsp + grv;

//afraid of height (AFH)
if (AFH) && (grounded) && (!place_meeting(x+hsp*10,y+1,Owall))
{
	if(flip)
	{
		hsp = -hsp;
		face = sign(hsp); // Add this line - make face flip when hitting wall
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
    sprite_index = SjaisonJ;
    image_speed = 0;
if (sign(vsp) > 0) image_index = 1; else image_index = 0;

}
else
{
	grounded = true;
	image_speed = 1;
	if (hsp == 0)
	{
		sprite_index = Sjaison;
	}
	else 
	{
			sprite_index = SjaisonR;
	}
}
if (hsp != 0) image_xscale = face * size;
image_yscale = size;

// Circle detection around Owilson - check if Ocherry enters the circle
if (instance_exists(Ocherry))
{
	var _cherry = Ocherry;
	var _detectionRadius = 2500; // Radius of detection circle (adjust as needed)
	var _dashRadius = 1500;
	var _distance = point_distance(x, y, _cherry.x, _cherry.y);
	
	var _maxspd = 20;          // Max speed
	var _accel = 0.1;          // Acceleration factor for smooth transition
	var _deccel = 0.05;         // Deceleration factor for smooth stop
	
	// Check if Ocherry is within the circle
	if (_distance <= _detectionRadius) or (charge)
	{
		if(sound_circle) and (!audio_is_playing(SNmonster)) 
		{
			audio_sound_pitch(SNmonster,random_range(1.,0.7));
			audio_play_sound(SNmonster,6,false);
			sound_circle = false;
		}
		flip = false;
		// Determine which side Ocherry is on (left or right)
		var _cherryDirection = sign(_cherry.x - x); // -1 for left, 1 for right
		
		// Make face immediately turn towards cherry
		if (_cherryDirection != 0)
		{
			if(!charge) and (!colddown) and (!charging) face = _cherryDirection;
		}
		if(!colddown)
		{
			if(_distance <= _dashRadius) charge = true;
		}
		
		if(colddown)
		{
			hsp = 0;
			colddownTime--;
			if(colddownTime <= 0)
			{
				colddownTime = colddownTimer;
				colddown = false;
			}
		}
		if(charge) 
		{

			with(instance_create_layer(x,y,"powerups",Odust))
			{
				vsp = 0
			}
			if(sound_charge) and (!audio_is_playing(SNmonster_attack)) 
			{
				audio_sound_pitch(SNmonster_attack,random_range(0.6,0.8));
				audio_play_sound(SNmonster_attack,5,false);
				sound_charge = false;
			}
			if(chargeDirection == 0) chargeDirection = _cherryDirection;
			hsp = lerp(hsp,chargeDirection*-15,0.5);
			face = chargeDirection;
			chargeTime--;
		}
		
		if(diraction) {chargeDirection = _cherryDirection; diraction = false;}
		
		if(chargeTime <= 0)
		{
			if(sound_waind) and (!audio_is_playing(SNmonster_charge)) 
			{
				audio_sound_pitch(SNmonster_charge,random_range(0.6,0.8));
				audio_play_sound(SNmonster_charge,5,false);
				sound_waind = false;
			}
			sound_charge = true;
			charge = false;
			hsp = lerp(hsp,chargeDirection*50,0.5);
			face = chargeDirection;
			charging--;
			if(charging <= 0)
			{
				sound_waind = true;
				diraction = true;
				charging = chargingTime
				chargeTime = chargeTimer;
				colddown = true;
				chargeDirection = 0;
			}
		}
		if(!charge) and (!colddown)
		{
			// Make hsp smoothly accelerate towards cherry (with slip)
			if(_cherryDirection == -1) hsp = lerp(hsp, -_maxspd, _accel);
			if(_cherryDirection == 1) hsp = lerp(hsp, _maxspd, _accel);
		}
	}
	else 
	{
	    sound_circle = true;
	    flip = true;
    
	    // Gradually slow back down to normal speed
	    var _normalSpeed = 7;
	    if(abs(hsp) > _normalSpeed)
	    {
	        hsp = lerp(hsp, sign(hsp) * _normalSpeed, 0.1);
	    }
	}
}

// Check if Ocherry is dashing
if instance_exists(Ocherry)
{
	var _CHfront = (sign(Ocherry.x - x) != face);
	
	if place_meeting(x,y,Ocherry)
	{
		if(_CHfront)
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
					audio_sound_pitch(SNzobmie_damage,random_range(0.4,0.6));
					audio_play_sound(SNzobmie_damage,5,false);
					if(poke_damage) {other.hp -= 3; other.hsp = -sign(other.hsp) * 45;}
				
					var _pokeDir = pokeDircation;
					var _dashDir = dashDirection;

					onground(false);
					POtimer = true;
				
					var _knockbackSpeedH = 40;
					var _knockbackSpeedV = 30;
					var _attackDir = 0;
				
					if (poke_damage)
					{
						_attackDir = _pokeDir;
					
						if (_attackDir >= 80 and _attackDir <= 100)
						{
							hsp = 0;
							vsp = -_knockbackSpeedV * 2.5;
						}
						else
						{
							var _pokeH = lengthdir_x(1, _attackDir);
							hsp = -_pokeH * _knockbackSpeedH;
						
							var _pokeV = lengthdir_y(1, _attackDir);
							if (_pokeV > 0)
							{
								vsp = -_knockbackSpeedV * (1 + abs(_pokeV) * 0.5);
							}
							else
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
						if(other.shuild == false) // Already passed through - on the other side
						{
							other.shuild = false;
							dashEnergy++;
						}
						else // First contact - hitting from behind
						{
							repeat (3)
							{
								with(instance_create_layer(x,y,"powerups",Odust))
								{
									image_blend = c_red;
								}
							}
							audio_sound_pitch(SNzobmie_damage,random_range(0.4,0.6));
							audio_play_sound(SNzobmie_damage,5,false);
							other.shuild = false; // Disable shield while passing through
							other.hp -= 5;
						}
					}
				}
				else STATE = STATE_DEAD;
			}
		}
		else // Hitting shield
		{
			if(shuild)
			{
				with (Ocherry)
				{
					if(damage)
					{
						audio_sound_pitch(SNshuilld,random_range(0.6,0.9));
						audio_play_sound(SNshuilld,5,false);
						STATE = STATE_FREE;
						POtimer = true;
						hsp = -sign(hsp) * 65;
						vsp = -30;
						damage = false;
						dash_damage = false;
						poke_damage = false;
					}
					else STATE = STATE_DEAD;
				}
			}
		}
	}
	else // No longer colliding - reset shield
	{
		shuild = true;
	}
}

//size
if (hsp != 0) image_xscale = sign(hsp) * size;
image_yscale = size;