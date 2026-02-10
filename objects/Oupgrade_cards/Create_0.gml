// Upgrade card variables
upgrade_type = "";
hover_scale = 1;
target_scale = 1;
base_scale = 1;
hover_scale_max = 1.2;

// Animation states
card_state = "idle";
animation_timer = 0;

// Animation values for selected card
grow_scale = 1.5;
shrink_scale = 0.05;
destination_x = 600;
destination_y = 400;
original_x = x;
original_y = y;

// CRITICAL: Make persistent so it doesn't get deactivated
persistent = true;

// Use object_set_persistent to ensure it stays active
object_set_persistent(object_index, true);