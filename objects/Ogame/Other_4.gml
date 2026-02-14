window_set_fullscreen(true)

// Destroy upgrade cards if entering error room or main menu
if (room == Rerror || room == Rmain_menu) {
    with (Oupgrade_cards) {
        instance_destroy();
    }
    showing_upgrade_cards = false;
    upgrade_cards_created = false;
}

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

//key and upgrade
global.key = false;
upgraded = false;

// Reset bonus levels for this room
room_bonus_levels = 0;
extra_levels = 0;

// Count bonus levels from all enemies in the room
with (Ojack) {
    if (level_upgrade > 0 && instance_exists(Ogame)) {
        Ogame.extra_levels += level_upgrade;
        show_debug_message("Found enemy with level_upgrade=" + string(level_upgrade));
    }
}
show_debug_message("Total extra_levels for room: " + string(extra_levels));

//create the player
if(!instance_exists(Ocherry)) and room != Rerror and room != Rmain_menu
{
	instance_create_layer(global.spawn_x,global.spawn_y,"player",Ocherry);
}