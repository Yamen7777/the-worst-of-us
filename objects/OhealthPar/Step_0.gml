with(Ocherry)
{
	     if(hp == 100) other.image_index = 0;
	else if(hp >=  90) other.image_index = 1;
	else if(hp >=  80) other.image_index = 2;
	else if(hp >=  70) other.image_index = 3;
	else if(hp >=  60) other.image_index = 4;
	else if(hp >=  50) other.image_index = 5;
	else if(hp >=  40) other.image_index = 6;
	else if(hp >=  30) other.image_index = 7;
	else if(hp >=  20) other.image_index = 8;
	else if(hp >=  10) other.image_index = 9;
	else if(hp ==  1 ) other.image_index = 10;
	else if(hp <=  00) other.image_index = 11;

}