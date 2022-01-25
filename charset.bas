SCREEN 1
_FULLSCREEN
tiles_file$ = "c64chars.bin"
DIM in_byte AS _UNSIGNED _BYTE
DIM SHARED x AS INTEGER
DIM SHARED y AS INTEGER
DIM thisbit AS _UNSIGNED _BIT

OPEN tiles_file$ FOR BINARY AS #1
DO UNTIL EOF(1)

    FOR column = 8 TO 128 STEP 8
        FOR y = 0 TO 134
            GET #1, , in_byte
            FOR b = 0 TO 7 STEP 1

                thisbit = INT(_READBIT(in_byte, b))
                x = column + (7 - b)
                IF thisbit = 0 THEN
                    PSET (x, y), 12
                    ' PRINT "1";
                ELSE
                    PSET (x, y), 1
                    '  PRINT "0";
                END IF



                'PRINT thisbit;
            NEXT
            'PRINT
        NEXT
    NEXT
LOOP
CLOSE #1







