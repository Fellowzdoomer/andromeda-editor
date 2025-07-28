// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_doom_sprite_otf(d_sprite, surfID, isSprite){
	
		lump = find_lump(d_sprite);
		
		var wadFile = global.wadFileG;
		var spriteSurfaceOTF = -1;
		var textureSurfaceOTF = -1;
		buffer_seek(wadFile,buffer_seek_start,lump.pos);
		
		loadedSprite = [];
		gfxColumnIndex = [];
		gfxColumnHStarts = [];
		gfxColumnYStarts = [];
		gfxColumnXStarts = [];
	
		if (isSprite)
		{
			gfxWidth = buffer_read(global.wadFileG,buffer_u16);
			gfxHeight = buffer_read(global.wadFileG,buffer_u16);
			gfxOffX = buffer_read(global.wadFileG,buffer_u16);
			gfxOffY = buffer_read(global.wadFileG,buffer_u16);
			if (surface_exists(spriteSurfaceOTF)) surface_free(spriteSurfaceOTF)
			if (!surface_exists(spriteSurfaceOTF))
			{
				spriteSurfaceOTF = surface_create(gfxWidth,gfxHeight)	
			}
			surface_set_target(spriteSurfaceOTF);
		}
		else  // for flats, misnomer
		{
			if (surface_exists(textureSurfaceOTF)) surface_free(textureSurfaceOTF)
			if (!surface_exists(textureSurfaceOTF))
			{
				textureSurfaceOTF = surface_create(64,64)	
			}
			surface_set_target(textureSurfaceOTF);
		}
		draw_clear_alpha(c_black,0);
		
		if (isSprite){
			var _x = 0;
			for (var i = 0; i < gfxWidth; i++)
			{
				var colIndexLive = buffer_read(wadFile,buffer_u32);
				array_push(gfxColumnIndex,colIndexLive);
			}
			
			for (var j = 0; j < array_length(gfxColumnIndex); j++)
			{
				buffer_seek(wadFile,buffer_seek_start,lump.pos + gfxColumnIndex[j]);
				var colYStarts = [];
				var colHeights = [];
				var colPixels = [];

				while true
				{
					var columnY = buffer_read(wadFile, buffer_u8);
					if (columnY == 255) break;

					var columnH = buffer_read(wadFile, buffer_u8);
					buffer_read(wadFile, buffer_u8); // unused byte 1

					var postData = [];
					for (var i = 0; i < columnH; i++) {
						array_push(postData, buffer_read(wadFile, buffer_u8));
					}
					buffer_read(wadFile, buffer_u8); // unused byte 2

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
							global.colorsOTF[colorIndex][0],
							global.colorsOTF[colorIndex][1],
							global.colorsOTF[colorIndex][2]
						);
						draw_rectangle_color(col, yStart + i, col, yStart + i, pixCol, pixCol, pixCol, pixCol, false);
					}
				}
			}
		
			surface_reset_target();
			global.sprCache[surfID] = sprite_create_from_surface(spriteSurfaceOTF,0,0,gfxWidth,gfxHeight,false,false,0,0);
		}
		
		else
		{
			loadedSprite = [];
			buffer_seek(wadFile,buffer_seek_start,lump.pos);
	
			for (var i = 0; i < 4096; i++)
			{
				buffer_seek(wadFile,buffer_seek_start,lump.pos + i);
				pixelData = buffer_read(wadFile,buffer_u8);
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
			global.sprCache[surfID] = sprite_create_from_surface(textureSurfaceOTF,0,0,64,64,false,false,0,0);
		}
		//surface_reset_target();
}