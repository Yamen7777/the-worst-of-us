x += lengthdir_x(spd,dir);
y += lengthdir_y(spd,dir);

if (place_meeting(x,y,Owall)) 
{
	spd = 0;
	instance_change(OEspark,true);
}

if(place_meeting(x,y,Ocherry)) {with(Ocherry) {STATE = STATE_DEAD;}}