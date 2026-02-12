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
damage_objects = [Ospinning_blade, Oslash, Ofireball, OfireBreath, OfireExplode, Ospinning_thorns, OfireSlash];
// Attack system
attacking = false;
attack_cooldown = 0;
attack_cooldown_time = 40;
attack_range = 250; // Attack range
stop_distance = 200; //Stop moving when this close
attack_created = [false];
//shoot
shooting = false;
shoot_range = 900; // Attack range
shoot_stop_distance = 800; //Stop moving when this close
shoot_created = [false];

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
    var level_multiplier = power(1.5, enemy_level - 1);
    
    hp = base_hp * level_multiplier;
    current_damage = base_damage * level_multiplier;
}

// Initialize stats
calculate_enemy_stats();
