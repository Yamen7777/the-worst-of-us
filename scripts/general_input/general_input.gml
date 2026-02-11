function input_setup()
{
	buffer_time = 5;
	Jbuffer = false;
	Jbuffer_timer = 0;
}

function general_input(){
	if (hasControl)
	{
		//direction input
		left = keyboard_check(ord("a")) or keyboard_check(ord("A")) or keyboard_check(vk_left) or gamepad_button_check(0,gp_padl) or gamepad_axis_value(0,gp_axislh) < -0.5; 
		right = keyboard_check(ord("d")) or keyboard_check(ord("D")) or keyboard_check(vk_right) or gamepad_button_check(0,gp_padr) or gamepad_axis_value(0,gp_axislh) > 0.5;
		down = keyboard_check(ord("s")) or keyboard_check(ord("S")) or keyboard_check(vk_down) or gamepad_button_check(0,gp_padd) or gamepad_axis_value(0,gp_axislv) > 0.5;
		up = keyboard_check(ord("w")) or keyboard_check(ord("W")) or keyboard_check(vk_up) or gamepad_button_check(0,gp_padu) or gamepad_axis_value(0,gp_axislv) < -0.5; 


		//action input
		// Jump - X button (gp_face1)
		jump = keyboard_check_pressed(vk_space) or gamepad_button_check_pressed(0,gp_face1);
		jump_hold = keyboard_check(vk_space) or gamepad_button_check(0,gp_face1);

		// Running/Shift - L2 (gp_shoulderl)
		running = keyboard_check(vk_shift) or gamepad_button_check(0,gp_shoulderl);
		shift = keyboard_check(vk_shift) or gamepad_button_check(0,gp_shoulderl);

		// Dash - L1 (gp_shoulderlb)
		dash = keyboard_check_pressed(vk_control) or gamepad_button_check_pressed(0,gp_shoulderlb);

		// Attack - R2 (gp_shoulderr) - PRESSED
		LMB = mouse_check_button_pressed(mb_left) or gamepad_button_check_pressed(0,gp_shoulderr);

		// Attack Hold - R2 (gp_shoulderr) - HELD
		HLMB = mouse_check_button(mb_left) or gamepad_button_check(0,gp_shoulderr);

		// Block - R1 (gp_shoulderrb) - PRESSED
		RMB = mouse_check_button_pressed(mb_right) or gamepad_button_check_pressed(0,gp_shoulderrb);

		// Block Hold - R1 (gp_shoulderrb) - HELD
		HRMB = mouse_check_button(mb_right) or gamepad_button_check(0,gp_shoulderrb);

		// Spell 1 (Q) - Square button (gp_face3)
		spell1 = keyboard_check_pressed(ord("q")) or keyboard_check_pressed(ord("Q")) or gamepad_button_check_pressed(0,gp_face3);

		// Spell 2 (E) - Triangle button (gp_face4)
		spell2 = keyboard_check_pressed(ord("e")) or keyboard_check_pressed(ord("E")) or gamepad_button_check_pressed(0,gp_face4);

		// Spell 3 (R) - Circle button (gp_face2)
		spell3 = keyboard_check_pressed(ord("r")) or keyboard_check_pressed(ord("R")) or gamepad_button_check_pressed(0,gp_face2);
	
		//jump buffer
		if(jump)
		{
			Jbuffer_timer = buffer_time;
		}
		if(Jbuffer_timer > 0)
		{
			Jbuffer = true;
			Jbuffer_timer--;
		}
		else
		{
			Jbuffer = false;
		}
	}
	else
	{
		left = 0;
		right = 0;
		down = 0;
		jump = 0;
		jump_hold = 0;
		running = 0;
	}
}