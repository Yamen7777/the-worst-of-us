// Regular Draw Event
draw_self(); // Draw the slot sprite

if(room == Ressance)
{
	if(image_index == 1)
	{
	    draw_set_font(Fm5x7L);
	    draw_set_colour(c_aqua);
	    draw_text(x + 210, y + 50, "fling");
	}
	if(image_index == 2)
	{
	    draw_set_font(Fm5x7L);
	    draw_set_colour(c_orange);
	    draw_text(x + 210, y + 50, "burst");
	}
	if(image_index == 3)
	{
	    draw_set_font(Fm5x7L);
	    draw_set_colour(c_fuchsia);
	    draw_text(x + 210, y + 50, "attract");
	}
}

if(room == Rtutorial)
{
	if(global.fling) and (global.grasp) //ocherry slot 2 attract
    {
		image_index = 3;
        draw_set_font(Fm5x7L);
	    draw_set_colour(c_fuchsia);
	    draw_text(x -15, y - 100, "attract");
		
		//fragment discription
		draw_set_font(Fm5x7L);
	    draw_set_colour(c_dkgray);
		if(instance_exists(Ocherry)) draw_text(x + 230, y + 50, "Recall your blades back, slicing through enemies as they return");
		
    }
    else if(global.fling) and (global.burst) //yokai slot 2 burst
    {
		image_index = 2;
        //fragment name
	    draw_set_font(Fm5x7L);
	    draw_set_colour(c_orange);
	    draw_text(x + 20, y - 100, "burst");
		
		//fragment discription
		draw_set_font(Fm5x7L);
	    draw_set_colour(c_dkgray);
		if(instance_exists(Oyokai)) draw_text(x + 230, y + 50, "Blue fire bursts on impact, dealing area damage");
    }
    else if(global.grasp) and (global.burst) //werewolf slot 2 attract
    {
		image_index = 3;
        draw_set_font(Fm5x7L);
	    draw_set_colour(c_fuchsia);
	    draw_text(x -15, y - 100, "attract");
		
		//fragment discription
		draw_set_font(Fm5x7L);
	    draw_set_colour(c_dkgray);
		if(instance_exists(Owerewolf)) draw_text(x + 230, y + 50, "Your fangs latch onto enemies, preventing them from escaping");
    }
}