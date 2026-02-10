// Upgrade card variables
upgrade_type = ""; // Will be set by Ogame: "attack", "defence", "range", "speed", or "spell"
hover_scale = 1;
target_scale = 1;
base_scale = 1;
hover_scale_max = 1.2;

// Animation states
card_state = "idle"; // "idle", "selected", "disappearing"
animation_timer = 0;

// Animation values for selected card
grow_scale = 1.5; // How big the card gets when selected
shrink_scale = 0.05; 
destination_x = 500;
destination_y = 500;
original_x = x;
original_y = y;

// Make sure card doesn't move with camera
persistent = false;