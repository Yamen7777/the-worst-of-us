// Step event for platform
if (instance_exists(Ocherry))  // Ensure the player exists
{
	var _cam = view_camera[0]; // Get the first camera
	var _camX = camera_get_view_x(_cam); // Top-left X
	var _camY = camera_get_view_y(_cam); // Top-left Y
	var _camW = camera_get_view_width(_cam); // Width
	var _camH = camera_get_view_height(_cam); // Height

	if (x >= _camX && x <= _camX + _camW && y >= _camY && y <= _camY + _camH) {
	    // The point is inside the camera view!
	    // Put your original code here:
	    if (point_in_circle(Ocherry.x, Ocherry.y, x, y, 3200)) and (Ocherry.Djumping)
		{
			switching = true
	    }
	}

	if(switching) and (spdrot != 0)
	{
		vine = true;
		var mid_x = x + random_range(0, sprite_width);
		var mid_y = y + random_range(0, sprite_height);

		audio_sound_pitch(SNstopping,random_range(0.9,0.7));
		audio_play_sound(SNstopping,4,false);
		repeat (30)
		{
			instance_create_layer(mid_x,mid_y,"powerups",Odust)
		}
		spdrot = 0;
		switching = false;
	}

	if(switching) and (spdrot == 0)
	{
		vine = false;
		var mid_x = x + random_range(0, sprite_width);
		var mid_y = y + random_range(0, sprite_height);

		audio_sound_pitch(SNstopping,random_range(0.9,1.1));
		audio_play_sound(SNstopping,4,false);
		repeat (30)
		{
			instance_create_layer(mid_x,mid_y,"powerups",Odust)
		}
		spdrot = _speed;
		switching = false;
	}
	if(vine) image_index = 1;
	else image_index = 0;

}
