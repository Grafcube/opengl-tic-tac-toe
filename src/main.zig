const std = @import("std");

const sdl = @cImport(@cInclude("SDL2/SDL.h"));
const gl = @cImport(@cInclude("GL/gl.h"));

const TITLE = "Tic-Tac-Toe: Zig+SDL2+OpenGL";

fn Vector2(comptime T: type) type {
    return struct {
        x: T,
        y: T,
    };
}

const dim = Vector2(usize){ .x = 600, .y = 600 };

const Player = enum { X, O };

const Error = error{
    InitError,
};

pub fn main() !void {
    if (sdl.SDL_Init(sdl.SDL_INIT_VIDEO) < 0) {
        std.log.err("Failed to initialize SDL: {s}\n", .{sdl.SDL_GetError()});
        return error.InitError;
    }
    defer sdl.SDL_Quit();

    const window = sdl.SDL_CreateWindow(
        TITLE,
        sdl.SDL_WINDOWPOS_UNDEFINED,
        sdl.SDL_WINDOWPOS_UNDEFINED,
        dim.x,
        dim.y,
        sdl.SDL_WINDOW_OPENGL,
    );
    const ctx = sdl.SDL_GL_CreateContext(window);
    _ = ctx;

    main: while (true) {
        var event: sdl.SDL_Event = undefined;
        while (sdl.SDL_PollEvent(&event) == 1) {
            switch (event.type) {
                sdl.SDL_QUIT => break :main,
                else => {},
            }
        }

        gl.glViewport(0, 0, dim.x, dim.y);
        gl.glClear(gl.GL_COLOR_BUFFER_BIT);
        gl.glClearColor(0.067, 0.067, 0.106, 0.0);

        draw_board();
        draw_mark(0, 0, Player.X);
        draw_mark(0, 1, Player.X);
        draw_mark(0, 2, Player.X);
        draw_mark(1, 0, Player.X);
        draw_mark(1, 1, Player.X);
        draw_mark(1, 2, Player.X);
        draw_mark(2, 0, Player.X);
        draw_mark(2, 1, Player.X);
        draw_mark(2, 2, Player.X);
        draw_mark(0, 0, Player.O);
        draw_mark(0, 1, Player.O);
        draw_mark(0, 2, Player.O);
        draw_mark(1, 0, Player.O);
        draw_mark(1, 1, Player.O);
        draw_mark(1, 2, Player.O);
        draw_mark(2, 0, Player.O);
        draw_mark(2, 1, Player.O);
        draw_mark(2, 2, Player.O);

        gl.glFlush();
        sdl.SDL_GL_SwapWindow(window);
    }
}

fn draw_board() void {
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

fn draw_mark(x: u8, y: u8, player: Player) void {
    const coords: [3][3]Vector2(f32) = .{
        .{
            Vector2(f32){ .x = -1.0, .y = -1.0 },
            Vector2(f32){ .x = -0.33, .y = -1.0 },
            Vector2(f32){ .x = 0.33, .y = -1.0 },
        },
        .{
            Vector2(f32){ .x = -1.0, .y = 0.33 },
            Vector2(f32){ .x = -0.33, .y = 0.33 },
            Vector2(f32){ .x = 0.33, .y = 0.33 },
        },
        .{
            Vector2(f32){ .x = -1.0, .y = -0.33 },
            Vector2(f32){ .x = -0.33, .y = -0.33 },
            Vector2(f32){ .x = 0.33, .y = -0.33 },
        },
    };

    switch (player) {
        .X => draw_x(coords[x][y]),
        .O => draw_o(coords[x][y]),
    }
}

fn draw_x(offset: Vector2(f32)) void {
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

fn draw_o(offset: Vector2(f32)) void {
    const radius = 0.26;
    const origin = Vector2(f32){
        .x = (offset.x + (0.66 - 2 * radius) / 2.0) + std.math.sqrt(2) * radius,
        .y = (offset.y + (0.66 - 2 * radius) / 2.0) + std.math.sqrt(2) * radius,
    };

    gl.glLineWidth(16.0);
    gl.glColor3f(0.953, 0.545, 0.659);

    gl.glBegin(gl.GL_LINE_STRIP);
    var i: f32 = 0.0;
    var resolution: f32 = 120.0;
    while (i <= resolution) {
        gl.glVertex2f(
            origin.x + (radius * std.math.cos(i * std.math.tau / resolution)),
            origin.y + (radius * std.math.sin(i * std.math.tau / resolution)),
        );
        i += 6;
    }
    gl.glEnd();
}
