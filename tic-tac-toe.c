#include <GL/gl.h>
#include <SDL2/SDL.h>
#include <assert.h>
#include <math.h>

#define TAU 2 * M_PI

const char TITLE[] = "Tic-Tac-Toe: SDL2+OpenGL";

typedef struct {
  int x, y;
} Vector2u;

typedef struct {
  float x, y;
} Vector2f;

const Vector2u DIM = {600, 600};

typedef enum { PLAYER_X, PLAYER_O } Player;

void game(SDL_Window *);
void draw_board();
void draw_mark(uint, uint, Player);
void draw_x(Vector2f, float, float);
void draw_o(Vector2f, float, float, float);
void draw_end_screen(int);
int check_win(int[3][3]);
uint find_cell(float axis, float max);
Vector2u cell_click(float, float);

int main() {
  SDL_Init(SDL_INIT_VIDEO);

  SDL_Window *window =
      SDL_CreateWindow(TITLE, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
                       DIM.x, DIM.y, SDL_WINDOW_OPENGL);
  assert(window);

  SDL_GLContext ctx = SDL_GL_CreateContext(window);

  game(window);

  SDL_DestroyWindow(window);
  SDL_Quit();
  return 0;
}

void game(SDL_Window *window) {
  int current_player = PLAYER_X;
  int board[3][3] = {
      {-1, -1, -1},
      {-1, -1, -1},
      {-1, -1, -1},
  };
  int move = 0;
  int winner = -1;
  int running = 1;

  while (running) {
    SDL_Event event;
    while (SDL_PollEvent(&event) == 1) {
      switch (event.type) {
      case SDL_QUIT:
        running = 0;
        break;
      case SDL_MOUSEBUTTONUP:
        if (winner != -1 || move > 8) {
          winner = -1;
          move = 0;
          current_player = PLAYER_X;
          for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
              board[i][j] = -1;
            }
          }
          break;
        }

        Vector2u cell = cell_click(event.button.x, event.button.y);
        if (board[cell.x][cell.y] == -1) {
          board[cell.x][cell.y] = current_player;
        } else {
          break;
        }

        if (current_player == PLAYER_X) {
          current_player = PLAYER_O;
        } else {
          current_player = PLAYER_X;
        }

        move += 1;
        break;
      default:
        break;
      }
    }

    glViewport(0, 0, DIM.x, DIM.y);
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(0.067, 0.067, 0.106, 0.0);
    glLineWidth(16.0);

    draw_board();

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] != -1) {
          draw_mark(i, j, board[i][j]);
        }
      }
    }

    winner = check_win(board);
    if (winner != -1 || move > 8)
      draw_end_screen(winner);

    glFlush();
    SDL_GL_SwapWindow(window);
  }
}

void draw_board() {
  glColor3f(0.953, 0.545, 0.659);
  glBegin(GL_LINES);
  glVertex2f(0.33, 1.0);
  glVertex2f(0.33, -1.0);
  glVertex2f(-0.33, 1.0);
  glVertex2f(-0.33, -1.0);
  glVertex2f(1.0, 0.33);
  glVertex2f(-1.0, 0.33);
  glVertex2f(1.0, -0.33);
  glVertex2f(-1.0, -0.33);
  glEnd();
}

int check_win(int board[3][3]) {
  // Check LtR diagonal
  if (board[0][0] == board[1][1] && board[0][0] == board[2][2]) {
    return board[0][0];
  }

  // Check RtL diagonal
  if (board[2][0] == board[1][1] && board[2][0] == board[0][2]) {
    return board[2][0];
  }

  // Check rows
  for (int i = 0; i < 3; i++) {
    if (board[i][0] == board[i][1] && board[i][0] == board[i][2]) {
      return board[i][0];
    }
  }

  // Check columns
  for (int i = 0; i < 3; i++) {
    if (board[0][i] == board[1][i] && board[0][i] == board[2][i]) {
      return board[0][i];
    }
  }

  return -1;
}

void draw_end_screen(int player) {
  glColor3f(0.192, 0.196, 0.267);
  glBegin(GL_QUADS);
  glVertex2f(-1.0, 0.10);
  glVertex2f(1.0, 0.10);
  glVertex2f(1.0, -0.10);
  glVertex2f(-1.0, -0.10);
  glEnd();

  Vector2f offset = {-0.10, -0.10};
  switch (player) {
  case PLAYER_X:
    draw_x(offset, 0.2, 0.04);
    break;
  case PLAYER_O:
    draw_o(offset, 0.06, 0.04, 8);
    break;
  default:
    break;
  }
}

void draw_mark(uint x, uint y, Player sign) {
  Vector2f coords[3][3] = {
      {{-1.0, 0.33}, {-1.0, -0.33}, {-1.0, -1.0}},
      {{-0.33, 0.33}, {-0.33, -0.33}, {-0.33, -1.0}},
      {{0.33, 0.33}, {0.33, -0.33}, {0.33, -1.0}},
  };

  switch (sign) {
  case PLAYER_X:
    draw_x(coords[x][y], 0.66, 0.12);
    break;
  case PLAYER_O:
    draw_o(coords[x][y], 0.24, 0.08, 16);
    break;
  }
}

void draw_x(Vector2f offset, float length, float padding) {
  Vector2f start = {
      offset.x + padding,
      offset.y + length - padding,
  };
  Vector2f end = {
      offset.x + length - padding,
      offset.y + padding,
  };

  glColor3f(0.953, 0.545, 0.659);
  glBegin(GL_LINES);
  glVertex2f(start.x, start.y);
  glVertex2f(end.x, end.y);
  glVertex2f(end.x, start.y);
  glVertex2f(start.x, end.y);
  glEnd();
}

void draw_o(Vector2f offset, float radius, float padding, float steps) {
  Vector2f origin = {
      offset.x + radius + padding,
      offset.y + radius + padding,
  };

  glColor3f(0.953, 0.545, 0.659);
  glBegin(GL_LINE_STRIP);
  float i = 0;
  float resolution = 120;
  while (i <= resolution) {
    glVertex2f(origin.x + (radius * cos(i * TAU / resolution)),
               origin.y + (radius * sin(i * TAU / resolution)));
    i += resolution / steps;
  }
  glEnd();
}

uint find_cell(float axis, float max) {
  if ((axis / max) < 0.33) {
    return 0;
  } else if ((axis / max) < 0.66) {
    return 1;
  } else {
    return 2;
  }
}

Vector2u cell_click(float x, float y) {
  Vector2u res = {
      find_cell(x, DIM.x),
      find_cell(y, DIM.y),
  };
  return res;
}
