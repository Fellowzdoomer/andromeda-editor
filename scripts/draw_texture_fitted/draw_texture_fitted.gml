// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_texture_fitted(_spr, _x, _y, _box) {
    if (!sprite_exists(_spr)) return;

    var sw = sprite_get_width(_spr);
    var sh = sprite_get_height(_spr);
    var scale = min(_box / sw, _box / sh);
    var dw = sw * scale;
    var dh = sh * scale;
    var dx = _x + (_box - dw) / 2;
    var dy = _y + (_box - dh) / 2;
    draw_sprite_ext(_spr, 0, dx, dy, scale, scale, 0, c_white, 1);
}