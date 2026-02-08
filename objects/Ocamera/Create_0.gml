/// @description camera input
//resolution
#macro RES_W 3733
#macro RES_H 2240
#macro RES_SCALE 1
#macro CAM_SMOOTH 0.1

//enable view
view_enabled = true;
view_visible[0] = true;

//create camera 
camera = camera_create_view(0,0,RES_W,RES_H);
view_set_camera(0,camera);

//resize window & application surface
window_set_size(RES_W * RES_SCALE,RES_H * RES_SCALE);
surface_resize(application_surface,RES_W * RES_SCALE,RES_H * RES_SCALE);
display_set_gui_size(RES_W,RES_H);

//center window
var displayW = display_get_width();
var displayH = display_get_height();

var windowW = RES_W * RES_SCALE;
var windowH = RES_H * RES_SCALE;

window_set_position(displayW/2 - windowW/2,displayH/2 - windowH/2);

//screen shake
shake_length = 0;
shake_magnitude = 0;
shake_remain = 0;
buff = 32;
	