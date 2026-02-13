/// @description player veriables | cherry create
//input setop
input_setup();

// Initialize debug variables
global.show_collision_mask = false;


//effects 
trail_timer = 0;

//health
hp = 100;
hitstun_time = 0; // frames of stun / invincibility after taking damage

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
pause = false;

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
JHF[0] = 15;
jumpSP[0] = -30;



timer = false;
time = 10;

// Sliding system
sliding_ground = false;
sliding_started = false;
sliding_duration = 30; // How long the slide lasts (in frames)
sliding_timer = 0;
sliding_speed = 70; // Initial sliding speed
sliding_decel = 0.6; // How much speed to lose per frame (deceleration)
sliding_cooldown = 0; // Cooldown timer
sliding_cooldown_max = 30; // Cooldown duration (1 second at 60fps)

//dash 
dashing = false;
canDash = false;
dashDistance = 800; //min 400 max 800
dashTime = 10;
water_dash = false;
water_push = false;
dashDirection = 0;
dashEnergy = 0;
bananaF = noone;
follow_banana = noone;

dashed = false;
dashT = 180; //min 60 max 180
dash_cooldown = dashT;

//attacking
attack = false; // Main attack flag for collision detection
attack1 = false;
attack2 = false;
attack3 = false;
attack_crouch = false;
attack_air = false;
queued_attack2 = false;
queued_attack3 = false;
attack_timer = 0;
cooldown_timer = 0;
combo_window_timer = 0;
attack1_started = false;
attack2_started = false;
attack3_started = false;
attack_crouch_started = false;
attack_air_started = false;
attack1_duration = 20; // 4 frames at 12fps (4 * 60/12 = 20)
attack2_duration = 20; // 4 frames at 12fps (4 * 60/12 = 20)
attack3_duration = 25; // 5 frames at 12fps (5* 60/12 = 25)
attack_crouch_duration = 25; //5 frames at 12fps (5 * 60/12 = 25)
attack_air_duration = 25; //5 frames at 12fps (5 * 60/12 = 25)
cooldown_duration = 30; // Cooldown after combo ends
combo_window_start = 5; // Combo window opens after 5 frames

//hold attack
hold_attack = false;
hold_time = 0;
hold_max = 50; 


// Blocking system
blocking = false;
block_deflect = false;
block_deflect_started = false;
block_deflect_duration = 25; // 5 frames at 12fps (5 * 60/12 = 25)
block_deflect_timer = 0;
block_blade_created = false; // Track if blade was created this block
damage_blocked = false; // Track if last hit was blocked (for red flash intensity)

// Spell system
//icons
icon1 = false;
icon2 = false;
icon3 = false;
iconD = false;
// Base spell stats (level 0 values)
base_max_blood = 50; // Starting max blood at level 0
base_spell_damage_multiplier = 1.0; // Base spell damage

// Current spell stats
current_max_blood = base_max_blood;
current_spell_damage_multiplier = base_spell_damage_multiplier;

// Upgrade increments
max_blood_per_level = 90; // +90 per level (50 -> 140 -> 230 -> 320 -> 410 -> 500)
spell_damage_boost_per_level = 1.0; // +100% damage per level at levels 4 and 5

spell1_active = false;
spell1_started = false;
spell1_duration = 45; // 9 frames at 12fps (9 * 60/12 = 45)
spell1_timer = 0;
spell1_cooldown = 0;
spell1_cooldown_max = 180; // 3 seconds at 60fps

spell2_active = false;
spell2_started = false;
spell2_duration = 80; // 16 frames at 12fps (16 * 60/12 = 80)
spell2_timer = 0;
spell2_cooldown = 0;
spell2_cooldown_max = 300; // 5 seconds at 60fps

spell3_active = false;
spell3_started = false;
spell3_duration = 90; // 15 frames at 12fps (18 * 60/12 = 90)
spell4_duration = 110; // 22 frames at 12fps (22 * 60/12 = 110)
spell3_timer = 0;
spell3_cooldown = 0;
spell3_cooldown_max = 420; // 7 seconds at 60fps

spell_attack_frame1 = 25; // Frame 5 at 12fps (5 * 60/12 = 25)
spell_attack_frame2 = 10; // Frame 2 at 12fps (2 * 60/12 = 10)
spell_attack_frame3 = 60; // Frame 12 at 12fps (12 * 60/12 = 60)
spell_attack_frame4 = 70; // Frame 14 at 12fps (14 * 60/12 = 70)


spell1_attacked = false;
spell2_attacked = false;
spell3_attacked = false;

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


// LEVEL SYSTEM
player_level = 0;
max_level = 25;
available_upgrade_points = 0;

//fire modes 
fire_mode = false;
fire_range = false;
fire_dash = false;
fire_spells = false;
fire_defence = false;

// Upgrade categories (0-5 each)
upgrade_attack = 0;
upgrade_speed = 0;
upgrade_range = 0;
upgrade_defence = 0;
upgrade_spell = 0;

max_upgrade_level = 5;

// Base stats (level 0 values)
base_damage = 10;
base_speed = 25;
base_run_speed = 35;
base_range = 1.0; // Multiplier for attack range
base_defence = 0; // Damage reduction
base_spell_power = 1.0; // Spell damage multiplier
base_spell_cooldown = 1.0; // Spell cooldown multiplier

// Current stats (calculated from base + upgrades)
current_damage = base_damage;
current_speed = base_speed;
current_run_speed = base_run_speed;
current_range = base_range;
current_defence = base_defence;
current_spell_power = base_spell_power;
current_spell_cooldown = base_spell_cooldown;

// Upgrade increments (how much each upgrade level adds)
attack_damage_per_level = 5; // +5 damage per level
speed_boost_per_level = 3; // +3 speed per level
run_speed_boost_per_level = 5; // +5 run speed per level
range_multiplier_per_level = 0.2; // +20% range per level
defence_reduction_per_level = 2; // -2 damage taken per level (max 10 reduction at level 5)
spell_power_per_level = 0.3; // +30% spell damage per level
spell_cooldown_reduction_per_level = 0.15; // -15% cooldown per level (max 75% reduction)

// Function to level up
level_up = function() {
    if (player_level < max_level) {
        player_level++;
        available_upgrade_points++;
        
        // Show upgrade cards
        if (instance_exists(Ogame)) {
            Ogame.show_upgrade_cards();
        }
        
        // Play level up sound/effect
        // audio_play_sound(SNlevelup, 1, false);
        
        return true;
    }
    return false;
}

// Function to upgrade a specific stat
upgrade_stat = function(_stat_type) {
    if (available_upgrade_points <= 0) return false;
    
    var upgraded = false;
    
    switch(_stat_type) {
        case "attack":
            if (upgrade_attack < max_upgrade_level) {
                upgrade_attack++;
                upgraded = true;
            }
            break;
            
        case "speed":
            if (upgrade_speed < max_upgrade_level) {
                upgrade_speed++;
                upgraded = true;
            }
            break;
            
        case "range":
            if (upgrade_range < max_upgrade_level) {
                upgrade_range++;
                upgraded = true;
            }
            break;
            
        case "defence":
            if (upgrade_defence < max_upgrade_level) {
                upgrade_defence++;
                upgraded = true;
            }
            break;
            
        case "spell":
            if (upgrade_spell < max_upgrade_level) {
                upgrade_spell++;
                upgraded = true;
            }
            break;
    }
    
    if (upgraded) {
        available_upgrade_points--;
        
        // Add to upgrade history
        array_push(global.upgrade_history, _stat_type);
        
        calculate_stats(); // Recalculate all stats
        
        // Save progress after upgrading
        if (instance_exists(Ogame)) {
            global.save_progress();
        }
        
        return true;
    }
    
    return false;
}

// Function to calculate current stats based on upgrades
calculate_stats = function() {
    // Attack damage
    current_damage = base_damage + (upgrade_attack * attack_damage_per_level);
    
    // Speed - Scale from min to max based on upgrade level
    var speed_progress = upgrade_speed / max_upgrade_level;
    current_speed = lerp(15, 30, speed_progress);
    current_run_speed = lerp(25, 45, speed_progress);
    
    if (upgrade_speed >= 1) {
        var dash_progress = (upgrade_speed - 1) / (max_upgrade_level - 1);
        dashDistance = lerp(400, 800, dash_progress);
        dashT = lerp(180, 60, dash_progress);
    } else {
        dashDistance = 0;
        dashT = 180;
    }
    
    // Range (multiplicative)
    current_range = base_range + (upgrade_range * range_multiplier_per_level);
    
    // === DEFENCE SYSTEM ===
    // Defence (damage reduction percentage)
    // Level 0: 25% reduction (0.75 damage taken)
    // Level 1: 50% reduction (0.50 damage taken)
    // Level 2: 75% reduction (0.25 damage taken)
    // Level 3+: 100% reduction (0.00 damage taken - immune)
    if (upgrade_defence == 0) {
        current_defence = 0.25; // 25% reduction
    } else if (upgrade_defence == 1) {
        current_defence = 0.50; // 50% reduction
    } else if (upgrade_defence == 2) {
        current_defence = 0.75; // 75% reduction
    } else if (upgrade_defence >= 3) {
        current_defence = 1.00; // 100% reduction (immune)
    }
    
    // Spell power (multiplicative)
    current_spell_power = base_spell_power + (upgrade_spell * spell_power_per_level);
    
    // Spell cooldown reduction (multiplicative, capped at 75% reduction)
    var cooldown_reduction = min(upgrade_spell * spell_cooldown_reduction_per_level, 0.75);
    current_spell_cooldown = base_spell_cooldown - cooldown_reduction;
    
    // === ENERGY/SPELL SYSTEM ===
    // Max blood calculation: 50 at level 0, then +90 per level
    current_max_blood = base_max_blood + (upgrade_spell * max_blood_per_level);
    
    // Spell damage multiplier
    // Level 0-3: 1x damage
    // Level 4: 2x damage
    // Level 5: 3x damage
    if (upgrade_spell <= 3) {
        current_spell_damage_multiplier = 1.0;
    } else if (upgrade_spell == 4) {
        current_spell_damage_multiplier = 2.0;
    } else if (upgrade_spell >= 5) {
        current_spell_damage_multiplier = 3.0;
    }
    
    // Update blood bar max capacity in ObloodPar
    if (instance_exists(ObloodPar)) {
        ObloodPar.fullBlood = current_max_blood;
        // Clamp current blood to new max
        ObloodPar.blood = clamp(ObloodPar.blood, 0, current_max_blood);
    }
}

// Initialize stats
calculate_stats();

// Set default spawn if none exists
if (global.spawn_x == -1) {
    global.spawn_x = xstart;  // Your initial spawn position
    global.spawn_y = ystart;
}

damage_taken = function(_damage, _source_x = undefined, _source_facing = undefined, _unblockable = false)
{
    // If we are currently in hitstun, ignore further damage
    if (hitstun_time > 0) or (dashing) return;
    
    // Make sure damage is a valid number
    if (is_undefined(_damage)) _damage = 0;
    
    // Cancel sliding if hit
    if (sliding_ground) {
        sliding_ground = false;
        sliding_timer = 0;
        sliding_cooldown = sliding_cooldown_max;
    }
    
    // Variable to track if we're blocking successfully
    var _blocked_successfully = false;
    var _final_damage = _damage; // Start with full damage
    var _hit_from_behind = false; // Track if hit from behind while blocking
    var _shield_broken = false; // Track if shield was broken by unblockable attack
    
    // --- BLOCKING CHECK ---
    if (blocking && _source_facing != undefined) {
        // Check if player and source are facing each other (opposite directions)
        var _facing_each_other = (face != _source_facing);
        
        if (_facing_each_other) {
            // Check if attack is unblockable (breaks shield)
            if (_unblockable) {
                // SHIELD BREAK! Unblockable attack hits through block
                _shield_broken = true;
                blocking = false;
                block_deflect = false;
                block_deflect_timer = 0;
                block_blade_created = false;
                
                // Play shield break sound
                audio_play_sound(SNdamage, 1, false);
                
                // Full damage taken (no block reduction)
                _final_damage = _damage;
            } else {
                // Successfully blocked!
                _blocked_successfully = true;
                block_deflect = true;
                block_deflect_started = true;
                block_deflect_timer = block_deflect_duration;
                blocking = true;
                
                // Apply defence reduction when blocking
                _final_damage = _damage * (1 - current_defence);
                
                // Create spinning blade on block (level 4 and 5) - ONLY ONCE PER BLOCK
                if (!block_blade_created) {
                    if (upgrade_defence == 4) {
                        var _blade_x = x + (face * 50);
                        var _blade_y = y - 180;
                        
                        if(fire_defence) var _spinning = Sspinning_fire;
                        else var _spinning = Sspinning_blade;
                        
                        with(instance_create_layer(_blade_x, _blade_y, "bullets", Ospinning_thorns)) {
                            sprite_index = _spinning;
                            damage = 2;
                            image_xscale = other.face * 0.5;
                            image_yscale = 0.5;
                            max_distance = 400;
                        }
                        block_blade_created = true;
                    } else if (upgrade_defence >= 5) {
                        var _blade_x = x + (face * 50);
                        var _blade_y = y - 180;
                        
                        if(fire_defence) var _spinning = Sspinning_fire;
                        else var _spinning = Sspinning_blade;
                        
                        with(instance_create_layer(_blade_x, _blade_y, "bullets", Ospinning_thorns)) {
                            sprite_index = _spinning;
                            damage = 4;
                            image_xscale = other.face * 0.75;
                            image_yscale = 0.75;
                            max_distance = 800;
                        }
                        block_blade_created = true;
                    }
                }
                
                // Knockback when blocking
                var _kb_dist = 4;
                var _dir = -face;
                
                for (var i = 0; i < _kb_dist; i++) {
                    if (!place_meeting(x + _dir, y, Owall)) {
                        x += _dir;
                    } else break;
                }
                
                vsp = min(vsp, -2);
            }
        } else {
            // Blocking but hit from behind - not a successful block!
            _hit_from_behind = true;
            blocking = false; // Immediately stop blocking to show hit animation
            block_deflect = false;
            block_deflect_timer = 0;
            block_blade_created = false;
        }
    }
    
    // Apply the final calculated damage
    hp -= _final_damage;
    if (hp < 0) hp = 0;
    
    // Track if damage was blocked for visual effect
    damage_blocked = _blocked_successfully;
    
    // Only apply hitstun and knockback if we took damage
    if (_final_damage > 0) {
        hitstun_time = 20;
        
        // If shield was broken or hit from behind, clear blocking state
        if (_shield_broken || !_blocked_successfully && !_hit_from_behind) {
            blocking = false;
            block_deflect = false;
            block_deflect_timer = 0;
            block_blade_created = false;
        }
        
        // Cancel all spells
        spell1_active = false;
        spell1_timer = 0;
        spell1_attacked = false;
        
        spell2_active = false;
        spell2_timer = 0;
        spell2_attacked = false;
        
        spell3_active = false;
        spell3_timer = 0;
        spell3_attacked = false;
        
        hold_time = 0;
        
        // Knockback
        var _dir = 1;
        
        if (_source_facing != undefined) {
            _dir = _source_facing;
        }
        else if (_source_x != undefined) {
            _dir = sign(x - _source_x);
            if (_dir == 0) _dir = 1;
        } 
        else {
            if (place_meeting(x - 1, y, Ospikes) || place_meeting(x - 1, y, Ojack)) {
                _dir = 1;
            }
            else if (place_meeting(x + 1, y, Ospikes) || place_meeting(x + 1, y, Ojack)) {
                _dir = -1;
            }
            else {
                _dir = -face;
            }
        }
        
        // Use unblocked knockback if shield was broken
        var _is_blocked = _blocked_successfully && !_shield_broken;
        var _kb_dist = _is_blocked ? 4 : 8;
        var _kb_hsp = _is_blocked ? 4 : 8;
        
        hsp = _dir * _kb_hsp;
        vsp = min(vsp, -2);
        
        if (!_is_blocked) {
            for (var i = 0; i < _kb_dist; i++)
            {
                if (!place_meeting(x + _dir, y, Owall))
                {
                    x += _dir;
                }
                else break;
            }
        }
        
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

	//crouching and sliding
	// Decrease sliding timer
	if (sliding_timer > 0) {
	    sliding_timer--;
	}

	// Decrease sliding cooldown
	if (sliding_cooldown > 0) {
	    sliding_cooldown--;
	}

	// Transition to crouch/slide
	// Manual = downkey | automatic = wall collision
	if (ground) and (down or place_meeting(x, y-10, Owall))
	{
	    // Check if player should slide (running + pressing down + not on cooldown)
	    if (run && abs(hsp) > 20 && !sliding_ground && !crouching && !attack && sliding_cooldown == 0) {
	        // Start sliding
	        sliding_ground = true;
	        sliding_started = true;
	        sliding_timer = sliding_duration;
	        crouching = false;  // Make sure crouching is FALSE
        
	        // Set sliding speed in the direction of movement (use current hsp direction)
	        hsp = sign(hsp) * sliding_speed;
	    }
	    else if (!sliding_ground) {
	        // Normal crouching (only if NOT sliding)
	        crouching = true;
	    }
	}
	else {
	    // Not on ground or not holding down
	    crouching = false;
	    // Don't cancel sliding here - let it finish naturally
	}

	// Sliding physics
	if (sliding_ground) {
	    // Apply deceleration (subtract instead of multiply)
	    var _slide_dir = sign(hsp);
	    hsp = _slide_dir * max(0, abs(hsp) - sliding_decel);
    
	    // Stop sliding if speed is too low or timer runs out
	    if (abs(hsp) < 2 || sliding_timer <= 0) {
	        sliding_ground = false;
	        sliding_timer = 0;
	        hsp = 0;
	        sliding_cooldown = sliding_cooldown_max; // START COOLDOWN
        
	        // Transition to crouch if still holding down
	        if (down && ground) {
	            crouching = true;
	        }
	    }
    
	    // Cancel slide if player jumps
	    if (jump && ground) {
	        sliding_ground = false;
	        sliding_timer = 0;
	        sliding_cooldown = sliding_cooldown_max; // START COOLDOWN
	    }
	}
	
	
	//running
	if(shift) and ((ground) or (Jcount >= 1))
	{
	    run = true;
	}
	else run = false;

	//moving
	var _walking = true;
	if(!audio_is_playing(SNstep1)) and (!audio_is_playing(SNstep2)) and (!audio_is_playing(SNstep3)) and (!audio_is_playing(SNstep4)) _walking = false;
	if(sprite_index == ScabeW) and (!_walking)
	{
	    audio_sound_pitch(SNstep1,1);
	    audio_sound_pitch(SNstep2,1);
	    audio_sound_pitch(SNstep3,1);
	    audio_sound_pitch(SNstep4,1);
	    audio_play_sound(choose(SNstep1,SNstep2,SNstep3,SNstep4),1,false);
	}
	if(sprite_index == ScabeR) and (!_walking)
	{
	    audio_sound_pitch(SNstep1,1.3);
	    audio_sound_pitch(SNstep2,1.3);
	    audio_sound_pitch(SNstep3,1.3);
	    audio_sound_pitch(SNstep4,1.3);
	    audio_play_sound(choose(SNstep1,SNstep2,SNstep3,SNstep4),1,false);
	}
	// ATTACKING - Freeze during attacks
	else if (attack) {
	    hsp = 0;
	    vsp = 0;
	    // Don't disable crouching during crouch attack
	    if (!attack_crouch) {
	        crouching = false;
	    }
	}
	// NORMAL MOVEMENT - Only when not sliding or attacking
	else
	{
	    //calculate movement
	    if (vsp >= 0) and (place_meeting(x,y+1,Owall)) onground(true);

	    var move = right - left;

	    if (move != 0) face = move;

	    //acceleration and deceleration - USE CALCULATED SPEEDS
	    if(run) var maxspd = current_run_speed; // Uses calculated run speed (25-45)
	    else maxspd = current_speed; // Uses calculated walk speed (15-30)
	    var accel = 0.2;          // Acceleration factor for smooth transition
	    var deccel = 0.1;         // Deceleration factor for smooth stop

	    // Acceleration (while moving)
	    if (move != 0) and (hsp < maxspd) {
	        // Move towards max speed with lerp
	        hsp = lerp(hsp, move * maxspd, accel);
	    }
	    // Deceleration (when no movement input)
	    else {
	        // If the speed is less than or equal to deceleration threshold, stop immediately
	        if (abs(hsp) <= 6) {
	            hsp = 0;
	        } 
	        else {
	            // Smooth stop using lerp
	            hsp = lerp(hsp, 0, deccel);
	        }
	    }
    
	    //stop moving if crouching (but not sliding)
	    if (crouching && !sliding_ground) hsp = 0;
	}

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
		Jcount = 0; 
		JHT = 0;
		Jmax = 2;
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
	    audio_sound_pitch(SNjumpWing, random_range(0.9, 1.1));
	    audio_play_sound(SNjumpWing, 3, false);
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
	hasControl = (wall_jump_cooldown <= 0);
	//Reset wall memory when appropriate
	if (wall_id == noone && place_meeting(x, y+1, Owall)) 
	{
	    wall_last_id = noone;
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
	
	//dash
	D_inputs = right or left or up or down;

	dashing = false;
	// Check if dash is unlocked (speed level >= 1) and has enough blood
	if (dash and canDash and !sliding_ground and upgrade_speed >= 1 and instance_exists(ObloodPar) and ObloodPar.blood >= 10) 
	{
	    screenShake(25,8);
	    dashing = true;
	    vsp = -2;
	    onground(false);
	    canDash = false;
	    audio_sound_pitch(SNdash,random_range(0.8,1));
	    audio_play_sound(SNdash,4,false);

	    // If the player is holding a movement key, use the input direction
	    if (D_inputs) {
	        dashDirection = point_direction(0, 0, right - left, down - up);
	    } else {
	        // No input, dash in the direction the sprite is facing
	        dashDirection = (face == -1) ? 180 : 0; 
	    } 

	    dashSPD = dashDistance / dashTime;
	    dashEnergy = dashDistance;
	    STATE = STATE_DASH;
	    dashed = true;
	    ObloodPar.blood -= 10;
	}
	
	//dash cooldown
	if(dash_cooldown > 0) and (dashed)
	{
		dash_cooldown--;
		canDash = false;
	}
	else
	{
		canDash = true;
		dash_cooldown = dashT;
		dashed = false;
	}
	
	
	if(room != Ressance)
	{
	    //health Par
	    if(!instance_exists(OhealthPar))
	    {
	        instance_create_layer(500,200,layer,OhealthPar);
	    }
	    if(hp <= 0)
	    {
	        STATE = STATE_DEAD;
	    }

	    //blade par
		if(!instance_exists(ObloodPar))
		{
		    // Create all three parts with proper initialization
		    var bg = instance_create_depth(475,360,301,Oblood);
		    bg.sprite_index = SbloodPar1;
    
		    var bar = instance_create_depth(507,355,301,ObloodPar);
		    bar.sprite_index = SbloodPar2;
		    bar.fullBlood = current_max_blood; // Set from player stats
    
		    // Apply loaded blood if it exists
		    if (variable_global_exists("loaded_blood") && !is_undefined(global.loaded_blood)) {
		        bar.blood = global.loaded_blood;
		        show_debug_message("STATE_FREE: Applied loaded blood: " + string(bar.blood));
		        // DON'T clear the variable here - let alarm[1] handle it
		    } else {
		        bar.blood = 0; // Start with 0 blood
		    }
    
		    var overlay = instance_create_depth(475,360,301,Oblood);
		    overlay.sprite_index = SbloodPar3;
		}
		
		//icons
		if(upgrade_spell >= 1) and (!icon1)
		{
			icon1 = true;
			with (instance_create_layer(460,400,layer,Ospell_icon)) sprite_index = Sspell1;
		}
		if(upgrade_spell >= 2) and (!icon2)
		{
			icon2 = true;
			with (instance_create_layer(560,400,layer,Ospell_icon)) sprite_index = Sspell2;
		}
		if(upgrade_spell >= 3) and (!icon3) 
		{
			icon3 = true;
			with (instance_create_layer(660,400,layer,Ospell_icon)) sprite_index = Sspell3;
		}
		if(upgrade_speed >= 1) and (!iconD) 
		{
			iconD = true;
			with (instance_create_layer(800,400,layer,Ospell_icon)) sprite_index = Sspell_dash;
		}
	}
	
	// Blocking (can't block while in hitstun - prevents blocking when hit from behind)
	if (HRMB && ground && !attack && !sliding_ground && hitstun_time == 0) {
	    blocking = true;
	    hsp = 0; // Stop movement while blocking
	} else if (!block_deflect) {
	    blocking = false;
	    block_blade_created = false; // Reset when not blocking
	}

	// Block deflect timer
	if (block_deflect_timer > 0) {
	    block_deflect_timer--;
	}

	// Block deflect finished
	if (block_deflect && block_deflect_timer == 0) {
	    block_deflect = false;
	    blocking = false;
	    block_blade_created = false; // Reset when deflect ends
	}
	
	//fire modes
	if(upgrade_attack >= 3) fire_mode = true;
	else fire_mode = false;
	
	if(upgrade_range >= 3) fire_range = true;
	else fire_range = false;
	
	if(upgrade_speed >= 3) fire_dash = true;
	else fire_dash = false;
	
	if(upgrade_spell >= 4) fire_spells = true;
	else fire_spells = false;
	
	if(upgrade_defence >= 4) fire_defence = true;
	else fire_defence = false;
	
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
	attack = (attack1 || attack2 || attack3 || attack_crouch || attack_air || attack_timer > 0);

	// COOLDOWN - Block all attacks
	if (cooldown_timer > 0 || sliding_ground) {  // Added || sliding_ground
	    // Can't attack during cooldown or slide
	}
	// CROUCH ATTACK - Check first since it's a special condition
	else if (crouching && ground && !attack1 && !attack2 && !attack3 && !attack_air && attack_timer == 0 && !sliding_ground) {  // Added !sliding_ground
	    if (LMB && !attack_crouch) {
	        attack_crouch = true;
	        attack_crouch_started = true;
	        attack_timer = attack_crouch_duration;
        
	        // Create crouch attack slash
			if(face ==  1) var _bladeX =  60;
			if(face == -1) var _bladeX = -60;

			if(!fire_mode) var _sprite = Sslash1;
			if( fire_mode) var _sprite = SslashFire1;
			with(instance_create_layer(Ocherry.x+_bladeX, Ocherry.y-80, "bullets", Oslash)) 
			{
			    damage = 5 + (other.upgrade_attack * 2);
			    sprite_index = _sprite;
			    image_xscale = other.face;
			    image_yscale = -1;
			}
        
	        // Play crouch attack sound
	        audio_sound_pitch(SNsword, random_range(1, 1.2));
	        audio_play_sound(SNsword, 1, false);
	    }
	}
	// AIR ATTACK - Check second since it's also a special condition
	else if (!ground && !attack1 && !attack2 && !attack3 && !attack_crouch && attack_timer == 0) {
	    if (LMB && !attack_air) {
	        attack_air = true;
	        attack_air_started = true;
	        attack_timer = attack_air_duration;
        
	        // Create air attack slash
			if(face ==  1) var _bladeX =  100;
			if(face == -1) var _bladeX = -100;

			if(!fire_mode) var _sprite = Sslash1;
			if( fire_mode) var _sprite = SslashFire1;
			with(instance_create_layer(Ocherry.x+_bladeX, Ocherry.y-140, "bullets", Oslash)) 
			{
			    damage = 5 + (other.upgrade_attack * 2);
			    sprite_index = _sprite;
			    image_xscale = other.face;
			}
        
	        // Play air attack sound
	        audio_sound_pitch(SNsword, random_range(1, 1.2));
	        audio_play_sound(SNsword, 1, false);
	    }
	}
	// IDLE - Can start attack 1
	else if (!attack1 && !attack2 && !attack3 && !attack_crouch && !attack_air && attack_timer == 0 && cooldown_timer == 0 && !sliding_ground) {
    
	    // Charging up (single powerful attack)
	    if (HLMB) and (ground) and (!hold_attack) {
	        hsp = 0;
	        hold_time++;
        
	        // DON'T lock image_index here - let it animate naturally
        
	        // Charge time for one powerful attack
	        if (hold_time >= 40) { // Longer charge time (was 20)
	            hold_time = 40; // Cap at charge time
	            hold_attack = true;
	        }
	    }
	    // Released the button - release powerful attack if charged
		else if (hold_time > 0) {
		    hsp = 0;
		    if (hold_attack) {
		        // Start the attack animation properly
		        attack2 = true;
		        attack2_started = true;
		        attack_timer = attack2_duration;
        
		        if(face ==  1) var _bladeX =  130;
		        if(face == -1) var _bladeX = -130;
        
		        // Create large slash
		        if(!fire_mode) var _sprite = Sslash2;
		        if( fire_mode) var _sprite = SslashFire2;
		        with(instance_create_layer(Ocherry.x+_bladeX,Ocherry.y-140,"bullets",Oslash)) 
		        {
		            damage = (5 + (other.upgrade_attack * 2)) * 2; // Changed from * 5 to * 2, then * 2 for double
		            sprite_index = _sprite;
		            image_xscale = other.face * 1.5; // 1.5x size
		            image_yscale = 1.5; // 1.5x size
		            image_angle += 125*other.face;
		        }
        
		        // Play attack sound
		        audio_sound_pitch(SNsword,random_range(0.8, 0.9)); // Lower pitch for powerful attack
		        audio_play_sound(SNsword, 1, false);
		    }
		    hold_time = 0;
		    hold_attack = false;
		}
    
	    //normal attack
	    if (LMB) {
	        attack1 = true;
	        attack1_started = true;
	        attack_timer = attack1_duration;
	        combo_window_timer = combo_window_start;
	        queued_attack2 = false;
	        queued_attack3 = false;
	        //create attack 1 slash
	        if(face ==  1) var _bladeX =  150;
	        if(face == -1) var _bladeX = -150;
        
	        if(!fire_mode) var _sprite = Sslash1;
	        if( fire_mode) var _sprite = SslashFire1;
	        with(instance_create_layer(Ocherry.x+_bladeX,Ocherry.y-180,"bullets",Oslash)) 
	        {
	            damage = 5 + (other.upgrade_attack * 2);
	            sprite_index = _sprite;
	            image_xscale = other.face;
	        }
	        // Play attack 1 sound
	        audio_sound_pitch(SNsword,random_range(1,1.2));
	        audio_play_sound(SNsword, 1, false);
	    }
	}

	// CROUCH ATTACK FINISHED
	if (attack_crouch && attack_timer == 0) {
	    attack_crouch = false;
	    cooldown_timer = cooldown_duration; // Start cooldown
	}

	// AIR ATTACK FINISHED
	if (attack_air && attack_timer == 0) {
	    attack_air = false;
	    cooldown_timer = cooldown_duration; // Start cooldown
	}

	// ATTACK 1 ACTIVE
	if (attack1 && attack_timer > 0) {
	    // Combo window is open (after 5 frames have passed)
	    if (combo_window_timer == 0) {
	        // Player presses LMB during the combo window - queue attack 2
	        if (LMB && !queued_attack2) {
	            queued_attack2 = true;
	        }
	    }
	}

	// ATTACK 1 FINISHED
	if (attack1 && attack_timer == 0) {
	    attack1 = false;
    
	    if (queued_attack2) {
	        // Start attack 2 immediately
	        attack2 = true;
	        attack2_started = true;
	        attack_timer = attack2_duration;
	        combo_window_timer = combo_window_start;
	        queued_attack2 = false;
	        //create attack 2 slash
			if(face ==  1) var _bladeX =  130;
			if(face == -1) var _bladeX = -130;

			if(!fire_mode) var _sprite = Sslash2;
			if( fire_mode) var _sprite = SslashFire2;
			with(instance_create_layer(Ocherry.x+_bladeX,Ocherry.y-140,"bullets",Oslash)) 
			{
			    damage = 5 + (other.upgrade_attack * 2);
			    sprite_index = _sprite;
			    image_xscale = other.face;
			    image_angle += 125*other.face;
			}
	        // Play attack 2 sound
	        audio_sound_pitch(SNsword,random_range(1,1.2));
	        audio_play_sound(SNsword, 1, false);
	    } else {
	        // Attack 1 ended without combo - start cooldown
	        cooldown_timer = cooldown_duration;
	    }
	}

	// ATTACK 2 ACTIVE
	if (attack2 && attack_timer > 0) {
	    // Combo window is open (after 5 frames have passed)
	    if (combo_window_timer == 0) {
	        // Player presses LMB during the combo window - queue attack 3
	        if (LMB && !queued_attack3) {
	            queued_attack3 = true;
	        }
	    }
	}

	// ATTACK 2 FINISHED
	if (attack2 && attack_timer == 0) {
	    attack2 = false;
    
	    if (queued_attack3) {
	        // Start attack 3 immediately
	        attack3 = true;
	        attack3_started = true;
	        attack_timer = attack3_duration;
	        queued_attack3 = false;
	        //create attack 3 slash
			if(face ==  1) var _bladeX =  170;
			if(face == -1) var _bladeX = -170;

			if(!fire_mode) var _sprite = Sslash3;
			if( fire_mode) var _sprite = SslashFire3;
			with(instance_create_layer(Ocherry.x+_bladeX,Ocherry.y-140,"bullets",Oslash)) 
			{
			    damage = 5 + (other.upgrade_attack * 2);
			    sprite_index = _sprite;
			    image_xscale = other.face;
			}
	        // Play attack 3 sound
	        audio_sound_pitch(SNsword,random_range(1,1.2));
	        audio_play_sound(SNsword, 1, false);
	    } else {
	        // Attack 2 ended without combo - start cooldown
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
	    cooldown_timer = cooldown_duration; // Start 30 frame cooldown
	}

	// SPELL SYSTEM
	// Decrease spell timers
	if (spell1_timer > 0) spell1_timer--;
	if (spell2_timer > 0) spell2_timer--;
	if (spell3_timer > 0) spell3_timer--;

	if (spell1_cooldown > 0) spell1_cooldown--;
	if (spell2_cooldown > 0) spell2_cooldown--;
	if (spell3_cooldown > 0) spell3_cooldown--;

	// Update attack flag to include spells
	attack = (attack1 || attack2 || attack3 || attack_crouch || attack_air || spell1_active || spell2_active || spell3_active || attack_timer > 0);

	// SPELL 1 - Q (Costs 50 blood) - UNLOCKED AT LEVEL 1
	if (spell1 && !spell1_active && !spell2_active && !spell3_active && spell1_cooldown == 0 && !attack1 && !attack2 && !attack3 && !attack_crouch && !attack_air && ground && !sliding_ground && upgrade_spell >= 1) {
	    // Check if player has enough blood
	    if (instance_exists(ObloodPar) && ObloodPar.blood >= 50) {
	        spell1_active = true;
	        spell1_started = true;
	        spell1_timer = spell1_duration;
	        spell1_attacked = false;
	        spell1_cooldown = spell1_cooldown_max;
	        hsp = 0;
        
	        // Consume blood
	        ObloodPar.blood -= 50;
	    }
	}

	// SPELL 1 ACTIVE - Cast projectile at specific frame
	if (spell1_active && spell1_timer > 0) {
	    // Cast at frame 5 (when timer reaches the attack frame)
	    if (spell1_timer == spell1_duration - spell_attack_frame1 && !spell1_attacked) {
	        // Check if spell is unlocked (level 1+)
	        if (upgrade_spell >= 1) {
	            // Create spell projectile
	            if(face == 1) var _bladeX = 75;
	            if(face == -1) var _bladeX = -75;
	            with(instance_create_layer(x + _bladeX, y - 165, "bullets", Ofireball))
	            {
	                image_xscale = other.face;
	                // Apply spell damage multiplier
	                damage = damage * other.current_spell_damage_multiplier;
                
	                // Apply size scaling based on energy level
	                if (other.upgrade_spell == 4) {
	                    // Level 4: 1.5x size
	                    image_xscale *= 1.5;
	                    image_yscale = 1.5;
	                } else if (other.upgrade_spell >= 5) {
	                    // Level 5: 2x size
	                    image_xscale *= 2;
	                    image_yscale = 2;
	                }
	            }
        
	            // Play spell sound
	            audio_sound_pitch(SNfire,random_range(0.7,0.8));
	            audio_play_sound(SNfire, 4, false);
	        }
        
	        spell1_attacked = true;
	    }
	}

	// SPELL 1 FINISHED
	if (spell1_active && spell1_timer == 0) {
	    spell1_active = false;
	    // Cooldown already started when spell was cast
	}

	// SPELL 2 - E (Costs 75 blood) - UNLOCKED AT LEVEL 2
	if (spell2 && !spell1_active && !spell2_active && !spell3_active && spell2_cooldown == 0 && !attack1 && !attack2 && !attack3 && !attack_crouch && !attack_air && ground && !sliding_ground && upgrade_spell >= 2) {
	    // Check if player has enough blood
	    if (instance_exists(ObloodPar) && ObloodPar.blood >= 75) {
	        spell2_active = true;
	        spell2_started = true;
	        spell2_timer = spell2_duration;
	        spell2_attacked = false;
	        spell2_cooldown = spell2_cooldown_max;
	        hsp = 0;
        
	        // Consume blood
	        ObloodPar.blood -= 75;
	    }
	}

	// SPELL 2 ACTIVE - Cast projectile at specific frame
	if (spell2_active && spell2_timer > 0) {
	    // Cast at frame 2 (when timer reaches the attack frame)
	    if (spell2_timer == spell2_duration - spell_attack_frame2 && !spell2_attacked) {
	        // Check if spell is unlocked (level 2+)
	        if (upgrade_spell >= 2) {
	            // Create spell projectile
	            if(face == 1) var _bladeX = 120;
	            if(face == -1) var _bladeX = -120;
	            with(instance_create_layer(x + _bladeX, y - 190, "bullets", OfireBreath))
	            {
					image_xscale = other.face;
	                // Apply spell damage multiplier
	                damage = damage * other.current_spell_damage_multiplier;
                
	                // Apply size scaling based on energy level
	                if (other.upgrade_spell == 4) {
	                    // Level 4: 1.5x size
	                    image_xscale *= 1.5;
	                    image_yscale = 1.5;
	                } else if (other.upgrade_spell >= 5) {
	                    // Level 5: 2x size
	                    image_xscale *= 2;
	                    image_yscale = 2;
	                }
	            }
        
	            // Play spell sound
	            audio_sound_pitch(SNfire,random_range(0.7,0.8));
	            audio_play_sound(SNfire, 4, false);
	        }
        
	        spell2_attacked = true;
	    }
	}

	// SPELL 2 FINISHED
	if (spell2_active && spell2_timer == 0) {
	    spell2_active = false;
	    // Cooldown already started when spell was cast
	}

	// SPELL 3 - R (Costs 100 blood) - UNLOCKED AT LEVEL 3
	if (spell3 && !spell1_active && !spell2_active && !spell3_active && spell3_cooldown == 0 && !attack1 && !attack2 && !attack3 && !attack_crouch && !attack_air && ground && !sliding_ground && upgrade_spell >= 3) {
	    // Check if player has enough blood
	    if (instance_exists(ObloodPar) && ObloodPar.blood >= 100) {
	        spell3_active = true;
	        spell3_started = true;
	        if(fire_spells) spell3_timer = spell4_duration;
			else spell3_timer = spell3_duration;
	        spell3_attacked = false;
	        spell3_cooldown = spell3_cooldown_max;
	        hsp = 0;
        
	        // Consume blood
	        ObloodPar.blood -= 100;
	    }
	}
	
	if(fire_spells)
	{
		// SPELL 3 ACTIVE - Cast projectile at specific frame
		if (spell3_active && spell3_timer > 0) {
		    // Cast at frame 10 (when timer reaches the attack frame)
		    if (spell3_timer == spell4_duration - spell_attack_frame4 && !spell3_attacked) {
		        // Check if spell is unlocked (level 3+)
		        if (upgrade_spell >= 3) {
		            // Create spell projectile
		            if(face == 1) var _bladeX = 75;
		            if(face == -1) var _bladeX = -75;
		            with(instance_create_layer(x + _bladeX, y - 175, "bullets", OfireSlash))
		            {
						image_xscale = other.face;
		                // Apply spell damage multiplier
		                damage = damage * other.current_spell_damage_multiplier;
                
		                // Apply size scaling based on energy level
		                if (other.upgrade_spell == 4) {
		                    // Level 4: 1.5x size
		                    image_xscale *= 1.5;
		                    image_yscale = 1.5;
		                } else if (other.upgrade_spell >= 5) {
		                    // Level 5: 2x size
		                    image_xscale *= 2;
		                    image_yscale = 2;
		                }
		            }
        
		            // Play spell sound
		            audio_sound_pitch(SNfire,random_range(0.7,0.8));
		            audio_play_sound(SNfire, 4, false);
		        }
        
		        spell3_attacked = true;
		    }
		}
	}
	else
	{
		// SPELL 3 ACTIVE - Cast projectile at specific frame
		if (spell3_active && spell3_timer > 0) {
		    // Cast at frame 10 (when timer reaches the attack frame)
		    if (spell3_timer == spell3_duration - spell_attack_frame3 && !spell3_attacked) {
		        // Check if spell is unlocked (level 3+)
		        if (upgrade_spell >= 3) {
		            // Create spell projectile
		            if(face == 1) var _bladeX = 75;
		            if(face == -1) var _bladeX = -75;
		            with(instance_create_layer(x + _bladeX, y - 175, "bullets", OfireSlash))
		            {
		                // Apply spell damage multiplier
		                damage = damage * other.current_spell_damage_multiplier;
                
		                // Apply size scaling based on energy level
		                if (other.upgrade_spell == 4) {
		                    // Level 4: 1.5x size
		                    image_xscale *= 1.5;
		                    image_yscale = 1.5;
		                } else if (other.upgrade_spell >= 5) {
		                    // Level 5: 2x size
		                    image_xscale *= 2;
		                    image_yscale = 2;
		                }
		            }
        
		            // Play spell sound
		            audio_sound_pitch(SNfire,random_range(0.7,0.8));
		            audio_play_sound(SNfire, 4, false);
		        }
        
		        spell3_attacked = true;
		    }
		}
	}

	// SPELL 3 FINISHED
	if (spell3_active && spell3_timer == 0) {
	    spell3_active = false;
	    // Cooldown already started when spell was cast
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
	

	//dash trail effect
	if (trail_timer <= 0)
		{
		    // Create trail further behind (32 pixels instead of 16)
		    var trail_x = x - lengthdir_x(32, dashDirection);
		    var trail_y = y - lengthdir_y(32, dashDirection); 
			
			var _x = random_range(Ocherry.x-50,Ocherry.x+50);
			var _y = random_range(Ocherry.y,Ocherry.y-300);
			
			if(fire_dash) var _colors = c_orange;
			else var _colors = c_aqua;
	
			//sparks
			with (instance_create_depth(_x,_y, depth+1, Odust))
		    {
		        image_blend = _colors;
		        image_alpha = 0.6;
		    }
			
		    with (instance_create_depth(trail_x, trail_y, depth+1, Otrail))
		    {
		        sprite_index = other.sprite_index;
		        image_xscale = other.face;
		        image_blend = _colors;
		        image_alpha = 0.6;
        
		        fade_speed = 0.08; // Faster fade
		    }
    
		    trail_timer = 2; // Create trail every x frames
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

STATE_PAUSE = function()
{
    Cpause = true;
    hasControl = false;
    hsp = 0;
    vsp = 0; 
    grv = 0;
    
	image_index = 0;
	
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
    
    //screen shake
    screenShake(20,6);
    
    //transition
    if (image_index >= 10) and (sprite_index == ScabeD) and (!death_transition_done) {
        death_transition_done = true;
        
        // UNDO LAST UPGRADE (go back one level)
        global.undo_last_upgrade();
        
        // Reset HP to full
        hp = 100;
        
        // Reset blood to 0
        if (instance_exists(ObloodPar)) {
            ObloodPar.blood = 0;
        }
        
        // Reset kill counter to room start value
        if (instance_exists(Ogame)) {
            global.kill_counter = Ogame.room_start_kill_count;
        }
        
        // === CRITICAL FIX: SAVE PROGRESS NOW (with reset stats) ===
        // This ensures the save file has HP=100 and Blood=0, not the death values
        // AND saves the REDUCED level/upgrades from death penalty
        if (instance_exists(Ogame)) {
            // Mark upgrades as CONFIRMED so they save at the reduced level
            Ogame.upgrades_confirmed = true;
            
            // Store the NEW reduced values as confirmed
            global.confirmed_level = player_level;
            global.confirmed_upgrade_attack = upgrade_attack;
            global.confirmed_upgrade_speed = upgrade_speed;
            global.confirmed_upgrade_range = upgrade_range;
            global.confirmed_upgrade_defence = upgrade_defence;
            global.confirmed_upgrade_spell = upgrade_spell;
            global.confirmed_upgrade_history = global.upgrade_history;
            
            global.save_progress();
            show_debug_message("SAVED AFTER DEATH: HP=" + string(hp) + " Blood=0 Level=" + string(player_level));
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
    }
}


STATE = STATE_FREE; 

// Death transition flag
death_transition_done = false; 