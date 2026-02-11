// Pop animation (when cards first appear)
if (card_state == "popping") {
    // Wait for delay first
    if (pop_delay > 0) {
        pop_delay--;
        hover_scale = 0; // Stay invisible during delay
    } else {
        animation_timer++;
        
        // Phase 1: Scale up to 120% (0-15 frames)
        if (animation_timer <= 15) {
            hover_scale = lerp(hover_scale, pop_scale_max, pop_speed);
        }
        // Phase 2: Scale down to 100% (16-30 frames)
        else if (animation_timer <= 30) {
            hover_scale = lerp(hover_scale, base_scale, pop_speed);
        }
        // Phase 3: Pop complete
        else {
            hover_scale = base_scale;
            card_state = "idle"; // Now ready for selection
            animation_timer = 0;
            
            // Check if ALL cards are done popping
            var all_done = true;
            with (Oupgrade_cards) {
                if (card_state == "popping") {
                    all_done = false;
                }
            }
            
            // If all cards finished popping, enable selection
            if (all_done && instance_exists(Ogame)) {
                Ogame.all_cards_popped = true;
                show_debug_message("ALL CARDS POPPED - Selection enabled!");
            }
        }
    }
}
// Animation handling for selected card
else if (card_state == "selected") {
    animation_timer++;
    show_debug_message("Animation timer: " + string(animation_timer) + " State: " + card_state + " ID: " + string(id));
    
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
		if (animation_timer % 5 == 0) {
		    // Convert GUI coordinates to room coordinates
		    var cam = view_camera[0];
		    var cam_x = camera_get_view_x(cam);
		    var cam_y = camera_get_view_y(cam);
		    var cam_w = camera_get_view_width(cam);
		    var cam_h = camera_get_view_height(cam);
    
		    // GUI to room conversion
		    var room_x = cam_x + (x / 3733) * cam_w;
		    var room_y = cam_y + (y / 2240) * cam_h;
    
		    repeat(2) {
		        with (instance_create_layer(room_x, room_y, "Instances", Odust)) {
		            image_blend = c_orange;
		            depth = -10000;
		        }
		    }
		}
    }
    // Phase 3: Final dust burst
	else if (animation_timer == 61) {
	    // Convert GUI coordinates to room coordinates
	    var cam = view_camera[0];
	    var cam_x = camera_get_view_x(cam);
	    var cam_y = camera_get_view_y(cam);
	    var cam_w = camera_get_view_width(cam);
	    var cam_h = camera_get_view_height(cam);
    
	    var room_x = cam_x + (x / 3733) * cam_w;
	    var room_y = cam_y + (y / 2240) * cam_h;
    
	    repeat(8) {
	        with (instance_create_layer(room_x, room_y, "Instances", Odust)) {
	            image_blend = c_orange;
	            depth = -10000;
	        }
	    }
	}
    // Phase 4: Wait a moment then destroy and re-enable controls
    else if (animation_timer > 65) {
        show_debug_message("ANIMATION COMPLETE - CLEANING UP");
    
        if (instance_exists(Ogame)) {
            Ogame.upgrade_cards_animating = false;
            Ogame.showing_upgrade_cards = false;
            Ogame.upgrade_cards_created = false;
        }
    
        // RE-ENABLE PLAYER CONTROLS AND MOVEMENT
        if (instance_exists(Ocherry)) {
            Ocherry.hasControl = true;
            Ocherry.Cpause = false;
            Ocherry.STATE = Ocherry.STATE_FREE;
        }
    
        instance_destroy();
    }
}
else if (card_state == "disappearing") {
    image_alpha = lerp(image_alpha, 0, 0.2);
    if (image_alpha < 0.1) {
        instance_destroy();
    }
}
else if (card_state == "idle") {
    // Normal idle behavior - ONLY IN "IDLE" STATE
    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);
    var half_width = (sprite_get_width(sprite_index) * hover_scale) / 2;
    var half_height = (sprite_get_height(sprite_index) * hover_scale) / 2;
    
    if (point_in_rectangle(mouse_gui_x, mouse_gui_y, 
        x - half_width, y - half_height, 
        x + half_width, y + half_height)) {
        
        target_scale = hover_scale_max;
        
        // ONLY allow clicking if ALL cards have finished popping
        if (mouse_check_button_pressed(mb_left) && instance_exists(Ogame) && Ogame.all_cards_popped) {
            show_debug_message("CARD CLICKED! Setting state to selected, ID: " + string(id));
            
            if (instance_exists(Ocherry)) {
                Ocherry.upgrade_stat(upgrade_type);
            }
            
            card_state = "selected";
            animation_timer = 0;
            original_x = x;
            original_y = y;
            
            show_debug_message("Card state is now: " + card_state + " for ID: " + string(id));
            
            with (Oupgrade_cards) {
                if (id != other.id) {
                    card_state = "disappearing";
                    show_debug_message("Setting other card to disappearing: " + string(id));
                }
            }
            
            if (instance_exists(Ogame)) {
                Ogame.upgrade_cards_animating = true;
            }
        }
    } else {
        target_scale = base_scale;
    }
    hover_scale = lerp(hover_scale, target_scale, 0.2);
}