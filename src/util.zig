pub fn Vector2(comptime T: type) type {
    return struct {
        x: T,
        y: T,
    };
}

fn find_cell(axis: f32, max: f32) u8 {
    if ((axis / max) < 0.33) {
        return 0;
    } else if ((axis / max) < 0.66) {
        return 1;
    } else {
        return 2;
    }
}

pub fn cell_click(x: f32, y: f32, dim: Vector2(usize)) Vector2(u8) {
    return Vector2(u8){
        .x = find_cell(x, @intToFloat(f32, dim.x)),
        .y = find_cell(y, @intToFloat(f32, dim.y)),
    };
}
