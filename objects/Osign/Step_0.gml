/// @description E sign and auto-trigger dialogue

// Show E sign when in range
if (instance_exists(Ocherry) && point_in_circle(Ocherry.x, Ocherry.y, x, y, 500) && !instance_exists(Otext)) {
    image_index = 1;
} else {
    image_index = 0;
}

// Auto-trigger dialogue when in range (no need to press E)
if (instance_exists(Ocherry) && point_in_circle(Ocherry.x, Ocherry.y, x, y, 500) && !instance_exists(Otext)) {
    with (instance_create_layer(x, y - 64, layer, Otext)) {
        audio_play_sound(Snsign, 8, false);
        audio_play_sound(Sntext, 10, true);
        
        // Set as dialogue type
        text_type = "dialogue";
        dialogue_array = ["Hello!\n -enter-", "This is line 2\n -enter-", "This is line 3\n -enter-"];
        current_dialogue_index = 0;
        text = dialogue_array[0];
        length = string_length(text);
        creator = other.id;
    }
    
    with (Ocamera) {
        follow = other.id;
    }
}