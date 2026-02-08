// Position in bottom right corner
x = display_get_gui_width() - 600;
y = display_get_gui_height() - 400;

// Animation variables
alpha = 1;
scale = 0;
rotation = 125;
scale_speed = 0.15;
rotation_speed = 12;
show_time = 120;
timer = 0;
delay_time = 30; // 0.5 second delay at 60fps
state = "delay"; // Start with delay state