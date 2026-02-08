if(OmainMenu.chapter_selected) and (control)
{
	startY = y;
	control = false;
}

if(global.not_selected)
{
	y = lerp(y,startY,0.1)
}
if(OmainMenu.chapter_committed != -1) and (keyboard_check_pressed(vk_escape))
{
	timer = true;
}
if(timer)
{
	time = lerp(time,0,0.1)
}
if(time <= 0.3)
{
	timer = false;
	time = 5;
	startY = 0;
	control = true;
	TRANS(TRANS_MODE.GOTO,"cloud",Rmain_menu);
}

if(global.not_selected) and (control)
{
	with(OmainMenu)
	{
		if(chapters)
		{
			if(chapter_cursor == 0)
			{
				with(other)
				{
					x = chapter1X;
					y = chpater1Y;
				}
			}
			if(chapter_cursor == 1)
			{
				with(other)
				{
					x = chapter2X;
					y = chapter2Y;
				}
			}
		if(chapter_cursor == 2)
			{
				with(other)
				{
					x = chapter3X;
					y = chapter3Y;
				}
			}
		}
	}
}

if(!global.not_selected)
{
	y = lerp(y,2100,0.1)
}
