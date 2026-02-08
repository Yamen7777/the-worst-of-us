//item ease in
y = lerp(y,menuY_target,menu_speed);

//item control
if(OmainMenu.menu_cursor == 0)
{
	
	selected = true;
}
else selected = false;

if(selected)
{
	image_index = 1;
}
else image_index = 0;

var mouse_is_over = position_meeting(mouse_x, mouse_y, id);

if (mouse_is_over and !mouse_was_over and !selected and OmainMenu.menu_control) {
    audio_play_sound(SNselect, 5, false);
    OmainMenu.menu_cursor = 0;
}

mouse_was_over = mouse_is_over;

if(position_meeting(mouse_x, mouse_y, id)) and (OmainMenu.menu_control) and (mouse_check_button_pressed(mb_left))
{
	OmainMenu.menu_selected = true;
}