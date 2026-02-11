/// ObloodPar Step Event
// Safety check - ensure fullBlood is always valid
if (is_undefined(fullBlood) || fullBlood <= 0) {
    if (instance_exists(Ocherry)) {
        fullBlood = Ocherry.current_max_blood;
    } else {
        fullBlood = 50; // Fallback
    }
}

// Safety check - ensure blood is valid
if (is_undefined(blood)) {
    blood = 0;
}

// Clamp blood to valid range
blood = clamp(blood, 0, fullBlood);

// Visual update
if (sprite_index == SbloodPar2) {
    image_xscale = blood / fullBlood;
}