/// @description menu control
//OmainMenu step



//room control
if(room == Rmain_menu)
{
	main_menu = true;
	chapters = false;
}
else if(room == Rchapters)
{
	main_menu = false;
	chapters = true;
}
else
{
	main_menu = false;
	chapters = false;
}


//main menu control
if(main_menu)
{
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
			if(menu_cursor != 1)
			{
				Ostart_button.menuY_target += 300;
				Oexit_button.menuY_target += 300;
				Onew_save.menuY_target += 300;
			}
	    }
	}

	if (menu_selected) and (menu_committed != -1)
	{
		switch (menu_committed)
		{
			case 2: default: 
			{
				// Check if this is a first-time player (no save file exists)
				if(!global.load_main_progress())
				{
					// First time player - go to intro
					TRANS(TRANS_MODE.GOTO,"cloud",Rintro);
				}
				else
				{
					// Returning player - go to chapters
					TRANS(TRANS_MODE.GOTO,"cloud",Rchapters);
				}
			}
			break;
			case 1: 
			{
				confirm_board = true;
				confirm_control = true; 
				main_menu = false;
				chapters = false;
			}
			break;
			case 0: game_end(); break;
		}
	}
}


//chapter control
if(chapters)
{
	//keyboard control
	if(chapter_control)
	{
	
		if(chapter_selected)
	    {
			audio_play_sound(SNchoosen,5,false);
	        chapter_committed = chapter_cursor;
	    }
	}
	if(chapter_committed != -1) and (keyboard_check_pressed(vk_escape))
	{
		chapter_committed = -1;
		chapter_control = true;
		chapter_selected = false;
		not_selected = true;
		chapter_one = false;
		chapter_two = false;
		chapter_three = false;
		not_board = true;
	}
	if(not_selected)
	{
		//island one
		global.not_selected = true;
		global.chapter1 = false;
		global.chapter2 = false;
		global.chapter3 = false;
		if(not_board)
		{
			instance_destroy(Omenu_board);
			not_board = false;
		}
	}
	if(chapter_one)
	{
		global.not_selected = false;
		global.chapter1 = true;
		global.chapter2 = false;
		global.chapter3 = false;
		if(board)
		{
			with(instance_create_layer(1120,480,"menu",Omenu_board)) locked = false;
			board = false;
		}
	}
	if(chapter_two)
	{
		global.not_selected = false;
		global.chapter1 = false;
		global.chapter2 = true;
		global.chapter3 = false;
		if(board)
		{
			if(Oisland_two.chapter_open)
			{
				with(instance_create_layer(28,480,"menu",Omenu_board)) locked = false;
			}
			else with(instance_create_layer(28,480,"menu",Omenu_board)) locked = true;
			board = false;
		}
		
	}
	if(chapter_three)
	{
		global.not_selected = false;
		global.chapter1 = false;
		global.chapter2 = false;
		global.chapter3 = true;
		if(board)
		{
			if(Oisland_three.chapter_open)
			{
				with(instance_create_layer(28,480,"menu",Omenu_board)) locked = false;
			}
			else with(instance_create_layer(28,480,"menu",Omenu_board)) locked = true;
			board = false;
		}
	}
	if (chapter_selected) and (chapter_committed != -1)
	{
		switch (chapter_committed)
		{
			case 0: default: 
			{
				chapter_one = true;
				chapter_two = false;
				chapter_three = false; 
				chapter_control = false;
				break;
			}
			case 1: 
			{
					not_selected = false;
					chapter_one = false;
					chapter_two = true;
					chapter_three = false;
					chapter_control = false;
				break;
			}
			case 2: 
			{
					not_selected = false;
					chapter_one = false;
					chapter_two = false;
					chapter_three = true; 
					chapter_control = false;
				break;
			}
		}
	}
	
}

//confirm board 
		if(confirm_board)
		{
			menu_selected = false;
		    //instance create Oconfirm_board and loose control until yes or no were choosen
			if(confirm_control)
			{
				
				with instance_create_layer(608,480,"buttons",Oconfirm_board) depth = 1;
				confirm_control = false;
			}
		}
		else
		{
			if(confirm_control)
			{
				main_menu = true;
		        menu_selected = false;
		        menu_committed = -1;
				menu_control = true;
				confirm_control = false;
			}
		}
		