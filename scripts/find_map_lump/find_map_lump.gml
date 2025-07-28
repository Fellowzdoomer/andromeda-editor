/// find_map_lump(mapname, lumpname, isAsset=false)
/// → returns lump struct {name, pos, size, index} or -1 if not found

//if (live_call()) return live_result;
function is_digit(c) {
    return (c >= "0" && c <= "9");
}

function is_map_marker(str)
{
    if (string_length(str) == 4) {
        // E#M# pattern
        return string_char_at(str,1) == "E" &&
               is_digit(string_char_at(str,2)) &&
               string_char_at(str,3) == "M" &&
               is_digit(string_char_at(str,4));
    }
    else if (string_length(str) == 5) {
        // MAP## pattern
        return string_copy(str, 1, 3) == "MAP" &&
               is_digit(string_char_at(str,4)) &&
               is_digit(string_char_at(str,5));
    }
    return false;
}

function find_map_lump(mapname, lumpname, isAsset=false)
{
    var names = (!isAsset) ? global.wadArrayName : global.aWadArrayName;
    var locs  = (!isAsset) ? global.wadArrayLocation : global.aWadArrayLocation;
    var sizes = (!isAsset) ? global.wadArraySize : global.aWadArraySize;

    var lump_count = array_length(names);
    var map_index = -1;

    // Step 1: Find the map marker
    for (var i = 0; i < lump_count; i++) {
        if (names[i] == mapname) {
            map_index = i;
            break;
        }
    }
    if (map_index == -1) return -1; // map not found

    // Step 2: Scan forward after the map marker
    for (var i = map_index + 1; i < lump_count; i++) {
        var name = names[i];

        // If we reach another map marker, stop searching
        if (is_map_marker(name)) {
            break;
        }

        if (name == lumpname) {
            return {
                name: name,
                pos: locs[i],
                size: sizes[i],
                index: i
            };
        }
    }

    return -1; // Not found in this map block
}