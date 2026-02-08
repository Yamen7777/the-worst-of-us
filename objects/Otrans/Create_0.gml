/// @description size variables and mode setup

W = display_get_gui_width();
H = display_get_gui_height();
H_half = H * 0.5;

enum TRANS_MODE
{
	OFF,
	NEXT,
	GOTO,
	RESTART,
	INTRO,
	AGAIN
}

mode = TRANS_MODE.INTRO;
percent = 1;
target = room;


again = false;
restart = false;
intro = false; 
goto = false;
next = false;


//types of transtions
strawberry_slide = false;
cloud = false;
thunder = false;

//cloud vars 
transition_speed_in = 5;   // frames at 25fps for fade in
transition_speed_out = 10; // frames at 25fps for fade out
base_fps = 25;
percent = 1; // Start at 1 for fade-out transitions
transition_created = false;

//chapters
current_chapter = 1; // Tracks which chapter we're transitioning for
chapter_override = -1; // Allows forcing a specific chapter

//audio
again = false;
restart = false;
intro = false; 
goto = false;
next = false;
sound_cooldown_timer = 0;

sound_to_play = 0;