tiles_file$ = "tiles.bin"
DIM in_byte AS _UNSIGNED _BYTE
OPEN tiles_file$ FOR BINARY AS #1
DO UNTIL EOF(1)
    GET #1, , in_byte
    PRINT in_byte;
LOOP
CLOSE #1

