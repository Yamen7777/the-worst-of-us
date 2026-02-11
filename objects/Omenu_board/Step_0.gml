/// @description menu control

// Only process menu if we're in the main menu room
if(room != Rmain_menu) exit;

//keyboard control
if(menu_control)
{
    if keyboard_check_pressed(ord("w")) or keyboard_check_pressed(ord("W")) or keyboard_check_pressed(vk_up) or gamepad_button_check(0,gp_padu) or gamepad_axis_value(0,gp_axislv) < -0.5
    {
        audio_play_sound(SNselect, 5, false);
        menu_cursor++;
        if (menu_cursor >= menu_items) menu_cursor = 0;
    }
    if keyboard_check_pressed(ord("s")) or keyboard_check_pressed(ord("S")) or keyboard_check_pressed(vk_down) or gamepad_button_check(0,gp_padd) or gamepad_axis_value(0,gp_axislv) > 0.5
    {
        audio_play_sound(SNselect, 5, false);
        menu_cursor--;
        if (menu_cursor < 0) menu_cursor = menu_items - 1;
    }

    if( keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space) or gamepad_button_check_pressed(0,gp_face1) )  menu_selected = true;

    if(menu_selected)
    {
        audio_play_sound(SNchoosen,5,false);
        menu_committed = menu_cursor;
        menu_control = false;
        
        // Animate buttons down
        if(instance_exists(Ostart_button)) Ostart_button.menuY_target += 300;
        if(instance_exists(Oexit_button)) Oexit_button.menuY_target += 300;
        if(instance_exists(Onew_save)) Onew_save.menuY_target += 300;
    }
}

if (menu_selected) and (menu_committed != -1)
{
    switch (menu_committed)
    {
        case 2: default: // "continue" (Ostart_button)
        {
            // Try to load saved progress
            if(!global.load_main_progress())
            {
                // No save exists, start new game
                TRANS(TRANS_MODE.GOTO, "strawberry", Rtutorial);
            }
            else
            {
                // Save exists - load chapter progress
                var target_room = global.load_chapter_progress();
                if (target_room == false) {
                    // Chapter save doesn't exist, start new
                    TRANS(TRANS_MODE.GOTO, "strawberry", Rtutorial);
                } else {
                    // Load saved progress
                    TRANS(TRANS_MODE.GOTO, "strawberry", target_room);
                }
            }
            break;
        }
        
        case 1: // "new game" (Onew_save)
        {
            // Reset visited rooms and collected flowers for new save (from Onew_save step)
            ds_list_clear(global.visited_rooms);
            ds_map_clear(global.main_collected_flowers);
            global.main_flower_count = 0;
            
            global.reset_chapter_progress(); // Clear chapter save
            global.kill_counter = 0; // Reset kill counter
            
            TRANS(TRANS_MODE.GOTO, "strawberry", Rtutorial);
            break;
        }
        
        case 0: // "exit" (Oexit_button)
        {
            game_end();
            break;
        }
    }
}