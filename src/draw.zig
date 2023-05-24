const gl = @cImport(@cInclude("GL/gl.h"));
const Vector2 = @import("util.zig").Vector2;
const player = @import("player.zig");

pub fn draw_board() void {
    gl.glLineWidth(16.0);
    gl.glColor3f(0.953, 0.545, 0.659);

    gl.glBegin(gl.GL_LINES);
    gl.glVertex2f(0.33, 1.0);
    gl.glVertex2f(0.33, -1.0);
    gl.glVertex2f(-0.33, 1.0);
    gl.glVertex2f(-0.33, -1.0);
    gl.glVertex2f(1.0, 0.33);
    gl.glVertex2f(-1.0, 0.33);
    gl.glVertex2f(1.0, -0.33);
    gl.glVertex2f(-1.0, -0.33);
    gl.glEnd();
}

pub fn draw_mark(x: u8, y: u8, sign: player.Player) void {
    const coords: [3][3]Vector2(f32) = .{
        .{
            Vector2(f32){ .x = -1.0, .y = 0.33 },
            Vector2(f32){ .x = -1.0, .y = -0.33 },
            Vector2(f32){ .x = -1.0, .y = -1.0 },
        },
        .{
            Vector2(f32){ .x = -0.33, .y = 0.33 },
            Vector2(f32){ .x = -0.33, .y = -0.33 },
            Vector2(f32){ .x = -0.33, .y = -1.0 },
        },
        .{
            Vector2(f32){ .x = 0.33, .y = 0.33 },
            Vector2(f32){ .x = 0.33, .y = -0.33 },
            Vector2(f32){ .x = 0.33, .y = -1.0 },
        },
    };

    switch (sign) {
        .X => player.draw_x(coords[x][y], 0.66, 0.12),
        .O => player.draw_o(coords[x][y], 0.24, 0.08, 16),
    }
}

pub fn draw_end_screen(winner: ?player.Player) void {
    gl.glColor3f(0.192, 0.196, 0.267);
    gl.glBegin(gl.GL_QUADS);
    gl.glVertex2f(-1.0, 0.10);
    gl.glVertex2f(1.0, 0.10);
    gl.glVertex2f(1.0, -0.10);
    gl.glVertex2f(-1.0, -0.10);
    gl.glEnd();

    if (winner) |mark| {
        switch (mark) {
            .X => player.draw_x(
                Vector2(f32){ .x = -0.10, .y = -0.10 },
                0.2,
                0.04,
            ),
            .O => player.draw_o(
                Vector2(f32){ .x = -0.10, .y = -0.10 },
                0.06,
                0.04,
                8,
            ),
        }
    }
}
