/// @description progress text

// Progress the letter reveal
letters += spd;
text_current = string_copy(text, 1, floor(letters));

// Use the correct font
draw_set_font(Fm5x7L);
if (h == 0) h = string_height(text);
w = string_width(text_current);

// Check if text reveal is complete
if (letters >= length && !text_complete) {
    text_complete = true;
    audio_stop_sound(Sntext);
}

// DIALOGUE TYPE - wait for Enter to continue/close
if (text_type == "dialogue") {
    if (text_complete && keyboard_check_pressed(vk_enter)) {
        current_dialogue_index++;
        
        // Check if there are more dialogue lines
        if (current_dialogue_index < array_length(dialogue_array)) {
            // Go to next dialogue
            text = dialogue_array[current_dialogue_index]
            length = string_length(text);
            letters = 0;
            text_current = "";
            text_complete = false;
            audio_play_sound(Sntext, 10, true);
        } else {
            // No more dialogue - destroy
            instance_destroy();
            if (instance_exists(Ocamera)) {
                with (Ocamera) {
                    if (instance_exists(Ocherry)) follow = Ocherry;
                }
            }
        }
    }
}

// INTERACTION TYPE - auto-destroy after timer
else if (text_type == "interaction") {
    if (text_complete) {
        interaction_timer++;
        
        if (interaction_timer >= interaction_hold_time) {
            instance_destroy();
            if (instance_exists(Ocamera)) {
                with (Ocamera) {
                    if (instance_exists(Ocherry)) follow = Ocherry;
                }
            }
        }
    }
}