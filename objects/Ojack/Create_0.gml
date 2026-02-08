face = 1;
flip = true;
hit = false;
wall = [Owall, Ossplat];
//invincible
damaged_by_list = ds_list_create();
invincible_clear_timer = 0;
invincible_clear_time = 60;
invincible = false;
invincible_time = 20;
invincible_timer = invincible_time;
// List of all damaging objects
damage_objects = [Ospinning_blade, Oblade_back, Oblue_fire, Oblue_explode, Oscratch, Otransform];
// Attack system
attacking = false;
attack_cooldown = 0;
attack_cooldown_time = 60;
attack_range = 300; // Attack range
stop_distance = 200; //Stop moving when this close
attack_created = [false, false];