// Get max blood from player
var _maxBlood = 500; // Default
if (instance_exists(Ocherry)) {
    _maxBlood = Ocherry.current_max_blood;
}

fullBlood = _maxBlood;
blood = clamp(blood, 0, fullBlood);

if(sprite_index == SbloodPar2)
{
    image_xscale = blood/fullBlood;
}