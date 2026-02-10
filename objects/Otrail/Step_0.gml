// Fade out over time
image_alpha -= fade_speed;

// Destroy when fully transparent
if (image_alpha <= 0)
{
    instance_destroy();
}

if(Ocherry.upgrade_speed == 5) damage = 15;
if(Ocherry.upgrade_speed == 4) damage = 10;
if(Ocherry.upgrade_speed == 3) damage = 5;
if(Ocherry.upgrade_speed <= 2) damage = 0;
