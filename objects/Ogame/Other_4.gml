window_set_fullscreen(true)

if(instance_exists(OmainMenu)) OmainMenu.not_board = false;

with(to_destroy)
{
	is_destroyed = true;
}

if(room == Rintro)
{
	audio_play_sound(SNintro,10,false)
}

//kill counter 
// Save the kill count at the start of this room
room_start_kill_count = global.kill_counter;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var draw_x = display_get_gui_width() / 2;
var draw_y = 50;

var text = "KILLS: " + string(global.kill_counter);

draw_text_transformed(
    draw_x, 
    draw_y, 
    text,
    kill_counter_scale,
    kill_counter_scale,
    kill_counter_rotation
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

//key
global.key = false;

//create the player
if(!instance_exists(Ocherry)) and (room != Rmain_menu)
{
	instance_create_layer(global.spawn_x,global.spawn_y,"player",Ocherry);
}