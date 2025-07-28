// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_doom_sound(sndLump, soundCacheID, loadFrom=global.wadFileG){
	var lookForSound = find_lump(sndLump)
	if (sndLump != 1)
	{
		buffer_seek(loadFrom,buffer_seek_start,lookForSound.pos+2)
		var soundSampleRate = buffer_read(loadFrom,buffer_u16)
		var soundCacheBuffer = buffer_create(lookForSound.size-8,buffer_fixed,1);
		var soundDataCopy = buffer_copy(loadFrom,
			lookForSound.pos+8,
			lookForSound.size-8,
			soundCacheBuffer,
			0)
		var soundData = audio_create_buffer_sound(soundCacheBuffer,buffer_u8,soundSampleRate,0,lookForSound.size-8,audio_mono);
		global.doomSnd[soundCacheID] = soundData
	}
	else
	{
		show_message(string(sndLump) + " was not found! Terminating init_doom_sound script.")
		exit;
	}
}