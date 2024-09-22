# output.s
### Handles outputing data to the screen

## Definitions
### ENDL
Indicates the end of a line, acts as a newline when printed

### VIDMEM
The VGA Text mode video memory base address

### ROWS
Number of rows on output display. Text lines in text mode, pixels in gfx mode

### COLS
Number of columns on output display. Text columns in text mode, pixels in gfx mode

## Macros
### print ( ...str )
Prints a string to the screen

Arguments:
- An indefinate string of bytes

## Functions
### putc()
Prints a character to the screen

Arguments:
- AL - Character
- AH - Color attribute
- BX - Cursor position

### puts()
Prints a string to the screen

Arguments:
- SI - Pointer to string
- AH - Color attribute
- BX - Cursor position

Returns:
- BX - New cursor position

### prints()
Prints a string at the cursor position

Arguments:
- SI - string

### printc
Prints a character at the cursor position

Arguments:
- AL - character

### cls()
Clears the screen

### newline()
Moves the cursor down a line

Arguments:
- BX - cursor

Returns:
- BX - new cursor

## Variables
### u16 cursor
### u8 attr

%endif
