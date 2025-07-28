// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function base_texture_name(texName) {
    var len = string_length(texName);
    while (len > 0) {
        var ch = string_char_at(texName, len);
        if (ch >= "0" && ch <= "9") {
            len -= 1;
        } else {
            break;
        }
    }
    return string_copy(texName, 1, len);
}