var _draw_x = target_x + x_offset;
var _draw_y = target_y + y_offset;
draw_set_alpha(alpha);
draw_set_font(Fm5x7M);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
// Shadow
draw_set_color(c_black);
for (var i = -2; i <= 2; i += 2) {
    for (var j = -2; j <= 2; j += 2) {
        draw_text_transformed(_draw_x + i, _draw_y + j, string(damage_value), scale, scale, 0);
    }
}
// Main text with appropriate color
draw_set_color(display_color);
draw_text_transformed(_draw_x, _draw_y, string(damage_value), scale, scale, 0);
draw_set_alpha(1);
draw_set_color(c_white);