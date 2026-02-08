

if(locked)
{
	image_index = 3;
}
else
{
		//keyboard control
	    if keyboard_check_pressed(ord("s")) or keyboard_check_pressed(ord("S")) or keyboard_check_pressed(vk_down) or gamepad_button_check(0,gp_padd) or gamepad_axis_value(0,gp_axislv) > 0.5
	    {
			audio_play_sound(SNselect, 5, false);
	        menu_cursor++;
	        if (menu_cursor >= menu_items) menu_cursor = 0;
	    }
	    if keyboard_check_pressed(ord("w")) or keyboard_check_pressed(ord("W")) or keyboard_check_pressed(vk_up) or gamepad_button_check(0,gp_padu) or gamepad_axis_value(0,gp_axislv) < -0.5
	    {
			audio_play_sound(SNselect, 5, false);
	        menu_cursor--;
	        if (menu_cursor < 0) menu_cursor = menu_items - 1;
	    }
		
		// Decrease click delay
		if (click_delay > 0) click_delay--;
		
		// Mouse control
		var mouse_x_in_world = camera_get_view_x(view_camera[0]) + mouse_x;
		var mouse_y_in_world = camera_get_view_y(view_camera[0]) + mouse_y;
		
		// Get collision box bounds
		var collision_left = x + sprite_get_bbox_left(sprite_index);
		var collision_right = x + sprite_get_bbox_right(sprite_index);
		var collision_top = y + sprite_get_bbox_top(sprite_index);
		var collision_bottom = y + sprite_get_bbox_bottom(sprite_index);
		
		// Check if mouse is over the menu board's collision box
		if (point_in_rectangle(mouse_x_in_world, mouse_y_in_world, collision_left, collision_top, collision_right, collision_bottom))
		{
			// Calculate the height of each third
			var third_height = (collision_bottom - collision_top) / 3;
			
			// Determine which third the mouse is in
			var mouse_relative_y = mouse_y_in_world - collision_top;
			var top_third = (mouse_relative_y < third_height);
			var middle_third = (mouse_relative_y >= third_height && mouse_relative_y < third_height * 2);
			var bottom_third = (mouse_relative_y >= third_height * 2);
			
			// Handle mouse navigation with audio/visual feedback
			if (top_third && menu_cursor != 0)
			{
				audio_play_sound(SNselect, 5, false);
				menu_cursor = 0;
			}
			else if (middle_third && menu_cursor != 1)
			{
				audio_play_sound(SNselect, 5, false);
				menu_cursor = 1;
			}
			else if (bottom_third && menu_cursor != 2)
			{
				audio_play_sound(SNselect, 5, false);
				menu_cursor = 2;
			}
			
			// Handle left click for selection
			if (mouse_check_button_pressed(mb_left) && click_delay == 0)
			{
				if (top_third)
				{
					// Top third - select "continue" (menu_cursor = 0)
					menu_cursor = 0;
				}
				else if (middle_third)
				{
					// Middle third - select "new game" (menu_cursor = 1)
					menu_cursor = 1;
				}
				else if (bottom_third)
				{
					// Bottom third - select "exit" (menu_cursor = 2)
					menu_cursor = 2;
				}
				click_delay = 5; // Small delay before executing selection
			}
		}
		else
		{
			// Mouse is outside the menu board
			if (mouse_check_button_pressed(mb_left) && click_delay == 0)
			{
				// Left click outside = escape
				with(OmainMenu)
				{
					chapter_committed = -1;
					chapter_control = true;
					chapter_selected = false;
					not_selected = true;
					chapter_one = false;
					chapter_two = false;
					chapter_three = false;
					not_board = true;
					Ochapter_arrow.timer = true;
					TRANS(TRANS_MODE.GOTO,"cloud",Rmain_menu);
				}
				click_delay = 10; // Prevent underlying objects from detecting this click
			}
		}
		
		// Execute selection after delay
		if (click_delay == 1)
		{
			menu_selected = true;
		}
		
		//moving the image
		image_index = menu_cursor;
		
		
	    if( keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space) or gamepad_button_check_pressed(0,gp_face1) ) menu_selected = true;
	
		if(menu_selected)
	    {
			audio_play_sound(SNchoosen,5,false);
	        menu_committed = menu_cursor;
	        menu_control = false;
	    }

		if (menu_selected) and (menu_committed != -1)
		{
			switch (menu_committed)
			{	

				case 0: default: // "continue"
				{
				    if (global.chapter1) {
				        global.chapter = 1;
				        var target_room = global.load_chapter_progress();
				        if (target_room == false) {
				            // No save exists, start new game
				            TRANS(TRANS_MODE.GOTO, "strawberry", level1);
				        } else {
				            // Load saved progress
				            TRANS(TRANS_MODE.GOTO, "strawberry", target_room);
				        }
				    } else if (global.chapter2) {
				        global.chapter = 2;
				        var target_room = global.load_chapter_progress();
				        if (target_room == false) {
				            // No save exists, start new game
				            TRANS(TRANS_MODE.GOTO, "strawberry", level1);
				        } else {
				            // Load saved progress
				            TRANS(TRANS_MODE.GOTO, "strawberry", target_room);
				        }
				    }
				}
				break;

				case 1: //new game 
				{
				    global.reset_chapter_progress(); // Clear only current chapter
					global.kill_counter = 0; //reset the kill counter
				    if (global.chapter1) {
						global.chapter = 1;
				        TRANS(TRANS_MODE.GOTO,"strawberry",rougeL1);
				    } else if (global.chapter2) {
						global.chapter = 2;
				        TRANS(TRANS_MODE.GOTO,"strawberry", rougeL1);
				    }
				    break;
				}
			
				case 2: //exit
				{
					with(OmainMenu)
					{
						chapter_committed = -1;
						chapter_control = true;
						chapter_selected = false;
						not_selected = true;
						chapter_one = false;
						chapter_two = false;
						chapter_three = false;
						not_board = true;
						Ochapter_arrow.timer = true;
						TRANS(TRANS_MODE.GOTO,"cloud",Rmain_menu);
					}
					break;
				}
			}
		}
}