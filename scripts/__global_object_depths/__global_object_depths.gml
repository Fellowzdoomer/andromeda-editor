function __global_object_depths() {
	// Initialise the global array that allows the lookup of the depth of a given object
	// GM2.0 does not have a depth on objects so on import from 1.x a global array is created
	// NOTE: MacroExpansion is used to insert the array initialisation at import time
	gml_pragma( "global", "__global_object_depths()");

	// insert the generated arrays here
	global.__objectDepths[0] = 0; // Obj_FileManager
	global.__objectDepths[1] = 0; // Obj_FileManager_CreateFolder
	global.__objectDepths[2] = 0; // Obj_FileManager_File
	global.__objectDepths[3] = 0; // Obj_FileManager_Folder
	global.__objectDepths[4] = 0; // Obj_FileManager_ItemParent
	global.__objectDepths[5] = 0; // Obj_FileManager_Refresh
	global.__objectDepths[6] = 0; // Obj_FileManager_PathUp
	global.__objectDepths[7] = 0; // Obj_FileManager_Trash
	global.__objectDepths[8] = 0; // Obj_FileManager_AndroidAppStorage
	global.__objectDepths[9] = 0; // Obj_FileManager_AndroidExternal
	global.__objectDepths[10] = 0; // Obj_FileManager_GoHome
	global.__objectDepths[11] = 0; // Obj_FileManager_CreateFile


	global.__objectNames[0] = "Obj_FileManager";
	global.__objectNames[1] = "Obj_FileManager_CreateFolder";
	global.__objectNames[2] = "Obj_FileManager_File";
	global.__objectNames[3] = "Obj_FileManager_Folder";
	global.__objectNames[4] = "Obj_FileManager_ItemParent";
	global.__objectNames[5] = "Obj_FileManager_Refresh";
	global.__objectNames[6] = "Obj_FileManager_PathUp";
	global.__objectNames[7] = "Obj_FileManager_Trash";
	global.__objectNames[8] = "Obj_FileManager_AndroidAppStorage";
	global.__objectNames[9] = "Obj_FileManager_AndroidExternal";
	global.__objectNames[10] = "Obj_FileManager_GoHome";
	global.__objectNames[11] = "Obj_FileManager_CreateFile";


	// create another array that has the correct entries
	var len = array_length_1d(global.__objectDepths);
	global.__objectID2Depth = [];
	for( var i=0; i<len; ++i ) {
		var objID = asset_get_index( global.__objectNames[i] );
		if (objID >= 0) {
			global.__objectID2Depth[ objID ] = global.__objectDepths[i];
		} // end if
	} // end for


}
