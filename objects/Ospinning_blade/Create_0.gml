// Movement
move_speed = 40;
base_direction = Ocherry.face == 1 ? 0 : 180; // Right if facing right, left if facing left

// Random angle tilt
angle_tilt = random_range(-2.5, 2.5);
direction = base_direction + angle_tilt;

// Starting position
start_x = x;
start_y = y;
max_distance = 1750;

damage = 7.5;