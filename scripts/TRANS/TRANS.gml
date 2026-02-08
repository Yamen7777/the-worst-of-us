/// @desc TRANS(mode, transition_type, targetroom)
/// @arg mode            Transition mode (NEXT, RESTART, GOTO)
/// @arg transition_type "cloud" or "strawberry" (default)
/// @arg target          Target room (only for GOTO mode)

function TRANS(_mode, _transition_type = "strawberry", _target = room)
{
    with (Otrans)
    {
        mode = _mode;
        
        // Only set target if we're in GOTO mode
        if (_mode == TRANS_MODE.GOTO) {
            target = _target;
        }
        
        // Reset all transition types
        strawberry_slide = false;
        cloud = false;
		thunder = false;
        
        // Set the requested transition type
        switch (string_lower(_transition_type))
        {
            case "cloud":
                cloud = true;
                break;
                
            case "strawberry":
            default:
                strawberry_slide = true;
                break;
				
			case "thunder":
                thunder = true;
                break;	
        }
    }
}