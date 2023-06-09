CC = gcc
CFLAGS = -lGL -lSDL2 -lm

all: tic-tac-toe

tic-tac-toe: tic-tac-toe.c
	$(CC) tic-tac-toe.c -o tic-tac-toe $(CFLAGS)

.PHONY: clean

clean:
	rm -f tic-tac-toe
