spd = 0.5; //text speed
letters = 0;
text = "";
length = string_length(text);
text_current = "";
w = 0;
h = 0;
border = 10;

// Text type system
text_type = "dialogue"; // "dialogue" or "interaction"
dialogue_array = []; // Array of dialogue lines
current_dialogue_index = 0;
creator = noone;

// Auto-destroy timer for interactions
interaction_hold_time = 120;
interaction_timer = 0;

// Track if text is complete
text_complete = false;