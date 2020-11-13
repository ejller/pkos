#define ROWS 25
#define COLS 80
#define VIDMEM 0xb8000

int cursor_row = 0;
int cursor_col = 0;

void printchar(char c, int row, int col) {
	char* offset = (char*) (VIDMEM + 2*((row * COLS) + col));
	*offset = c;
}

void print(char* string, int len) {
	for (int i = 0; i < len; i++) {
		printchar(string[i], cursor_row, cursor_col);
		cursor_col++;
	}
}

void clear_screen() {
	for (int i = 0; i < ROWS; i++) {
		for (int j = 0; j < COLS; j++) {
			printchar(' ', i, j);
		}
	}
}

void main() {
	clear_screen();
}
