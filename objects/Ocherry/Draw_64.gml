// Draw player level and upgrade debug info
draw_set_font(Fm5x7L);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

if (instance_exists(Ocherry)) {
    var debug_x = 1500;
    var debug_y = 500;
    var line_height = 80;
    
    draw_text(debug_x, debug_y, "LEVEL: " + string(Ocherry.player_level));
    draw_text(debug_x, debug_y + line_height, "ATTACK: " + string(Ocherry.upgrade_attack) + "/5");
    draw_text(debug_x, debug_y + line_height * 2, "DEFENCE: " + string(Ocherry.upgrade_defence) + "/5");
    draw_text(debug_x, debug_y + line_height * 3, "RANGE: " + string(Ocherry.upgrade_range) + "/5");
    draw_text(debug_x, debug_y + line_height * 4, "SPEED: " + string(Ocherry.upgrade_speed) + "/5");
    draw_text(debug_x, debug_y + line_height * 5, "SPELL: " + string(Ocherry.upgrade_spell) + "/5");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_font(FLM);
draw_set_colour(c_red);
draw_text(700,500,string(hp));