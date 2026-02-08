if (!collected) {
    wave_angle += wave_speed;
    y = originY + sin(wave_angle) * wave_height;
}
else {
    // Collection animation
    image_xscale = lerp(image_xscale, 2, 0.2);
    image_yscale = lerp(image_yscale, 2, 0.2);
    image_alpha = lerp(image_alpha, 0, 0.2);
    
    if (image_alpha <= 0.05) {
        instance_destroy();
    }
}