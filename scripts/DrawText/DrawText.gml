/// @desc drawtext(colour,font,halign,valign)
/// @arg colour
/// @arg font
/// @arg hagign
/// @arg valign


function DrawText(_color, _font, _halign, _valign) 
{
    draw_set_colour(_color);
    draw_set_font(_font);
    draw_set_halign(_halign);
    draw_set_valign(_valign);
}