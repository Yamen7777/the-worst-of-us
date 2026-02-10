draw_set_font(Fm5x7);
draw_set_color(c_gray);

if(essance_room)
{
	draw_text(300,0,"your character is built differently depending on the fragments you choose\n choose 2 fragments to fuse with your essance");
	if(fuse_option)
	{
		draw_text(400,300,"press ENTER to fuse the your essance with the fragments");
	}
}
else
{
	draw_set_font(Fm5x7M);
	draw_set_color(c_black);
	draw_text(500,840,"I: fullscreen\nO: auto kill\nP: game restart")
}

if (!tutorial) exit;
if (!global.dummy_dialogue_finished) exit;

draw_set_font(Fm5x7L);
draw_set_alpha(1);

var xx = 2000;
var yy = 250;
var line_space = 14;

var text_array;

if (current_character == "cherry")
{
    switch (tutorial_step)
	{
	    // -------------------------
	    // LESSON 0
	    // -------------------------
		case 0:
	        if (tutorial_step_complete) draw_set_color(c_lime);
			else draw_set_color(c_dkgray);
	        draw_text(xx, yy,
	        "running: Press shift to run.\n");
	    break;
		
		// -------------------------
	    // LESSON 1
	    // -------------------------
	    case 1:
	        if (tutorial_step_complete) draw_set_color(c_lime);
			else draw_set_color(c_dkgray);
	        draw_text(xx, yy,
	        "Attacks: Press LMB 3 times to attack.\n" +
	        "Your attack creates spinning blades that penetrate through enemies\n" +
	        "and stay in place when they reach their destination.");
	    break;

	    // -------------------------
	    // LESSON 2
	    // -------------------------
	    case 2:
	        if (tutorial_step_complete) draw_set_color(c_lime);
			else draw_set_color(c_dkgray);
	        draw_text(xx, yy,
	        "Hold Attack: Hold LMB to throw multiple blades at once.\n" +
	        "You can see how many blades you are going to throw\n" +
	        "by looking at the blade meter.");

	        // arrow indicator
	        draw_text(xx - 1050 , yy + 75, "<---");
	    break;

	    // -------------------------
	    // LESSON 3
	    // -------------------------
	    case 3:
	        var blade_count = instance_number(Oblade_spot);

	        if (tutorial_step_complete) draw_set_color(c_lime);
			else draw_set_color(c_dkgray);
	        draw_text(xx, yy,
	        "Super: Press E to attract your blades back.\n" +
	        "You can also see how many blades you have out.");

	        var blade_text;
	        if (blade_count == 9)
	        {
	            blade_text = "You currently have 9 blades out, which is the maximum.";
	        }
	        else
	        {
	            blade_text = "You currently have " + string(blade_count) +
	                         " blades out, 9 is the maximum.";
	        }

	        draw_text(xx, yy + 180, blade_text);
		
			// arrow indicator
	        draw_text(xx - 1050 , yy + 75, "<---");
	    break;

	    // -------------------------
	    // LESSON 4
	    // -------------------------
	    case 4:
	        if (tutorial_step_complete) draw_set_color(c_lime);
			else draw_set_color(c_dkgray);
	        draw_text(xx, yy,
	        "Special:\n" +
	        "Your specials are:\n" +
	        "1. Double jump\n" +
	        "2. Attacking and using Super mid-air");

	        if (tutorial_dj_complete)
	        {
	            draw_set_color(c_lime);
	            draw_text(xx, yy + 176, "1. Double jump");
	        }

	       if (tutorial_air_complete)
			{
			    draw_set_color(c_lime);
			    draw_text(xx, yy + 262, "2. Attacking and using Super mid-air");
			}
			break;
		// -------------------------
		// FINAL – GOOD TO GO
		// -------------------------
		case 5:
		    draw_set_color(c_lime);
		    draw_text(xx, yy, "You are good to go.\n" +
			"you can press P to restart the game the try different fragments");
			break;
	}
}
else if(current_character == "yokai")
{
    switch (tutorial_step)
	{
		// -------------------------
	    // LESSON 0
	    // -------------------------
		case 0:
	        if (tutorial_step_complete) draw_set_color(c_lime);
			else draw_set_color(c_dkgray);
	        draw_text(xx, yy,
	        "running: Press shift to run.\n");
	    break;
		
	    // -------------------------
	    // LESSON 1
	    // -------------------------
	    case 1:
		    if (tutorial_step_complete) draw_set_color(c_lime);
		    else draw_set_color(c_dkgray);
	        draw_text(xx, yy,
	        "Attack: Press LMB 3 times to attack.\n" +
	        "Your attack creates blue fire that hits enemies from a distance.\n" +
	        "The blue fire bursts on impact, dealing area damage.");
			break;


	    // -------------------------
	    // LESSON 2
	    // -------------------------
	    case 2:
		    if (tutorial_step_complete) draw_set_color(c_lime);
		    else draw_set_color(c_dkgray);

	        draw_text(xx, yy,
	        "Hold Attack: Hold LMB to charge.\n" +
	        "You throw a large blue fire depending on how long you charge.\n" +
	        "The bigger the fire, the stronger the explosion.");
			break;


	    // -------------------------
	    // LESSON 3
	    // -------------------------
	    case 3:
		    if (tutorial_step_complete) draw_set_color(c_lime);
		    else draw_set_color(c_dkgray);

	        draw_text(xx, yy,
	        "Super: Press E to use your super.\n" +
	        "Every time you kill an enemy, you gain their fire spirit.\n" +
	        "Spirits charge your super. More spirits make it stronger,\n" +
	        "with a maximum of 8 spirits.");
			
			// arrow indicator
	        draw_text(xx - 1050 , yy + 75, "<---");
			break;


	    // -------------------------
	    // LESSON 4
	    // -------------------------
	    case 4:
		    if (tutorial_step_complete) draw_set_color(c_lime);
		    else draw_set_color(c_dkgray);

	        draw_text(xx, yy,
	        "Special:\n" +
	        "Your special ability is:\n" +
	        "RMB to dash.\n" +
	        "You cannot take damage while dashing.\n" +
			"your walk and run speeds are slower.");
			break;

		// -------------------------
		// FINAL – GOOD TO GO
		// -------------------------
		case 5:
		    draw_set_color(c_lime);
		    draw_text(xx, yy, "You are good to go.\n" +
			"you can press P to restart the game the try different fragments");
			break;
	}
}
else if(current_character == "werewolf")
{
    switch (tutorial_step)
	{
		// -------------------------
	    // LESSON 0
	    // -------------------------
		case 0:
	        if (tutorial_step_complete) draw_set_color(c_lime);
			else draw_set_color(c_dkgray);
	        draw_text(xx, yy,
	        "running: Press shift to run.\n");
	    break;
		
	    // -------------------------
        // LESSON 1 – ATTACK
        // -------------------------
        case 1:
            if (tutorial_step_complete) draw_set_color(c_lime);
            else draw_set_color(c_dkgray);

            draw_text(xx, yy,
            "Attack: Press LMB 3 times to attack.\n" +
            "Your attack creates big scratches.\n" +
            "These scratches can damage multiple enemies at once.");
        break;

        // -------------------------
        // LESSON 2 – HOLD ATTACK
        // -------------------------
        case 2:
            if (tutorial_step_complete) draw_set_color(c_lime);
            else draw_set_color(c_dkgray);

            draw_text(xx, yy,
            "Hold Attack: Hold LMB to charge.\n" +
            "You leap at enemies, creating a powerful scratch.\n" +
            "The longer you charge, the higher the damage.");
        break;

        // -------------------------
        // LESSON 3 – SUPER
        // -------------------------
        case 3:
            if (tutorial_step_complete) draw_set_color(c_lime);
            else draw_set_color(c_dkgray);

            draw_text(xx, yy,
            "Super: Press E to use your super.\n" +
            "Your super create a burst and transforms you into a red werewolf\n" +
            "with bigger and stronger scratches.\n" +
            "Every attack drains enemy blood.\n" +
            "Blood extends the transformation duration.");
			
			// arrow indicator
	        draw_text(xx - 1050 , yy + 75, "<---");
        break;

        // -------------------------
        // LESSON 4 – SPECIALS
        // -------------------------
        case 4:
            if (tutorial_step_complete) draw_set_color(c_lime);
            else draw_set_color(c_dkgray);

            draw_text(xx, yy,
            "Specials:\n" +
            "1. Extremely high running speed: shift\n" +
            "2. Run attack: Hold Shift + LMB");

        break;

        // -------------------------
        // FINAL – GOOD TO GO
        // -------------------------
        case 5:
		    draw_set_color(c_lime);
		    draw_text(xx, yy, "You are good to go.\n" +
			"you can press P to restart the game the try different fragments");
			break;
	}
}
