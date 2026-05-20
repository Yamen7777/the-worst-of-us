if (!has_hit) {
    var _hp_before = Ocherry.hp;
    Ocherry.damage_taken(damage, x, image_xscale, true);
    if (Ocherry.hp < _hp_before) {
        has_hit = true;
    }
}