// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function find_lump_asset(str)
{
    for (var i = 0; i < array_length(aWadArrayName); i++) {
        if (aWadArrayName[i] == str)
		{
			//show_debug_message(str + " is in the wadArrayName array!");
			return {
				name: aWadArrayName[i],
				pos: aWadArrayLocation[i],
				size: aWadArraySize[i]
			};
		}
    }
    return -1;
}