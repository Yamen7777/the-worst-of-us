image_xscale = 0.35;
image_yscale = 2.5;
with(Ojaison)
{
	if(face ==  1) other.x = x + 200;
	if(face == -1) other.x = x - 200;
}
y = Ojaison.y - 300;