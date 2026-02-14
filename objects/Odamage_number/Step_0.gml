/// @description Move and fade
// Move upward
target_y -= move_speed;
// Update timer
timer++;
// Fade out in last 30%
var _progress = timer / duration;
if (_progress > 0.7) {
    alpha = 1.0 - ((_progress - 0.7) / 0.3);
}
// Scale pulse at start
if (timer < 10) {
    scale = 1.0 + sin(timer * 0.3) * 0.2;
} else {
    scale = 1.0;
}
// Destroy when done
if (timer >= duration) {
    instance_destroy();
}