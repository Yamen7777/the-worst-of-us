//keyboard control
if(keyboard_check_pressed(vk_right))
{
    audio_play_sound(SNselect, 5, false);
    menu_cursor++;
    if (menu_cursor >= menu_items) menu_cursor = 0;
}
if(keyboard_check_pressed(vk_left))
{
    audio_play_sound(SNselect, 5, false);
    menu_cursor--;
    if (menu_cursor < 0) menu_cursor = menu_items - 1;
}

// Also allow escape to cancel
if(keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("O")))
{
    instance_destroy();
    OmainMenu.menu_control = true;
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

// Check if mouse is over the confirm board's collision box
if (point_in_rectangle(mouse_x_in_world, mouse_y_in_world, collision_left, collision_top, collision_right, collision_bottom))
{
    // Calculate the center of the collision box for left/right detection
    var collision_center_x = (collision_left + collision_right) / 2;
    
    // Determine which half the mouse is in
    var left_half = (mouse_x_in_world < collision_center_x);
    
    // Handle mouse navigation with audio/visual feedback
    if (left_half && menu_cursor != 1)
    {
        audio_play_sound(SNselect, 5, false);
        menu_cursor = 1;
    }
    else if (!left_half && menu_cursor != 0)
    {
        audio_play_sound(SNselect, 5, false);
        menu_cursor = 0;
    }
    
    // Handle left click for selection
    if (mouse_check_button_pressed(mb_left) && click_delay == 0)
    {
        if (left_half)
        {
            // Left half - select "YES" (menu_cursor = 1)
            menu_cursor = 1;
        }
        else
        {
            // Right half - select "NO" (menu_cursor = 0)
            menu_cursor = 0;
        }
        click_delay = 5; // Small delay before executing selection
    }
}
else
{
    // Mouse is outside the confirm board
    if (mouse_check_button_pressed(mb_left) && click_delay == 0)
    {
        // Left click outside = escape
        instance_destroy();
        OmainMenu.menu_control = true;
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

if(keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) menu_selected = true;

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
		case 0: default: // NO - close the confirm board only
		{
		    // Reset menu selection state but DON'T move buttons back
		    with(OmainMenu) {
				confirm_board = false
				confirm_control = true;
		    }
			instance_destroy();
		}
		break;
        
        case 1: //YES - delete everything and go to intro
        {
            // Reset all progress
            global.reset_all_progress();
            
            // Reset chapter selection states
            with(OmainMenu) {
                menu_selected = false;
                menu_committed = -1;
            }
			
			// NOW move the buttons down as animation
		    Ostart_button.menuY_target += 300;
		    Oexit_button.menuY_target += 300;
		    Onew_save.menuY_target += 300;
            
            // Go to intro (first-time player experience)
            TRANS(TRANS_MODE.GOTO,"cloud",Rintro);
            instance_destroy();
        }
        break;
    }
}