map_file$ = "map.bin"

DIM SHARED map(41) AS _UNSIGNED _BYTE

FOR i = 0 TO 41
    map(i) = i
NEXT i


OPEN map_file$ FOR BINARY AS #1
PUT #1, , map()
CLOSE #1


DIM in_byte AS _UNSIGNED _BYTE
OPEN map_file$ FOR BINARY AS #1
DO UNTIL EOF(1)
    GET #1, , in_byte
    PRINT in_byte,
LOOP
CLOSE #1

