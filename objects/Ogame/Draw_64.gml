draw_set_font(Fm5x7);
draw_set_color(c_gray);

if(room != Rerror and room != Rmain_menu)
{
	draw_set_font(Fm5x7M);
	draw_set_color(c_black);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text(500,520,"I: fullscreen\nO: auto kill\nP: game restart")
}