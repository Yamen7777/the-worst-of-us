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
damage_objects = [Ospinning_blade, Oblade_back, Oblue_fire, Oblue_explode, Oscratch, Otransform, Oslash, Ofireball, OfireExplode];
// Attack system
attacking = false;
attack_cooldown = 0;
attack_cooldown_time = 30;
attack_range = 450; // Melee attack range
attack_created = [false, false, false];
current_attack_part = 0;
// Arrow system
arrow_attacking = false;
arrow_cooldown = 0;
arrow_cooldown_time = 60;
arrow_range = 1500; // Maximum range to shoot arrows
walk_threshold = 500; // Below this, switch to melee behavior
arrow_shot_count = 0;
arrow_created = [false, false];
// Movement states
state = "walking";
walk_speed = 8;
detection_radius = 2500;
// Dodge system
dodging = false;
dodge_timer = 0;
dodge_duration = 20;
dodge_cooldown = 0;
dodge_cooldown_time = 90;
dodge_chance = 0.6;
dodge_invincible = false;
// Ranged attack objects that can be dodged
dodgeable_objects = [Ospinning_blade, Oblade_back, Oblue_fire, Oscratch];