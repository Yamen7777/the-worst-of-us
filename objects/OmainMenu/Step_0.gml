/// @description menu control
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
        
        if(instance_exists(Ostart_button)) Ostart_button.menuY_target += 300;
        if(instance_exists(Oexit_button)) Oexit_button.menuY_target += 300;
        if(instance_exists(Onew_save)) Onew_save.menuY_target += 300;
    }
}

if (menu_selected) and (menu_committed != -1)
{
    switch (menu_committed)
    {
        case 2: default: // "continue"
        {
            var target_room = global.load_progress();
            // Check if load_progress returned a valid room (number) or false
            if (target_room != false && target_room != undefined) {
                // Successfully loaded - go to saved room
                show_debug_message("CONTINUE: Going to room " + string(target_room));
                TRANS(TRANS_MODE.GOTO, "strawberry", target_room);
            } else {
                // No save file found - start new game
                show_debug_message("CONTINUE: No save found, starting new game");
                global.reset_all_progress();
                TRANS(TRANS_MODE.GOTO, "strawberry", Rtutorial);
            }
            break;
        }
        
        case 1: // "new game"
        {
            show_debug_message("NEW GAME: Resetting progress");
            global.reset_all_progress();
            TRANS(TRANS_MODE.GOTO, "strawberry", Rtutorial);
            break;
        }
        
        case 0: // "exit"
        {
            game_end();
            break;
        }
    }
}