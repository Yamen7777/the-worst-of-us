/// @description Spawns enemies based on danger level within the spawner's area
// The spawner's sprite size determines the spawn area
// Scale the object in the room editor to cover the desired area

// Calculate spawn boundaries based on sprite size and scale
// Sprite origin is top-left (0,0), so calculate from x,y
// Note: sprite_width/height already include image_xscale/yscale!
// Left edge
spawn_left = x;
// Right edge  
spawn_right = x + sprite_width;
// Top edge
spawn_top = y;
// Bottom edge
spawn_bottom = y + sprite_height;

// Danger budget - can be set in room editor or defaults to 20
// We'll read from Ogame in Room Start event to ensure it's initialized
var danger_budget = 20;

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
var max_attempts = 50;  // Prevent infinite loops

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
show_debug_message("=== SPAWNER DEBUG ===");
show_debug_message("Danger budget: " + string(danger_budget));
show_debug_message("Enemies to spawn: " + string(array_length(spawn_queue)));
show_debug_message("Bounds: left=" + string(spawn_left) + " right=" + string(spawn_right) + " top=" + string(spawn_top) + " bottom=" + string(spawn_bottom));

// Enemies will be spawned in Room Start event (Other_4)
// This ensures Ogame is fully initialized first
