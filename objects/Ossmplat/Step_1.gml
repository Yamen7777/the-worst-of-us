// circle move
dir += spdrot;

//target position
var _targetX = xstart + lengthdir_x(radius,dir);
var _targetY = ystart + lengthdir_y(radius,dir);

// X & Y speed based on movement type
hsp = move_x ? (_targetX - x) : 0; // Move only if move_x is true
vsp = move_y ? (_targetY - y) : 0; // Move only if move_y is true

//move
x += hsp;
y += vsp;