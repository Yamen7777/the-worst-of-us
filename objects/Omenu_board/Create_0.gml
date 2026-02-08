//locked chapters
locked = false;

//menu
menu_committed = -1;
menu_control = true;
menu_selected = false;

menu[0] = "continue";
menu[1] = "new game";
menu[2] = "exit";

menu_items = array_length(menu);
menu_cursor = 0;

// Mouse click delay to prevent underlying objects from detecting clicks
click_delay = 0;
