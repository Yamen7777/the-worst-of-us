/// @description camera movment
//camera position
var camX = camera_get_view_x(camera);
var camY = camera_get_view_y(camera);
var camW = camera_get_view_width(camera);
var camH = camera_get_view_height(camera);

//camera target
if(instance_exists(Ocherry))
{
	var targetX = (Ocherry.x - camW/2) + 500;
	var targetY = (Ocherry.y - camH/2) - 500;
}
else
{
	var targetX = global.spawn_x;
	var targetY = global.spawn_y;
}

//clamp camara
targetX = clamp(targetX,0+buff,(room_width - camW)-buff);
targetY = clamp(targetY,0+buff,(room_height - camH)-buff);

//smooth camera
camX = lerp(camX,targetX,CAM_SMOOTH);
camY = lerp(camY,targetY,CAM_SMOOTH);

//apply shake
camX += random_range(-shake_remain,shake_remain);
camY += random_range(-shake_remain,shake_remain);
shake_remain = max(0,shake_remain-((1/shake_length)*shake_magnitude));

//apply camera position
camera_set_view_pos(camera,camX,camY);
camera_set_view_size(camera,camW,camH);

// Parallax effect - applied after camera position is set
// Calculate parallax offset based on camera position
var parallax_offset = camX - (room_width / 2);
var parallax_offset_y = camY - (room_height / 2);

// Apply parallax effect to all 9 background layers with much slower speeds
// Background (closest) - moves at 10% speed
if (layer_exists("Background")) {
    layer_x("Background", -parallax_offset * 0.10);
    layer_y("Background", -parallax_offset_y * 0.10);
}

// Background1 - moves at 8.75% speed
if (layer_exists("Background1")) {
    layer_x("Background1", -parallax_offset * 0.0875);
    layer_y("Background1", -parallax_offset_y * 0.0875);
}

// Background2 - moves at 7.5% speed
if (layer_exists("Background2")) {
    layer_x("Background2", -parallax_offset * 0.075);
    layer_y("Background2", -parallax_offset_y * 0.075);
}

// Background3 - moves at 6.25% speed
if (layer_exists("Background3")) {
    layer_x("Background3", -parallax_offset * 0.0625);
    layer_y("Background3", -parallax_offset_y * 0.0625);
}

// Background4 - moves at 5% speed
if (layer_exists("Background4")) {
    layer_x("Background4", -parallax_offset * 0.05);
    layer_y("Background4", -parallax_offset_y * 0.05);
}

// Background5 - moves at 3.75% speed
if (layer_exists("Background5")) {
    layer_x("Background5", -parallax_offset * 0.0375);
    layer_y("Background5", -parallax_offset_y * 0.0375);
}

// Background6 - moves at 3.125% speed
if (layer_exists("Background6")) {
    layer_x("Background6", -parallax_offset * 0.03125);
    layer_y("Background6", -parallax_offset_y * 0.03125);
}

// Background7 - moves at 2.5% speed
if (layer_exists("Background7")) {
    layer_x("Background7", -parallax_offset * 0.025);
    layer_y("Background7", -parallax_offset_y * 0.025);
}

// Background8 - moves at 1.875% speed
if (layer_exists("Background8")) {
    layer_x("Background8", -parallax_offset * 0.01875);
    layer_y("Background8", -parallax_offset_y * 0.01875);
}

// Background9 (furthest) - moves at 1.25% speed
if (layer_exists("Background9")) {
    layer_x("Background9", -parallax_offset * 0.0125);
    layer_y("Background9", -parallax_offset_y * 0.0125);
}

