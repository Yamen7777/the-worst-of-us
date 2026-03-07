image_alpha -= 0.001;
if(image_alpha == 0.1) instance_destroy();

if(image_index >= 9) image_speed = 0;

// Push state handling for dead body
if (push_state) {
    // Count down timer
    push_state_timer--;
    if (push_state_timer <= 0) {
        push_state = false;
    }
    
    // Show yellow blend during push state
    image_blend = c_yellow;
    
    // Check for horizontal wall collision
    if (hsp != 0) {
        var _wall_check = noone;
        if (hsp > 0) {
            _wall_check = instance_place(x + abs(hsp) + 5, y, Owall);
        } else {
            _wall_check = instance_place(x - abs(hsp) - 5, y, Owall);
        }
        
        if (_wall_check != noone) {
            // Hit a wall - just stop, no damage (already dead)
            hsp = 0;
            
            // End push state early
            push_state = false;
            image_blend = c_white;
        }
        
        // Check for collision with other Ojack enemies
        var _other_enemy = noone;
        if (hsp > 0) {
            _other_enemy = instance_place(x + abs(hsp) + 10, y, Ojack);
        } else {
            _other_enemy = instance_place(x - abs(hsp) - 10, y, Ojack);
        }
        
        if (_other_enemy != noone) {
            // Hit another Ojack - calculate damage
            var _impact_speed = abs(hsp);
            var _damage = 0;
            
            if (_impact_speed >= 3) {
                // Scale damage from 1 to 10 based on speed (3 to 50+)
                _damage = floor(lerp(1, 10, clamp((_impact_speed - 3) / 47, 0, 1)));
            }
            
            // Other enemy takes full damage (dead body gives full damage)
            if (_damage > 0) {
                _other_enemy.hp -= _damage;
                with (_other_enemy) {
                    show_damage_number(x, y, -_damage, -370);
                }
            }
            
            // Give other enemy a small knockback (25 at 50+ hsp, 1 at 3 hsp)
            var _other_knockback = 0;
            if (_impact_speed >= 3) {
                _other_knockback = floor(lerp(1, 25, clamp((_impact_speed - 3) / 47, 0, 1)));
            }
            _other_enemy.hsp = sign(hsp) * _other_knockback;
            
            // Give other enemy push state
            if (abs(_other_knockback) >= 1) {
                _other_enemy.push_state = true;
                _other_enemy.push_state_timer = _other_enemy.push_state_time;
            }
            
            // Stop horizontal movement
            hsp = 0;
            
            // End push state early
            push_state = false;
            image_blend = c_white;
        }
    }
} else {
    image_blend = c_white;
}

hsp *= 0.95; // friction
vsp += 0.5; // gravity

if(place_meeting(x,y-1,Owall)) vsp = 0;

x += hsp;
y += vsp;
