//kill counter 
// Handle hitstop countdown
if (hitstop_timer > 0) {
    hitstop_timer--;
    
    // When freeze is over, restore normal room speed and play end sounds
    if (hitstop_timer <= 0) {
        room_speed = normal_room_speed;
        
        // Debug - show what pitch values we're using
        show_debug_message("SNkill pitch: " + string(hitstop_kill_pitch));
        show_debug_message("SNscore pitch: " + string(hitstop_score_pitch));
        
        // Try using audio_play_sound instead with audio_sound_pitch
        var snd_kill = audio_play_sound(SNkill, 10, false);
        audio_sound_pitch(snd_kill, hitstop_kill_pitch);
        
        var snd_score = audio_play_sound(SNscore, 10, false);
        audio_sound_pitch(snd_score, hitstop_score_pitch);
    }
}


// Animate kill counter scale
kill_counter_scale = lerp(kill_counter_scale, kill_counter_target_scale, 0.2);

// Animate kill counter rotation
kill_counter_rotation = lerp(kill_counter_rotation, kill_counter_target_rotation, 0.15);

// Decay the jump power and return to normal
kill_counter_jump_power = lerp(kill_counter_jump_power, 0, 0.1);
kill_counter_target_scale = 1 + kill_counter_jump_power;
kill_counter_target_rotation = lerp(kill_counter_target_rotation, 0, 0.1);

// Clamp values to prevent floating point drift
if (abs(kill_counter_scale - 1) < 0.01) kill_counter_scale = 1;
if (abs(kill_counter_rotation) < 0.5) kill_counter_rotation = 0;

//chapter open 
if(open_chapter2)
{
	with(Oisland_two) chapter_open = true;
	global.save_main_progress();
}
if(open_chapter3)
{
	with(Oisland_three) chapter_open = true;
}

if(room == Rmain_menu) or (room == Rchapters)
{
	// Remove the effect by setting the slot to undefined
    if (audio_bus_main.effects[0] != undefined)
    {
        audio_bus_main.effects[0] = undefined;
    }
}
with(Oisland_two) chapter_open = true;

//into
if(room == Rintro)
{
	// Ensure we have a clean state for new players
	if(!file_exists("main.sav"))
	{
		// This is a first-time player, ensure clean state
		open_chapter2 = false;
		open_chapter3 = false;
		ds_map_clear(global.main_collected_flowers);
		global.main_flower_count = 0;
	}
}

//key
//check for enemies 
if(!instance_exists(Ojack)) and (!instance_exists(Owillson)) and (!instance_exists(Ojaison)) and (!instance_exists(Oflying)) and (!global.key) and (room != Ressance) and (room != Rtutorial)
{
	if(!audio_is_playing(SNcheckpoint)) audio_play_sound(SNcheckpoint,11,false);
	global.key = true
}

//blade spot
// Check if we have too many blade spots
if (instance_number(Oblade_spot) > 9 && ds_list_size(global.blade_spots) > 0) {
    // Get the oldest one (first in list)
    var oldest_id = ds_list_find_value(global.blade_spots, 0);
    
    // Remove from list first
    ds_list_delete(global.blade_spots, 0);
    
    // Destroy the instance
    with(oldest_id) {
        instance_destroy();
    }
}

//essance room
if (room == Ressance) 
{
	essance_room = true
	if(!audio_is_playing(Essence_room_wind)) audio_play_sound(Essence_room_wind,2,true);
	if(audio_is_playing(out_wind)) audio_stop_sound(out_wind);
}
else 
{
	essance_room = false;
	if(audio_is_playing(Essence_room_wind)) audio_stop_sound(Essence_room_wind);
	if(!audio_is_playing(out_wind)) audio_play_sound(out_wind,2,true);
	
}

if(!global.fuse)
{
    if (essance_room && !essance_objects_created)
    {
        essance_objects_created = true;
        
        // Room dimensions for reference
        var room_w = room_width;   // 5600
        var room_h = room_height;  // 3360
        var center_x = room_w / 2; // 2800
        var center_y = room_h / 2; // 1680
        
        // Essance - center bottom
        instance_create_layer(center_x + 20, room_h * 0.705, "essance", Oessance);
        
        // Fragments - top area, evenly spaced
        with (instance_create_layer(room_w * 0.4, room_h * 0.223, "essance", Ofragment_frame)) 
        {
            image_index = 1; 
            fragment = 1;
            original_fragment = 1;
        }
        
        with (instance_create_layer(center_x - 57, room_h * 0.184, "essance", Ofragment_frame)) 
        {
            image_index = 2; 
            fragment = 2;
            original_fragment = 2;
        }
        
        with (instance_create_layer(room_w * 0.56, room_h * 0.223, "essance", Ofragment_frame)) 
        {
            image_index = 3; 
            fragment = 3;
            original_fragment = 3;
        }
        
        // Slots - middle area, left and right
        with (instance_create_layer(room_w * 0.349, room_h * 0.486, "essance", Oslots1)) 
        {
            image_index = 0;
            fragment_type = 0;
        }
        
        with (instance_create_layer(room_w * 0.594, room_h * 0.486, "essance", Oslots2)) 
        {
            image_index = 0;
            fragment_type = 0;
        }
    }

    //controlling the fragments  
    //slot 1
    if(global.slot1 != 0) and (fragment1 == false) //creating fragments 
    {
        fragment1 = true;
        
        var room_w = room_width;
        var room_h = room_height;
        
        if (global.slot1 == 1) //fling
        {
            global.fling = true;
            slot1 = 1;
            with(instance_create_layer(room_w * 0.446, room_h * 0.6, layer, Ofragments)) sprite_index = Sfragment1;
            with(instance_create_layer(room_w * 0.439, room_h * 0.587, layer, Ofragment_effect)) sprite_index = Sfragment_effect1;
        }
        if (global.slot1 == 2) //burst
        {
            slot1 = 2;
            global.burst = true;
            with(instance_create_layer(room_w * 0.486, room_h * 0.568, layer, Ofragments)) sprite_index = Sfragment2;
            with(instance_create_layer(room_w * 0.477, room_h * 0.553, layer, Ofragment_effect)) sprite_index = Sfragment_effect2;
        }
        if (global.slot1 == 3) //grasp
        {
            slot1 = 3;
            global.grasp = true;
            with(instance_create_layer(room_w * 0.523, room_h * 0.6, layer, Ofragments)) sprite_index = Sfragment3;
            with(instance_create_layer(room_w * 0.512, room_h * 0.581, layer, Ofragment_effect)) sprite_index = Sfragment_effect3;
        }    
    }
    else if (global.slot1 == 0) and (fragment1 == true) // destroy fragments 
    {
        if (slot1 == 1) // fling
        {
            global.fling = false;
            fragment1 = false;
            slot1 = 0;
        
            if (instance_exists(Ofragments)) 
            {
                with (Ofragments)
                {
                    if (sprite_index == Sfragment1) 
                    {
                        instance_destroy();
                    }
                }
            }
        }
        else if (slot1 == 2) // burst
        {
            global.burst = false;
            fragment1 = false;
            slot1 = 0;
        
            if (instance_exists(Ofragments)) 
            {
                with (Ofragments)
                {
                    if (sprite_index == Sfragment2) 
                    {
                        instance_destroy();
                    }
                }
            }
        }
        else if (slot1 == 3) // grasp
        {
            global.grasp = false;
            fragment1 = false;
            slot1 = 0;
        
            if (instance_exists(Ofragments)) 
            {
                with (Ofragments)
                {
                    if (sprite_index == Sfragment3) 
                    {
                        instance_destroy();
                    }
                }
            }
        }
    }

    //slot 2
    if(global.slot2 != 0) and (fragment2 == false) //creating fragments 
    {
        fragment2 = true;
        
        var room_w = room_width;
        var room_h = room_height;
        
        if (global.slot2 == 1) //fling
        {
            global.fling = true;
            slot2 = 1;
            with(instance_create_layer(room_w * 0.446, room_h * 0.6, layer, Ofragments)) sprite_index = Sfragment1;
            with(instance_create_layer(room_w * 0.439, room_h * 0.587, layer, Ofragment_effect)) sprite_index = Sfragment_effect1;
        }
        if (global.slot2 == 2) //burst
        {
            slot2 = 2;
            global.burst = true;
            with(instance_create_layer(room_w * 0.486, room_h * 0.568, layer, Ofragments)) sprite_index = Sfragment2;
            with(instance_create_layer(room_w * 0.477, room_h * 0.553, layer, Ofragment_effect)) sprite_index = Sfragment_effect2;
        }
        if (global.slot2 == 3) //grasp
        {
            slot2 = 3;
            global.grasp = true;
            with(instance_create_layer(room_w * 0.523, room_h * 0.6, layer, Ofragments)) sprite_index = Sfragment3;
            with(instance_create_layer(room_w * 0.512, room_h * 0.581, layer, Ofragment_effect)) sprite_index = Sfragment_effect3;
        }    
    }
    else if (global.slot2 == 0) and (fragment2 == true) // destroy fragments 
    {
        if (slot2 == 1) // fling
        {
            global.fling = false;
            fragment2 = false;
            slot2 = 0;
        
            if (instance_exists(Ofragments)) 
            {
                with (Ofragments)
                {
                    if (sprite_index == Sfragment1) 
                    {
                        instance_destroy();
                    }
                }
            }
        }
        else if (slot2 == 2) // burst
        {
            global.burst = false;
            fragment2 = false;
            slot2 = 0;
        
            if (instance_exists(Ofragments)) 
            {
                with (Ofragments)
                {
                    if (sprite_index == Sfragment2) 
                    {
                        instance_destroy();
                    }
                }
            }
        }
        else if (slot2 == 3) // grasp
        {
            global.grasp = false;
            fragment2 = false;
            slot2 = 0;
        
            if (instance_exists(Ofragments)) 
            {
                with (Ofragments)
                {
                    if (sprite_index == Sfragment3) 
                    {
                        instance_destroy();
                    }
                }
            }
        }
    }
}

//fusing
if(global.slot1 != 0) and (global.slot2 != 0) and (!global.fuse) and (!global.fusing)
{
    fuse_option = true;
    if (keyboard_check_pressed(vk_enter))
    {
        fuse_option = false;
        global.fusing = true;
        fusing_step = 0;
        fusing_timer = 0;
        
        // Set fusion center point
        fusion_center_x = 1405;
        fusion_center_y = 1150;
    }
}
else fuse_option = false;

//fusing animation
if(global.fusing)
{
    switch(fusing_step)
    {
        // Step 0: Move essance and fragments to center with spiral
        case 0:
            // Mark essance for movement
			
            if (instance_exists(Oessance) && !essance_moving)
            {
				if(!audio_is_playing(Essence_room_pick)) audio_play_sound(Essence_room_pick,6,false);
                with(Oessance)
                {
                    moving_to_center = true;
                    start_x = x;
                    start_y = y;
                    move_progress = 0;
                    spiral_angle = random(360);
                }
                essance_moving = true;
            }
            
            // Mark all fragments for movement
            if (instance_exists(Ofragments))
            {
                with(Ofragments)
                {
                    if (!variable_instance_exists(id, "moving_to_center"))
                    {
                        moving_to_center = true;
                        start_x = x;
                        start_y = y;
                        move_progress = 0;
                        spiral_angle = random(360);
                        ds_list_add(other.fragments_moving, id);
                    }
                }
            }
            
            // Check if everything reached center
            var all_reached = true;
            
            if (instance_exists(Oessance))
            {
                with(Oessance)
                {
                    if (moving_to_center)
                    {
                        // Accelerating movement (0 to 1)
                        move_progress += 0.015; // Adjust for speed
                        var eased_progress = power(move_progress, 2); // Quadratic easing
                        
                        // Spiral movement
                        spiral_angle += 1; // Rotation speed
                        var spiral_radius = 100 * (1 - eased_progress); // Shrinking spiral
                        
                        var target_x = other.fusion_center_x + lengthdir_x(spiral_radius, spiral_angle);
                        var target_y = other.fusion_center_y + lengthdir_y(spiral_radius, spiral_angle);
                        
                        x = lerp(start_x, target_x, eased_progress);
                        y = lerp(start_y, target_y, eased_progress);
                        
                        if (move_progress < 1) all_reached = false;
                    }
                }
            }
            
            if (instance_exists(Ofragments))
            {
                with(Ofragments)
                {
                    if (moving_to_center)
                    {
                        move_progress += 0.015;
                        var eased_progress = power(move_progress, 2);
                        
                        spiral_angle += 1;
                        var spiral_radius = 120 * (1 - eased_progress);
                        
                        var target_x = other.fusion_center_x + lengthdir_x(spiral_radius, spiral_angle);
                        var target_y = other.fusion_center_y + lengthdir_y(spiral_radius, spiral_angle);
                        
                        x = lerp(start_x, target_x, eased_progress);
                        y = lerp(start_y, target_y, eased_progress);
                        
                        if (move_progress < 1) all_reached = false;
                    }
                }
            }
            
            if (all_reached)
            {
                fusing_step = 1;
                fusing_timer = 0;
            }
            break;
            
        // Step 1: Create fusion effect and destroy essance/fragments
        case 1:
			if(!audio_is_playing(Essence_room_spin)) audio_play_sound(Essence_room_spin,6,false);
            // Create smoke cover effect
            instance_create_layer(fusion_center_x, fusion_center_y, "bullets", Ofusing_effect).sprite_index = Sfusing_effect4;
            
            // Destroy essance and fragments
            instance_destroy(Oessance);
            instance_destroy(Ofragments);
            
            // Create central fusion fragment
            fusion_fragment = instance_create_layer(fusion_center_x, fusion_center_y, layer, Ofragments);
            
            // Set sprite
            fusion_fragment.sprite_index = Sfragments;
            
            fusion_fragment.fusion_scale = 1;
            fusion_fragment.fusion_y_start = fusion_center_y;
            
            fusing_step = 2;
            fusing_timer = 0;
            break;
            
        // Step 2: Wait for smoke effect frame 6, then create effect1
        case 2:
            fusing_timer++;
            if (fusing_timer >= 15) // Adjust timing as needed
            {
                instance_create_layer(fusion_center_x, fusion_center_y, "bullets", Ofusing_effect).sprite_index = Sfusing_effect1;
                fusing_step = 3;
                fusing_timer = 0;
            }
            break;
            
        // Step 3: Shrink and move fragment down (5 seconds = 300 frames at 60fps)
        case 3:
            if (instance_exists(fusion_fragment))
            {
                fusing_timer++;
                var shrink_duration = 180; // 5 seconds
                var progress = fusing_timer / shrink_duration;
                
                // Shrink to 1/3 size
                fusion_fragment.image_xscale = lerp(1, 0.33, progress);
                fusion_fragment.image_yscale = lerp(1, 0.33, progress);
                
                // Move down 100 pixels
                fusion_fragment.y = lerp(fusion_fragment.fusion_y_start, fusion_fragment.fusion_y_start, progress);
                
                if (fusing_timer >= shrink_duration)
                {
                    fusing_step = 4;
                    fusing_timer = 0;
                }
            }
            break;
            
        // Step 4: Create character and pause them
        case 4:
            fuse = true;
            if(!audio_is_playing(Essence_room_fuse)) audio_play_sound(Essence_room_fuse,6,false);
			
            // Wait one frame for character to be created
            if (instance_exists(Ocherry) || instance_exists(Oyokai) || instance_exists(Owerewolf))
            {
                // Pause the player
                if (instance_exists(Ocherry)) Ocherry.STATE = Ocherry.STATE_PAUSE;
                if (instance_exists(Oyokai)) Oyokai.STATE = Oyokai.STATE_PAUSE;
                if (instance_exists(Owerewolf)) Owerewolf.STATE = Owerewolf.STATE_PAUSE;
                
                // Create effect2
                instance_create_layer(fusion_center_x, fusion_center_y, "bullets", Ofusing_effect).sprite_index = Sfusing_effect2;
                
                fusing_step = 5;
                fusing_timer = 0;
            }
            break;
            
        // Step 5: Wait, then create effect3
        case 5:
            fusing_timer++;
			// Destroy fusion fragment
            if (instance_exists(fusion_fragment)) instance_destroy(fusion_fragment);
            if (fusing_timer >= 30) // Wait 0.5 seconds
            {
                instance_create_layer(fusion_center_x, fusion_center_y, "bullets", Ofusing_effect).sprite_index = Sfusing_effect3;
                fusing_step = 6;
                fusing_timer = 0;
            }
            break;
            
        // Step 6: End scene
        case 6:
            fusing_timer++;
            if (fusing_timer >= 58) //for the fusing animation
            {
                
                // Unpause player
                if (instance_exists(Ocherry)) Ocherry.STATE = Ocherry.STATE_FREE;
                if (instance_exists(Oyokai)) Oyokai.STATE = Oyokai.STATE_FREE;
                if (instance_exists(Owerewolf)) Owerewolf.STATE = Owerewolf.STATE_FREE;
                
                // End fusion scene
                global.fusing = false;
                fusing_step = 0;
            }
            break;
    }
}

//create the characters in essance room
if(fuse)
{
	fuse = false;
	global.fuse = true;
    if(global.fling) and (global.grasp)
    {
		global.spawn_x = 1377;
		global.spawn_y = 1270;
        if !instance_exists(Ocherry) 
        {
            with(instance_create_layer(global.spawn_x, global.spawn_y, "player", Ocherry)) 
			{
				STATE = STATE_FUSE;
				image_index = 0;
				sprite_index = ScabeF;
			}
        }
    }
    else if(global.fling) and (global.burst)
    {
		global.spawn_x = 1446;
		global.spawn_y = 1270;
        if !instance_exists(Oyokai) 
        {
             with(instance_create_layer(global.spawn_x, global.spawn_y, "player", Oyokai))
			 {
				STATE = STATE_FUSE;
				image_index = 0;
				sprite_index = SyokaiF;
			}
        }
    }
    else if(global.grasp) and (global.burst)
    {
		global.spawn_x = 1396;
		global.spawn_y = 1270;
        if !instance_exists(Owerewolf) 
        {
             with(instance_create_layer(global.spawn_x, global.spawn_y, "player", Owerewolf))
			 {
				STATE = STATE_FUSE;
				image_index = 0;
				sprite_index = SwerewolfF;
			}
        }
    }
}

//create the characters
if(global.fuse)
{
    if(global.fling) and (global.grasp)
    {
        if !instance_exists(Ocherry)
		{
		    instance_create_layer(global.spawn_x, global.spawn_y, "player", Ocherry);
		    current_character = "cherry";
		}
    }
    else if(global.fling) and (global.burst)
    {
        if !instance_exists(Oyokai)
		{
		    instance_create_layer(global.spawn_x, global.spawn_y, "player", Oyokai);
		    current_character = "yokai";
		}
    }
    else if(global.burst && global.grasp)
	{
		if !instance_exists(Owerewolf)
		{
		    instance_create_layer(global.spawn_x, global.spawn_y, "player", Owerewolf);
		    current_character = "werewolf";
		}
	}
}

//tutorial room
// tutorial room check
if (room == Rtutorial) tutorial = true;
else tutorial = false;

if (!tutorial || tutorial_done) exit;

// --------------------------------------------------
// START CONDITION
// this should be set TRUE when dummy dialogue ends
// example: global.dummy_dialogue_finished = true
// --------------------------------------------------
if (!global.dummy_dialogue_finished) exit;

// --------------------------------------------------
// CHARACTER CHECK
// --------------------------------------------------
if (!instance_exists(Ocherry)) exit;

// --------------------------------------------------
// TUTORIAL LOGIC
// --------------------------------------------------
if (current_character == "cherry")
{
    switch (tutorial_step)
	{
		// =========================
	    // LESSON 0 – RUNNING
	    // =========================
	    case 0:
	        // lmb attack check
	        if (Ocherry.run) and (Ocherry.hsp != 0)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;
		
	    // =========================
	    // LESSON 1 – LMB ATTACK
	    // =========================
	    case 1:
	        // lmb attack check
	        if (Ocherry.attack3 && Ocherry.attack_timer > 0)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;

	    // =========================
	    // LESSON 2 – HOLD LMB
	    // =========================
	    case 2:
	        // hold lmb attack check
	        if (!Ocherry.HLMB) and (Ocherry.hold_attack)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;

	    // =========================
	    // LESSON 3 – SUPER
	    // =========================
	    case 3:
			global.extra_dummies = true;
		    // super check
		    if (Ocherry.super)
		    {
		        tutorial_step_complete = true;
		    }

		    if (tutorial_step_complete)
		    {
		        tutorial_hold_timer++;
		        if (tutorial_hold_timer >= room_speed)
		        {
		            tutorial_step++;
		            tutorial_step_complete = false;
		            tutorial_hold_timer = 0;
		        }
		    }
			break;


	    // =========================
	    // LESSON 4 – SPECIALS
	    // =========================
	    case 4:
		    // double jump check
		    if (Ocherry.DJ)
		    {
		        tutorial_dj_complete = true;
		    }

		    // mid air attack or super check
		    // mid air action check
		    if ((Ocherry.LMB || Ocherry.super) && !Ocherry.ground)
		    {
		        tutorial_air_complete = true;
		    }

		    // both completed → turn green and wait
		    if (tutorial_dj_complete && tutorial_air_complete)
		    {
		        tutorial_step_complete = true;
		    }

		    if (tutorial_step_complete)
		    {
		        tutorial_hold_timer++;
		        if (tutorial_hold_timer >= room_speed)
		        {
		            tutorial_step++;
		            tutorial_step_complete = false;
		            tutorial_hold_timer = 0;
		        }
		    }
			break;
		
		// =========================
	    // tutorial done
	    // =========================
	
		case 5:
		    // final message delay
			tutorial_done = true;
			break;
	}
}
else if(current_character == "werewolf")
{
    switch (tutorial_step)
	{
		// =========================
	    // LESSON 0 – RUNNING
	    // =========================
	    case 0:
	        // lmb attack check
	        if (Owerewolf.run) and (Owerewolf.hsp != 0)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;
		
	    // =========================
	    // LESSON 1 – LMB ATTACK
	    // =========================
	    case 1:
	        // lmb attack check
	        if (Owerewolf.attack3 && Owerewolf.attack_timer > 0)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;

	    // =========================
	    // LESSON 2 – HOLD LMB
	    // =========================
	    case 2:
	        // hold lmb attack check
	        if (Owerewolf.hold_released)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;

	    // =========================
	    // LESSON 3 – SUPER
	    // =========================
	    case 3:
			global.extra_dummies = true;
		    // super check
		    if (Owerewolf.transform)
		    {
		        tutorial_step_complete = true;
		    }

		    if (tutorial_step_complete)
		    {
		        tutorial_hold_timer++;
		        if (tutorial_hold_timer >= room_speed)
		        {
		            tutorial_step++;
		            tutorial_step_complete = false;
		            tutorial_hold_timer = 0;
		        }
		    }
			break;


	    // =========================
	    // LESSON 4 – SPECIALS
	    // =========================
	    case 4:
	    // Latch the run attack detection
	    if (Owerewolf.run_attack) 
	    {
	        tutorial_action_detected = true;
	    }
    
	    if (tutorial_action_detected)
	    {
	        tutorial_hold_timer++;
	        if (tutorial_hold_timer >= room_speed)
	        {
	            tutorial_step++;
	            tutorial_step_complete = false;
	            tutorial_hold_timer = 0;
	            tutorial_action_detected = false; // Reset for next use
	        }
	    }
		break;
		
		// =========================
	    // tutorial done
	    // =========================
	
		case 5:
		    // final message delay
			tutorial_done = true;
			break;
	}
}else if(current_character == "yokai")
{
    switch (tutorial_step)
	{
		// =========================
	    // LESSON 0 – RUNNING
	    // =========================
	    case 0:
	        // lmb attack check
	        if (Oyokai.run) and (Oyokai.hsp != 0)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;
		
	    // =========================
	    // LESSON 1 – LMB ATTACK
	    // =========================
	    case 1:
	        // lmb attack check
	        if (Oyokai.attack3 && Oyokai.attack_timer > 0)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;

	    // =========================
	    // LESSON 2 – HOLD LMB
	    // =========================
	    case 2:
	        // hold lmb attack check
	        if (Oyokai.HA)
	        {
	            tutorial_step_complete = true;
	        }

	        if (tutorial_step_complete)
	        {
	            tutorial_hold_timer++;
	            if (tutorial_hold_timer >= room_speed)
	            {
	                tutorial_step++;
	                tutorial_step_complete = false;
	                tutorial_hold_timer = 0;
	            }
	        }
	    break;

	    // =========================
	    // LESSON 3 – SUPER
	    // =========================
	    case 3:
			global.extra_dummies = true;
		    // super check
		    if (Oyokai.super_attack)
		    {
		        tutorial_step_complete = true;
		    }

		    if (tutorial_step_complete)
		    {
		        tutorial_hold_timer++;
		        if (tutorial_hold_timer >= room_speed)
		        {
		            tutorial_step++;
		            tutorial_step_complete = false;
		            tutorial_hold_timer = 0;
		        }
		    }
			break;


	    // =========================
	    // LESSON 4 – SPECIALS
	    // =========================
	    case 4:
		// Latch the dash detection
		if (Oyokai.dashing) 
		{
		    tutorial_action_detected = true;
		}
    
		if (tutorial_action_detected)
		{
		    tutorial_hold_timer++;
		    if (tutorial_hold_timer >= room_speed)
		    {
		        tutorial_step++;
		        tutorial_step_complete = false;
		        tutorial_hold_timer = 0;
		        tutorial_action_detected = false; // Reset for next use
		    }
		}
		break;
		
		// =========================
	    // tutorial done
	    // =========================
	
		case 5:
		    // final message delay
			tutorial_done = true;
			break;
	}
}

if(global.extra_dummies) and (!create_dummies)
{
	create_dummies = true;
	global.extra_dummies = false;
	
	instance_create_layer(10368,3072,"wall",OdummyF);
	instance_create_layer(10080,3072,"wall",OdummyF);
	instance_create_layer( 9792,3072,"wall",OdummyF);
	instance_create_layer( 9504,3072,"wall",OdummyF);
	instance_create_layer( 9216,3072,"wall",OdummyF);
}

