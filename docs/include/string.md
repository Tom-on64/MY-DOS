# string.s
### String operations

## Macros
### strcmp ( str1, str2 )
Compares two strings

Returns:
- ZF - 1 if strings are equal
- CF - If ZF = 0; 1 if str1 < str2, 0 if str1 > str2

### strcpy ( src, dest )
Copies a string into a buffer


### strcat ( str1, str2 ) _TODO_
Concatonates two strings

### strlen ( str )
Gets the length of a string

Returns:
- AX - length

### memset ( value, len, dest )
Sets a region of memory to the same byte

### memcpy ( src, dest, len )
Copies a region of memory to another

