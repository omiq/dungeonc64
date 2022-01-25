SCREEN 1
_FULLSCREEN
_MOUSESHOW
OPTION BASE 0
tiles_file$ = "c64chars.bin"


LINE (140, 10)-(308, 190), , B

LINE (140, 35)-(308, 190), , B

FOR tiler = 46 TO 46 + (5 * 24) STEP 24
    FOR tilec = 140 TO 140 + (24 * 6) STEP 24
        LINE (tilec, tiler)-(tilec + 24, tiler + 24), , B
    NEXT
NEXT


DIM SHARED charset(256, 8) AS _UNSIGNED _BYTE
DIM SHARED this_char AS INTEGER
DIM in_byte AS _UNSIGNED _BYTE
DIM row AS INTEGER
DIM col AS INTEGER

this_char = 0
in_byte = 0

' LOAD DATA
OPEN tiles_file$ FOR BINARY AS #1
FOR this_char = 0 TO 256

    ' PREPARE THE ARRAY
    FOR row = 0 TO 7
        GET #1, , charset(this_char, row)
    NEXT

NEXT
CLOSE #1


' CHAR PICKER
col = 0
row = 10
FOR this_char = 0 TO 256
    CALL print_char(this_char, col, row)
    IF col <= 120 THEN
        col = col + 10
    ELSE
        col = 0
        row = row + 10
    END IF
NEXT


DIM click_char AS _UNSIGNED _BYTE
DIM del_char AS _UNSIGNED _BYTE
DO
    IF _MOUSEINPUT THEN '  skip keyboard reads
        LOCATE 1, 1
        PRINT _MOUSEX; _MOUSEY; _MOUSEBUTTON(1); _MOUSEBUTTON(2)
        IF _MOUSEX < 138 THEN
            IF _MOUSEBUTTON(1) THEN

                LOCATE 1, 20

                PRINT INT(_MOUSEX / 10); INT(_MOUSEY / 10) - 1
                click_char = (INT(_MOUSEX / 10) + (INT((_MOUSEY / 10) - 1) * 14))
                CALL print_char(click_char, 150, 20)
            END IF


            IF _MOUSEBUTTON(2) THEN

                LOCATE 1, 20
                PRINT INT(_MOUSEX / 10); INT(_MOUSEY / 10) - 1
                del_char = (INT(_MOUSEX / 10) + (INT((_MOUSEY / 10) - 1) * 14))
                CALL print_char(del_char, 160, 20)
            END IF
        ELSE
            IF _MOUSEX > 139 AND _MOUSEY > 47 THEN
                IF _MOUSEBUTTON(1) THEN
                    CALL print_char(click_char, _MOUSEX, _MOUSEY)
                END IF
                IF _MOUSEBUTTON(2) THEN
                    CALL print_char(del_char, _MOUSEX, _MOUSEY)
                END IF


            END IF

        END IF
    END IF
LOOP UNTIL INKEY$ = CHR$(27) 'escape key exit

END



' DISPLAY THE SELECTED CHAR
SUB print_char (which_char AS _UNSIGNED _BYTE, x AS _UNSIGNED _BYTE, y AS _UNSIGNED _BYTE)

    DIM r, b AS INTEGER
    DIM this_byte AS _UNSIGNED _BYTE
    DIM this_bit AS _UNSIGNED _BIT

    r = 0
    b = 0

    ' LOOP THROUGH 8 ROWS OF BYTES
    FOR r = 0 TO 7

        ' GET THE BYTE FROM THE CHARACTER DATA ARRAY
        this_byte = charset(which_char, r)

        ' LOOP THROUGH 8 BITS
        FOR b = 0 TO 7 STEP 1

            this_bit = INT(_READBIT(this_byte, b))
            IF this_bit = 0 THEN
                PSET (x + (7 - b), y + r), 12
            ELSE
                PSET (x + (7 - b), y + r), 1
            END IF

        NEXT

    NEXT
END SUB






