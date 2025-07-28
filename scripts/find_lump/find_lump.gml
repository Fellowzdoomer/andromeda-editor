// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function find_lump(str, isAsset=false,pwad="")
{
	if (!isAsset)
	{
	    for (var i = 0; i < array_length(global.wadArrayName); i++) {
	        if (global.wadArrayName[i] == str)
			{
				//show_debug_message(str + " is in the wadArrayName array!");
				return {
					name: global.wadArrayName[i],
					pos: global.wadArrayLocation[i],
					size: global.wadArraySize[i]
				}
			}
	    }
	}
	else
	{
		for (var i = 0; i < array_length(global.aWadArrayName); i++) {
	        if (global.aWadArrayName[i] == str)
			{
				//show_debug_message(str + " is in the wadArrayName array!");
				return {
					name: global.aWadArrayName[i],
					pos: global.aWadArrayLocation[i],
					size: global.aWadArraySize[i]
				}
			}
		}
	}
    return -1;
}