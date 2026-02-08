// Only remove from list if we're still in it (wasn't removed by Ogame already)
var my_position = ds_list_find_index(global.blade_spots, id);

if (my_position != -1) {
    ds_list_delete(global.blade_spots, my_position);
}