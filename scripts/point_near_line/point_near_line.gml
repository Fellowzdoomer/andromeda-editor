// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function point_near_line(px, py, x1, y1, x2, y2, tolerance) {
    var dx = x2 - x1;
    var dy = y2 - y1;
    var length_sq = dx * dx + dy * dy;

    if (length_sq == 0) return point_distance(px, py, x1, y1) <= tolerance;

    var t = clamp(((px - x1) * dx + (py - y1) * dy) / length_sq, 0, 1);
    var projX = x1 + t * dx;
    var projY = y1 + t * dy;

    return point_distance(px, py, projX, projY) <= tolerance;
}
