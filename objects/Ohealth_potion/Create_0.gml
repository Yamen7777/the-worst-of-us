/// Ohealth_potion Create Event

// Potion type (set by creator)
is_big = false; // Will be set to true/false when created

// Physics
hsp = 0;
vsp = 0;
grv = 0.4;
bounce_count = 0;
max_bounces = 2;
can_collect = false; // Can't collect until it settles

// Wave movement
originY = y;
wave_angle = 0;
wave_speed = 0.1;
wave_height = 8;
is_settled = false;

