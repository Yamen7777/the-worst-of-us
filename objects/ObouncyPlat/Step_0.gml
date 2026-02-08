if(place_meeting(x,y-35, Ocherry))
{
    bouncy_cayote = 7;
    timer = false;
    sprite = true;
}
else 
{
    if (bouncy_cayote > 0) bouncy_cayote--;
    timer = true;
    sprite = false;
}
if(bouncy_cayote > 0) bounce = true;

//bounce
if(bounce)
{
    if( (keyboard_check_pressed(vk_space)) or (gamepad_button_check_pressed(0,gp_face1)) ) && (bouncy_cayote > 0)
    {
        audio_sound_pitch(SNbounce,random_range(0.6,0.9));
        audio_play_sound(SNbounce,5,false);
        if(right)
        {
            with(Ocherry)
            {
                bounce = true;
                canJump = false;
                canDJ = false;
                Jcount = 0;
                onground(false);
                vsp = -80;
                hsp = 90;
                // Do NOT play double jump sound or effects here
                if (Jmax > 1) canDJ = true;
            }
        }
        if(left)
        {
            with(Ocherry)
            {
                bounce = true;
                canJump = false;
                canDJ = false;
                Jcount = 0;
                onground(false);
                vsp = -80;
                hsp = -90;
                // Do NOT play double jump sound or effects here
                if (Jmax > 1) canDJ = true;
            }
        }
        if(!right) and (!left)
        {
            with(Ocherry)
            {
                bounce = true;
                canJump = false;
                canDJ = false;
                Jcount = 0;
                onground(false);
                vsp = -80;
                // Do NOT play double jump sound or effects here
                if (Jmax > 1) canDJ = true;
            }
        }
    }
}

//timer
if(timer)
{
    bounceTime --;
}

if(bounceTime <= 0)
{
    bounce = false;
    bounceTime = 5;
    timer = false;
}

//sprite
if(sprite)
{
    image_index = 3;
}
else
{
    if(right) image_index = 2;
    if(left) image_index = 1;
    if(!right) and (!left) image_index = 0;
}