_TITLE "MAP EDITOR"
SCREEN 8
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


'_FULLSCREEN
_MOUSESHOW
OPTION BASE 0
DIM SHARED chars_file$
DIM SHARED tiles_file$
DIM SHARED map_file$
chars_file$ = "c64chars.bin"
tiles_file$ = "tiles.bin"
map_file$ = "map.bin"


' BUTTONS
CALL draw_button("Save", 242, 0)
CALL draw_button("X", 620, 0)


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

DIM SHARED this_tile AS INTEGER
DIM SHARED tiles(500) AS _UNSIGNED _BYTE

' LOAD TILE DATA
CALL load_tiles

' LOAD MAP
CALL load_map


' DRAW GRID LINES
CALL draw_grid



DO
    IF _MOUSEINPUT THEN '  skip keyboard reads
        LOCATE 1, 1
        PRINT _MOUSEX; _MOUSEY;
        IF _MOUSEX < 238 THEN

            ' PAINT CHARACTER SELECTION
            IF _MOUSEBUTTON(1) THEN

                selected_tile = INT(((_MOUSEY - 10) / 24) / 7) + INT((_MOUSEX - 10) / 24)
                LOCATE 1, 10
                PRINT selected_tile

                'CALL print_char(click_char, 150, 20)
            END IF

            ' ERASE CHARACTER SELECTION
            IF _MOUSEBUTTON(2) THEN

                LOCATE 1, 10
                PRINT INT(_MOUSEX / 10); INT(_MOUSEY / 10) - 1


            END IF

        ELSE
            ' __________________________
            ' BUTTONS
            ' --------------------------


            ' [QUIT]
            IF _MOUSEX > 299 AND _MOUSEY < 20 AND _MOUSEBUTTON(1) THEN END


            ' [SAVE]
            IF _MOUSEX > 141 AND _MOUSEX < 193 AND _MOUSEY > 35 AND _MOUSEY < 48 THEN
                IF _MOUSEBUTTON(1) THEN CALL save_map
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

    ' MAP GRID
    FOR tiler = 10 TO 10 + (5 * 24) STEP 24
        FOR tilec = 240 TO 240 + (24 * 6) STEP 24
            LINE (tilec, tiler)-(tilec + 24, tiler + 24), dgrey, B
        NEXT
    NEXT

    ' MAP GRID
    FOR tiler = 10 TO 10 + (5 * 24) STEP 24
        FOR tilec = 10 TO 10 + (24 * 6) STEP 24
            LINE (tilec, tiler)-(tilec + 24, tiler + 24), dgrey, B
        NEXT
    NEXT



END SUB

' OUTPUT THE MAP
SUB load_map ()


    ' SAVE THE TILES
    OPEN map_file$ FOR BINARY AS #1
    GET #1, , map()
    CLOSE

    LOCATE 1, 1
    PRINT "MAP DATA LOADED"



END SUB




' OUTPUT THE MAP
SUB save_map ()


    ' SAVE THE TILES
    OPEN map_file$ FOR BINARY AS #1
    PUT #1, , map()
    CLOSE

    LOCATE 1, 1
    PRINT "MAP DATA SAVED"



END SUB

' BUTTON DRAWING
SUB draw_button (label AS STRING, x AS INTEGER, y AS INTEGER)

    LINE (x, y)-(x + 49, y + 8), dgrey, BF
    LINE (x, y)-(x + 50, y), white, BF
    LINE (x, y)-(x, y + 8), white, BF

    LINE (x + 2, y + 8)-(x + 49, y + 8), dgrey, BF

    _PRINTSTRING (x + 8, y + 1), label
END SUB


' LOAD THE CELL DATA
SUB load_tiles ()

    ' GET THE CURRENT TILE DATA
    OPEN tiles_file$ FOR BINARY AS #2
    GET #2, , tiles()
    CLOSE #2


    this_tile = 0
    tile_row = 0
    tile_col = 0
    FOR tile_row = 0 TO 5
        FOR tile_col = 0 TO 6
            tmp_X = tile_col * 24
            tmp_Y = tile_row * 24
            CALL print_tile(this_tile, tmp_X + 10, tmp_Y + 10)
            this_tile = this_tile + 1
        NEXT
    NEXT

END SUB


SUB print_tile (tile_no, x, y)

    DIM tremainder AS _BYTE
    DIM trow AS _BYTE
    DIM tile_cell AS INTEGER


    ' Get starting byte
    tremainder = INT(tile_no MOD 7)
    trow = (tile_no - tremainder) / 7
    tile_cell = ((trow * 63) + (tremainder * 3))
    'PRINT tile_cell

    trow = 0
    FOR trow = 1 TO 3
        CALL print_char(tiles(tile_cell), x, y)
        CALL print_char(tiles(tile_cell + 1), x + 8, y)
        CALL print_char(tiles(tile_cell + 2), x + 16, y)
        tile_cell = tile_cell + 21
        y = y + 8
    NEXT

END SUB


' DISPLAY THE SELECTED CHAR
SUB print_char (which_char AS _UNSIGNED INTEGER, x AS INTEGER, y AS INTEGER)

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






