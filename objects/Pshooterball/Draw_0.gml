draw_self();

if  (flash > 0)
{
	flash--;
	shader_set(Shflash);
	draw_self();
	shader_reset();
}