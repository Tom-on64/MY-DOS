# input.s
### User input handling

## Functions
### getc()
Gets a character from the user

Returns:
- AH - Keyboard scan code
- AL - Character

### gets()
Gets a string from the user

Arguments: 
- DI - buffer
- CX - maxlen

Returns: 
- DI - pointer to string end

