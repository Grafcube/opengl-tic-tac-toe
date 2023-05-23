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
    var move: u8 = 0;
    var winner: ?Player = null;

    main: while (true) {
        var event: sdl.SDL_Event = undefined;
        while (sdl.SDL_PollEvent(&event) == 1) {
            switch (event.type) {
                sdl.SDL_QUIT => break :main,
                sdl.SDL_MOUSEBUTTONUP => {
                    if (winner != null or move > 8) break;
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
                    move += 1;
                },
                else => {},
            }
        }

        gl.glViewport(0, 0, dim.x, dim.y);
        gl.glClear(gl.GL_COLOR_BUFFER_BIT);
        gl.glClearColor(0.067, 0.067, 0.106, 0.0);

        draw.draw_board();
        winner = check_win(board);

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

fn check_win(board: [3][3]?Player) ?Player {
    // Check LtR diagonal
    if (board[0][0] == board[1][1] and board[0][0] == board[2][2]) {
        return board[0][0];
    }

    // Check RtL diagonal
    if (board[2][0] == board[1][1] and board[2][0] == board[0][2]) {
        return board[2][0];
    }

    // Check rows
    for (board) |row| {
        if (row[0] == row[1] and row[0] == row[2]) {
            return row[0];
        }
    }

    // Check columns
    var i: u8 = 0;
    while (i < 3) {
        defer i += 1;
        if (board[0][i] == board[1][i] and board[0][i] == board[2][i]) {
            return board[0][i];
        }
    }

    return null;
}
