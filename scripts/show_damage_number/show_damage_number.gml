/// @desc show_damage_number(x, y, amount, y_offset, type)
/// @arg x - The x position
/// @arg y - The y position  
/// @arg amount - The amount to display
/// @arg y_offset - Height above character
/// @arg type - "damage", "heal", or "block"
function show_damage_number(_x, _y, _amount, _y_offset, _type = "damage") {
    with (instance_create_layer(_x, _y, "instances", Odamage_number)) {
        target_x = _x;
        target_y = _y;
        display_type = _type;
        y_offset = _y_offset;
        
        switch (_type) {
            case "damage":
                damage_value = -_amount;
                display_color = c_red;
                break;
            case "heal":
                damage_value = "+" + string(_amount);
                display_color = c_green;
                break;
            case "block":
                damage_value = "BLOCK";
                display_color = c_gray;
                break;
        }
    }
}