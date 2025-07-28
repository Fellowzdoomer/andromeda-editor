// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

///@function init_doom_graphic(d_sprite, surfID, useGraphicFormat, isTexture,isAsset,isFont,otf,otf_buffer)
///@description Initializes a Doom formatted graphic for GameMaker use.
///@param {String} d_sprite	The name of the sprite lump to load.
///@param {Real}	surfID The surface ID number to assign the sprite to.
///@param {Bool}	useGraphicFormat Whether this should be read in graphic format or RAW/Flat format
///@param {Bool}	isTexture (Optional) Is this a texture? Commonly used to initialize TEXTUREx entries
///@param {Bool}	isAsset (Optional) Is this graphic an Asset? (pulls from the assetFile WAD)
///@param {Bool}	isFont (Optional) Is this graphic a Font? Primarily used to prepare the font array
///@param {Bool}	otf (Optional)	On-The-Fly: Is this graphic being called in the moment?
///@param {String}	otf_buffer (Optional) What file to load the OTF graphic from. Note that OTF must be true in order to use this

function init_doom_graphic(d_sprite, surfID, useGraphicFormat, isTexture=false,isAsset=false,isFont=false,otf=false,otf_buffer=global.wadLoad) {
	var fileToLookAt;
	var flatSurfaceOTF = -1;
	var textureSurfaceOTF = -1;
	var spriteSurfaceOTF = -1;
	var assetSurfaceOTF = -1;
	var pnamesSurfaceOTF = -1;
	colors = global.colorsOTF;
	if (otf)
	{
		if (file_exists(otf_buffer)) fileToLookAt = buffer_load(otf_buffer)	
		else show_error(string(otf_buffer) + " does not exist! Terminating program.",false)
	}
	if (!otf)
	{
		if (isAsset) fileToLookAt = global.assetFileG;
		if (!isAsset) 
		{
			//if (otf) fileToLookAt = global.pWADFileG;
			fileToLookAt = global.wadFileG;
		}
	}
	lump = find_lump(d_sprite, isAsset);
	if (lump == -1) {
		show_debug_message("Lump not found: " + string(d_sprite));
		return;
	}
	
	//show_debug_message("Seeking to " + string(lump.pos) + " in file " + string(fileToLookAt));
	buffer_seek(fileToLookAt, buffer_seek_start, lump.pos);
	if (lump.pos < 0 || lump.pos >= buffer_get_size(fileToLookAt))
	{
	    show_debug_message("Invalid lump position: " + string(lump.pos));
	    exit; // or return
	}
	loadedSprite = [];
	gfxColumnIndex = [];
	gfxColumnHStarts = [];
	gfxColumnYStarts = [];
	gfxColumnXStarts = [];
	if (useGraphicFormat) // Sprites and graphics
	{
		gfxWidth = buffer_read(fileToLookAt,buffer_u16);
		gfxHeight = buffer_read(fileToLookAt,buffer_u16);
		gfxOffX = buffer_read(fileToLookAt,buffer_u16);
		gfxOffY = buffer_read(fileToLookAt,buffer_u16);
		
		if (isFont) // Specifically for fonts
		{
			if (otf)
			{
				if (surface_exists(fontSurfaceOTF)) surface_free(fontSurfaceOTF)
				if (!surface_exists(fontSurfaceOTF)) fontSurfaceOTF = surface_create(gfxWidth,gfxHeight)		
				surface_set_target(fontSurfaceOTF)	
			}
			else
			{
				if (surface_exists(fontSurface)) surface_free(fontSurface)
				if (!surface_exists(fontSurface)) fontSurface = surface_create(gfxWidth,gfxHeight)		
				surface_set_target(fontSurface)
			}
		}
		else if (isTexture)
		{
			if (!otf)
			{
				if (surface_exists(pnamesSurface)) surface_free(pnamesSurface)
				if (!surface_exists(pnamesSurface)) pnamesSurface = surface_create(gfxWidth,gfxHeight)		
				surface_set_target(pnamesSurface)
			}
			else
			{
				if (surface_exists(pnamesSurfaceOTF)) surface_free(pnamesSurfaceOTF)
				if (!surface_exists(pnamesSurfaceOTF)) pnamesSurfaceOTF = surface_create(gfxWidth,gfxHeight)		
				surface_set_target(pnamesSurfaceOTF)
			}
		}
		else // For everything else
		{
			if (otf)
			{
				if (surface_exists(spriteSurfaceOTF)) surface_free(spriteSurfaceOTF)
				if (!surface_exists(spriteSurfaceOTF)) spriteSurfaceOTF = surface_create(gfxWidth,gfxHeight)	
				surface_set_target(spriteSurfaceOTF);
			}
			else
			{
				if (surface_exists(spriteSurface)) surface_free(spriteSurface)
				if (!surface_exists(spriteSurface)) spriteSurface = surface_create(gfxWidth,gfxHeight)	
				surface_set_target(spriteSurface);
			}
		}
	}
	else  // for flats
	{
		if (otf)
		{
			if (surface_exists(flatSurfaceOTF)) surface_free(flatSurfaceOTF)
			if (!surface_exists(flatSurfaceOTF)) flatSurfaceOTF = surface_create(64,64)	
			surface_set_target(flatSurfaceOTF);
		}
		else
		{
			if (surface_exists(flatSurface)) surface_free(flatSurface)
			if (!surface_exists(flatSurface)) flatSurface = surface_create(64,64)	
			surface_set_target(flatSurface);
		}
	}
	draw_clear_alpha(c_black,0);
	
	if (useGraphicFormat){
		var _x = 0;
		for (var i = 0; i < gfxWidth; i++)
		{
			var colIndexLive = buffer_read(fileToLookAt,buffer_u32);
			array_push(gfxColumnIndex,colIndexLive);
		}
		
		for (var j = 0; j < array_length(gfxColumnIndex); j++)
		{
			buffer_seek(fileToLookAt,buffer_seek_start,lump.pos + gfxColumnIndex[j]);
			var colYStarts = [];
			var colHeights = [];
			var colPixels = [];
			while true
			{
				var columnY = buffer_read(fileToLookAt, buffer_u8);
				if (columnY == 255) break;
					var columnH = buffer_read(fileToLookAt, buffer_u8);
				buffer_read(fileToLookAt, buffer_u8); // unused byte 1
					var postData = [];
				for (var i = 0; i < columnH; i++) {
					array_push(postData, buffer_read(fileToLookAt, buffer_u8));
				}
				buffer_read(fileToLookAt, buffer_u8); // unused byte 2
				array_push(colYStarts, columnY);
				array_push(colHeights, columnH);
				array_push(colPixels, postData);
			}
			array_push(gfxColumnYStarts, colYStarts);
			array_push(gfxColumnHStarts, colHeights);
			array_push(loadedSprite, colPixels);
		}
	
		for (var col = 0; col < array_length(gfxColumnIndex); col++)
		{
			var postYs = gfxColumnYStarts[col];
			var postHs = gfxColumnHStarts[col];
			var postPixels = loadedSprite[col];
				for (var p = 0; p < array_length(postYs); p++)
			{
				var yStart = postYs[p];
				var yHeight = postHs[p];
				var pixels = postPixels[p];
					for (var i = 0; i < yHeight; i++)
				{
					var colorIndex = pixels[i];
					var pixCol = make_color_rgb(
						colors[colorIndex][0],
						colors[colorIndex][1],
						colors[colorIndex][2]
					);
					draw_rectangle_color(col, yStart + i, col, yStart + i, pixCol, pixCol, pixCol, pixCol, false);
				}
			}
		}
	
		surface_reset_target();
		if (isFont)
		{
			if (otf) global.sprCache[surfID] = sprite_create_from_surface(fontSurfaceOTF,0,0,gfxWidth,gfxHeight,false,false,0,0);
			else global.sprCache[surfID] = sprite_create_from_surface(fontSurface,0,0,gfxWidth,gfxHeight,false,false,0,0);
		}
		else if (isTexture)	
		{
			if (otf) global.sprPNAMESCache[surfID] = sprite_create_from_surface(pnamesSurfaceOTF,0,0,gfxWidth,gfxHeight,false,false,0,0);
			else global.sprPNAMESCache[surfID] = sprite_create_from_surface(pnamesSurface,0,0,gfxWidth,gfxHeight,false,false,0,0);
		}
		else
		{
			if (otf) global.sprCache[surfID] = sprite_create_from_surface(spriteSurfaceOTF,0,0,gfxWidth,gfxHeight,false,false,0,0);
			else global.sprCache[surfID] = sprite_create_from_surface(spriteSurface,0,0,gfxWidth,gfxHeight,false,false,0,0);
		}
	}
	
	else
	{
		loadedSprite = [];
		buffer_seek(fileToLookAt,buffer_seek_start,lump.pos);
		for (var i = 0; i < 4096; i++)
		{
			buffer_seek(fileToLookAt,buffer_seek_start,lump.pos + i);
			pixelData = buffer_read(fileToLookAt,buffer_u8);
			array_push(loadedSprite,pixelData);
		}
		gfxHeight = 64;
		gfxWidth = 64;	
		for (var _y = 0; _y < gfxHeight; _y++)
		{
			for (var _x = 0; _x < gfxWidth; _x++)
			{
				var index = _x + _y * gfxHeight;
				index = min(index, array_length(loadedSprite) - 1);
				var colorIndex = loadedSprite[index];
				var pixCol = make_color_rgb(
						colors[colorIndex][0],
						colors[colorIndex][1],
						colors[colorIndex][2]	
					)
				draw_rectangle_color(_x,_y,_x,_y,pixCol,pixCol,pixCol,pixCol,false)
			}
		}
		surface_reset_target();
		if (otf) global.sprFlat[surfID] = sprite_create_from_surface(flatSurfaceOTF,0,0,64,64,false,false,0,0);
		else global.sprFlat[surfID] = sprite_create_from_surface(flatSurface,0,0,64,64,false,false,0,0);
	}
}