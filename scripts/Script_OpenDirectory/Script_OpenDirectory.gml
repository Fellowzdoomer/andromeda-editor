function Script_OpenDirectory(argument0) {
	Path = argument0

	if(!FileManager_checkPermission() and os_type == os_android)
	{
		FileManager_getPermission()
		exit
	}


	with(Obj_FileManager_Folder) instance_destroy()
	with(Obj_FileManager_File) instance_destroy()

	show_debug_message("JSON Files")
	show_debug_message(FileManager_getDirectoryContent(Path))
	var Map = json_decode(FileManager_getDirectoryContent(Path))

	var X = 100
	var Y = 200
	var w = 120
	var h = 120
	var posx = X
	var posy = Y

	var FolderCount = real(Map[?"FolderCount"])
	for(var a = 0 ; a < FolderCount ; a++)
	{
		var ins = instance_create(posx,posy,Obj_FileManager_Folder);
		ins.Path = Path+"/"+Map[?"Folder"+string(a)]
		ins.Name = Map[?"Folder"+string(a)]
		posx += w
		if(posx > room_width-w)
		{
			posx = X 
			posy += h
		}
	}

	posx = X 
	posy += h

	var FileCount=real(Map[?"FileCount"])
	for(var a = 0 ; a < FileCount ; a++)
	{
		var ins = instance_create(posx,posy,Obj_FileManager_File);
		ins.Path = Path+"/"+Map[?"File"+string(a)]
		ins.Name = Map[?"File"+string(a)]
		posx += w
		if (posx>room_width-w)
		{
			posx = X 
			posy += h
		}
	}

	ds_map_destroy(Map)




}
