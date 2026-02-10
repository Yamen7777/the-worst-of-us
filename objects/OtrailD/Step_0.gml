// Fade out over time
image_alpha -= fade_speed;

// Destroy when fully transparent
if (image_alpha <= 0)
{
    instance_destroy();
}