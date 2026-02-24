/// @description Room Start - spawn enemies after Ogame is initialized

// Get danger budget and player level from Ogame
var danger_budget = 20;
var player_level = 0;
if (instance_exists(Ogame)) {
    danger_budget = Ogame.room_danger_level;
    // Calculate player level from danger level formula: danger = 12 + (player_level * 5)
    // So: player_level = (danger - 12) / 5
    player_level = max(0, floor((danger_budget - 12) / 5));
}

// Calculate max enemy level allowed based on player level
// For every 5 player levels, enemies can be 1 level higher
// Player level 0-4: enemies max level 1
// Player level 5-9: enemies max level 2
// Player level 10-14: enemies max level 3
// Player level 15-19: enemies max level 4
// Player level 20+: enemies max level 5
var max_enemy_level_allowed;
if (player_level < 5) {
    max_enemy_level_allowed = 1;
} else if (player_level < 10) {
    max_enemy_level_allowed = 2;
} else if (player_level < 15) {
    max_enemy_level_allowed = 3;
} else if (player_level < 20) {
    max_enemy_level_allowed = 4;
} else {
    max_enemy_level_allowed = 5;
}

show_debug_message("Calculated: danger=" + string(danger_budget) + ", player_level=" + string(player_level) + ", max_enemy_level=" + string(max_enemy_level_allowed));
show_debug_message("Player level: " + string(player_level) + ", Max enemy level allowed: " + string(max_enemy_level_allowed));

// Define available enemy types and their BASE danger levels (level 1)
// [object_type, base_danger, max_level]
enemy_types = [
    [Ojack, 3, 5],
    [Obandit2, 3, 5],
    [Obandit3, 4, 5],
    [Ofire, 20, 5],
    [Owind, 20, 5]
];

// Function to calculate danger cost at a specific level
// Cost = base * (1.5 ^ (level - 1))
calculate_danger_cost = function(base_cost, level) {
    return base_cost * power(1.5, level - 1);
};

// Build spawn queue with enemy type and level
// Each entry: [object_type, level]
spawn_queue = [];
var remaining_budget = danger_budget;
var attempts = 0;
var max_attempts = 100;

while (remaining_budget >= 3 && attempts < max_attempts) {  // 3 is minimum enemy cost
    attempts++;
    
    // Pick a random enemy type
    var enemy_data = enemy_types[irandom(array_length(enemy_types) - 1)];
    var enemy_obj = enemy_data[0];
    var base_cost = enemy_data[1];
    var max_level = enemy_data[2];
    
    // Determine what level we can afford (capped by player progress)
    var chosen_level = 1;
    var chosen_cost = base_cost;
    
    // Calculate the actual max level for this enemy type (limited by player progress and enemy's max)
    var actual_max_level = min(max_level, max_enemy_level_allowed);
    
    // Try higher levels (up to actual_max_level, not the enemy's theoretical max)
    for (var lvl = actual_max_level; lvl >= 1; lvl--) {
        var cost_at_level = calculate_danger_cost(base_cost, lvl);
        if (cost_at_level <= remaining_budget) {
            chosen_level = lvl;
            chosen_cost = cost_at_level;
            break;
        }
    }
    
    // If we can't afford even level 1, skip
    if (chosen_cost > remaining_budget) {
        continue;
    }
    
    // Add to queue
    array_push(spawn_queue, [enemy_obj, chosen_level]);
    remaining_budget -= chosen_cost;
    show_debug_message("Added " + string(enemy_obj) + " level " + string(chosen_level) + " (cost " + string(chosen_cost) + ") - remaining budget: " + string(remaining_budget));
}

// Debug info
show_debug_message("=== SPAWNER ROOM START ===");
show_debug_message("Danger budget: " + string(danger_budget));
show_debug_message("Enemies to spawn: " + string(array_length(spawn_queue)));

// Spawn all enemies in queue
for (var i = 0; i < array_length(spawn_queue); i++) {
    var spawn_data = spawn_queue[i];
    var enemy_obj = spawn_data[0];
    var enemy_lvl = spawn_data[1];
    
    // Random position within the spawn area
    var spawn_x_pos = random_range(spawn_left, spawn_right);
    var spawn_y_pos = random_range(spawn_top, spawn_bottom);
    
    // Create the enemy
    var enemy = instance_create_layer(spawn_x_pos, spawn_y_pos, layer, enemy_obj);
    
    // Set the enemy level
    enemy.enemy_level = enemy_lvl;
    enemy.calculate_enemy_stats();  // Recalculate stats based on level
    
    show_debug_message("Spawned enemy #" + string(i+1) + " (" + string(enemy_obj) + " level " + string(enemy_lvl) + ") at x=" + string(spawn_x_pos) + " y=" + string(spawn_y_pos));
}

// Destroy the spawner after spawning
instance_destroy();
