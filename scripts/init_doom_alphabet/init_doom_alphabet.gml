// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_doom_alphabet(d_sprite, surfID){
	
		lump = find_lump(d_sprite);
		if (lump == -1) {
			show_debug_message("Lump not found: " + string(d_sprite));
			return;
		}
		
		buffer_seek(wadFile,buffer_seek_start,lump.pos);
		
		loadedSprite = [];
		gfxColumnIndex = [];
		gfxColumnHStarts = [];
		gfxColumnYStarts = [];
		gfxColumnXStarts = [];

		gfxWidth = buffer_read(wadFile,buffer_u16);
		gfxHeight = buffer_read(wadFile,buffer_u16);
		gfxOffX = buffer_read(wadFile,buffer_u16);
		gfxOffY = buffer_read(wadFile,buffer_u16);
		if (surface_exists(fontSurface)) surface_free(fontSurface)
		if (!surface_exists(fontSurface))
		{
			fontSurface = surface_create(gfxWidth,gfxHeight)	
		}
		surface_set_target(fontSurface);
		draw_clear_alpha(c_black,0);
	
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
						colors[colorIndex][0],
						colors[colorIndex][1],
						colors[colorIndex][2]
					);
					draw_rectangle_color(col, yStart + i, col, yStart + i, pixCol, pixCol, pixCol, pixCol, false);
				}
			}
		}
	
		surface_reset_target();
		global.sprCache[surfID] = sprite_create_from_surface(fontSurface,0,0,gfxWidth,gfxHeight,false,false,0,0);
}