// Snap camera to spawn position
if (variable_global_exists("spawn_x") && variable_global_exists("spawn_y")) {
    var targetX = (global.spawn_x - RES_W / 2) + 500;
    var targetY = (global.spawn_y - RES_H / 2) - 500;

    // Clamp to room bounds
    targetX = clamp(targetX, 0, room_width - RES_W);
    targetY = clamp(targetY, 0, room_height - RES_H);

    camera_set_view_pos(camera, targetX, targetY);
}
