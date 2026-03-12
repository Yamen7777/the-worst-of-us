image_alpha -= 0.001;
if(image_alpha == 0.1) instance_destroy();

if(image_index >= 9) image_speed = 0;

hsp *= 0.95; // friction
vsp += 0.5; // gravity

if(place_meeting(x,y-1,Owall)) vsp = 0;

x += hsp;
y += vsp;
