var halfW = w * 0.5;

// Draw the box
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_roundrect_ext(x - halfW - border, y - h - (border * 2), x + halfW + border, y, 15, 15, false);
draw_set_alpha(1);

// Draw marker
draw_sprite(Smarker, 0, x, y);

// Draw text
DrawText(c_white, Fm5x7L, fa_center, fa_top);
draw_text(x, y - h - border, text_current);

// Draw "-enter-" prompt for dialogue when complete