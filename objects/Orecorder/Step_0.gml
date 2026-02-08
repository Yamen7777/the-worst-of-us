/// @description recording logic
//toggle record
if(keyboard_check_pressed(vk_f2))
{
    ghostRecord = !ghostRecord;
    
    //start recording
    if(ghostRecord)
    {
        if(ds_exists(ghostList,ds_type_list)) ds_list_destroy(ghostList);
        ghostFrames = 0;
        ghostList = ds_list_create();
        show_debug_message("Started recording");
    }
    
    //stop recording and save 
    if(!ghostRecord) and (ds_exists(ghostList,ds_type_list))
    {
        var _wrapper = ds_map_create();
        ds_map_add_list(_wrapper,"root",ghostList);
        var _theLot = json_encode(_wrapper);
        
        var filename = "ghost_" + room_get_name(room) + ".json";
        
        // Use buffer method instead of file_text (more reliable)
        var _buffer = buffer_create(string_byte_length(_theLot), buffer_fixed, 1);
        buffer_write(_buffer, buffer_text, _theLot);
        buffer_save(_buffer, filename);
        buffer_delete(_buffer);
        
        ds_map_destroy(_wrapper);
        show_debug_message("Saved recording: " + filename);
    }
}

//record the player
if(ghostRecord) and (instance_exists(Ocherry))
{
    //record this frame
    var _frameToRecord = ds_map_create();
    with(Ocherry)
    {
        _frameToRecord[? "x"] = x;
        _frameToRecord[? "y"] = y;
        _frameToRecord[? "face"] = face;
        _frameToRecord[? "sprite"] = sprite_index;
        _frameToRecord[? "image"] = image_index;
    }
    
    ds_list_add(ghostList, _frameToRecord);
    ds_list_mark_as_map(ghostList, ds_list_size(ghostList)-1);
    ghostFrames++;
}