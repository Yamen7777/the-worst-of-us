//selected
if(OmainMenu.chapter_cursor == 0)
{
	selected = true;
}
else selected = false;

var mouse_is_over = position_meeting(mouse_x, mouse_y, id);

if (mouse_is_over and !mouse_was_over and !selected and OmainMenu.chapter_control) and (Ochapter_arrow.control)
{
    audio_play_sound(SNselect, 5, false);
    OmainMenu.chapter_cursor = 0;
}

mouse_was_over = mouse_is_over;

if(position_meeting(mouse_x, mouse_y, id)) and (OmainMenu.chapter_control) and (mouse_check_button_pressed(mb_left)) and (Ochapter_arrow.control)
{
	OmainMenu.chapter_selected = true;
	OmainMenu.board = true;
}

if(global.not_selected)
{
	positionX = 0;
	positionY = 0;
	scale = 1;
}
else if(global.chapter1)
{
	positionX = 32;
	positionY = -96;
	scale = 1.2;
}
else if(global.chapter2)
{
	positionX = -352;
	positionY = 320;
	scale = 0.75;
}
else if(global.chapter3)
{
	positionX = -416;
	positionY = 128;
	scale = 0.75;
}

x = lerp(x,positionX,0.1);
y = lerp(y,positionY,0.1);
image_xscale = lerp(image_xscale,scale,0.1);
image_yscale = lerp(image_yscale,scale,0.1);