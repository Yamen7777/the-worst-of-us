originY = y;
wave_angle = 0;
wave_speed = 0.1;
wave_height = 8;
collected = false; // Reset collection state

// Unique ID using precise position
my_id = "f_" + string(room) + "_" + string(round(x/16)*16) + "_" + string(round(y/16)*16);

// Only check permanent collection
if (variable_global_exists("collected_flowers") && ds_map_exists(global.collected_flowers, my_id)) {
    instance_destroy();
    exit;
}

