// Position following for AT4 and AT5
if (sprite_index == Sscratch4 || sprite_index == SscratchP4 || sprite_index == SscratchP5 ) {
    if (instance_exists(Owerewolf)) {
        with(Owerewolf) {
            if (sprite_index == SwerewolfAT4 || sprite_index == SPwerewolfAT4) {
                hsp = 30 * face;
                with(other) {
                    if (other.face == 1) var _scratchX = 250;
                    if (other.face == -1) var _scratchX = -250;
                    x = Ocherry.x + _scratchX;
                    y = Ocherry.y - 230;
                }
            } else if (sprite_index == SwerewolfAT5 || sprite_index == SPwerewolfAT5) {
                invincible = true;
                var charge_level = floor(hold_time / hold_scratch);
                hsp = (20 * face) * charge_level;
                
                with(other) {
                    if (other.face == 1) var _scratchX = 250;
                    if (other.face == -1) var _scratchX = -250;
                    x = Ocherry.x + _scratchX;
                    y = Ocherry.y - 230;
                }
            }
        }
    }
}

// Clinch to the enemy - only if they're colliding with THIS scratch
var _hit_enemy = instance_place(x, y, Ojack);
if (_hit_enemy != noone) {
    with(_hit_enemy) {
        if (Owerewolf.face == 1) var _catchX = 150;
        if (Owerewolf.face == -1) var _catchX = -150;
        x = lerp(x,other.x + _catchX,0.2)
        hsp = 0;
    }
}