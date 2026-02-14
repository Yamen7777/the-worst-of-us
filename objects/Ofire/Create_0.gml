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
attack_cooldown_time = 60;
attack_range = 525; // Attack range
stop_distance = 500; //Stop moving when this close
attack_created = [false, false, false];

// LEVEL SYSTEM
max_enemy_level = 5;

// Base stats (level 1)
base_damage = 20;

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

// ========== JUMPING SYSTEM ==========
jump_speed = -20;          // Jump velocity
jump_forward_speed = 12;   // Forward momentum when jumping
is_jumping = false;        // Currently in jump
jump_cooldown = 0;         // Jump cooldown timer
jump_cooldown_time = 45;   // Frames before can jump again
wall_check_distance = 350;  // How far ahead to check for walls
jump_level = 1;            // Jump level (can be upgraded)

// ========== LEVEL-BASED ATTACK UNLOCKS ==========
// Attack availability based on enemy level
// Level 1: Attack 1 only (SfireA + Sfire_slash1)
// Level 2: Attack 2 unlocked (SfireA with 2 slashes)
// Level 3: Attack 3 unlocked (SfireA3 with all 3 slashes)
// Level 4: Special unlocked (SfireSP)

// Function to determine max attack phases based on level
get_max_attack_phases = function() {
    switch(enemy_level) {
        case 1: return 1;  // Only first attack
        case 2: return 2;  // First + second attack
        case 3: 
        case 4: 
        case 5: return 3;  // All three attacks
        default: return 1;
    }
}

// Function to check if special is unlocked
is_special_unlocked = function() {
    return enemy_level >= 4;
}

// ========== SPECIAL ATTACK ==========
special_cooldown = 0;
special_cooldown_time = 320;  // 3 seconds at 60fps
special_range = 600;          // Range to trigger special
using_special = false;        // Currently doing special

// ========== JUMP ATTACK ==========
jump_attacking = false;       // Currently doing jump attack
jump_attack_range = 550;      // Range to trigger jump attack (increased)
jump_stopped_by_wall = false; // Track if jump was stopped by wall collision

// ========== GAMER TAG SYSTEM ==========
gamer_tags = [
    "xX_FireLord_Xx",
    "PyroSlayer",
    "BlazeMaster",
    "InfernoKing",
    "FlameWarrior",
    "AshBringer",
    "EmberSoul",
    "PhoenixRising",
    "LavaBeast",
    "DragonFire",
    "Scorcher",
    "MagmaLord",
    "WildFire",
    "HeatWave",
    "Combustion",
    "FireStorm",
    "TorchBearer",
    "Ignition",
    "BurnOut",
    "FlameOn",
    "HotShot",
    "Smolder",
    "SizzleKing",
    "CharMaster",
    "Sparky",
    "CinderBlock",
    "FlareUp",
    "Bonfire",
    "SunBurn",
    "WildBlaze"
];
gamer_tag = gamer_tags[irandom(array_length(gamer_tags) - 1)];

danger_level = 20;
