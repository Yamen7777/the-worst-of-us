/// @description load ghost data
//setup
frame = 0;
var _teal = make_color_rgb(0, 112, 160); 
image_blend = _teal;
ghost_file_name = "ghost_" + room_get_name(room) + ".json";

//initialize variables
ghostDataRoot = -1;
ghostData = -1;
ghostFrames = 0;

//load data
if(file_exists(ghost_file_name))
{
    // Use buffer method to load
    var _buffer = buffer_load(ghost_file_name);
    var _jsonString = buffer_read(_buffer, buffer_text);
    buffer_delete(_buffer);
    
    ghostDataRoot = json_decode(_jsonString);
    
    // Check if the data was loaded successfully
    if(ghostDataRoot != -1 && ds_exists(ghostDataRoot, ds_type_map))
    {
        ghostData = ghostDataRoot[? "root"];
        
        // Check if ghostData exists and is a valid list
        if(ghostData != undefined && ds_exists(ghostData, ds_type_list))
        {
            ghostFrames = ds_list_size(ghostData);
        }
        else
        {
            show_debug_message("Ghost data is invalid");
            instance_destroy();
        }
    }
    else
    {
        show_debug_message("Failed to decode ghost JSON");
        instance_destroy();
    }
}
else 
{
    show_debug_message("No ghost file found: " + ghost_file_name);
    instance_destroy();
}