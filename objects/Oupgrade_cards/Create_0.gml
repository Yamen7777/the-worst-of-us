// Oupgrade_cards Create Event
// Upgrade card variables
upgrade_type = "";
hover_scale = 0; // Start at 0 for pop animation
target_scale = 1;
base_scale = 1;
hover_scale_max = 1.2;

// Animation states
card_state = "popping"; // Start with popping animation
animation_timer = 0;
pop_delay = 0; // Will be set when card is created

// Pop animation values
pop_scale_max = 1.2; // Max size during pop
pop_speed = 0.15; // Speed of scaling

// Animation values for selected card
grow_scale = 1.5;
shrink_scale = 0.05;
destination_x = 600;
destination_y = 400;
original_x = x;
original_y = y;

//Make persistent so it doesn't get deactivated
persistent = true;
object_set_persistent(object_index, true);