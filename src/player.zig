const math = @import("std").math;
const gl = @cImport(@cInclude("GL/gl.h"));
const Vector2 = @import("util.zig").Vector2;

pub const Player = enum { X, O };

pub fn draw_x(offset: Vector2(f32), length: f32, padding: f32) void {
    const start = Vector2(f32){
        .x = offset.x + padding,
        .y = offset.y + length - padding,
    };
    const end = Vector2(f32){
        .x = offset.x + length - padding,
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

pub fn draw_o(offset: Vector2(f32), radius: f32, padding: f32, steps: f32) void {
    const origin = Vector2(f32){
        .x = offset.x + radius + padding,
        .y = offset.y + radius + padding,
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
        i += resolution / steps;
    }
    gl.glEnd();
}
