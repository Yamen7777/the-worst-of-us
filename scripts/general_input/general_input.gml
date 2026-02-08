function input_setup()
{
	buffer_time = 5;
	Jbuffer = false;
	Jbuffer_timer = 0;
}

function general_input(){
	if (hasControl)
	{
		//diractions input
		left = keyboard_check(ord("a")) or keyboard_check(ord("A")) or keyboard_check(vk_left) or gamepad_button_check(0,gp_padl) or gamepad_button_check(0,gp_shoulderlb) or gamepad_axis_value(0,gp_axislh) < -0.5; 
		right = keyboard_check(ord("d")) or keyboard_check(ord("D")) or keyboard_check(vk_right) or gamepad_button_check(0,gp_padr) or gamepad_button_check(0,gp_shoulderrb) or gamepad_axis_value(0,gp_axislh) > 0.5;
		down = keyboard_check(ord("s")) or keyboard_check(ord("S")) or keyboard_check(vk_down) or gamepad_button_check(0,gp_padd) or gamepad_axis_value(0,gp_axislv) > 0.5;
		up = keyboard_check(ord("w")) or keyboard_check(ord("W")) or keyboard_check(vk_up) or gamepad_button_check(0,gp_padu) or gamepad_axis_value(0,gp_axislv) < -0.5; 
	
	
		//action input
		jump = keyboard_check_pressed(vk_space) or gamepad_button_check_pressed(0,gp_face1); //	X
		jump_hold = keyboard_check(vk_space) or gamepad_button_check(0,gp_face1); // X
		running = keyboard_check(vk_shift) or gamepad_button_check(0,gp_face3); // □ (Square)
		dash = keyboard_check_pressed(vk_control) or gamepad_button_check_pressed(0,gp_face2); // △ (Triangle)
		LMB = mouse_check_button_pressed(mb_left);
		HLMB = mouse_check_button(mb_left);
		RMB = mouse_check_button_pressed(mb_right);
		HRMB = mouse_check_button(mb_right);
		shift = keyboard_check(vk_shift);
		spell1 = keyboard_check(ord("q")) or keyboard_check(ord("Q"));
		spell2 = keyboard_check(ord("e")) or keyboard_check(ord("E"));
		spell3 = keyboard_check(ord("r")) or keyboard_check(ord("R"));
	
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