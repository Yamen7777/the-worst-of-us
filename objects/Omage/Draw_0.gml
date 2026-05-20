draw_self();
draw_set_font(Fm5x7M);
draw_set_color(c_white);
draw_set_halign(fa_middle);
draw_set_valign(fa_middle);
// Draw gamer tag above level
draw_text(x, y-410, gamer_tag);
draw_text(x,y-360,"LEVEL: " +string(enemy_level));