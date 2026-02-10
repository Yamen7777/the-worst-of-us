// Draw GUI Event
// Get camera dimensions
var cam_width = camera_get_view_width(view_camera[0]);
var cam_height = camera_get_view_height(view_camera[0]);

// Draw the card sprite
draw_sprite_ext(sprite_index, image_index, x, y, hover_scale, hover_scale, 0, c_white, 1);

// Draw upgrade type text below card with larger font
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_orange);
draw_set_font(Fm5x7);

var display_name = "";
switch(upgrade_type) {
    case "attack":
        display_name = "DAMAGE";
        break;
    case "defence":
        display_name = "DEFENCE";
        break;
    case "range":
        display_name = "RANGE";
        break;
    case "speed":
        display_name = "SWIFTNESS";
        break;
    case "spell":
        display_name = "ENERGY";
        break;
}

// Calculate text position (accounting for scale)
var text_y = y + (sprite_get_height(sprite_index) * hover_scale / 2) + 75;
// Draw text with additional scaling (you can adjust the 3 multiplier)
draw_text_transformed(x, text_y, display_name, hover_scale * 3, hover_scale * 3, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);