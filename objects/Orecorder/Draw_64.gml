/// @description recording indicator
if(ghostRecord)
{
    draw_set_color(c_red);
    draw_circle(400,100,50,false);
    draw_text(100,100, string(ghostFrames));
}