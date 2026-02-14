/// @description Room Start - spawn enemies after Ogame is initialized

// Get danger budget from Ogame now that it's initialized
var danger_budget = 20;
if (instance_exists(Ogame)) {
    danger_budget = Ogame.room_danger_level;
}

// Define available enemy types and their danger levels
// [object_type, danger_cost]
enemy_types = [
    [Ojack, 3],
    [Obandit2, 3],
    [Obandit3, 4],
    [Ofire, 20]
];

// Build spawn queue based on danger budget
spawn_queue = [];
var remaining_budget = danger_budget;
var attempts = 0;
var max_attempts = 50;

while (remaining_budget > 0 && attempts < max_attempts) {
    attempts++;
    
    // Pick a random enemy type
    var enemy_data = enemy_types[irandom(array_length(enemy_types) - 1)];
    var enemy_obj = enemy_data[0];
    var enemy_cost = enemy_data[1];
    
    // Check if it fits in remaining budget
    if (enemy_cost <= remaining_budget) {
        array_push(spawn_queue, enemy_obj);
        remaining_budget -= enemy_cost;
        show_debug_message("Added " + string(enemy_obj) + " (cost " + string(enemy_cost) + ") - remaining budget: " + string(remaining_budget));
    }
}

// Debug info
show_debug_message("=== SPAWNER ROOM START ===");
show_debug_message("Danger budget: " + string(danger_budget));
show_debug_message("Enemies to spawn: " + string(array_length(spawn_queue)));

// Spawn all enemies in queue
for (var i = 0; i < array_length(spawn_queue); i++) {
    // Random position within the spawn area
    var spawn_x_pos = random_range(spawn_left, spawn_right);
    var spawn_y_pos = random_range(spawn_top, spawn_bottom);
    
    // Create the enemy
    var enemy = instance_create_layer(spawn_x_pos, spawn_y_pos, layer, spawn_queue[i]);
    show_debug_message("Spawned enemy #" + string(i+1) + " (" + string(spawn_queue[i]) + ") at x=" + string(spawn_x_pos) + " y=" + string(spawn_y_pos));
}

// Destroy the spawner after spawning
instance_destroy();
