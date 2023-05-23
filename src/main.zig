const std = @import("std");
const util = @import("util.zig");
const draw = @import("draw.zig");
const Player = @import("player.zig").Player;

const sdl = @cImport(@cInclude("SDL2/SDL.h"));
const gl = @cImport(@cInclude("GL/gl.h"));

const TITLE = "Tic-Tac-Toe: Zig+SDL2+OpenGL";

const dim = util.Vector2(usize){ .x = 600, .y = 600 };

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

    var current_player = Player.X;
    var board: [3][3]?Player = undefined;
    for (board) |*pt| {
        pt.* = .{ null, null, null };
    }

    main: while (true) {
        var event: sdl.SDL_Event = undefined;
        while (sdl.SDL_PollEvent(&event) == 1) {
            switch (event.type) {
                sdl.SDL_QUIT => break :main,
                sdl.SDL_MOUSEBUTTONUP => {
                    const cell = util.cell_click(
                        @intToFloat(f32, event.button.x),
                        @intToFloat(f32, event.button.y),
                        dim,
                    );
                    if (board[cell.x][cell.y] == null) {
                        board[cell.x][cell.y] = current_player;
                    } else {
                        break;
                    }
                    if (current_player == Player.X) {
                        current_player = Player.O;
                    } else {
                        current_player = Player.X;
                    }
                },
                else => {},
            }
        }

        gl.glViewport(0, 0, dim.x, dim.y);
        gl.glClear(gl.GL_COLOR_BUFFER_BIT);
        gl.glClearColor(0.067, 0.067, 0.106, 0.0);

        draw.draw_board();

        for (board) |set, x| {
            for (set) |val, y| {
                if (val) |player| {
                    draw.draw_mark(@intCast(u8, x), @intCast(u8, y), player);
                }
            }
        }

        gl.glFlush();
        sdl.SDL_GL_SwapWindow(window);
    }
}
