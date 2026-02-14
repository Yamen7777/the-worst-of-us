image_xscale = face;

if(hp <= 0) 
{
	repeat (5)
	{
		with(instance_create_layer(x,y,"powerups",Odust))
		{
			image_blend = c_red;
		}
	}
	killCounter(3);
	
	// Add bonus level to room tracker if this enemy gives bonus levels
	if (level_upgrade > 0 && instance_exists(Ogame)) {
		Ogame.room_bonus_levels += level_upgrade;
		show_debug_message("Enemy gives " + string(level_upgrade) + " bonus level(s). Total bonus: " + string(Ogame.room_bonus_levels));
	}
	
	instance_create_layer(x,y-100,"powerups",Ostrawberry); 
	instance_destroy();
}
//circe around fly 
if(instance_exists(Ocherry))
{
	var CH = Ocherry;
	var _radius = 2000;
	var _follow = 600;
	var _distance = point_distance(x,y,CH.x,CH.y);
	
	if(_distance <= _radius)
	{
		sound_timer = true;
	    shoot = true;
	    follow = true;
	    var CHdiraction = sign(CH.x - x);
	    if(CHdiraction != 0) face = CHdiraction;
    
	    if(face ==  1) x = lerp(x,CH.x - _follow,0.02);
	    if(face == -1) x = lerp(x,CH.x + _follow,0.02);
    
	    // Count UP instead of down
	    if(shoot)
	    {
	        shoot_time++;
	        if(shoot_time >= time)
	        {
	            // Shoot!
	            with(instance_create_layer(x,y,layer,Oredblast))
	            {
					audio_sound_pitch(Snlaser,random_range(1.2,0.8));
					if(!audio_is_playing(Snlaser)) audio_play_sound(Snlaser,3,false);
	                dir = point_direction(x,y,CH.x,CH.y);
	                image_angle = dir;
	            }
	            shoot_time = 0; // Reset timer
	        }
	    }
	}
	else
	{
		sound_timer = false;
		sound_time = sound_T;
		if(follow)
		{
			if(face ==  1) _x = x-300;
			if(face == -1) _x = x+300;
			follow = false;
		}
		if(hsp < 0)
		{
			face = -1;
		}
		if(hsp > 0)
		{
			face =  1;
		}
	
		dir -= spdrot;

		var Xtarget = _x + lengthdir_x(radius,dir);

		hsp = (Xtarget - x);
		
		x += hsp;

	}
}

//play sound
if(sound_timer)
{
	if(!audio_is_playing(SNfly)) and (sound_time == sound_T) 
	{
		audio_sound_pitch(SNfly,random_range(1.2,0.8));
		audio_play_sound(SNfly,4,false);
	}
	sound_time--;
	if(sound_time <= 0) sound_time = sound_T;
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
				if(poke_damage) {other.hp -= 3; other.hsp = -sign(other.hsp) * 45;} // Knockback
				if((dash_damage)) {other.hp -= 5;} // Knockback
				
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