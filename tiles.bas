tiles_file$ = "tiles.bin"
Open tiles_file$ For Binary As #1
Do Until EOF(1)
    Get #1, ,in_byte%
    Print in_byte%
Loop
Close #1

