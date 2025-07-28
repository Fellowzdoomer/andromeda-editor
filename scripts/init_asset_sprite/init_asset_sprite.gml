// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_asset_sprite(d_sprite, surfID, isSprite){
	
		lump = find_lump_asset(d_sprite);
		if (lump == -1) {
			show_debug_message("Lump not found: " + string(d_sprite));
			return;
		}
		
		buffer_seek(assetFile,buffer_seek_start,lump.pos);
		gfxWidth = buffer_read(assetFile,buffer_u16);
		gfxHeight = buffer_read(assetFile,buffer_u16);
		gfxOffX = buffer_read(assetFile,buffer_u16);
		gfxOffY = buffer_read(assetFile,buffer_u16);
		loadedSprite = [];
		gfxColumnIndex = [];
		gfxColumnHStarts = [];
		gfxColumnYStarts = [];
	
		if (isSprite)
		{
			if (surface_exists(assetSurface)) surface_free(assetSurface)
			if (!surface_exists(assetSurface))
			{
				assetSurface = surface_create(gfxWidth,gfxHeight)	
			}
			surface_set_target(assetSurface);
		}
		else
		{
			if (surface_exists(textureSurface)) surface_free(textureSurface)
			if (!surface_exists(textureSurface))
			{
				textureSurface = surface_create(gfxWidth,gfxHeight)	
			}
			surface_set_target(textureSurface);
		}
		draw_clear_alpha(c_black,0);
		
		if (isSprite){
			var _x = 0;
			for (var i = 0; i < gfxWidth; i++)
			{
				var colIndexLive = buffer_read(assetFile,buffer_u32);
				array_push(gfxColumnIndex,colIndexLive);
			}
			
			for (var j = 0; j < array_length(gfxColumnIndex); j++)
			{
				buffer_seek(assetFile,buffer_seek_start,lump.pos + gfxColumnIndex[j]);
				var colYStarts = [];
				var colHeights = [];
				var colPixels = [];

				while true
				{
					var columnY = buffer_read(assetFile, buffer_u8);
					if (columnY == 255) break;

					var columnH = buffer_read(assetFile, buffer_u8);
					buffer_read(assetFile, buffer_u8); // unused byte 1

					var postData = [];
					for (var i = 0; i < columnH; i++) {
						array_push(postData, buffer_read(assetFile, buffer_u8));
					}
					buffer_read(assetFile, buffer_u8); // unused byte 2

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
			global.sprAsset[surfID] = sprite_create_from_surface(assetSurface,0,0,gfxWidth,gfxHeight,false,false,0,0);
			}
}