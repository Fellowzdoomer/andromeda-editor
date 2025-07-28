// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_doom_sprite_otf_buffer(bufferOTF, surfID){

		var spriteSurfaceOTF = -1;
		
		loadedSprite = [];
		gfxColumnIndex = [];
		gfxColumnHStarts = [];
		gfxColumnYStarts = [];
		gfxColumnXStarts = [];
	
		gfxWidth = buffer_read(bufferOTF,buffer_u16);
		gfxHeight = buffer_read(bufferOTF,buffer_u16);
		gfxOffX = buffer_read(bufferOTF,buffer_u16);
		gfxOffY = buffer_read(bufferOTF,buffer_u16);
		if (surface_exists(spriteSurfaceOTF)) surface_free(spriteSurfaceOTF)
		if (!surface_exists(spriteSurfaceOTF))
		{
			spriteSurfaceOTF = surface_create(gfxWidth,gfxHeight)	
		}
		surface_set_target(spriteSurfaceOTF);
		draw_clear_alpha(c_black,0);
		
	
			var _x = 0;
			for (var i = 0; i < gfxWidth; i++)
			{
				var colIndexLive = buffer_read(bufferOTF,buffer_u32);
				array_push(gfxColumnIndex,colIndexLive);
			}
			
			for (var j = 0; j < array_length(gfxColumnIndex); j++)
			{
				buffer_seek(bufferOTF,buffer_seek_start, gfxColumnIndex[j]);
				while true
				{
					var columnY = buffer_read(bufferOTF,buffer_u8); // Y start pos
					if (columnY == 255) break;
					array_push(gfxColumnYStarts,columnY);
						
					var columnH = buffer_read(bufferOTF,buffer_u8); // Y Height
					array_push(gfxColumnHStarts,columnH);
		
					buffer_read(bufferOTF,buffer_u8); // unused byte 1
		
					for (var i = 0; i < columnH; i++)
					{
						pixelData = buffer_read(bufferOTF,buffer_u8);
						array_push(loadedSprite,pixelData);
					}
				
					buffer_read(bufferOTF,buffer_u8); // unused byte 2
				}
			}
		
			gfxBookmark = 0;
			for (var _i = 0; _i < array_length(gfxColumnYStarts); _i++)
			{
				for (
					var _y = gfxColumnYStarts[_i];
					_y < gfxColumnYStarts[_i] + gfxColumnHStarts[_i];
					_y++)
					{
						if gfxBookmark >= array_length(loadedSprite) break;
						var colorIndex = loadedSprite[gfxBookmark];
						var pixCol = make_color_rgb(
							global.colorsOTF[colorIndex][0],
							global.colorsOTF[colorIndex][1],
							global.colorsOTF[colorIndex][2]	
						)
				
						draw_rectangle_color(_x,_y,_x,_y,pixCol,pixCol,pixCol,pixCol,false)
						gfxBookmark++;
					}
			
				//if (gfxColumnHStarts[_i] + gfxColumnYStarts[_i] == gfxHeight)
				_x++;
			}
		
			surface_reset_target();
			global.sprCache[surfID] = sprite_create_from_surface(spriteSurfaceOTF,0,0,gfxWidth,gfxHeight,false,false,0,0);
		}
