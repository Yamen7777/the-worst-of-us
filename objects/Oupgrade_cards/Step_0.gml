// Check if mouse is hovering (use GUI coordinates)
var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

// Get sprite bounds
var half_width = (sprite_get_width(sprite_index) * hover_scale) / 2;
var half_height = (sprite_get_height(sprite_index) * hover_scale) / 2;

if (point_in_rectangle(mouse_gui_x, mouse_gui_y, 
    x - half_width, y - half_height, 
    x + half_width, y + half_height)) {
    
    target_scale = hover_scale_max;
    
    // Check for click
    if (mouse_check_button_pressed(mb_left)) {
        // Apply the upgrade
        if (instance_exists(Ocherry)) {
            Ocherry.upgrade_stat(upgrade_type);
        }
        
        // Hide all cards
        if (instance_exists(Ogame)) {
            Ogame.hide_upgrade_cards();
        }
    }
} else {
    target_scale = base_scale;
}

// Smooth scale transition
hover_scale = lerp(hover_scale, target_scale, 0.2);

// Animation handling
if (card_state == "selected") {
    animation_timer++;
    
    // Phase 1: Grow (0-20 frames)
    if (animation_timer <= 20) {
        hover_scale = lerp(hover_scale, grow_scale, 0.15);
    }
    // Phase 2: Shrink and move (21-60 frames)
    else if (animation_timer <= 60) {
        hover_scale = lerp(hover_scale, shrink_scale, 0.1);
        x = lerp(x, destination_x, 0.08);
        y = lerp(y, destination_y, 0.08);
        
        // Create dust particles periodically during shrink phase
        if (animation_timer % 5 == 0) { // Every 5 frames
            repeat(2) {
                with (instance_create_layer(x, y, "Instances", Odust)) {
                    image_blend = c_orange;
                }
            }
        }
    }
    // Phase 3: Final dust burst and destroy
    else if (animation_timer == 61) {
        // Create final dust burst
        repeat(8) {
            with (instance_create_layer(x, y, "Instances", Odust)) {
                image_blend = c_orange;
            }
        }
    }
    // Phase 4: Wait a moment then destroy
    else if (animation_timer > 65) {
        // Unpause the game before destroying
        if (instance_exists(Ogame)) {
            Ogame.upgrade_cards_animating = false;
            
            // Unpause the game
            if (instance_exists(Ocherry)) {
                Ocherry.STATE = Ocherry.STATE_FREE;
            }
        }
        instance_destroy();
    }
}
else if (card_state == "disappearing") {
    // Other cards just fade out quickly
    image_alpha = lerp(image_alpha, 0, 0.2);
    if (image_alpha < 0.1) {
        instance_destroy();
    }
}
else {
    // Normal idle behavior
    // Check if mouse is hovering (use GUI coordinates)
    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);

    // Get sprite bounds
    var half_width = (sprite_get_width(sprite_index) * hover_scale) / 2;
    var half_height = (sprite_get_height(sprite_index) * hover_scale) / 2;

    if (point_in_rectangle(mouse_gui_x, mouse_gui_y, 
        x - half_width, y - half_height, 
        x + half_width, y + half_height)) {
        
        target_scale = hover_scale_max;
        
        // Check for click
        if (mouse_check_button_pressed(mb_left)) {
            // Apply the upgrade
            if (instance_exists(Ocherry)) {
                Ocherry.upgrade_stat(upgrade_type);
            }
            
            // Start animation for this card
            card_state = "selected";
            animation_timer = 0;
            original_x = x;
            original_y = y;
            
            // Make all other cards disappear
            with (Oupgrade_cards) {
                if (id != other.id) {
                    card_state = "disappearing";
                }
            }
            
            // Tell Ogame we're animating (don't unpause yet)
            if (instance_exists(Ogame)) {
                Ogame.upgrade_cards_animating = true;
            }
        }
    } else {
        target_scale = base_scale;
    }

    // Smooth scale transition
    hover_scale = lerp(hover_scale, target_scale, 0.2);
}