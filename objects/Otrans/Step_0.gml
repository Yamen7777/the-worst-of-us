
// Add this at the top of your step event, before the transition code
// Sound cooldown timer
if (sound_cooldown_timer > 0) {
    sound_cooldown_timer--;
}

// strawberry transition
if (strawberry_slide) {
    if (mode != TRANS_MODE.OFF) {
        if (mode == TRANS_MODE.INTRO) {
            percent = max(0, percent-1);
            instance_create_layer(0, 0, layer, Otrans_SH);
        } else {
            percent = min(1, percent+0.05);
            instance_create_layer(0, 0, layer, Otrans_FH);
        }

        if (percent == 1 || percent == 0) {
            switch (mode) {
                case TRANS_MODE.INTRO:
                    mode = TRANS_MODE.OFF;
                    break;
                    
                case TRANS_MODE.NEXT:
                    if (!audio_is_playing(SNtransition)) {
                        audio_play_sound(SNtransition, 8, false);
                    }
                    mode = TRANS_MODE.INTRO;
                    room_goto_next();
                    break;
                    
                case TRANS_MODE.GOTO:
                    if (!audio_is_playing(SNtransition)) {
                        audio_play_sound(SNtransition, 8, false);
                    }
                    mode = TRANS_MODE.INTRO;
                    room_goto(target);
                    break;
                    
                case TRANS_MODE.RESTART:
                    if (!audio_is_playing(SNtransition)) {
                        audio_play_sound(SNtransition, 8, false);
                    }
					game_restart();
                    break;
                    
                case TRANS_MODE.AGAIN:
                    // Always play death/restart sound, even if other sounds are playing
                    audio_play_sound(SNagain, 8, false);
                    mode = TRANS_MODE.INTRO;
                    room_restart();
                    break;
            }
        }
    }
}

// cloud transition 
if(cloud) {
    if (mode != TRANS_MODE.OFF) {
        if (mode == TRANS_MODE.INTRO) {
            var increment_amount = (1 / transition_speed_in) * (base_fps / room_speed);
            percent = min(1, percent + increment_amount);
            
            if (!transition_created) {
                instance_create_layer(0, 0, layer, Ocloud_transitionSH);
                transition_created = true;
            }
        } else {
            var decrement_amount = (1 / transition_speed_out) * (base_fps / room_speed);
            percent = max(0, percent - decrement_amount);
            
            if (!transition_created) {
                instance_create_layer(0, 0, layer, Ocloud_transitionFH);
                transition_created = true;
            }
        }

        if (percent <= 0 || percent >= 1) {
            transition_created = false;
        }
    
        if (percent == 1) or (percent == 0) {
           switch (mode) {
				case TRANS_MODE.INTRO: {
					mode = TRANS_MODE.OFF;
					break;
				}
				case TRANS_MODE.NEXT: {
					if (!audio_is_playing(SNtransition)) {
						audio_play_sound(SNtransition, 8, false);
					}
					mode = TRANS_MODE.INTRO;
					room_goto_next();
					break;
				}
				case TRANS_MODE.GOTO: {
					if (!audio_is_playing(SNtransition)) {
						audio_play_sound(SNtransition, 8, false);
					}
					mode = TRANS_MODE.INTRO;
					room_goto(target);
					break;
				}
				case TRANS_MODE.RESTART: {
					if (!audio_is_playing(SNtransition)) {
						audio_play_sound(SNtransition, 8, false);
					}
					game_restart();
					break;
				}
				case TRANS_MODE.AGAIN: {
					// Always play death/restart sound, even if other sounds are playing
					audio_play_sound(SNagain, 8, false);
					mode = TRANS_MODE.INTRO;
					room_restart();
					break;
				}
			}
		}
	}
}

// thunder transition 
if(thunder) {
    if (mode != TRANS_MODE.OFF) {
        if (mode == TRANS_MODE.INTRO) {
            transition_speed_in = 0.5714;  
			var increment_amount = (1 / transition_speed_in) * (base_fps / room_speed);  
			percent = min(1, percent + increment_amount);  
            
            if (!transition_created) {
                instance_create_layer(0, 0, layer, OlightningSH);
                transition_created = true;
            }
        } else {
            transition_speed_out = 6;  
			var decrement_amount = (1 / transition_speed_out) * (base_fps / room_speed);  
			percent = max(0, percent - decrement_amount);  
            
            if (!transition_created) {
                instance_create_layer(0, 0, layer, OlightningFH);
                transition_created = true;
            }
        }

        if (percent <= 0 || percent >= 1) {
            transition_created = false;
        }
    
        if (percent == 1) or (percent == 0) {
           switch (mode) {
				case TRANS_MODE.INTRO: {
					mode = TRANS_MODE.OFF;
					break;
				}
				case TRANS_MODE.NEXT: {
					if (!audio_is_playing(SNlightning)) {
						audio_play_sound(SNlightning, 8, false);
					}
					mode = TRANS_MODE.INTRO;
					room_goto_next();
					break;
				}
				case TRANS_MODE.GOTO: {
					if (!audio_is_playing(SNlightning)) {
						audio_play_sound(SNlightning, 8, false);
					}
					mode = TRANS_MODE.INTRO;
					room_goto(target);
					break;
				}
				case TRANS_MODE.RESTART: {
					if (!audio_is_playing(SNlightning)) {
						audio_play_sound(SNlightning, 8, false);
					}
					game_restart();
					break;
				}
				case TRANS_MODE.AGAIN: {
					// Always play death/restart sound, even if other sounds are playing
					audio_play_sound(SNlightning, 8, false);
					mode = TRANS_MODE.INTRO;
					room_restart();
					break;
				}
			}
		}
	}
}