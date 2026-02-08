// Movement
move_speed = 40;
base_direction = Oyokai.face == 1 ? 0 : 180; // Right if facing right, left if facing left
// Random angle tilt
angle_tilt = random_range(-2, 2);
direction = base_direction + angle_tilt;
// Starting position
start_x = x;
start_y = y;
max_distance = 2000;
damage = 0;

// Arc projectile variables (for blue_fire2)
arc_distance = random_range(1800, 1900); // How far it travels horizontally
arc_height = random_range(200, 300); // How high the arc goes
arc_progress = 0; // Current progress along the arc (0 to 1)
arc_speed = 0.015; // How fast it moves along the arc (adjust for speed)
arc_direction = Oyokai.face == 1 ? 1 : -1; // 1 for right, -1 for left

//explode timer
explode = false
explode_timer = 2;
explode_time = explode_timer;

//fire 3 charge
charge = 0;
//super
blue_sprit = 0;

//enemies and walls
_obstacle = [Owall,Ojack,Odummy,OdummyF];

destroy = false;