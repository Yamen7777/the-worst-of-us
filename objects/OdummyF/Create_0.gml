face = 1;
hit = false;
hit_animating = false;


//invincible
damaged_by_list = ds_list_create(); // Track which instances damaged us
invincible_clear_timer = 0;
invincible_clear_time = 60; // Clear the list after 30 frames
invincible = false;
invincible_time = 10;
invincible_timer = invincible_time;

hit = false;
// List of all damaging objects
damage_objects = [Ospinning_blade, Oblade_back, Oblue_fire, Oblue_explode, Oscratch, Otransform];

// Animation control
image_index = 0;
image_speed = 0; // Start frozen

