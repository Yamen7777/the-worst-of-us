with(Ocherry)
{
    var _max = current_max_health;
    var _hp = hp;
    
    if (_hp >= _max) other.image_index = 0;
    else if (_hp >= _max * 0.9) other.image_index = 1;
    else if (_hp >= _max * 0.8) other.image_index = 2;
    else if (_hp >= _max * 0.7) other.image_index = 3;
    else if (_hp >= _max * 0.6) other.image_index = 4;
    else if (_hp >= _max * 0.5) other.image_index = 5;
    else if (_hp >= _max * 0.4) other.image_index = 6;
    else if (_hp >= _max * 0.3) other.image_index = 7;
    else if (_hp >= _max * 0.2) other.image_index = 8;
    else if (_hp >= _max * 0.1) other.image_index = 9;
    else if (_hp >= 1) other.image_index = 10;
    else other.image_index = 11;
}