if keyboard_check_pressed(vk_space) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) or gamepad_button_check_pressed(0,gp_face1) or gamepad_button_check_pressed(0,gp_face2)
{
	TRANS(TRANS_MODE.GOTO,"cloud",Rchapters);
	if(audio_is_playing(SNintro)) audio_stop_sound(SNintro);
	
}