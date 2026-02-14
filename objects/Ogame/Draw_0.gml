
if (room == Rtutorial) {
    draw_tutorial();
}

if(room == Rtutorial)
{
	if(tutorial_complete)
	{
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_colour(c_red)
		draw_text(12300,1965,"everytime you die you loose a level")
	}
	else 
	{
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_colour(c_white)
		draw_text(12000,1965,"go back and finish the tutorial")
	}
}