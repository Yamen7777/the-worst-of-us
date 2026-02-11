switch(state) {
    case "delay":
        timer++;
        if (timer >= delay_time) {
            timer = 0;
            state = "scale_in";
        }
        break;
        
    case "scale_in":
        scale += scale_speed;
        rotation -= rotation_speed;
        if (scale >= 1.2) {
            scale = 1.2;
            rotation = -20;
            state = "scale_settle";
            // Add current room to visited list and save progress
            global.add_room_to_visited(room);
        }
        break;
        
    case "scale_settle":
        scale -= scale_speed * 0.3;
        rotation += rotation_speed * 0.3;
        if (scale <= 1) {
            scale = 1;
            rotation = 0;
            state = "showing";
            timer = 0;
        }
        break;
        
    case "showing":
        timer++;
        if (timer >= show_time) {
            state = "scale_out_grow";
        }
        break;
        
    case "scale_out_grow":
        scale += scale_speed;
        rotation -= rotation_speed;
        if (scale >= 1.2) {
            scale = 1.2;
            rotation = -30;
            state = "scale_out_shrink";
        }
        break;
        
    case "scale_out_shrink":
        scale -= scale_speed;
        rotation += rotation_speed * 2;
        if (scale <= 0) {
            instance_destroy();
        }
        break;
}