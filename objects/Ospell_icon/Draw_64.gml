draw_self();

draw_set_font(Fm5x7M);
draw_set_colour(c_orange);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
if(sprite_index == Sspell1) draw_text(x+25,y+70,"Q");
if(sprite_index == Sspell2) draw_text(x+25,y+70,"E");
if(sprite_index == Sspell3) draw_text(x+25,y+70,"R");
if(sprite_index == Sspell_dash) draw_text(x+1,y+70,"ctrl");
