const math = @import("std").math;
const gl = @cImport(@cInclude("GL/gl.h"));
const Vector2 = @import("util.zig").Vector2;

pub const Player = enum { X, O };

pub fn draw_x(offset: Vector2(f32)) void {
    const padding = 0.12;
    const start = Vector2(f32){
        .x = offset.x + padding,
        .y = offset.y + 0.66 - padding,
    };
    const end = Vector2(f32){
        .x = offset.x + 0.66 - padding,
        .y = offset.y + padding,
    };

    gl.glLineWidth(16.0);
    gl.glColor3f(0.953, 0.545, 0.659);

    gl.glBegin(gl.GL_LINES);
    gl.glVertex2f(start.x, start.y);
    gl.glVertex2f(end.x, end.y);
    gl.glVertex2f(end.x, start.y);
    gl.glVertex2f(start.x, end.y);
    gl.glEnd();
}

pub fn draw_o(offset: Vector2(f32)) void {
    const radius = 0.26;
    const origin = Vector2(f32){
        .x = (offset.x + (0.66 - 2 * radius) / 2.0) + math.sqrt(2) * radius,
        .y = (offset.y + (0.66 - 2 * radius) / 2.0) + math.sqrt(2) * radius,
    };

    gl.glLineWidth(16.0);
    gl.glColor3f(0.953, 0.545, 0.659);

    gl.glBegin(gl.GL_LINE_STRIP);
    var i: f32 = 0.0;
    var resolution: f32 = 120.0;
    while (i <= resolution) {
        gl.glVertex2f(
            origin.x + (radius * math.cos(i * math.tau / resolution)),
            origin.y + (radius * math.sin(i * math.tau / resolution)),
        );
        i += 6;
    }
    gl.glEnd();
}
