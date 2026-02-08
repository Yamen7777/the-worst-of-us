// damage sources
for (var i = 0; i < array_length(damage_objects); i++) {
    var obj_type = damage_objects[i];
    
    if (instance_exists(obj_type)) {
        var damager = instance_place(x, y, obj_type);
        if (damager != noone) {
            // Check if this specific instance hasn't damaged us yet
            if (ds_list_find_index(damaged_by_list, damager) == -1) {
                // Add this instance to the damaged list
                ds_list_add(damaged_by_list, damager);
                invincible = true;
                invincible_clear_timer = invincible_clear_time;
				
                // Start hit animation
                hit = true;
                hit_animating = true;
                image_index = 0;
                image_speed = 1; // Play animation
            }
            else hit = false;
        }
    }
}


//destroy if blue fire charge
if(place_meeting(x,y,Oblue_fire)) Oblue_fire.destroy = true; 

// Clear the damaged list after timer expires
if (invincible_clear_timer > 0) {
    invincible_clear_timer--;
    if (invincible_clear_timer <= 0) {
        ds_list_clear(damaged_by_list);
    }
}

// Hit animation control
if (hit_animating) {
    // Check if animation reached frame 3
    if (image_index >= 3) {
        // Freeze back at frame 0
        image_index = 0;
        image_speed = 0;
        hit_animating = false;
        hit = false;
    }
}


//dialogue
/// @description Handle dialogue triggers

// CASE 1: Player gets close without hitting - peaceful dialogue
if (instance_exists(Ocherry) && place_meeting(x,y,Ocherry) && 
    !dialogue_started && !got_hit_first && !instance_exists(Otext)) and (room = Rtutorial) {
    dialogue_started = true;
    
    with (instance_create_layer(x, y - 410, layer, Otext)) {
        audio_play_sound(Snsign, 8, false);
        audio_play_sound(Sntext, 10, true);
        
        text_type = "dialogue";
        dialogue_array = [
            "Woah woah, where do you think you are going?",
            "That path is blocked. First you have to go through me.",
            "Let me teach you the basics first."
        ];
        // Auto-add "\n -enter-" to every line
		for (var i = 0; i < array_length(dialogue_array); i++) {
		    dialogue_array[i] += "\n -enter-";
		}

		current_dialogue_index = 0;
		text = dialogue_array[0];
		length = string_length(text);
		dialogue_start = true;
    }
    
    with (Ocamera) {
        follow = other.id;
    }
}

/// @description CASE 2: Player hits dummy first - aggressive dialogue

if hit and (!dialogue_started && !got_hit_first && !instance_exists(Otext)) and (room = Rtutorial) {
    got_hit_first = true;
    dialogue_started = true;
    with (instance_create_layer(x, y - 410, layer, Otext)) {
        audio_play_sound(Snsign, 8, false);
        audio_play_sound(Sntext, 10, true);
        
        text_type = "dialogue";
        dialogue_array = [
            "Ouch! Is that how you greet people?",
            "It seems like you are in a hurry.",
			"you immediately start attacking",
            "Okay then, let me teach you how it goes.",
        ];
        // Auto-add "\n -enter-" to every line
		for (var i = 0; i < array_length(dialogue_array); i++) {
		    dialogue_array[i] += "\n -enter-";
		}

		current_dialogue_index = 0;
		text = dialogue_array[0];
		length = string_length(text);
		dialogue_start = true;
    }
    
    with (Ocamera) {
        follow = other.id;
    }
}

// --------------------------------------------------
// dummy dialogue finished check (CASE 1 & 2)
// --------------------------------------------------
if (dialogue_started && !instance_exists(Otext)) and (room = Rtutorial)
{
    global.dummy_dialogue_finished = true;
}

// --------------------------------------------------
// Final dialogue after tutorial
// --------------------------------------------------
if (instance_exists(Ogame)) and (room = Rtutorial)
{
    if (Ogame.tutorial_done && !final_dialogue_started)
    {
        final_dialogue_started = true;

        with (instance_create_layer(x, y - 410, layer, Otext))
        {
            audio_play_sound(Snsign, 8, false);
            audio_play_sound(Sntext, 10, true);

            text_type = "dialogue";
            dialogue_array = [
                "You are good to go now.",
                "Be careful out there. It is a dangerous world.",
                "If you need anything, I will be right here... standing.",
                "It is not like I can move."
            ];

            for (var i = 0; i < array_length(dialogue_array); i++)
            {
                dialogue_array[i] += "\n -enter-";
            }

            current_dialogue_index = 0;
            text = dialogue_array[0];
            length = string_length(text);
        }
    }
}


// --------------------------------------------------
// Interaction text when hit during tutorial
// --------------------------------------------------
if (Ogame.tutorial && hit)
{
    if (interaction_cooldown <= 0 && !instance_exists(Otext))
    {
        // 35% chance to speak
        if (irandom(99) < 35)
        {
            var line = interaction_lines[irandom(array_length(interaction_lines) - 1)];

            with (instance_create_layer(x, y - 410, layer, Otext))
            {
                text_type = "interaction";
                text = line;
                length = string_length(text);
                interaction_hold_time = 90;
            }

            interaction_cooldown = room_speed * 2;
        }
    }
}

//spawn dummies 
if (global.extra_dummies) and (!extra_dummies) and (room = Rtutorial)
{
    if (interaction_cooldown <= 0 && !instance_exists(Otext))
    {
            var line = interaction_lines[irandom(array_length(interaction_lines) - 1)];

            with (instance_create_layer(x, y - 410, layer, Otext))
            {
                text_type = "interaction";
				if(Ogame.current_character == "cherry") dialogue_array = ["here, use these for practise."];
				if(Ogame.current_character == "yokai") dialogue_array = ["here, use these to fill your spirit meter."];
				if(Ogame.current_character == "werewolf") dialogue_array = ["here, use these to fill your blood meter."];
                text = dialogue_array[0];
                length = string_length(text);
                interaction_hold_time = 90;
				
            }

            interaction_cooldown = room_speed * 2;
			extra_dummies = true;
			dont_ask_me = true;
    }
}

//dont ask me
if (dont_ask_me) and (room = Rtutorial)
{
    if (interaction_cooldown <= 0 && !instance_exists(Otext))
    {
            var line = interaction_lines[irandom(array_length(interaction_lines) - 1)];

            with (instance_create_layer(x, y - 410, layer, Otext))
            {
                text_type = "interaction";
				if(Ogame.current_character == "cherry") dialogue_array = ["dont ask me where they came from."];
				if(Ogame.current_character == "yokai") dialogue_array = ["dont ask me how they got fire spirits."];
				if(Ogame.current_character == "werewolf") dialogue_array = ["dont ask me hot they have blood."];
                text = dialogue_array[0];
                length = string_length(text);
                interaction_hold_time = 90;
				
            }

            interaction_cooldown = room_speed * 2;
			dont_ask_me = false;
    }
}

if (interaction_cooldown <= 0 && room == Room16 && !you_made_it && instance_exists(Ocherry))
{
    var _cherry = Ocherry;
    var _detectionRadius = 1000;
    var _distance = point_distance(x, y, _cherry.x, _cherry.y);
    
    if (_distance <= _detectionRadius) {
        
        with (instance_create_layer(x, y - 410, layer, Otext)) {
            audio_play_sound(Snsign, 8, false);
            audio_play_sound(Sntext, 10, true);
            text_type = "dialogue";
            dialogue_array = [
                "Don't ask too many questions.",
                "You actually made it.",
                "You fought your way over here.",
                "I am proud of you."
            ];
            for (var i = 0; i < array_length(dialogue_array); i++) {
                dialogue_array[i] += "\n -enter-";
            }
            current_dialogue_index = 0;
            text = dialogue_array[0];
            length = string_length(text);
        }
        
        you_made_it = true;
        interaction_cooldown = 300;
    }
}

//open the door 
if(Ogame.tutorial_done && final_dialogue_started) and (!instance_exists(Otext)) global.key = true;