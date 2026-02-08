/// @description player movment

//custom functions
function onground(_val = true)
{
	if _val == true
	{
		ground = true;
		cayoteHT = cayoteHF;
	}
	else
	{
		ground = false;
		MyFloorPlat = noone;
		cayoteHT = 0;
	}
}
charge = (min(floor(Ocherry.hold_time / Ocherry.hold_blade), Ocherry.max_blades))/8;
function ssplat_check(_x,_y)
{
	//create a return veriable
	var _rtrn = noone;
	
	//check for normal collision if moving downward
	if (vsp >= 0) and (place_meeting(_x,_y,Ossplat))
	{
		//create a ds list for simesolid plarform colliding instances
		var _list = ds_list_create();
		var _listSize = instance_place_list(_x,_y,Ossplat,_list,false);
		
		//loop throurh the colliding instances to find the top platform bellow the player
		for(var i = 0; i < _listSize; i++)
		{
			var _listIsnt = _list[| i];
			if (_listIsnt != forgetssp) and (floor(bbox_bottom) <= ceil(_listIsnt.bbox_top - _listIsnt.vsp))
			{
				//return the id of the semisolid platform
				_rtrn = _listIsnt;
				//exit the loop early
				i = _listSize;
			}
		}
		//destroy the list to free memory
		ds_list_destroy(_list);
	}
	//return our variable
	return _rtrn;
}

//player input
general_input();

//hitstun timer (counts down every step)
if (hitstun_time > 0)
{
	image_alpha = 0.9;
	image_blend = c_red;
	hitstun_time--;
}
else
{
	image_alpha = 1;
	image_blend = c_white;
}



//moving platform collision
#region
var _rightWall = noone;
var _leftWall = noone;
var _bottomWall = noone;
var _topWall = noone;
var _list = ds_list_create();
var _listSize = instance_place_list(x,y,OmovingPlat,_list,false);

//loop through all colliding moving platform
for (var i = 0; i < _listSize; i++)
{
	var _listinst = _list[| i];
	
	//find the closest wall
	//right walls
	if _listinst.bbox_left - _listinst.hsp >= bbox_right-1
	{
		if (!instance_exists(_rightWall)) or (_listinst.bbox_left < _rightWall.bbox_left)
		{
			_rightWall = _listinst; 
		}
	}
	//left walls
	if _listinst.bbox_right - _listinst.hsp <= bbox_left+1
	{
		if (!instance_exists(_leftWall)) or (_listinst.bbox_right > _leftWall.bbox_right)
		{
			_leftWall = _listinst;
		}
	}
	//bottom wall
	if _listinst.bbox_top - _listinst.vsp >= bbox_bottom-1
	{
		if (!instance_exists(_bottomWall)) or (_listinst.bbox_top < _bottomWall.bbox_top)
		{
			_bottomWall = _listinst;
		}
	}
	//top wall
	if _listinst.bbox_bottom - _listinst.vsp <= bbox_top+1
	{
		if (!instance_exists(_topWall)) or _listinst.bbox_bottom > _topWall.bbox_bottom
		{
			_topWall = _listinst;
		}
	}
}
ds_list_destroy(_list);

//get pushed
//right wall
if instance_exists(_rightWall)
{
	var _rightDist = bbox_right - x;
	x = _rightWall.bbox_left - _rightDist;
}
//left wall
if instance_exists(_leftWall)
{
	var _leftDist = x - bbox_left;
	x = _leftWall.bbox_right + _leftDist;
}
//bottom wall
if instance_exists(_bottomWall)
{
	var _bottomDist = bbox_bottom - y;
	y = _bottomWall.bbox_top - _bottomDist;
}
//top wall (includes, collision for polish and crounching features)
if instance_exists(_topWall)
{
	var _topDist = y - bbox_top;
	var _targetY = _topWall.bbox_bottom + _topDist; 
	//check if there isnt a wall in the way
	if !place_meeting(x,_targetY,Owall)
	{
		y = _targetY;
	}
}
#endregion

//state
STATE();

//underwater sound effect 
var wasInWater = inWater;
inWater =( (place_meeting(x, y, OwaterBLock)) or (place_meeting(x,y,OwaterBallH)) ) and (STATE != STATE_DEAD);

// Just entered water
if (inWater and !wasInWater)
{
    var _lowPass = audio_effect_create(AudioEffectType.LPF2);
    _lowPass.mix = 0.1;
    audio_bus_main.effects[0] = _lowPass;
    audio_play_sound(SNwater_enter, 2, false); // Play once when entering
	audio_sound_gain(SNwater_enter, 2, 0);
	if(!audio_is_playing(SNudner_water)) audio_play_sound(SNudner_water,3,true); audio_sound_gain(SNwater_enter, 1.5, 0);
}
// Just left water
else if (!inWater and wasInWater)
{
    audio_stop_sound(SNwater_enter);
	audio_stop_sound(SNudner_water);
    // Remove the effect by setting the slot to undefined
    if (audio_bus_main.effects[0] != undefined)
    {
        audio_bus_main.effects[0] = undefined;
    }
	    audio_play_sound(SNwater_enter, 2, false);
		audio_sound_gain(SNwater_enter, 0.3, 0);

}

//bubble jump
if(timer)
{
	time --;
}

if(time <= 0)
{
	time = 10;
	timer = false;
}

if(timer) and keyboard_check_pressed(vk_space)
{
	vsp = -leap;
	hsp = leap*2;
	timer = false;
	time = 25;
}


//water push
if (water_push)
{
	// Store the final velocity changes
	var _vsp = OwaterBLock.Vleap;
	var _hsp = OwaterBLock.Hleap;

	//timer
	with(OwaterBLock) timer = true;
        
	dashEnergy = 0;
	
	vsp = _vsp;
	hsp = _hsp;
}

if (place_meeting(x, y, OwaterBLock))
{
    if (STATE == STATE_FREE)
    {
        with(OwaterBLock) slow = true;
    }
    
    if (STATE == STATE_DASH)
    {
        dashEnergy += 50;
        with(OwaterBLock)
        {
            if(dash_collect < 5)
            {
                dash_collect = 5;
            }
            else
            {
                dash_collect++;
            }
            dash_collect = clamp(dash_collect, 0, 50);
        }
        
        // Sound effect with pitch modulation
        dash_sound_timer++;
        if (dash_sound_timer >= dash_sound_interval)
        {
            dash_sound_timer = 0;
            
            // Calculate pitch based on dash_collect (0-50 maps to base_pitch-max_pitch)
            var current_pitch = base_pitch + ((OwaterBLock.dash_collect / 50) * (max_pitch - base_pitch));
            
            // Play the sound normally (not positional) with pitch
            var sound_instance = audio_play_sound(SNdash_collect, 2, false);
			audio_sound_gain(SNwater_enter, 2, 0);
            audio_sound_pitch(sound_instance, current_pitch);
        }
        
        //die if you hit a block while dashing
        // Alternative approach using dash velocity direction
        var dashX = lengthdir_x(4, dashDirection);
        var dashY = lengthdir_y(4, dashDirection);

        if (place_meeting(x + dashX, y + dashY, Owall))
        {
            STATE = STATE_DEAD;
        }
    }
}
else
{
	// Reset sound timer when not in water
    dash_sound_timer = 0;
	with(OwaterBLock) 
	{
		slow = false;
	    if (dash_collect > 0)
	    {
			Ocherry.water_push = true;
	    }
	}
}


//water slowing effect 
if (instance_exists(OwaterBLock)) and (OwaterBLock.slow)
{
	grv = 0.03;  
    vsp *= 0.95;     
	
	hsp = hsp/1.05;
	
	MAXgrv = 20;
	
	JHF[0] = 10;
	jumpSP[0] = -34;
	JHF[1] = 10;
	jumpSP[1] = -38;
}
else 
{
	if(!instance_exists(ObouncerG)) MAXgrv = 40;
	else MAXgrv = lerp(MAXgrv,40,0.1);

	grv = 0.4;
	
	JHF[0] = 12;
	jumpSP[0] = -30;
	JHF[1] = 12;
	jumpSP[1] = -34;
} 


if(sprite_index = SyokaiD) and (!dead)
{
	dead = true;

	audio_play_sound(SNdeath,10,false);
}

//check if we are crushed 
if place_meeting(x,y,Owall)
{
	STATE = STATE_DEAD;
}

// SPRITE CONTROL
//fusing
if(STATE = STATE_FUSE)
{
	sprite_index = SyokaiF;
}
//death
else if(STATE = STATE_DEAD)
{
    sprite_index = SyokaiD;
}
//hitstun
else if (hitstun_time > 0)
{
	sprite_index = SyokaiHT;
}
//dashing
else if(STATE = STATE_DASH)
{
    sprite_index = SyokaiDS;
}
//jumping
else if (!ground)
{
	if(sliding)
	{
		sprite_index = SyokaiWJ;
	}
	else
	{
		if(vsp < 0)
		{
			sprite_index = SyokaiJ;
		}
		if(vsp > 0)
		{
			sprite_index = Syokaij2;
		}
	}
}
else if(super_attack)
{
	sprite_index = SyokaiAT1;
}
else if (hold_attack) {
    sprite_index = SyokaiAT4;
}
else if (attack1) {
    sprite_index = SyokaiAT1;
    if (attack1_started) {
        image_index = 0;
        attack1_started = false;
    }
} else if (attack2) {
    sprite_index = SyokaiAT2;
    if (attack2_started) {
        image_index = 0;
        attack2_started = false;
    }
} else if (attack3) {
    sprite_index = SyokaiAT3;
    if (attack3_started) {
        image_index = 0;
        attack3_started = false;
    }
}
//poke
else if(STATE = STATE_POKE)
{
    sprite_index = SyokaiDS;
}
//crouching 
else if (crouching) sprite_index = SyokaiC;
//running
else if (abs(hsp) > 0) and (run)
{
	sprite_index = SyokaiR;
}
//walking
else if (abs(hsp) > 0)
{
	sprite_index = SyokaiW;
}
//running
else if (abs(hsp) >= walkSP[1]) sprite_index = SyokaiW; 
//no moving
else if (hsp == 0) sprite_index = Syokai;
//collision mask
mask_index = Syokai;
if (crouching) mask_index = SyokaiC;
