CC = gcc
FLEX = flex
BISON = bison
CFLAGS = -Wall -Iinclude
LDFLAGS = -lfl

SRC = src/lexer.c src/parser.c src/semantic.c src/exec.c src/main.c src/utils.c
OBJ = $(SRC:.c=.o)
BIN = bin/set_interpreter

all: $(BIN)

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

src/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

bin/:
	mkdir -p bin/

clean:
	rm -rf bin/ $(OBJ)


