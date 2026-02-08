/// @desc GUI/Vars/Menu setup


//rooms
main_menu = false;
chapters = false;

//main menu
menu_committed = -1;
menu_control = true;
menu_selected = false;

menu[2] = "start";
menu[1] = "new save";
menu[0] = "exit";

menu_items = array_length(menu);
menu_cursor = 2;

//confirm board
confirm_board = false;
confirm_control = false;

//chapters
chapter_committed = 2;
chapter_control = true;
chapter_selected = false;

//chapter array
chapter[0] = "chapter 1"
chapter[1] = "chapter 2"
chapter[2] = "chapter 3"

chapter_items = array_length(chapter);
chapter_cursor = 1;

//chapter selection
not_selected = true;
chapter_one = false;
chapter_two = false;
chapter_three = false;
board = false;

chapter_selected = true;
board = true;
not_board = false;

//global chapter selection
global.not_selected = true;
global.chapter1 = false;
global.chapter2 = false;
global.chapter3 = false;
