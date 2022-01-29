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
DIM SHARED map(43) AS _UNSIGNED _BYTE
DIM SHARED charset(256, 8) AS _UNSIGNED _BYTE
DIM SHARED this_char AS INTEGER
DIM in_byte AS _UNSIGNED _BYTE
DIM row AS INTEGER
DIM col AS INTEGER
DIM SHARED tiler, tilec AS INTEGER
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
        IF _MOUSEX > 15 AND _MOUSEX < 182 AND _MOUSEY > 15 AND _MOUSEY < 155 THEN

            ' PAINT CHARACTER SELECTION
            IF _MOUSEBUTTON(1) THEN
                tmp_row = _MOUSEY - 10
                tmp_row = INT(tmp_row / 24)

                selected_tile = INT((_MOUSEX - 15) / 24) + INT((tmp_row * 7))
                IF selected_tile > 41 THEN selected_tile = selected_tile - 7
                LOCATE 1, 10
                PRINT selected_tile


                remainder = selected_tile MOD 7
                tilerow = INT((selected_tile - remainder) / 7)
                y = tilerow * 24
                x = remainder * 24
                IF (y + 34) < 156 THEN
                    CALL draw_grid
                    LINE (x + 10, y + 10)-(x + 34, y + 34), blue, B
                END IF

            END IF


        ELSE
            ' __________________________
            ' BUTTONS
            ' --------------------------


            ' [QUIT]
            IF _MOUSEX > 620 AND _MOUSEY < 20 AND _MOUSEBUTTON(1) THEN END


            ' [SAVE]
            IF _MOUSEX > 241 AND _MOUSEX < 293 AND _MOUSEY > 0 AND _MOUSEY < 20 THEN
                IF _MOUSEBUTTON(1) THEN CALL save_map
            END IF


            ' TILES
            IF _MOUSEX > 243 AND _MOUSEX < 408 AND _MOUSEY > 10 AND _MOUSEY < 155 THEN


                tile_col = INT((_MOUSEX - 239) / 24)
                tile_row = INT((_MOUSEY - 10) / 24)
                tile = tile_col + (tile_row * 7)

                tmp_X = tile_col * 24 + 239
                tmp_Y = tile_row * 24 + 10

                LOCATE 1, 25
                PRINT tile

                IF _MOUSEBUTTON(1) THEN
                    map(tile) = selected_tile
                    CALL print_tile(selected_tile, tmp_X, tmp_Y)
                END IF
                IF _MOUSEBUTTON(2) THEN
                    map(tile) = 41
                    CALL print_tile(41, tmp_X, tmp_Y)
                END IF

            END IF

        END IF
    END IF

LOOP UNTIL INKEY$ = CHR$(27) 'escape key exit

END


' GRID LINES
SUB draw_map_grid ()

    ' MAP GRID
    FOR tiler = 10 TO 10 + (5 * 24) STEP 24
        FOR tilec = 240 TO 240 + (24 * 6) STEP 24
            LINE (tilec, tiler)-(tilec + 24, tiler + 24), dgrey, B
        NEXT
    NEXT

END SUB
SUB draw_grid ()

    ' TILE GRID
    FOR tiler = 10 TO 10 + (5 * 24) STEP 24
        FOR tilec = 10 TO 10 + (24 * 6) STEP 24
            LINE (tilec, tiler)-(tilec + 24, tiler + 24), dgrey, B
        NEXT
    NEXT



END SUB

' OUTPUT THE MAP
SUB load_map ()
    DIM this_tile, in_tile AS _UNSIGNED _BYTE
    tiler = 0
    tilec = 0
    this_tile = 0


    ' SAVE THE TILES
    OPEN map_file$ FOR BINARY AS #1

    ' MAP GRID
    FOR tiler = 0 TO 6
        FOR tilec = 0 TO 7

            GET #1, , in_tile
            map(this_tile) = in_tile
            PRINT in_tile;
            CALL print_tile(in_tile, (tilec * 24) + 240, (tiler * 24) + 10)
            this_tile = this_tile + 1
        NEXT
    NEXT

    CLOSE

    LOCATE 10, 10
    PRINT "MAP DATA LOADED"
    PRINT UBOUND(map, 1)

END SUB




' OUTPUT THE MAP
SUB save_map ()
    LOCATE 10, 10
    PRINT UBOUND(map, 1)

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

    ' REPLACE GRID LINES
    CALL draw_map_grid

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






