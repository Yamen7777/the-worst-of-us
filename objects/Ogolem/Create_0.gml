face = 1;
flip = true;
hit = false;
wall = [Owall, Ossplat];
hover_height = 100;
//invincible
damaged_by_list = ds_list_create();
invincible_clear_timer = 0;
invincible_clear_time = 60;
invincible = false;
invincible_time = 20;
invincible_timer = invincible_time;
hit_stun_timer = 10;
hit_stun = hit_stun_timer;
clinched = false;
clinched_timer = 0;
push_state = false;
push_state_timer = 0;
push_state_time = 60;
// List of all damaging objects
damage_objects = [Ospinning_blade, Oslash, Ofireball, OfireBreath, OfireExplode, Ospinning_thorns, OfireSlash];
// Attack system
attacking = false;
attack_cooldown = 0;
attack_cooldown_time = 90;
attack_range = 500;
stop_distance = 400;
attack_created = [false, false];
charging = false;
windup_frames = 35;
windup = windup_frames;
windup_speed = -6;
dash_frames = 20;
dash_speed = 50;
recovery_frames = 15;
charge_phase = 0;
dash_attack = noone;

// LEVEL SYSTEM
max_enemy_level = 5;

// Base stats (level 1)
base_damage = 5;

// Current stats (calculated from level)
hp = base_hp;
current_damage = base_damage;

// Function to calculate stats based on level
calculate_enemy_stats = function() {
    // Each level multiplies by 1.5
    // Level 1: 1x, Level 2: 1.5x, Level 3: 2.25x, Level 4: 3.375x, Level 5: 5.0625x
    var level_multiplier = power(1.5, enemy_level - 1);
    
    hp = base_hp * level_multiplier;
    current_damage = base_damage * level_multiplier;
}

// Initialize stats
calculate_enemy_stats();
extra_level_added = false;

danger_level = 3;