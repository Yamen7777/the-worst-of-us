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

if(keyboard_check_pressed(vk_tab)) fire_mode = !fire_mode;

if(sprite_index = ScabeD) and (!dead)
{
	dead = true;

	audio_play_sound(SNdeath,10,false);
}

// TEST: Press L to level up
if (keyboard_check_pressed(ord("L"))) {
    level_up();
}

// TEST: Press K to increase blood
if (keyboard_check_pressed(ord("K"))) {
    ObloodPar.blood += 50;
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
    sprite_index = ScabeF;
}
//death
else if(STATE = STATE_DEAD)
{
    sprite_index = ScabeD;
}
//hitstun
else if (hitstun_time > 0)
{
    sprite_index = ScabeHT;
}
//spell 1
else if (spell1_active) {
    sprite_index = ScabeSP1;
    if (spell1_started) {
        image_index = 0;
        spell1_started = false;
    }
}
//spell 2
else if (spell2_active) {
    sprite_index = ScabeSP2;
    if (spell2_started) {
        image_index = 0;
        spell2_started = false;
    }
}
//spell 3
else if (spell3_active) {
    sprite_index = ScabeSP3;
    if (spell3_started) {
        image_index = 0;
        spell3_started = false;
    }
}
//block deflect (successful block animation)
else if (block_deflect) {
    sprite_index = ScabeBD;
    if (block_deflect_started) {
        image_index = 0;
        block_deflect_started = false;
    }
}
//blocking idle
else if (blocking) {
    sprite_index = ScabeB;
}
//sliding - MOVED BEFORE CROUCHING
else if (sliding_ground) {
    sprite_index = ScabeSL;
    if (sliding_started) {
        image_index = 0;
        sliding_started = false;
    }
}
//air attack
else if (attack_air) {
    sprite_index = ScabeJA;
    if (attack_air_started) {
        image_index = 0;
        attack_air_started = false;
    }
}
//jumping
else if (!ground)
{
    if(sliding)
    {
        sprite_index = ScabeWJ;
    }
    else
    {
        if(vsp < 0)
        {
            sprite_index = ScabeJ;
        }
        if(vsp > 0)
        {
            sprite_index = Scabej2;
        }
    }
}
//hold attack
else if (hold_attack) {
    sprite_index = ScabeAT1;
}
//attack 1
else if (attack1) {
    sprite_index = ScabeAT1;
    if (attack1_started) {
        image_index = 0;
        attack1_started = false;
    }
}
//attack 2
else if (attack2) {
    sprite_index = ScabeAT2;
    if (attack2_started) {
        image_index = 0;
        attack2_started = false;
    }
}
//attack 3
else if (attack3) {
    sprite_index = ScabeAT3;
    if (attack3_started) {
        image_index = 0;
        attack3_started = false;
    }
}
//crouch attack 
else if (attack_crouch) {
    sprite_index = ScabeCA;
    if (attack_crouch_started) {
        image_index = 0;
        attack_crouch_started = false;
    }
}
//crouching - NOW AFTER SLIDING
else if (crouching) sprite_index = ScabeC;
//dashing
else if(STATE = STATE_DASH)
{
    sprite_index = ScabeDS;
}
//running
else if (abs(hsp) > 0) and (run)
{
    sprite_index = ScabeR;
}
//walking
else if (abs(hsp) > 0)
{
    sprite_index = ScabeW;
}
//running
else if (abs(hsp) >= walkSP[1]) sprite_index = ScabeW; 
//no moving
else if (hsp == 0) sprite_index = Scabe;