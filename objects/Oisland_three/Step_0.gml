//opening chapter 
if(chapter_open)
{
	image_index = 1;
}
else image_index = 0;

//selected
if(OmainMenu.chapter_cursor == 2)
{
	selected = true;
}
else selected = false;

var mouse_is_over = position_meeting(mouse_x, mouse_y, id);

if (mouse_is_over and !mouse_was_over and !selected and OmainMenu.chapter_control) and (Ochapter_arrow.control)
{
    audio_play_sound(SNselect, 5, false);
    OmainMenu.chapter_cursor = 2;
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
	positionX = 896;
	positionY = 288;
	scale = 0.75;
}
else if(global.chapter2)
{
	positionX = 928;
	positionY = 448;
	scale = 0.75;
}
else if(global.chapter3)
{
	positionX = -704;
	positionY = -224;
	scale = 1.2;
}

x = lerp(x,positionX,0.1);
y = lerp(y,positionY,0.1);
image_xscale = lerp(image_xscale,scale,0.1);
image_yscale = lerp(image_yscale,scale,0.1);