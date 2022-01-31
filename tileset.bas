_TITLE "TILE EDITOR"
SCREEN 1
'_PRINTMODE _KEEPBACKGROUND

' BLUE
_PALETTECOLOR 1, _RGB32(0, 155, 155)
CONST blue = 1

' DARK GREY
_PALETTECOLOR 2, _RGB32(55, 55, 55)
CONST dgrey = 2

' WHITE
_PALETTECOLOR 3, _RGB32(255, 255, 255)
CONST white = 3

' M GREY
_PALETTECOLOR 4, _RGB32(100, 100, 100)
CONST mgrey = 4

' BLACK
_PALETTECOLOR 12, _RGB32(0, 0, 0)
CONST black = 12


_FULLSCREEN
_MOUSESHOW
OPTION BASE 0
DIM SHARED chars_file$
DIM SHARED tiles_file$
chars_file$ = "c64chars.bin"
tiles_file$ = "tiles.bin"



' BUTTONS
CALL draw_button("Save", 142, 36)
CALL draw_button("X", 300, 0)


' TILE DATA
DIM SHARED cells(500) AS _UNSIGNED _BYTE
DIM SHARED charset(256, 8) AS _UNSIGNED _BYTE
DIM SHARED this_char AS INTEGER
DIM in_byte AS _UNSIGNED _BYTE
DIM row AS INTEGER
DIM col AS INTEGER

this_char = 0
in_byte = 0

' LOAD DATA
OPEN chars_file$ FOR BINARY AS #1
FOR this_char = 0 TO 256

    ' PREPARE THE ARRAY
    FOR row = 0 TO 7
        GET #1, , charset(this_char, row)
    NEXT

NEXT
CLOSE #1

DIM tmp_X AS INTEGER
DIM tmp_Y AS INTEGER

DIM this_cell AS INTEGER
DIM tiles(43, 10) AS _UNSIGNED _BYTE

' LOAD CELL DATA FILE
CALL load_cells

' DRAW GRID LINES
CALL draw_grid


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
click_char = 0
DIM del_char AS _UNSIGNED _BYTE
del_char = 32
CALL print_char(click_char, 150, 20)
CALL print_char(del_char, 160, 20)

DO
    IF _MOUSEINPUT THEN '  skip keyboard reads
        LOCATE 1, 1
        PRINT _MOUSEX; _MOUSEY;
        IF _MOUSEX < 138 THEN

            ' PAINT CHARACTER SELECTION
            IF _MOUSEBUTTON(1) THEN

                LOCATE 1, 10
                PRINT INT(_MOUSEX / 10); INT(_MOUSEY / 10) - 1
                click_char = (INT(_MOUSEX / 10) + (INT((_MOUSEY / 10) - 1) * 14))

                CALL print_char(click_char, 150, 20)
            END IF

            ' ERASE CHARACTER SELECTION
            IF _MOUSEBUTTON(2) THEN

                LOCATE 1, 10
                PRINT INT(_MOUSEX / 10); INT(_MOUSEY / 10) - 1
                del_char = (INT(_MOUSEX / 10) + (INT((_MOUSEY / 10) - 1) * 14))
                CALL print_char(del_char, 160, 20)
            END IF

        ELSE
            ' __________________________
            ' BUTTONS
            ' --------------------------


            ' [QUIT]
            IF _MOUSEX > 299 AND _MOUSEY < 20 AND _MOUSEBUTTON(1) THEN END


            ' [SAVE]
            IF _MOUSEX > 141 AND _MOUSEX < 193 AND _MOUSEY > 35 AND _MOUSEY < 48 THEN
                IF _MOUSEBUTTON(1) THEN CALL save_cells
            END IF


            ' TILES
            IF _MOUSEX > 139 AND _MOUSEX < 307 AND _MOUSEY > 47 AND _MOUSEY < 190 THEN
                cell = INT((_MOUSEX - 139) / 8) + (INT((_MOUSEY - 47) / 8)) * 21
                tmp_Y = INT(cell / 21)
                tmp_X = (INT(cell - (tmp_Y * 21)) * 8) + 141
                tmp_Y = ((tmp_Y + 1) * 8) + 39


                LOCATE 1, 25
                PRINT cell

                IF _MOUSEBUTTON(1) THEN
                    cells(cell) = click_char
                    CALL print_char(click_char, tmp_X, tmp_Y)
                END IF
                IF _MOUSEBUTTON(2) THEN
                    cells(cell) = del_char
                    CALL print_char(del_char, tmp_X, tmp_Y)
                END IF

                ' REPLACE GRID LINES
                CALL draw_grid
            END IF

        END IF
    END IF

LOOP UNTIL INKEY$ = CHR$(27) 'escape key exit

END


' GRID LINES
SUB draw_grid ()

    ' TOP BOXES
    LINE (140, 10)-(308, 190), dgrey, B
    LINE (140, 35)-(308, 190), dgrey, B

    ' CELL GRID
    FOR tiler = 46 TO 46 + (5 * 24) STEP 24
        FOR tilec = 140 TO 140 + (24 * 6) STEP 24
            LINE (tilec, tiler)-(tilec + 24, tiler + 24), dgrey, B
        NEXT
    NEXT

END SUB


' CONVERT CELLS TO TILES AND OUTPUT THE TILES
SUB save_cells ()


    ' SAVE THE TILES
    OPEN tiles_file$ FOR BINARY AS #1
    PUT #1, , cells()
    CLOSE

    LOCATE 1, 1
    PRINT "TILE DATA SAVED"



END SUB


' LOAD THE CELL DATA
SUB load_cells ()
    ' GET THE CURRENT TILE DATA
    OPEN tiles_file$ FOR BINARY AS #2
    GET #2, , cells()
    CLOSE #2

    this_cell = 0
    cell_row = 0
    cell_col = 0
    FOR cell_row = 0 TO 17
        FOR cell_col = 0 TO 20
            tmp_X = cell_col * 8
            tmp_Y = cell_row * 8
            CALL print_char(cells(this_cell), tmp_X + 141, tmp_Y + 47)
            this_cell = this_cell + 1
        NEXT
    NEXT

END SUB


' BUTTON DRAWING
SUB draw_button (label AS STRING, x AS INTEGER, y AS INTEGER)

    LINE (x, y)-(x + 49, y + 8), dgrey, BF
    LINE (x, y)-(x + 50, y), white, BF
    LINE (x, y)-(x, y + 8), white, BF

    LINE (x + 2, y + 8)-(x + 49, y + 8), dgrey, BF

    _PRINTSTRING (x + 8, y + 1), label
END SUB




' DISPLAY THE SELECTED CHAR
SUB print_char (which_char AS _UNSIGNED _BYTE, x AS INTEGER, y AS INTEGER)

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






