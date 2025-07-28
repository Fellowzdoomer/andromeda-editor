// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_doom_texture(texIndToDraw){
	
	if (texIndToDraw < 0 || texIndToDraw >= array_length(textureOffsetArray)) {
    show_debug_message("Warning: texIndToDraw out of range: " + string(texIndToDraw));
    return; // Early exit to avoid crash
	}

	if (texIndToDraw < global.tex1Count)
	{
	    buffer_seek(global.wadFileG, buffer_seek_start, global.TEXTURE1Pos.pos + textureOffsetArray[texIndToDraw]);
	}
	else
	{
	    var tex2Index = texIndToDraw - global.tex1Count;
	    buffer_seek(global.wadFileG, buffer_seek_start, texture2.pos + textureOffsetArray[tex2Index]);
	}
	textureName = "";
	var textureCompositeSurface = -1;

	for (var j = 0; j < 8; j++) {
        var ch = chr(buffer_peek(global.wadFileG, buffer_tell(global.wadFileG) + j, buffer_u8));
        if (ch == chr(0)) break;
        textureName += ch;
    }
	textureNameArray[texIndToDraw] = textureName;
	buffer_seek(global.wadFileG,buffer_seek_relative,8);
	var textureFiller = buffer_read(global.wadFileG, buffer_u32); // Always 00 00
	var textureSizeW = buffer_read(global.wadFileG,buffer_u16); // Width of current texture
	var textureSizeH = buffer_read(global.wadFileG,buffer_u16); // Height of current texture
	var textureFiller2 = buffer_read(global.wadFileG, buffer_u32); // Always 00 00
	var texturePatchNum = buffer_read(global.wadFileG, buffer_u16);
	if (!surface_exists(textureCompositeSurface))
	    textureCompositeSurface = surface_create(textureSizeW,textureSizeH);
	var textureCompositeArray = [];

	// patch descriptor for texture    
	for (var k = 0; k < texturePatchNum; k++)
	{
	    var patchOffsetX = buffer_read(global.wadFileG,buffer_s16);
	    var patchOffsetY = buffer_read(global.wadFileG,buffer_s16);
	    var patchIndexRef = buffer_read(global.wadFileG,buffer_u16);
	    var patchStepDir = buffer_read(global.wadFileG,buffer_u16); // Unused?
	    var patchColorMap = buffer_read(global.wadFileG,buffer_u16); // Unused?
	    array_push(textureCompositeArray,[patchIndexRef,patchOffsetX,patchOffsetY]);
	}

	surface_set_target(textureCompositeSurface);
	draw_clear_alpha(c_black,0);

	for (var i = 0; i < array_length(textureCompositeArray); i++)
	{
	    var patchIndex = textureCompositeArray[i][0];
	    var patchX = textureCompositeArray[i][1];
	    var patchY = textureCompositeArray[i][2];
    
	    // Check patchIndex bounds
	    if (patchIndex < 0 || patchIndex >= array_length(global.sprPNAMESCache))
	    {
	        show_debug_message("Invalid patchIndex: " + string(patchIndex));
	        // Draw red rectangle placeholder for missing patch
	        draw_set_color(c_red);
	        draw_rectangle(patchX, patchY, patchX + 8, patchY + 8, false);
	        draw_set_color(c_white);
	        continue; // skip to next patch
	    }
    
	    // Load patch sprite if missing
	    if (global.sprPNAMESCache[patchIndex] == -1)
	    {
	        init_doom_graphic(global.pnamesArray[patchIndex], patchIndex, true, true, false, false, true);
	    }
    
	    // Confirm sprite exists before drawing
	    var patchSprite = global.sprPNAMESCache[patchIndex];
	    if (patchSprite == -1 || !sprite_exists(patchSprite))
	    {
	        // Draw red rectangle placeholder
	        draw_set_color(c_red);
	        draw_rectangle(patchX, patchY, patchX + 64, patchY + 64, false);
	        draw_set_color(c_white);
	        continue;
	    }

	    draw_sprite(patchSprite, 0, patchX, patchY);
	}

	global.sprGeneratedTextureCache[texIndToDraw] = sprite_create_from_surface(textureCompositeSurface,0,0,textureSizeW,textureSizeH,false,false,0,0);
	surface_reset_target();
	surface_free(textureCompositeSurface);
}