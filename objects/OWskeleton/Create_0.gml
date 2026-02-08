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
attack_cooldown_time = 70;
attack_range = 350;
stop_distance = 300;
attack_created = [false, false, false]; // Track which attacks have been created (3 parts now)
current_attack_part = 0; // Which part of the 3-part attack we're on (0, 1, or 2)

// Running attack
running_attack = false;
running_attack_triggered = false;

// Running cooldown - NEW
run_cooldown = 0;
run_cooldown_time = 300; // time before can run again
run_trigger_distance = 1500; // Player must be this far to trigger running again

// Movement states
state = "walking";
walk_speed = 10;
run_speed = 20;
detection_radius = 2500;

// Shield system
shielding = false;
shield_delay = 0;
shield_delay_time = 30;
can_shield = true;
shield_hold_time = 60;
shield_hold_timer = 0;
block_cooldown = 0; // NEW - cooldown after getting hit
block_cooldown_time = 60; // 1 second
attack_face_locked = 1; // NEW - locks facing direction during attacks