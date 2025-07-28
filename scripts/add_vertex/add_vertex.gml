// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function add_vertex(x, y) {
    // Optional: check if vertex already exists near (x, y) and reuse index
    for (var i = 0; i < array_length(vertexArray); i++) {
        var v = vertexArray[i];
        if (point_distance(x, y, v._verX, v._verY) < 0.01) {
            return i; // reuse existing vertex index
        }
    }
    // Add new vertex
    var newIndex = array_length(vertexArray);
    array_push(vertexArray, { _verX: x, _verY: y });
    return newIndex;
}
