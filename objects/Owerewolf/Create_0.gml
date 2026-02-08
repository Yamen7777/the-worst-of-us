/// @description player veriables
//input setop
input_setup();

// Initialize debug variables
global.show_collision_mask = false;


//effects 
trail_timer = 0;

//health / damage
hp = 100;
hitstun_time = 0; // frames of stun / invincibility after taking damage
invincible = false;

//moving
face = 1;
run = 0;
walkSP[0] = 20;
walkSP[1] = 35;
hsp = 0;
vsp = 0;
crouching = false;
hasControl = true;
Cpause = false;
dead = false;
wasGround = false;
fallBuffer = 0;
bounce = false;

//jumping
grv = 0.4;
MAXgrv = 40;
Jmax = 1;
Jcount = 0;
DJcount = 0;
Djumping = false;
ground = false;
DJ = false;
DJtimer = 3;
leap = 60;
canJump = false;
canDJ = false;
strawberryF = noone;
follow_strawberry = noone;
wall_jump = false;
WJ_HSP = 40; //wall jump horizantol speed
WJ_VSP = -45; //wall jump vertocal speed
wall_id = noone;
wall_jump_cooldown = 0;
wall_last_id = noone;
wall_id_cooldown = 0;
wall_time = 0;
sliding = false;


//jump values
JHT = 0;
JHF[0] = 13;
jumpSP[0] = -28;


timer = false;
time = 10;

//dash 
dashing = false;
canDash = false;
dashDistance = 550;
dashTime = 15;
water_dash = false;
water_push = false;
dashDirection = 0;
dashEnergy = 0;
bananaF = noone;
follow_banana = noone;

dashed = false;
dashT = 45;
dash_cooldown = dashT;

//poke
poking = false;
canPoke = true;
pokeDistance = 450;
pokeTime = 15;
pokeDircation = 0;
pokeEnergy = 0;
POtimer = false;
Ptime = 20;
POtime = Ptime;


//attacking
attack = false;
attack1 = false;
attack2 = false;
attack3 = false;
queued_attack2 = false;
queued_attack3 = false;
attack_timer = 0;
cooldown_timer = 0;
combo_window_timer = 0;
attack1_started = false;
attack2_started = false;
attack3_started = false;
attack1_duration = 35;
attack2_duration = 20;
attack3_duration = 25;
cooldown_duration = 25;
combo_window_start = 5;
//hold attack
hold_attack = false;
hold_time = 0;
hold_scratch = 30;
max_scratchs = 3;
hold_released = false; //Track if button was released

//run attack
run_attack = false;
run_attack_duration = 40;
run_attack_timer = run_attack_duration;
RA_cooldown = 60;
run_attack_cooldown = 0


//super
transform = false;
transforming = false;

//damage to enemies
damage = false;
dash_damage = false;
damage_timer = false;
damageT = 10;
damage_time = damageT;


//cayote time
cayoteHF = 2;
cayoteHT = 0;
cayoteJF = 5;
cayoteJT = 0;

//moving platform
MyFloorPlat = noone;
downSlopesSemiSolid = noone;
forgetssp = noone;
MovingPlatXspd = 0;
MovingPlatMaxYspd = 150;
empXspd = false; //early moving platform X speed 

//sound effect 
underwater_applied = false;
inWater = false;
dash_sound_timer = 0;
dash_sound_interval = 5; // Play sound every 5 frames (quarter second at 60fps)
base_pitch = 0.8;         // Base pitch for the sound
max_pitch = 2;          // Maximum pitch when dash_collect reaches 50

// Set default spawn if none exists
if (global.spawn_x == -1) {
    global.spawn_x = xstart;  // Your initial spawn position
    global.spawn_y = ystart;
}

//getting hit
damage_taken = function(_damage, _source_x = undefined)
{
    // If we are currently in hitstun, ignore further damage
    if (hitstun_time > 0) or (transforming) or (run_attack) return;
    
    // Apply damage
    hp -= _damage;
    if (hp < 0) hp = 0;
    
    // Start hitstun / temporary invincibility
    hitstun_time = 20;
    
    //reset hold attack
    hold_time = 0;
    
    // --- Knockback / unstuck ---
    // Determine knockback direction based on which side was hit
    var _dir = 1; // Default to right
    
    if (_source_x != undefined) {
        // If source position provided, knock away from it
        _dir = sign(x - _source_x);
    } else {
        // No source provided - check collision sides to determine knockback
        // Check left side
        if (place_meeting(x - 1, y, Ospikes) || place_meeting(x - 1, y, Ojack)) {
            _dir = 1; // Hit from left, push right
        }
        // Check right side
        else if (place_meeting(x + 1, y, Ospikes) || place_meeting(x + 1, y, Ojack)) {
            _dir = -1; // Hit from right, push left
        }
        // If can't determine, use facing direction opposite
        else {
            _dir = -face;
        }
    }
    
    // If still zero, default to right
    if (_dir == 0) _dir = 1;
    
    var _kb_dist = 8;
    var _kb_hsp = 8;
    
    // Velocity kick (feel) - knock AWAY from source
    hsp = _dir * _kb_hsp;
    vsp = min(vsp, -2);
    
    // Physical shove
    for (var i = 0; i < _kb_dist; i++)
    {
        if (!place_meeting(x + _dir, y, Owall))
        {
            x += _dir;
        }
        else break;
    }
    
    // If still inside spikes, nudge upward
    if (place_meeting(x, y, Ospikes))
    {
        for (var j = 0; j < 16; j++)
        {
            if (!place_meeting(x, y - 1, Owall))
            {
                y -= 1;
                if (!place_meeting(x, y, Ospikes)) break;
            }
            else break;
        }
    }
}

//states 
STATE_FREE = function()
{
    // --- Update wall_id every frame ---
    var wall_left = instance_place(x-20, y, Owall);
    var wall_right = instance_place(x+20, y, Owall);
    if (wall_left != noone) {
        wall_id = wall_left;
    } else if (wall_right != noone) {
        wall_id = wall_right;
    } else {
        wall_id = noone;
    }

	//dont fall of the moving platform
	empXspd = false;
	if (instance_exists(MyFloorPlat)) and (MyFloorPlat.hsp != 0) and (!place_meeting(x,y + MovingPlatMaxYspd+1,MyFloorPlat))
	{
		var _Xcheck = MyFloorPlat.hsp;
		//move with the platform
		if !place_meeting(x + _Xcheck,y,Owall)
		{
			x += _Xcheck;
			empXspd = true;
		}
	}

	//crouching
	//trasition to crouch
	//manual = downkey | automatic = wall collistion
	if (ground) and (down or place_meeting(x,y-10,Owall))
	{
		crouching = true;
	}
	else crouching = false;
	//change collision mask
	if crouching and (!transform) {mask_index = SwerewolfC;}
	else if crouching and (transform) {mask_index = SPwerewolfC;}

	//trasistion out of crouching
	//manual = !downkey | automatic = !ground
	if (crouching) and (!down or !ground)
	{
		//check if I CAN UNcrouch
		if (!transform) mask_index = Swerewolf;
		else if (transform) mask_index = SPwerewolf;
		//uncrouch if no solid wall in the way 
		if (!place_meeting(x,y,Owall))
		{
			crouching = false;
		}
		//go back to crouching mask index if CAN'T uncrouch
		else
		{
			if(!transform) mask_index = SwerewolfC;
			else if(transform) mask_index = SPwerewolfC;
		}
	
	}
	//running
	if(shift) and ((ground) or (Jcount >= 1))
	{
		run = true;
	}
	else run = false;
	//run attack
	if(run) and (LMB) and (run_attack_cooldown <= 0)
	{
		run_attack = true;
		run_attack_cooldown = RA_cooldown;
		// Create scratch effect
	    if (face ==  1) var _scratchX =  250;
	    if (face == -1) var _scratchX = -250;
	    with(instance_create_layer(Ocherry.x + _scratchX, Ocherry.y - 230, "bullets", Oscratch)) {
	        if(!other.transform)
			{
				sprite_index = Sscratch4;
				damage = 7;
			}
	        else 
			{
				sprite_index = SscratchP5;
				damage = 11;
			}
	        image_xscale = other.face;
	    }
		audio_sound_pitch(SNsword, random_range(0.9, 0.8));
	    audio_play_sound(SNsword, 1, false);
	}
	if(run_attack)
	{
		run_attack_timer--;
		if(run_attack_timer <= 0)
		{
			run_attack_timer = run_attack_duration;
			run_attack = false;
		}
	}
	
	//run attack cooldwon
	if(run_attack_cooldown > 0)
	{
		run_attack_cooldown--;
	}
	
	//moving
	var _walking = true;
	if(!audio_is_playing(SNstep1)) and (!audio_is_playing(SNstep2)) and (!audio_is_playing(SNstep3)) and (!audio_is_playing(SNstep4)) _walking = false;
	if((sprite_index == SwerewolfW) or (sprite_index == SPwerewolfW)) and (!_walking)
	{
		audio_sound_pitch(SNstep1,1);
		audio_sound_pitch(SNstep2,1);
		audio_sound_pitch(SNstep3,1);
		audio_sound_pitch(SNstep4,1);
		audio_play_sound(choose(SNstep1,SNstep2,SNstep3,SNstep4),1,false);
	}
	if((sprite_index == SwerewolfR) or (sprite_index == SPwerewolfR)) and (!_walking)
	{
		audio_sound_pitch(SNstep1,1.3);
		audio_sound_pitch(SNstep2,1.3);
		audio_sound_pitch(SNstep3,1.3);
		audio_sound_pitch(SNstep4,1.3);
		audio_play_sound(choose(SNstep1,SNstep2,SNstep3,SNstep4),1,false);
	}
	
	if(attack) //make sure the player isnt moving
	{
		hsp = 0;
		vsp = 0;
		crouching = false;
	}
	else if (!run_attack) and (!transforming)
	{
		//calculate movment
		if (vsp >= 0) and (place_meeting(x,y+1,Owall)) onground(true);

		var move = right - left;

		if (move != 0) face = move;

		//acceleration and deceleration
		if(run) var maxspd = 45; //max speed when the player is running
		else maxspd = 25; // Max speed when the player is walking
		var accel = 0.2;          // Acceleration factor for smooth transition
		var deccel = 0.1;         // Deceleration factor for smooth stop

		// Acceleration (while moving)
		if (move != 0) and (hsp < maxspd) {
		    // Move towards max speed with lerp
		    hsp = lerp(hsp, move * maxspd, accel);  // Interpolate towards the target speed (move direction * maxspd)
		}
		// Deceleration (when no movement input)
		else {
		    // If the speed is less than or equal to deceleration threshold, stop immediately
		    if (abs(hsp) <= 6) {
		        hsp = 0;  // Stop the player immediately when speed is below the deceleration threshold
		    } 
		    else {
		        // Smooth stop using lerp
		        hsp = lerp(hsp, 0, deccel);  // Interpolate towards 0 speed
		    }
		}
	}

	//stop moving if crouching
	if (crouching) hsp = 0;

	//gravity
	if (cayoteHT > 0)
	{
		cayoteHT--;
	}
	else
	{
		cayoteJT--;
		if(instance_exists(OwaterBLock)) and (OwaterBLock.slow) {vsp += 1.6;}
		else {vsp += 3;}
		if (vsp > MAXgrv) vsp = MAXgrv;
		onground(false);
	}
	//jump input
	if (ground) 
	{
		canJump = true;
		canDJ = false;
		Jcount = 0; 
		JHT = 0;
		Jmax -= Jcount;
		DJcount = 0;
		cayoteJT = cayoteJF;
		wall_last_id = noone;
		wall_jump_cooldown = 0;
		bounce = false;
		//Reset wall_id and sliding after wall jump
	    wall_id = noone;
	    sliding = false;
	}
	else if Jcount == 0 and cayoteJT <= 0 
	{
		Jcount = 1;
		JHT = 0;
		canJump = false;
		canDJ = true;
	} 
	
	//jumping
	//check for solid floor
	_solidFloor = false
	if (instance_exists(MyFloorPlat))
	and ( (MyFloorPlat.object_index == Owall) or (object_is_ancestor(MyFloorPlat.object_index,Owall)) )
	{
		_solidFloor = true;
	}

	//jump
	_jumping = false;
	// Ground jump block
	if (canJump && Jbuffer && wall_time <= 0 && ((!down) || _solidFloor)) and (!attack) and (hasControl) {
	    audio_sound_pitch(SNjump, random_range(0.9, 1.1));
	    audio_play_sound(SNjump, 3, false);
	    Jcount = 1;
	    // When setting JHT = JHF[Jcount-1], clamp Jcount to array length
	    var max_jumps = array_length(JHF);
	    var safe_Jcount = clamp(Jcount, 1, max_jumps);
	    if (safe_Jcount > 0) {
	        JHT = JHF[safe_Jcount-1];
	    } else {
	        JHT = JHF[0];
	    }
	    onground(false);
	    cayoteJT = 0;
	    canJump = false;
	    canDJ = true;
	    Jbuffer = false;
	    Jbuffer_timer = 0;
		_jumping = true;
	}
	
	if (!jump_hold)
	{
		JHT = 0;
	}
	if (JHT > 0)
	{
		// When setting vsp = jumpSP[Jcount-1], clamp Jcount to array length
		var safe_Jcount2 = clamp(Jcount, 1, array_length(jumpSP));
		if (safe_Jcount2 > 0) {
		    vsp = jumpSP[safe_Jcount2-1];
		} else {
		    vsp = jumpSP[0];
		}
		JHT--;
	}
	
	//wall jump
	if (wall_jump_cooldown > 0) wall_jump_cooldown--;
	if (wall_id_cooldown > 0) wall_id_cooldown--;
	// Wall detection (includes ancestors)
	var wall_left = instance_place(x-20, y, Owall);
	var wall_right = instance_place(x+20, y, Owall);
	var wall_dir = 0;
	function instance_is_wall(inst) {
	    return (inst != noone) && 
	          (inst.object_index == Owall || 
	           object_is_ancestor(inst.object_index, Owall));
	}
	// Check walls
	if (wall_left != noone && instance_is_wall(wall_left)) {
	    wall_id = wall_left;
	    wall_dir = -1;
	}
	else if (wall_right != noone && instance_is_wall(wall_right)) {
	    wall_id = wall_right;
	    wall_dir = 1;
	}

	// Wall sliding - add this before wall jump execution
	var wall_slide_multiplier = 0.9; 
	var is_sliding = false;
	
	if( ( (wall_id  == wall_right) and (face == 1) ) or ( (wall_id  == wall_left) and (face == -1) ) ) and (!ground) and (wall_id != noone)
	{
		sliding = true;
	}
	else sliding = false;
	
	if (sliding && vsp > 0 && !ground) {
		onground(false);
	    // Check if player is moving towards the wall or holding the direction
	    var moving_into_wall = (wall_dir == -1 && left) || (wall_dir == 1 && right);
    
	    if (moving_into_wall) {
	        // Apply wall sliding by reducing vertical speed
	        vsp *= wall_slide_multiplier;
	        is_sliding = true;
	    }
	}

	// Wall jump execution
	if (wall_id != noone && jump && wall_time <= 0) {
	    // Ground check (Owall/Ossplat and ancestors)
	    var allow_wall_jump = true;
	    var check_box = collision_rectangle(
	        bbox_left, bbox_bottom + 1,
	        bbox_right, bbox_bottom + 50,
	        [Owall, Ossplat],
	        true, true
	    );
    
	    if (check_box != noone) {
	        allow_wall_jump = false;
	    }
	    //generat the jump
	    if (allow_wall_jump && 
	       (wall_id != wall_last_id || wall_id_cooldown <= 0) &&
	       wall_jump_cooldown <= 0) {
        
	        // Perform wall jump
	        audio_sound_pitch(SNjump, random_range(1.3,1.6));
	        audio_play_sound(SNjump, 3, false);
        
	        hsp = WJ_HSP * -wall_dir;
	        vsp = WJ_VSP;
	        face = -wall_dir;
        
	        // Set cooldowns
	        wall_time = 10;
	        wall_last_id = wall_id;
	        wall_jump_cooldown = 8; // General cooldown
	        wall_id_cooldown = 30; // Same-wall cooldown
        
	        // Small downward push
	        vsp += 1;
	        canJump = false;
	        canDJ = false;
	    }
	}
	if(wall_time > 0)
	{
		
		//Reset wall_id and sliding after wall jump
	    wall_id = noone;
	    sliding = false;
		wall_time--;
	}

	//Control handling
	hasControl = (wall_jump_cooldown <= 0) ;
	//Reset wall memory when appropriate
	if (wall_id == noone && place_meeting(x, y+1, Owall)) 
	{
	    wall_last_id = noone;
	}
	
	// Enable double jump after wall jump when airborne and away from wall (supports multiple air jumps)
	if (!ground && wall_id == noone && !canDJ && Jcount < Jmax) {
	    canDJ = true;
	}
	
	//double jump
	// Check if player is far from ground
	// Combined check version
	far_ground = true;
	var inst_list = ds_list_create();
	collision_rectangle_list(
	    bbox_left, bbox_bottom,
	    bbox_right, bbox_bottom + 50,
	    all, false, true, inst_list, false);

	for (var i = 0; i < ds_list_size(inst_list); i++) {
	    var inst = inst_list[| i];
	    if (array_contains([Owall, Ossplat], inst.object_index) ||
	       object_is_ancestor(inst.object_index, Owall) || 
	       object_is_ancestor(inst.object_index, Ossplat)) {
	        far_ground = false;
	        break;
	    }
	}
	ds_list_destroy(inst_list);
	
	//check for double jump
	if(jump) && ( canDJ && Jbuffer && (Jcount < Jmax) && ((!down) || _solidFloor) && (wall_jump_cooldown == 0) && far_ground && (wall_time <= 0) && (wall_id == noone) )
	{
		audio_sound_pitch(SNjump,random_range(0.9,1.1));
		audio_play_sound(SNjump,3,false);

		_jumping = true;
		//Jbuffer
		Jbuffer = false;
		Jbuffer_timer = 0;
	
		//jump
		if(wall_id == noone) Jcount++;
		if (Jcount > 0) {
			// When setting JHT = JHF[Jcount-1], clamp Jcount to array length
			var max_jumps = array_length(JHF);
			var safe_Jcount = clamp(Jcount, 1, max_jumps);
			if (safe_Jcount > 0) {
			    JHT = JHF[safe_Jcount-1];
			} else {
			    JHT = JHF[0];
			}
		} else {
			JHT = JHF[0];
		}
		onground(false);
		cayoteJT = 0;
		DJ = true;
		DJcount += 1;
		canDJ = false;
		Djumping = true;
		Djumping = true
	}
	// Reset Djumping when jump button is released
	if (!jump) {
	    Djumping = false;
	}
	
	//innitiate double jump
	for (var i = 1; i < Jmax; i++)
	{
		JHF[i] = 10;       // Air jump height (same as first jump)
		jumpSP[i] = -30;   // Air jump speed (same as first jump, can be adjusted if needed)
	}

	//landing 
	if (vsp >= 0 && ground) {
	    if (!wasGround && fallBuffer > 4) {  // Only play if fell >4 pixels
			audio_sound_pitch(SNland,random_range(0.8,1.3));
	        audio_play_sound(SNland, 3, false);
	    }
	    wasGround = true;
	    fallBuffer = 0;  // Reset after landing
	} 
	else if (vsp > 0) {  // If falling downward
	    fallBuffer += vsp;  // Track distance fallen
	    wasGround = false;
	}
	else {
	    wasGround = false;
	}

	
	//double jump trail 
	if(DJ)
	{
		screenShake(25,6);
		audio_sound_pitch(SNdoubleJump,random_range(0.8,1.3));
		audio_play_sound(SNdoubleJump,4,false);

		if (trail_timer <= 0)
		{
		    // Create trail further behind (32 pixels instead of 16)
		    var trail_x = x - lengthdir_x(32, pokeDircation);
		    var trail_y = y - lengthdir_y(32, pokeDircation);
    
		    with (instance_create_depth(trail_x, trail_y, depth+1, Otrail))
		    {
		        sprite_index = other.sprite_index;
		        image_xscale = other.face;
		        image_blend = c_green;
		        image_alpha = 0.6;
        
		        fade_speed = 0.08; // Faster fade
		    }
    
		    trail_timer = 3; // Create trail every x frames
		}
		trail_timer--;
		DJtimer--;
	}
	if(DJtimer <= 0)
	{
		DJ = false;
		DJtimer = 3;
	}
	//health Par
	if(room != Ressance)
	{
		if(!instance_exists(OhealthPar))
		{
			instance_create_layer(500,200,layer,OhealthPar);
		}
		if(hp <= 0)
		{
			STATE = STATE_DEAD;
		}
		//blood Par
		if(!instance_exists(ObloodPar))
		{
			
			with instance_create_depth(490,320,301,ObloodPar) sprite_index = SbloodPar1;
			with instance_create_depth(540,395,302,ObloodPar) sprite_index = SbloodPar2;
			with instance_create_depth(490,320,302,ObloodPar) sprite_index = SbloodPar3;
		}
	}
	
			/* this character doesnt have poke
			//poke
			poke_input = right or left or up or down;
	
			poking = false;
			if (dash) and (canPoke) and (ground)
			{
				screenShake(15,4);
				poking = true;
				vsp = -2;
				onground(false);
			    canPoke = false;
				audio_sound_pitch(SNdash,random_range(0.4,6));
				audio_play_sound(SNdash,4,false);

			    // If the player is holding a movement key, use the input direction
			    if (poke_input) {
			        pokeDircation = point_direction(0, 0, right - left, down - up);
			    } else {
			        // No input, poke in the direction the sprite is facing
			        pokeDircation = (face == -1) ? 180 : 0; 
			    }

			    pokeSPD = pokeDistance / pokeTime;
			    pokeEnergy = pokeDistance;
			    STATE = STATE_POKE;
			}
			//poke timer 
			if(POtimer)
			{
				POtime--;
			}
			if(POtime <= 0)
			{
				POtime = Ptime;
				POtimer = false;
				canPoke = true;
			}
			*/
	
	
	//attacking
	// Decrease timers
	if (attack_timer > 0) {
	    attack_timer--;
	}
	if (cooldown_timer > 0) {
	    cooldown_timer--;
	}
	if (combo_window_timer > 0) {
	    combo_window_timer--;
	}

	// Update main attack flag
	attack = (attack1 || attack2 || attack3 || attack_timer > 0 || hold_attack);

	// COOLDOWN - Block all attacks
	if (cooldown_timer > 0) {
	    // Can't attack during cooldown
	}
	// IDLE - Can start attack 1 or hold attack
	else if (!attack1 && !attack2 && !attack3 && attack_timer == 0 && cooldown_timer == 0) {
    
	    // Charging up
	    if (HLMB && ground && !hold_released) and (!run_attack){
	        hold_time++;
        
	        // Cap at max scratches
	        if (hold_time >= hold_scratch * max_scratchs) {
	            hold_time = hold_scratch * max_scratchs;
	        }
        
	        if (hold_time >= hold_scratch) {
	            hold_attack = true;
	        }
        
	        // AUTO-RELEASE when fully charged
	        if (hold_time >= hold_scratch * max_scratchs) {
	            hold_released = true;
	            hold_attack = false;
	            cooldown_timer = cooldown_duration;

	            // Create scratch effect
	            if (face ==  1) var _scratchX =  250;
	            if (face == -1) var _scratchX = -250;
				var charge_level = floor(hold_time / hold_scratch);
				damage_level = charge_level * 25;
				var _distance = ((10*face)*charge_level)*21;
	            with(instance_create_layer(Ocherry.x + _scratchX + _distance, Ocherry.y - 230, "bullets", Oscratch)) {
	                if(!other.transform)
					{
						sprite_index = Sscratch4;
						damage = other.damage_level;
					}
			        else 
					{
						sprite_index = SscratchP4;
						damage = other.damage_level*1.5;
					}
	                image_xscale = other.face;
					
	            }
            
	            audio_sound_pitch(SNsword, random_range(0.9, 0.8));
	            audio_play_sound(SNsword, 1, false);
	        }
	    }
	    // Released the button - calculate how many scratches to release
	    else if (hold_time > 0 && !hold_released) {
	        if (hold_attack) {
	            hold_released = true;
	            hold_attack = false;
	            cooldown_timer = cooldown_duration;
            
	            // Create scratch effect
	            if (face ==  1) var _scratchX =  250;
	            if (face == -1) var _scratchX = -250;
				var charge_level = floor(hold_time / hold_scratch);
				damage_level = charge_level * 25;
				var _distance = ((10*face)*charge_level)*21;
	            with(instance_create_layer(Ocherry.x + _scratchX + _distance, Ocherry.y - 230, "bullets", Oscratch)) {
	                if(!other.transform)
					{
						sprite_index = Sscratch4;
						damage = other.damage_level;
					}
			        else 
					{
						sprite_index = SscratchP4;
						damage = other.damage_level*1.5;
					}
	                image_xscale = other.face;
	                image_xscale = other.face;
	            }
            
	            audio_sound_pitch(SNsword, random_range(0.9, 0.8));
	            audio_play_sound(SNsword, 1, false);
	        }
	    }
    
	    // Reset when animation finishes
	    if (hold_released && (sprite_index == SwerewolfAT5 or sprite_index == SPwerewolfAT5) && image_index >= image_number - 1) {
	        hold_time = 0;
	        hold_released = false;
	    }
    
	    // Normal attack
	    if (LMB && ground) and (!run){
	        attack1 = true;
	        attack1_started = true;
	        attack_timer = attack1_duration;
	        combo_window_timer = combo_window_start;
	        queued_attack2 = false;
	        queued_attack3 = false;
        
	        // Create scratch 1 effect
	        if (face == 1) var _scratchX = 220;
	        if (face == -1) var _scratchX = -220;
	        with(instance_create_layer(Ocherry.x + _scratchX, Ocherry.y - 200, "bullets", Oscratch)) {
	            if(!other.transform)
				{
					sprite_index = Sscratch1;
					damage = 10;
				}
			    else 
				{
					sprite_index = SscratchP1;
					damage = 15;
				}
	            image_xscale = other.face;
	        }
        
	        // Play attack 1 sound
	        audio_sound_pitch(SNsword, random_range(0.9, 0.8));
	        audio_play_sound(SNsword, 1, false);
	    }
	}

	// ATTACK 1 ACTIVE
	if (attack1 && attack_timer > 0) {
	    if (combo_window_timer == 0) {
	        if (LMB && !queued_attack2) {
	            queued_attack2 = true;
	        }
	    }
	}

	// ATTACK 1 FINISHED
	if (attack1 && attack_timer == 0) {
	    attack1 = false;
    
	    if (queued_attack2) {
	        attack2 = true;
	        attack2_started = true;
	        attack_timer = attack2_duration;
	        combo_window_timer = combo_window_start;
	        queued_attack2 = false;
        
	        if (face == 1) var _scratchX = 200;
	        if (face == -1) var _scratchX = -200;
	        with(instance_create_layer(Ocherry.x + _scratchX, Ocherry.y - 180, "bullets", Oscratch)) {
	            if(!other.transform)
				{
					sprite_index = Sscratch2;
					damage = 10;
				}
			    else 
				{
					sprite_index = SscratchP2;
					damage = 15;
				}
	            image_xscale = other.face;
	        }
        
	        audio_sound_pitch(SNsword, random_range(0.9, 0.8));
	        audio_play_sound(SNsword, 1, false);
	    } else {
	        cooldown_timer = cooldown_duration;
	    }
	}

	// ATTACK 2 ACTIVE
	if (attack2 && attack_timer > 0) {
	    if (combo_window_timer == 0) {
	        if (LMB && !queued_attack3) {
	            queued_attack3 = true;
	        }
	    }
	}

	// ATTACK 2 FINISHED
	if (attack2 && attack_timer == 0) {
	    attack2 = false;
    
	    if (queued_attack3) {
	        attack3 = true;
	        attack3_started = true;
	        attack_timer = attack3_duration;
	        queued_attack3 = false;
        
	        if (face == 1) var _scratchX = 245;
	        if (face == -1) var _scratchX = -245;
	        with(instance_create_layer(Ocherry.x + _scratchX, Ocherry.y - 225, "bullets", Oscratch)) {
	            if(!other.transform)
				{
					sprite_index = Sscratch3;
					damage = 10;
				}
			    else 
				{
					sprite_index = SscratchP3;
					damage = 15;
				}
	            image_xscale = other.face;
	        }
        
	        audio_sound_pitch(SNsword, random_range(0.9, 0.8));
	        audio_play_sound(SNsword, 1, false);
	    } else {
	        cooldown_timer = cooldown_duration;
	    }
	}

	// ATTACK 3 ACTIVE
	if (attack3 && attack_timer > 0) {
	    // Attack 3 is playing
	}

	// ATTACK 3 FINISHED
	if (attack3 && attack_timer == 0) {
	    attack3 = false;
	    cooldown_timer = cooldown_duration;
	}
	
	//use ability to bring back the scratchs 
	// Check if E is pressed
	if (room != Ressance) and (super) and (!transforming) and (!transform) and (ObloodPar.blood >= ObloodPar.fullBlood/10) and (ObloodPar.blood != 0)
	{
		transforming = true;
		image_index = 0;
	}
	//loose blood when transforming
	if(transform)
	{
		ObloodPar.blood -= 0.14;
	}
	if(instance_exists(ObloodPar))
	{
		if(ObloodPar.blood <= 0)
		{
			transform = false;
		}
	}
	//damage to enemies
	if(damage) and (damage_timer)
	{
		damage_time--;
		if(damage_time <= 0)
		{
			damage_time = damageT;
			damage_timer = false
		}
	}
	
	//transforming effect
	if(transform) and (sprite_index == SPwerewolfSP) and (!instance_exists(Otransform))
	{
		instance_create_layer(x,y-150,"bullets",Otransform);
		audio_sound_pitch(SNexplotion2,random_range(1.1,1.2));
		audio_play_sound(SNexplotion2, 3, false);
	}
	// horizantol collision
	var _subpixel = 0.5;
	if (place_meeting(x + hsp,y,Owall))
	{
		//check for slopes
		if (!place_meeting(x + hsp,y - abs(hsp)-1,Owall))
		{
			while (place_meeting(x + hsp,y,Owall)) {y -= _subpixel;}
		}
		//check for collision
		else
		{
			//ceiling slopes
			if (!place_meeting(x + hsp,y + abs(hsp)+1,Owall))
			{
				while (place_meeting(x + hsp,y,Owall)) {y += _subpixel;}
			}
			//normal collison
			else
			{
				var _pixel_check = _subpixel * sign(hsp);
				while (!place_meeting(x + _pixel_check,y,Owall)) {x += _pixel_check;}	
				hsp = 0;
			}
		}
	}

	//going down slopes
	downSlopesSemiSolid = noone;
	if ((vsp >= 0) and (!place_meeting(x + hsp,y+1,Owall)) and (place_meeting(x + hsp,y + abs(hsp)+1,Owall)))
	{
		//check for semisolid platform in the way
		downSlopesSemiSolid = ssplat_check(x +	hsp,y + abs(hsp)+1)
		//precisly move down slopes if there is no semisolid plat
		if (!instance_exists(downSlopesSemiSolid))
		{
			while (!place_meeting(x + hsp, y + _subpixel,Owall)) {y += _subpixel}
		}
	}

	//move
	x += hsp;

	//vertical collision
	//up collisions
	if (vsp< 0) and (place_meeting(x,y + vsp,Owall))
	{
		//scoot up to the wall precisely
		var _pixel_check = _subpixel * sign(vsp);
		while (!place_meeting(x,y + _subpixel,Owall))
		{
			y += _pixel_check;
		}
		//bonk (OPTINAL)
		//if (vsp < 0) {JHF = 0;}
		vsp = 1;
	}

	//down collisions
	//check semisolid and moving semisolid platform
	var _clampYspd = max(0,vsp);
	var _list = ds_list_create(); //create a ds list to store all of the objects we run into
	var _array = array_create(0);
	array_push(_array,Owall,Ossplat);

	//check and add objects to the list
	var _listsize = instance_place_list(x,y+1 + _clampYspd + MovingPlatMaxYspd,_array,_list,false);

	//check for semisolid platform blow
	var _ycheck = y+1 + _clampYspd;
	if (instance_exists(MyFloorPlat)) {_ycheck += max(0, MyFloorPlat.vsp);}
	var _semisolid = ssplat_check(x,_ycheck);

	//loop throw all colliding istance
	for (var i = 0; i < _listsize; i++)
	{
		//get and instance of Owall or semisolidplat from the list
		var _listinst = _list[| i]; //comeback
			
		//avoid magnetism
		if ( (_listinst != forgetssp)
		and (_listinst.vsp <= vsp or instance_exists(MyFloorPlat))
		and (_listinst.vsp > 0 or place_meeting(x,y+1 + _clampYspd,_listinst)) )
		or (_listinst == _semisolid)
		{
			//return any solid wall or any semisolidplat below the player
			if((_listinst.object_index == Owall) or (object_is_ancestor(_listinst.object_index, Owall))
			or (floor(bbox_bottom) <= ceil(_listinst.bbox_top - _listinst.vsp)))
			{
				//return the HIGHEST wall object
				if ((!instance_exists(MyFloorPlat))
				or (_listinst.bbox_top + _listinst.vsp <= MyFloorPlat.bbox_top + MyFloorPlat.vsp)
				or (_listinst.bbox_top + _listinst.vsp <= bbox_bottom))
				{
					MyFloorPlat = _listinst;
				}
			}
		}
	}
	//destroy ds list to avoid memory leak
	ds_list_destroy(_list);

	//check for down slopes semisolid
	if (instance_exists(downSlopesSemiSolid)) {MyFloorPlat = downSlopesSemiSolid;}

	//last check for the platform is below us
	if (instance_exists(MyFloorPlat) and (!place_meeting(x,y + MovingPlatMaxYspd,MyFloorPlat)))
	{
		MyFloorPlat = noone; 
	}
	//land on platform if exist
	if(instance_exists(MyFloorPlat))
	{
		//scoot up to the flatform precily
		var _subpixel = 0.5;
		while((!place_meeting(x,y + _subpixel,MyFloorPlat)) and (!place_meeting(x,y,Owall))) {y += _subpixel}
	
		//make sure we dont end up below  the top of the semisolidplat
		if ((MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index,Ossplat)))
		{
			while (place_meeting(x,y,MyFloorPlat)) {y -= _subpixel;}
		}
		y = floor(y)
		
		//collide with the ground
		vsp = 0;
		onground(true);
	}


	//manually fall through semisolid platrform
	if (down) and (jump)
	{
		//make sure we have a semisolid platform
		if (instance_exists(MyFloorPlat))
		and (MyFloorPlat.object_index == Ossplat or object_is_ancestor(MyFloorPlat.object_index,Ossplat))
		{
			//check if we can go down the semisolid platform
			var _ycheck = max(1,MyFloorPlat.vsp+1);
			if (!place_meeting(x,y + _ycheck,Owall))
			{
				//move below the platform
				y += 1;
				//inheret platform downward movment
				vsp = _ycheck-1;
				//forget the platform
				forgetssp = MyFloorPlat;
				onground(false);
			}
		}
	}

	//reset forgetssp veriable
	if (instance_exists(forgetssp)) and (!place_meeting(x,y,forgetssp))
	{
		forgetssp = noone;
	}
	//move
	if !place_meeting(x,y + vsp,Owall) { y += vsp;}

	//final moving platform collision and movment 
	//X - MoveingPlatXspd and collison
	MovingPlatXspd = 0; 
	if instance_exists(MyFloorPlat) {MovingPlatXspd = MyFloorPlat.hsp;}

	//move with MovingPlatXspd
	if (!empXspd)
	{
		if place_meeting(x + MovingPlatXspd,y,Owall)
		{
			//scoot up the wall precisely
			var _subpixel = 0.5;
			var _pixel_check = _subpixel * sign(MovingPlatXspd);
			while (!place_meeting(x + _subpixel,y,Owall)) {x += _pixel_check;}
	
			//set MovingPlatXspd to 0
			MovingPlatXspd = 0;
		}

		//moving 
		x += MovingPlatXspd;
	}

	//Y - snap to moving semisolid platform
	if (instance_exists(MyFloorPlat)) and (MyFloorPlat.vsp != 0)
	{
		//snap to the top of the platform 
		if (!place_meeting(x,MyFloorPlat.bbox_top,Owall))
		and (MyFloorPlat.bbox_top >= bbox_bottom-MovingPlatMaxYspd)
		{
			y = MyFloorPlat.bbox_top; //un-floor the Y
		}
	
							/*
							//going up a solid solid wall
							if (MyFloorPlat.vsp < 0) and (place_meeting(x,y + MyFloorPlat.vsp,Owall))
							{
								//check to for going throw semisolid platform
								if (MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index, Ossplat))
								{
									//go throw the semisolid platform
									var _subpixel = 0.25;
									while (place_meeting(x,y + MyFloorPlat.vsp,Owall)) { y += _subpixel;}
		
									//if we got pushes into a solid wall, push ourselfs back out
									while (place_meeting(x,y,Owall)) {y -= _subpixel}
									y = round(y);
								}
								//cancel the platform variable
								onground(false);
							}
							*/
	}

	//get pushed down a semisolid by a moving platform
	if (instance_exists(MyFloorPlat))
	and ( (MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index,Ossplat)) )
	and (place_meeting(x,y,Owall))
	{
		//check for moving plarform
		//add crush later
		//dont check too far so we dont warp 
		var _maxPushDist = 20;
		var _pushedDist = 0;
		var _startY = y;
		while (place_meeting(x,y,Owall)) and (_pushedDist <= _maxPushDist)
		{
			y++;
			_pushedDist++;
		}
		//forget myfloorplat
		MyFloorPlat = noone;
	
		//if crushed, go back
		if	(_pushedDist > _maxPushDist) {y = _startY;}
	}
}

STATE_DASH = function()
{
	dashing = true;
	//move via the dash
	hsp = lengthdir_x(dashSPD,dashDirection);
	vsp = lengthdir_y(dashSPD,dashDirection);
	

	if (trail_timer <= 0)
		{
		    // Create trail further behind (32 pixels instead of 16)
		    var trail_x = x - lengthdir_x(32, pokeDircation);
		    var trail_y = y - lengthdir_y(32, pokeDircation);
    
		    with (instance_create_depth(trail_x, trail_y, depth+1, Otrail))
		    {
		        sprite_index = other.sprite_index;
		        image_xscale = other.face;
		        image_blend = c_aqua;
		        image_alpha = 0.6;
        
		        fade_speed = 0.08; // Faster fade
		    }
    
		    trail_timer = 4; // Create trail every x frames
		}
		trail_timer--;
		DJtimer--;

	
	// horizantol collision
	var _subpixel = 0.5;
	if (place_meeting(x + hsp,y,Owall))
	{
		//check for slopes
		if (!place_meeting(x + hsp,y - abs(hsp)-1,Owall))
		{
			while (place_meeting(x + hsp,y,Owall)) {y -= _subpixel;}
		}
		//check for collision
		else
		{
			//ceiling slopes
			if (!place_meeting(x + hsp,y + abs(hsp)+1,Owall))
			{
				while (place_meeting(x + hsp,y,Owall)) {y += _subpixel;}
			}
			//normal collison
			else
			{
				var _pixel_check = _subpixel * sign(hsp);
				while (!place_meeting(x + _pixel_check,y,Owall)) {x += _pixel_check;}	
				hsp = 0;
			}
		}
	}

	//going down slopes
	downSlopesSemiSolid = noone;
	if ((vsp >= 0) and (!place_meeting(x + hsp,y+1,Owall)) and (place_meeting(x + hsp,y + abs(hsp)+1,Owall)))
	{
		//check for semisolid platform in the way
		downSlopesSemiSolid = ssplat_check(x +	hsp,y + abs(hsp)+1)
		//precisly move down slopes if there is no semisolid plat
		if (!instance_exists(downSlopesSemiSolid))
		{
			while (!place_meeting(x + hsp, y + _subpixel,Owall)) {y += _subpixel}
		}
	}

	//move
	x += hsp;

	//vertical collision
	//up collisions
	if ((vsp< 0) and (place_meeting(x,y + vsp,Owall)))
	{
		//scoot up to the wall precisely
		var _pixel_check = _subpixel * sign(vsp);
		while (!place_meeting(x,y + _subpixel,Owall))
		{
			y += _pixel_check;
		}
		//bonk (OPTINAL)
		//if (vsp < 0) {JHF = 0;}
		vsp = 1;
	}

	//down collisions
	//check semisolid and moving semisolid platform
	var _clampYspd = max(0,vsp);
	var _list = ds_list_create(); //create a ds list to store all of the objects we run into
	var _array = array_create(0);
	array_push(_array,Owall,Ossplat);

	//check and add objects to the list
	var _listsize = instance_place_list(x,y+1 + _clampYspd + MovingPlatMaxYspd,_array,_list,false);

	//check for semisolid platform blow
	var _ycheck = y+1 + _clampYspd;
	if (instance_exists(MyFloorPlat)) {_ycheck += max(0, MyFloorPlat.vsp);}
	var _semisolid = ssplat_check(x,_ycheck);

	//loop throw all colliding istance
	for (var i = 0; i < _listsize; i++)
	{
		//get and instance of Owall or semisolidplat from the list
		var _listinst = _list[| i]; //comeback
			
		//avoid magnetism
		if ( (_listinst != forgetssp)
		and (_listinst.vsp <= vsp or instance_exists(MyFloorPlat))
		and (_listinst.vsp > 0 or place_meeting(x,y+1 + _clampYspd,_listinst)) )
		or (_listinst == _semisolid)
		{
			//return any solid wall or any semisolidplat below the player
			if((_listinst.object_index == Owall) or (object_is_ancestor(_listinst.object_index, Owall))
			or (floor(bbox_bottom) <= ceil(_listinst.bbox_top - _listinst.vsp)))
			{
				//return the HIGHEST wall object
				if ((!instance_exists(MyFloorPlat))
				or (_listinst.bbox_top + _listinst.vsp <= MyFloorPlat.bbox_top + MyFloorPlat.vsp)
				or (_listinst.bbox_top + _listinst.vsp <= bbox_bottom))
				{
					MyFloorPlat = _listinst;
				}
			}
		}
	}
	//destroy ds list to avoid memory leak
	ds_list_destroy(_list);

	//check for down slopes semisolid
	if (instance_exists(downSlopesSemiSolid)) {MyFloorPlat = downSlopesSemiSolid;}

	//last check for the platform is below us
	if (instance_exists(MyFloorPlat) and (!place_meeting(x,y + MovingPlatMaxYspd,MyFloorPlat)))
	{
		MyFloorPlat = noone; 
	}
	//land on platform if exist
	if(instance_exists(MyFloorPlat))
	{
		//scoot up to the flatform precily
		var _subpixel = 0.5;
		while((!place_meeting(x,y + _subpixel,MyFloorPlat)) and (!place_meeting(x,y,Owall))) {y += _subpixel}
	
		//make sure we dont end up below  the top of the semisolidplat
		if ((MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index,Ossplat)))
		{
			while (place_meeting(x,y,MyFloorPlat)) {y -= _subpixel;}
		}
		y = floor(y)
		
		//collide with the ground
		vsp = 0;
		onground(true);
	}


	//manually fall through semisolid platrform
	if (down) and (jump)
	{
		//make sure we have a semisolid platform
		if (instance_exists(MyFloorPlat))
		and (MyFloorPlat.object_index == Ossplat or object_is_ancestor(MyFloorPlat.object_index,Ossplat))
		{
			//check if we can go down the semisolid platform
			var _ycheck = max(1,MyFloorPlat.vsp+1);
			if (!place_meeting(x,y + _ycheck,Owall))
			{
				//move below the platform
				y += 1;
				//inheret platform downward movment
				vsp = _ycheck-1;
				//forget the platform
				forgetssp = MyFloorPlat;
				onground(false);
			}
		}
	}

	//reset forgetssp veriable
	if (instance_exists(forgetssp)) and (!place_meeting(x,y,forgetssp))
	{
		forgetssp = noone;
	}
	//move
	if !place_meeting(x,y + vsp,Owall) { y += vsp;}

	//final moving platform collision and movment 
	//X - MoveingPlatXspd and collison
	MovingPlatXspd = 0; 
	if instance_exists(MyFloorPlat) {MovingPlatXspd = MyFloorPlat.hsp;}

	//move with MovingPlatXspd
	if (!empXspd)
	{
		if place_meeting(x + MovingPlatXspd,y,Owall)
		{
			//scoot up the wall precisely
			var _subpixel = 0.5;
			var _pixel_check = _subpixel * sign(MovingPlatXspd);
			while (!place_meeting(x + _subpixel,y,Owall)) {x += _pixel_check;}
	
			//set MovingPlatXspd to 0
			MovingPlatXspd = 0;
		}

		//moving 
		x += MovingPlatXspd;
	}

	//Y - snap to moving semisolid platform
	if (instance_exists(MyFloorPlat)) and (MyFloorPlat.vsp != 0)
	{
		//snap to the top of the platform 
		if (!place_meeting(x,MyFloorPlat.bbox_top,Owall))
		and (MyFloorPlat.bbox_top >= bbox_bottom-MovingPlatMaxYspd)
		{
			y = MyFloorPlat.bbox_top; //un-floor the Y
		}
	
							/*
							//going up a solid solid wall
							if (MyFloorPlat.vsp < 0) and (place_meeting(x,y + MyFloorPlat.vsp,Owall))
							{
								//check to for going throw semisolid platform
								if (MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index, Ossplat))
								{
									//go throw the semisolid platform
									var _subpixel = 0.25;
									while (place_meeting(x,y + MyFloorPlat.vsp,Owall)) { y += _subpixel;}
		
									//if we got pushes into a solid wall, push ourselfs back out
									while (place_meeting(x,y,Owall)) {y -= _subpixel}
									y = round(y);
								}
								//cancel the platform variable
								onground(false);
							}
							*/
	}

	//get pushed down a semisolid by a moving platform
	if (instance_exists(MyFloorPlat))
	and ( (MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index,Ossplat)) )
	and (place_meeting(x,y,Owall))
	{
		//check for moving plarform
		//add crush later
		//dont check too far so we dont warp 
		var _maxPushDist = 10;
		var _pushedDist = 0;
		var _startY = y;
		while (place_meeting(x,y,Owall)) and (_pushedDist <= _maxPushDist)
		{
			y++;
			_pushedDist++;
		}
		//forget myfloorplat
		MyFloorPlat = noone;
	
		//if crushed, go back
		if	(_pushedDist > _maxPushDist) {y = _startY;}
	}
	
	//ending the dash
	dashEnergy -= dashSPD;
	if (dashEnergy <= 0)
	{
		vsp -= 2.5;
		STATE = STATE_FREE;
		damage_timer = true;
	}
}

STATE_POKE = function()
{
	poking = true;
	//move via the dash
	hsp = lengthdir_x(pokeSPD,pokeDircation);
	vsp = lengthdir_y(pokeSPD,pokeDircation);
	
	// Poke trail effect - create fading trail instances
	// Only create trail every few frames to reduce density
	if (trail_timer <= 0)
	{
	    var _face_dir = (pokeDircation > 90 and pokeDircation < 270) ? -1 : 1;
    
	    // Create trail further behind (32 pixels instead of 16)
	    var trail_x = x - lengthdir_x(32, pokeDircation);
	    var trail_y = y - lengthdir_y(32, pokeDircation);
    
	    with (instance_create_depth(trail_x, trail_y, depth+1, Otrail))
	    {
	        sprite_index = other.sprite_index;
	        image_xscale = _face_dir;
	        image_blend = c_purple;
	        image_alpha = 0.6;
        
	        fade_speed = 0.08; // Faster fade
	    }
    
	    poke_trail_timer = 3; // Create trail every x frames
	}

	trail_timer--;
	
	// horizantol collision
	var _subpixel = 0.5;
	if (place_meeting(x + hsp,y,Owall))
	{
		//check for slopes
		if (!place_meeting(x + hsp,y - abs(hsp)-1,Owall))
		{
			while (place_meeting(x + hsp,y,Owall)) {y -= _subpixel;}
		}
		//check for collision
		else
		{
			//ceiling slopes
			if (!place_meeting(x + hsp,y + abs(hsp)+1,Owall))
			{
				while (place_meeting(x + hsp,y,Owall)) {y += _subpixel;}
			}
			//normal collison
			else
			{
				var _pixel_check = _subpixel * sign(hsp);
				while (!place_meeting(x + _pixel_check,y,Owall)) {x += _pixel_check;}	
				hsp = 0;
			}
		}
	}

	//going down slopes
	downSlopesSemiSolid = noone;
	if ((vsp >= 0) and (!place_meeting(x + hsp,y+1,Owall)) and (place_meeting(x + hsp,y + abs(hsp)+1,Owall)))
	{
		//check for semisolid platform in the way
		downSlopesSemiSolid = ssplat_check(x +	hsp,y + abs(hsp)+1)
		//precisly move down slopes if there is no semisolid plat
		if (!instance_exists(downSlopesSemiSolid))
		{
			while (!place_meeting(x + hsp, y + _subpixel,Owall)) {y += _subpixel}
		}
	}

	//move
	x += hsp;

	//vertical collision
	//up collisions
	if ((vsp< 0) and (place_meeting(x,y + vsp,Owall)))
	{
		//scoot up to the wall precisely
		var _pixel_check = _subpixel * sign(vsp);
		while (!place_meeting(x,y + _subpixel,Owall))
		{
			y += _pixel_check;
		}
		//bonk (OPTINAL)
		//if (vsp < 0) {JHF = 0;}
		vsp = 1;
	}

	//down collisions
	//check semisolid and moving semisolid platform
	var _clampYspd = max(0,vsp);
	var _list = ds_list_create(); //create a ds list to store all of the objects we run into
	var _array = array_create(0);
	array_push(_array,Owall,Ossplat);

	//check and add objects to the list
	var _listsize = instance_place_list(x,y+1 + _clampYspd + MovingPlatMaxYspd,_array,_list,false);

	//check for semisolid platform blow
	var _ycheck = y+1 + _clampYspd;
	if (instance_exists(MyFloorPlat)) {_ycheck += max(0, MyFloorPlat.vsp);}
	var _semisolid = ssplat_check(x,_ycheck);

	//loop throw all colliding istance
	for (var i = 0; i < _listsize; i++)
	{
		//get and instance of Owall or semisolidplat from the list
		var _listinst = _list[| i]; //comeback
			
		//avoid magnetism
		if ( (_listinst != forgetssp)
		and (_listinst.vsp <= vsp or instance_exists(MyFloorPlat))
		and (_listinst.vsp > 0 or place_meeting(x,y+1 + _clampYspd,_listinst)) )
		or (_listinst == _semisolid)
		{
			//return any solid wall or any semisolidplat below the player
			if((_listinst.object_index == Owall) or (object_is_ancestor(_listinst.object_index, Owall))
			or (floor(bbox_bottom) <= ceil(_listinst.bbox_top - _listinst.vsp)))
			{
				//return the HIGHEST wall object
				if ((!instance_exists(MyFloorPlat))
				or (_listinst.bbox_top + _listinst.vsp <= MyFloorPlat.bbox_top + MyFloorPlat.vsp)
				or (_listinst.bbox_top + _listinst.vsp <= bbox_bottom))
				{
					MyFloorPlat = _listinst;
				}
			}
		}
	}
	//destroy ds list to avoid memory leak
	ds_list_destroy(_list);

	//check for down slopes semisolid
	if (instance_exists(downSlopesSemiSolid)) {MyFloorPlat = downSlopesSemiSolid;}

	//last check for the platform is below us
	if (instance_exists(MyFloorPlat) and (!place_meeting(x,y + MovingPlatMaxYspd,MyFloorPlat)))
	{
		MyFloorPlat = noone; 
	}
	//land on platform if exist
	if(instance_exists(MyFloorPlat))
	{
		//scoot up to the flatform precily
		var _subpixel = 0.5;
		while((!place_meeting(x,y + _subpixel,MyFloorPlat)) and (!place_meeting(x,y,Owall))) {y += _subpixel}
	
		//make sure we dont end up below  the top of the semisolidplat
		if ((MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index,Ossplat)))
		{
			while (place_meeting(x,y,MyFloorPlat)) {y -= _subpixel;}
		}
		y = floor(y)
		
		//collide with the ground
		vsp = 0;
		onground(true);
	}


	//manually fall through semisolid platrform
	if (down) and (jump)
	{
		//make sure we have a semisolid platform
		if (instance_exists(MyFloorPlat))
		and (MyFloorPlat.object_index == Ossplat or object_is_ancestor(MyFloorPlat.object_index,Ossplat))
		{
			//check if we can go down the semisolid platform
			var _ycheck = max(1,MyFloorPlat.vsp+1);
			if (!place_meeting(x,y + _ycheck,Owall))
			{
				//move below the platform
				y += 1;
				//inheret platform downward movment
				vsp = _ycheck-1;
				//forget the platform
				forgetssp = MyFloorPlat;
				onground(false);
			}
		}
	}

	//reset forgetssp veriable
	if (instance_exists(forgetssp)) and (!place_meeting(x,y,forgetssp))
	{
		forgetssp = noone;
	}
	//move
	if !place_meeting(x,y + vsp,Owall) { y += vsp;}

	//final moving platform collision and movment 
	//X - MoveingPlatXspd and collison
	MovingPlatXspd = 0; 
	if instance_exists(MyFloorPlat) {MovingPlatXspd = MyFloorPlat.hsp;}

	//move with MovingPlatXspd
	if (!empXspd)
	{
		if place_meeting(x + MovingPlatXspd,y,Owall)
		{
			//scoot up the wall precisely
			var _subpixel = 0.5;
			var _pixel_check = _subpixel * sign(MovingPlatXspd);
			while (!place_meeting(x + _subpixel,y,Owall)) {x += _pixel_check;}
	
			//set MovingPlatXspd to 0
			MovingPlatXspd = 0;
		}

		//moving 
		x += MovingPlatXspd;
	}

	//Y - snap to moving semisolid platform
	if (instance_exists(MyFloorPlat)) and (MyFloorPlat.vsp != 0)
	{
		//snap to the top of the platform 
		if (!place_meeting(x,MyFloorPlat.bbox_top,Owall))
		and (MyFloorPlat.bbox_top >= bbox_bottom-MovingPlatMaxYspd)
		{
			y = MyFloorPlat.bbox_top; //un-floor the Y
		}
	
							/*
							//going up a solid solid wall
							if (MyFloorPlat.vsp < 0) and (place_meeting(x,y + MyFloorPlat.vsp,Owall))
							{
								//check to for going throw semisolid platform
								if (MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index, Ossplat))
								{
									//go throw the semisolid platform
									var _subpixel = 0.25;
									while (place_meeting(x,y + MyFloorPlat.vsp,Owall)) { y += _subpixel;}
		
									//if we got pushes into a solid wall, push ourselfs back out
									while (place_meeting(x,y,Owall)) {y -= _subpixel}
									y = round(y);
								}
								//cancel the platform variable
								onground(false);
							}
							*/
	}

	//get pushed down a semisolid by a moving platform
	if (instance_exists(MyFloorPlat))
	and ( (MyFloorPlat.object_index == Ossplat) or (object_is_ancestor(MyFloorPlat.object_index,Ossplat)) )
	and (place_meeting(x,y,Owall))
	{
		//check for moving plarform
		//add crush later
		//dont check too far so we dont warp 
		var _maxPushDist = 10;
		var _pushedDist = 0;
		var _startY = y;
		while (place_meeting(x,y,Owall)) and (_pushedDist <= _maxPushDist)
		{
			y++;
			_pushedDist++;
		}
		//forget myfloorplat
		MyFloorPlat = noone;
	
		//if crushed, go back
		if	(_pushedDist > _maxPushDist) {y = _startY;}
	}
	
	//ending the dash
	pokeEnergy -= pokeSPD;
	if (pokeEnergy <= 0)
	{
		vsp -= 2.5;
		STATE = STATE_FREE;
		POtimer = true;
		damage_timer = true;
	}
}

STATE_PAUSE = function()
{
	Cpause = true;
	hsp = 0;
	vsp = 0; 
	grv = 0;
}

STATE_FUSE = function()
{
	Cpause = true;
	hsp = 0;
	vsp = 0; 
	grv = 0;
}

STATE_DEAD = function() {
    hasControl = false;
    hsp = 0;
    vsp = 0;
    grv = 0;
    
    // Deduct flowers from current attempt
    global.flower -= global.flowers_collected_this_room;
    
    // Clear temporary collection (makes flowers collectible again)
    ds_list_clear(global.temp_flowers);
    global.flowers_collected_this_room = 0;
    
    //screen shake
    screenShake(20,6);
    
    //transition
    if (image_index >= 5) and (sprite_index == SwerewolfD or sprite_index == SPwerewolfD) and (!death_transition_done) {
        death_transition_done = true;
        
        // Reset kill counter to room start value
        if (instance_exists(Ogame)) {
            global.kill_counter = Ogame.room_start_kill_count;
        }
        
        TRANS(TRANS_MODE.AGAIN,"strawberry");
        
        if (global.has_checkpoint) {
            // Respawn at checkpoint
            x = global.spawn_x;
            y = global.spawn_y;
        } else {
            // Respawn at level start
            x = xstart;
            y = ystart;
        }
        
        // Reset temporary progress
        if (!global.has_checkpoint) {
            global.flower -= global.flowers_collected_this_room;
        }
        ds_list_clear(global.temp_flowers);
        global.flowers_collected_this_room = 0;
    }
}


STATE = STATE_FREE; 

// Death transition flag
death_transition_done = false; 