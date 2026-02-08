//width and hight
var cam_w = display_get_gui_width();
var cam_h = display_get_gui_height();

//Stretch the sprite to full GUI dimensions
draw_sprite_ext(sprite_index, image_index, 0, 0, cam_w/sprite_width, cam_h/sprite_height, 0, c_white, 1);