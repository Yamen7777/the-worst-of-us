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

//dialogue 
// Dummy variables
hp = 100;
dialogue_started = false;
got_hit_first = false;

final_dialogue_started = false;


interaction_lines = [
    "Ouch!",
    "That hurt!",
    "aoih!"
];

interaction_cooldown = 0;

//intractions 
extra_dummies = false;
dont_ask_me = false;
you_made_it = false;