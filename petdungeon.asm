 processor 6502
	org $1201
StartBlock1201:
	; Starting new memory block at $1201
	.byte $b ; lo byte of next line
	.byte $12 ; hi byte of next line
	.byte $0a, $00 ; line 10 (lo, hi)
	.byte $9e, $20 ; SYS token and a space
	.byte   $34,$36,$32,$34
	.byte $00, $00, $00 ; end of program
	; Ending memory block at $1201
EndBlock1201:
	org $1210
StartBlock1210:
	; Starting new memory block at $1210
dungeon64
	; LineNumber: 495
	jmp block1
	; LineNumber: 4
txt_i	dc.b	$00
	; LineNumber: 5
txt_temp_address_p	dc.w	$00
	; LineNumber: 6
txt_ytab	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w 0
	; LineNumber: 12
txt_max_digits	dc.w	0
	; LineNumber: 12
txt_next_digit	dc.w	0
	; LineNumber: 13
txt_temp_num_p	= $02
	; LineNumber: 14
txt_temp_num	dc.w	0
	; LineNumber: 15
txt_temp_i	dc.b	$00
	; LineNumber: 17
txt_in_str	= $04
	; LineNumber: 18
txt_CRLF	dc.b	0
	; LineNumber: 5
levels_r	dc.b	0
	; LineNumber: 6
levels_current_level	dc.w	$00
	; LineNumber: 7
levels_t_x	dc.b	0
	; LineNumber: 7
levels_t_y	dc.b	0
	; LineNumber: 7
levels_tile_no	dc.b	0
	; LineNumber: 8
levels_temp_s	= $08
	; LineNumber: 8
levels_dest	= $16
	; LineNumber: 8
levels_ch_index	= $0B
	; LineNumber: 10
levels_tiles_across	dc.b	0
	; LineNumber: 11
levels_detected_screen_width	dc.b	0
	; LineNumber: 18
levels_screen_buffer	dc.b	 
	org levels_screen_buffer+1000
	; LineNumber: 20
levels_level_p	= $0D
	; LineNumber: 21
levels_tiles
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///tiles.bin"
	; LineNumber: 33
levels_level
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map.bin"
	; LineNumber: 40
player_char	dc.b	$00
	; LineNumber: 41
space_char	dc.b	$20
	; LineNumber: 43
key_press	dc.b	$00
	; LineNumber: 44
charat	dc.b	0
	; LineNumber: 45
game_won	dc.b	0
	; LineNumber: 45
game_running	dc.b	0
	; LineNumber: 46
x	dc.b	0
	; LineNumber: 46
y	dc.b	0
	; LineNumber: 46
oldx	dc.b	0
	; LineNumber: 46
oldy	dc.b	0
	; LineNumber: 48
new_status	= $10
	; LineNumber: 48
the_status	= $12
	; LineNumber: 48
p	= $22
	; LineNumber: 51
keys	dc.b	$00
	; LineNumber: 52
gold	dc.w	$00
	; LineNumber: 53
health	dc.b	$0c
	; LineNumber: 56
attack	dc.b	$0c
	; LineNumber: 57
defense	dc.b	$0c
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init16x8div
	;    Procedure type : Built-in function
	;    Requires initialization : no
initdiv16x8_divisor = $4c     ;$59 used for hi-byte
initdiv16x8_dividend = $4e	  ;$fc used for hi-byte
initdiv16x8_remainder = $50	  ;$fe used for hi-byte
initdiv16x8_result = $4e ;save memory by reusing divident to store the result
divide16x8
	lda #0	        ;preset remainder to 0
	sta initdiv16x8_remainder
	sta initdiv16x8_remainder+1
	ldx #16	        ;repeat for each bit: ...
divloop16:	asl initdiv16x8_dividend	;dividend lb & hb*2, msb -> Carry
	rol initdiv16x8_dividend+1
	rol initdiv16x8_remainder	;remainder lb & hb * 2 + msb from carry
	rol initdiv16x8_remainder+1
	lda initdiv16x8_remainder
	sec
	sbc initdiv16x8_divisor	;substract divisor to see if it fits in
	tay	        ;lb result -> Y, for we may need it later
	lda initdiv16x8_remainder+1
	sbc initdiv16x8_divisor+1
	bcc skip16	;if carry=0 then divisor didn't fit in yet
	sta initdiv16x8_remainder+1	;else save substraction result as new remainder,
	sty initdiv16x8_remainder
	inc initdiv16x8_result	;and INCrement result cause divisor fit in 1 times
skip16
	dex
	bne divloop16
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init16x8mul
	;    Procedure type : Built-in function
	;    Requires initialization : no
mul16x8_num1Hi = $4c
mul16x8_num1 = $4e
mul16x8_num2 = $50
mul16x8_procedure
	lda #$00
	ldy #$00
	beq mul16x8_enterLoop
mul16x8_doAdd
	clc
	adc mul16x8_num1
	tax
	tya
	adc mul16x8_num1Hi
	tay
	txa
mul16x8_loop
	asl mul16x8_num1
	rol mul16x8_num1Hi
mul16x8_enterLoop
	lsr mul16x8_num2
	bcs mul16x8_doAdd
	bne mul16x8_loop
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init8x8div
	;    Procedure type : Built-in function
	;    Requires initialization : no
div8x8_c = $4c
div8x8_d = $4e
div8x8_e = $50
	; Normal 8x8 bin div
div8x8_procedure
	lda #$00
	ldx #$07
	clc
div8x8_loop1
	rol div8x8_d
	rol
	cmp div8x8_c
	bcc div8x8_loop2
	sbc div8x8_c
div8x8_loop2
	dex
	bpl div8x8_loop1
	rol div8x8_d
	lda div8x8_d
div8x8_def_end
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : initeightbitmul
	;    Procedure type : Built-in function
	;    Requires initialization : no
multiplier = $4c
multiplier_a = $4e
multiply_eightbit
	cpx #$00
	beq mul_end
	dex
	stx $4e
	lsr
	sta multiplier
	lda #$00
	ldx #$08
mul_loop
	bcc mul_skip
mul_mod
	adc multiplier_a
mul_skip
	ror
	ror multiplier
	dex
	bne mul_loop
	ldx multiplier
	rts
mul_end
	txa
	rts
initeightbitmul_multiply_eightbit2
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : initmoveto
	;    Procedure type : Built-in function
	;    Requires initialization : no
	jmp initmoveto_moveto3
screenmemory =  $fe
colormemory =  $fb
screen_x = $4c
screen_y = $4e
SetScreenPosition
	sta screenmemory+1
	lda #0
	sta screenmemory
	ldy screen_y
	beq sydone
syloop
	clc
	adc #22
	bcc sskip
	inc screenmemory+1
sskip
	dey
	bne syloop
sydone
	ldx screen_x
	beq sxdone
	clc
	adc screen_x
	bcc sxdone
	inc screenmemory+1
sxdone
	sta screenmemory
	rts
initmoveto_moveto3
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : initrandom256
	;    Procedure type : Built-in function
	;    Requires initialization : no
	; init random256
Random
	lda #$01
	asl
	bcc initrandom256_RandomSkip4
	eor #$4d
initrandom256_RandomSkip4
	eor $9124
	sta Random+1
	rts
	;*
; //
; //	Output a string at the current cursor location.
; //	Set Carriage Return on/off	
; //	
; //	*
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_text_colour
	;    Procedure type : User-defined procedure
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cls
	;    Procedure type : User-defined procedure
	; LineNumber: 267
txt_cls
	; LineNumber: 268
	; Assigning to register
	; Assigning register : _a
	lda #$93
	; LineNumber: 269
	jsr $ffd2
	; LineNumber: 270
	jsr txt_DefineScreen
	; LineNumber: 273
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_DefineScreen
	;    Procedure type : User-defined procedure
	; LineNumber: 279
txt_DefineScreen
	; LineNumber: 281
	; Binary clause INTEGER: NOTEQUALS
	; Load Integer array
	ldx #0 ; watch for bug, Integer array has max index of 128
	lda txt_ytab,x
	ldy txt_ytab+1,x
txt_DefineScreen_rightvarInteger_var12 = $54
	sta txt_DefineScreen_rightvarInteger_var12
	sty txt_DefineScreen_rightvarInteger_var12+1
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_DefineScreen_rightvarInteger_var12+1   ; compare high bytes
	cmp #$00 ;keep
	beq txt_DefineScreen_pass113
	jmp txt_DefineScreen_ConditionalTrueBlock8
txt_DefineScreen_pass113
	lda txt_DefineScreen_rightvarInteger_var12
	cmp #$00 ;keep
	beq txt_DefineScreen_elsedoneblock10
	jmp txt_DefineScreen_ConditionalTrueBlock8
txt_DefineScreen_ConditionalTrueBlock8: ;Main true block ;keep 
	; LineNumber: 282
	; LineNumber: 283
	rts
	; LineNumber: 284
txt_DefineScreen_elsedoneblock10
	; LineNumber: 286
	; Binary clause INTEGER: EQUALS
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_address_p+1   ; compare high bytes
	cmp #$00 ;keep
	bne txt_DefineScreen_elseblock17
	lda txt_temp_address_p
	cmp #$00 ;keep
	bne txt_DefineScreen_elseblock17
	jmp txt_DefineScreen_ConditionalTrueBlock16
txt_DefineScreen_ConditionalTrueBlock16: ;Main true block ;keep 
	; LineNumber: 286
	; LineNumber: 288
	; Integer constant assigning
	ldy #$1e
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 289
	; Clear screen with offset
	lda #$1
	ldx #$fe
txt_DefineScreen_clearloop24
	dex
	sta $0000+$9600,x
	sta $00fd+$9600,x
	bne txt_DefineScreen_clearloop24
	; LineNumber: 291
	jmp txt_DefineScreen_elsedoneblock18
txt_DefineScreen_elseblock17
	; LineNumber: 292
	; LineNumber: 293
	; Clear screen with offset
	lda #$1
	ldx #$fe
txt_DefineScreen_clearloop26
	dex
	sta $0000+$9400,x
	sta $00fd+$9400,x
	bne txt_DefineScreen_clearloop26
	; LineNumber: 294
txt_DefineScreen_elsedoneblock18
	; LineNumber: 302
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
txt_DefineScreen_forloop27
	; LineNumber: 297
	; LineNumber: 298
	ldx #$16 ; optimized, look out for bugs
	lda #$20
txt_DefineScreen_fill36
	; integer assignment NodeVar
	ldy txt_temp_address_p+1 ; keep
	lda txt_temp_address_p,x
	dex
	bpl txt_DefineScreen_fill36
	; LineNumber: 299
	; integer assignment NodeVar
	lda txt_temp_address_p
	; Calling storevariable on generic assign expression
	pha
	lda txt_i
	asl
	tax
	pla
	sta txt_ytab,x
	tya
	sta txt_ytab+1,x
	; LineNumber: 300
	lda txt_temp_address_p
	clc
	adc #$16
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd37
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd37
	; LineNumber: 301
txt_DefineScreen_forloopcounter29
txt_DefineScreen_loopstart30
	; Compare is onpage
	; Test Inc dec D
	inc txt_i
	lda #$17
	cmp txt_i ;keep
	bcs txt_DefineScreen_forloop27
txt_DefineScreen_loopdone38: ;keep
txt_DefineScreen_forloopend28
txt_DefineScreen_loopend31
	; LineNumber: 304
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 309
	; LineNumber: 306
txt__text_x	dc.b	0
	; LineNumber: 306
txt__text_y	dc.b	0
txt_move_to_block39
txt_move_to
	; LineNumber: 310
	; ****** Inline assembler section
	clc
	; LineNumber: 311
	; Assigning to register
	; Assigning register : _y
	ldy txt__text_x
	; LineNumber: 312
	; Assigning to register
	; Assigning register : _x
	ldx txt__text_y
	; LineNumber: 313
	jsr $fff0
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 360
	; LineNumber: 359
txt_CH	dc.b	0
txt_put_ch_block40
txt_put_ch
	; LineNumber: 361
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 362
	jsr $ffd2
	; LineNumber: 364
	rts
	
; // Clear keyboard buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_clear_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 368
txt_clear_buffer
	; LineNumber: 370
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $c6
	; LineNumber: 371
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 377
	; LineNumber: 376
txt_ink	dc.b	$00
txt_get_key_block42
txt_get_key
	; LineNumber: 378
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 379
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 380
txt_get_key_while43
txt_get_key_loopstart47
	; Binary clause Simplified: EQUALS
	lda txt_ink
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_get_key_elsedoneblock46
txt_get_key_ConditionalTrueBlock44: ;Main true block ;keep 
	; LineNumber: 381
	; LineNumber: 382
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 383
	jmp txt_get_key_while43
txt_get_key_elsedoneblock46
txt_get_key_loopend48
	; LineNumber: 384
	jsr $e5cf
	; LineNumber: 385
	; Assigning from register
	sta txt_ink
	; LineNumber: 386
	rts
	; LineNumber: 387
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 392
	; LineNumber: 391
txt_tmp_key	dc.b	$00
txt_wait_key_block51
txt_wait_key
	; LineNumber: 394
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 395
txt_wait_key_while52
txt_wait_key_loopstart56
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock55
txt_wait_key_ConditionalTrueBlock53: ;Main true block ;keep 
	; LineNumber: 396
	; LineNumber: 397
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 398
	jmp txt_wait_key_while52
txt_wait_key_elsedoneblock55
txt_wait_key_loopend57
	; LineNumber: 400
	jsr txt_clear_buffer
	; LineNumber: 401
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 452
txt_cursor_return
	; LineNumber: 454
	; Assigning to register
	; Assigning register : _a
	lda #$d
	; LineNumber: 455
	jsr $ffd2
	; LineNumber: 457
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 478
	; LineNumber: 477
txt_next_ch	dc.b	0
txt_print_string_block61
txt_print_string
	; LineNumber: 480
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 481
txt_print_string_while62
txt_print_string_loopstart66
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock65
txt_print_string_ConditionalTrueBlock63: ;Main true block ;keep 
	; LineNumber: 481
	; LineNumber: 483
	; Assigning to register
	; Assigning register : _a
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; LineNumber: 484
	jsr $ffd2
	; LineNumber: 485
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 486
	jmp txt_print_string_while62
txt_print_string_elsedoneblock65
txt_print_string_loopend67
	; LineNumber: 488
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock73
txt_print_string_ConditionalTrueBlock71: ;Main true block ;keep 
	; LineNumber: 489
	; LineNumber: 490
	jsr txt_cursor_return
	; LineNumber: 492
txt_print_string_elsedoneblock73
	; LineNumber: 493
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_str_len
	;    Procedure type : User-defined procedure
	; LineNumber: 635
txt_str_len_block76
txt_str_len
	; LineNumber: 637
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 640
txt_str_len_while77
txt_str_len_loopstart81
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_i
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_str_len_elsedoneblock80
txt_str_len_ConditionalTrueBlock78: ;Main true block ;keep 
	; LineNumber: 640
	; LineNumber: 642
	
; // get the Str_Len by counting until char is 0
	; Test Inc dec D
	inc txt_i
	; LineNumber: 643
	jmp txt_str_len_while77
txt_str_len_elsedoneblock80
txt_str_len_loopend82
	; LineNumber: 647
	; LineNumber: 648
	lda txt_i
	rts
	
; // Return
; // print X spaces
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_space
	;    Procedure type : User-defined procedure
	; LineNumber: 652
txt_print_space_block85
txt_print_space
	; LineNumber: 654
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 659
	; Calling storevariable on generic assign expression
txt_print_space_forloop86
	; LineNumber: 656
	; LineNumber: 657
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 658
txt_print_space_forloopcounter88
txt_print_space_loopstart89
	; Compare is onpage
	; Test Inc dec D
	inc txt_i
	; integer assignment NodeVar
	ldy txt_max_digits+1 ; keep
	lda txt_max_digits
	cmp txt_i ;keep
	bne txt_print_space_forloop86
txt_print_space_loopdone93: ;keep
txt_print_space_forloopend87
txt_print_space_loopend90
	; LineNumber: 660
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string_centered
	;    Procedure type : User-defined procedure
	; LineNumber: 664
	; LineNumber: 663
txt__sc_w	dc.b	0
txt_print_string_centered_block94
txt_print_string_centered
	; LineNumber: 666
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 667
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 670
	
; // Get the length of the string
	jsr txt_str_len
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 673
	
; // padding should be half of width minus string length
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; HandleVarBinopB16bit
	ldy #0 ; ::HandleVarBinopB16bit 0
	; RHS is pure, optimization
	lda txt__sc_w
	sec
	sbc txt_i
	; Testing for byte:  #0
	; RHS is byte, optimization
	bcs txt_print_string_centered_skip96
	dey
txt_print_string_centered_skip96
txt_print_string_centered_int_shift_var97 = $56
	sta txt_print_string_centered_int_shift_var97
	sty txt_print_string_centered_int_shift_var97+1
		lsr txt_print_string_centered_int_shift_var97+1
	ror txt_print_string_centered_int_shift_var97+0

	lda txt_print_string_centered_int_shift_var97
	ldy txt_print_string_centered_int_shift_var97+1
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 676
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_max_digits+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_string_centered_elseblock100
	bne txt_print_string_centered_localsuccess104
	lda txt_max_digits
	cmp #$00 ;keep
	bcc txt_print_string_centered_elseblock100
	beq txt_print_string_centered_elseblock100
txt_print_string_centered_localsuccess104: ;keep
	; ; logical AND, second requirement
	; Binary clause Simplified: LESS
	lda txt_i
	; Compare with pure num / var optimization
	cmp #$28;keep
	bcs txt_print_string_centered_elseblock100
txt_print_string_centered_ConditionalTrueBlock99: ;Main true block ;keep 
	; LineNumber: 676
	; LineNumber: 680
	
; // Is it worth padding?
; // Add the padding
	jsr txt_print_space
	; LineNumber: 683
	
; // print the string
	jsr txt_print_string
	; LineNumber: 686
	jmp txt_print_string_centered_elsedoneblock101
txt_print_string_centered_elseblock100
	; LineNumber: 687
	; LineNumber: 689
	
; // print the string
	jsr txt_print_string
	; LineNumber: 690
txt_print_string_centered_elsedoneblock101
	; LineNumber: 694
	rts
	
; // NOT atari
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_dec
	;    Procedure type : User-defined procedure
	; LineNumber: 699
	; LineNumber: 698
txt__in_n	dc.b	0
	; LineNumber: 698
txt__add_cr	dc.b	0
txt_print_dec_block107
txt_print_dec
	; LineNumber: 701
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_digit
	sty txt_next_digit+1
	; LineNumber: 702
	lda #$00
	ldx #$00
	sta txt_temp_num_p
	stx txt_temp_num_p+1
	; LineNumber: 703
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 704
	; Calling storevariable on generic assign expression
	sta txt_temp_i
	; LineNumber: 706
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$a;keep
	bcc txt_print_dec_localfailed153
	jmp txt_print_dec_ConditionalTrueBlock109
txt_print_dec_localfailed153
	jmp txt_print_dec_elseblock110
txt_print_dec_ConditionalTrueBlock109: ;Main true block ;keep 
	; LineNumber: 706
	; LineNumber: 709
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed176
	jmp txt_print_dec_ConditionalTrueBlock156
txt_print_dec_localfailed176
	jmp txt_print_dec_elseblock157
txt_print_dec_ConditionalTrueBlock156: ;Main true block ;keep 
	; LineNumber: 710
	; LineNumber: 712
	
; // Left
	; Right is PURE NUMERIC : Is word =1
	; 16x8 div
	ldy #0
	lda txt__in_n
	sta initdiv16x8_dividend
	sty initdiv16x8_dividend+1
	lda #$64
	sta initdiv16x8_divisor
	sty initdiv16x8_divisor+1
	jsr divide16x8
	lda initdiv16x8_dividend
	ldy initdiv16x8_dividend+1
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 713
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 717
	
; // middle 
; // 12
	; Generic 16 bit op
	ldy #0
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	; Right is PURE NUMERIC : Is word =1
	; 16x8 div
	lda txt__in_n
	sta initdiv16x8_dividend
	sty initdiv16x8_dividend+1
	lda #$64
	sta initdiv16x8_divisor
	sty initdiv16x8_divisor+1
	jsr divide16x8
	lda initdiv16x8_dividend
	ldy initdiv16x8_dividend+1
	sta mul16x8_num1
	sty mul16x8_num1Hi
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$a
	sta mul16x8_num2
	jsr mul16x8_procedure
txt_print_dec_rightvarInteger_var180 = $56
	sta txt_print_dec_rightvarInteger_var180
	sty txt_print_dec_rightvarInteger_var180+1
	; Right is PURE NUMERIC : Is word =1
	; 16x8 div
	ldy #0
	lda txt__in_n
	sta initdiv16x8_dividend
	sty initdiv16x8_dividend+1
	lda #$a
	sta initdiv16x8_divisor
	sty initdiv16x8_divisor+1
	jsr divide16x8
	lda initdiv16x8_dividend
	ldy initdiv16x8_dividend+1
	; Low bit binop:
	sec
	sbc txt_print_dec_rightvarInteger_var180
txt_print_dec_wordAdd178
	sta txt_print_dec_rightvarInteger_var180
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var180+1
	tay
	lda txt_print_dec_rightvarInteger_var180
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 718
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock184
	bne txt_print_dec_ConditionalTrueBlock182
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock184
	beq txt_print_dec_elsedoneblock184
txt_print_dec_ConditionalTrueBlock182: ;Main true block ;keep 
	; LineNumber: 717
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd188
	dec txt_temp_num+1
txt_print_dec_WordAdd188
txt_print_dec_elsedoneblock184
	; LineNumber: 719
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	lda txt_temp_num
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 722
	
; // right digit
	; Modulo
	lda #$a
txt_print_dec_val_var189 = $56
	sta txt_print_dec_val_var189
	lda txt__in_n
	sec
txt_print_dec_modulo190
	sbc txt_print_dec_val_var189
	bcs txt_print_dec_modulo190
	adc txt_print_dec_val_var189
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 723
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 726
	jmp txt_print_dec_elsedoneblock158
txt_print_dec_elseblock157
	; LineNumber: 727
	; LineNumber: 730
	
; // left digit
	; Right is PURE NUMERIC : Is word =1
	; 16x8 div
	ldy #0
	lda txt__in_n
	sta initdiv16x8_dividend
	sty initdiv16x8_dividend+1
	lda #$a
	sta initdiv16x8_divisor
	sty initdiv16x8_divisor+1
	jsr divide16x8
	lda initdiv16x8_dividend
	ldy initdiv16x8_dividend+1
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 731
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 734
	
; // right digit
	; HandleVarBinopB16bit
	ldy #0 ; ::HandleVarBinopB16bit 0
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	; Right is PURE NUMERIC : Is word =1
	; 16x8 div
	lda txt__in_n
	sta initdiv16x8_dividend
	sty initdiv16x8_dividend+1
	lda #$a
	sta initdiv16x8_divisor
	sty initdiv16x8_divisor+1
	jsr divide16x8
	lda initdiv16x8_dividend
	ldy initdiv16x8_dividend+1
	sta mul16x8_num1
	sty mul16x8_num1Hi
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$a
	sta mul16x8_num2
	jsr mul16x8_procedure
txt_print_dec_rightvarInteger_var193 = $56
	sta txt_print_dec_rightvarInteger_var193
	sty txt_print_dec_rightvarInteger_var193+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var193+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var193
	bcs txt_print_dec_wordAdd192
	dey
txt_print_dec_wordAdd192
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 735
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 736
txt_print_dec_elsedoneblock158
	; LineNumber: 739
	jmp txt_print_dec_elsedoneblock111
txt_print_dec_elseblock110
	; LineNumber: 740
	; LineNumber: 741
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 742
txt_print_dec_elsedoneblock111
	; LineNumber: 744
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock198
txt_print_dec_ConditionalTrueBlock196: ;Main true block ;keep 
	; LineNumber: 743
	jsr txt_cursor_return
txt_print_dec_elsedoneblock198
	; LineNumber: 745
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_tile
	;    Procedure type : User-defined procedure
	; LineNumber: 43
	; LineNumber: 40
levels_tremainder	dc.b	0
	; LineNumber: 41
levels_trow	dc.b	0
	; LineNumber: 42
levels_tile_cell	dc.w	0
levels_draw_tile_block201
levels_draw_tile
	; LineNumber: 46
	
; // Get starting byte
	; Modulo
	lda #$7
levels_draw_tile_val_var202 = $56
	sta levels_draw_tile_val_var202
	lda levels_tile_no
	sec
levels_draw_tile_modulo203
	sbc levels_draw_tile_val_var202
	bcs levels_draw_tile_modulo203
	adc levels_draw_tile_val_var202
	; Calling storevariable on generic assign expression
	sta levels_tremainder
	; LineNumber: 47
	; Right is PURE NUMERIC : Is word =0
	; 8 bit div
	; 8 bit binop
	; Add/sub where right value is constant number
	lda levels_tile_no
	sec
	sbc levels_tremainder
	 ; end add / sub var with constant
	sta div8x8_d
	; Load right hand side
	lda #$7
	sta div8x8_c
	jsr div8x8_procedure
	; Calling storevariable on generic assign expression
	sta levels_trow
	; LineNumber: 48
	; Generic 16 bit op
	ldy #0
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	lda levels_tremainder
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$3
	sta mul16x8_num2
	jsr mul16x8_procedure
levels_draw_tile_rightvarInteger_var208 = $56
	sta levels_draw_tile_rightvarInteger_var208
	sty levels_draw_tile_rightvarInteger_var208+1
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy #0
	lda levels_trow
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$3f
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var208
levels_draw_tile_wordAdd206
	sta levels_draw_tile_rightvarInteger_var208
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var208+1
	tay
	lda levels_draw_tile_rightvarInteger_var208
	; Calling storevariable on generic assign expression
	sta levels_tile_cell
	sty levels_tile_cell+1
	; LineNumber: 52
	
; // ROW 1
	; INTEGER optimization: a=b+c 
	lda #<levels_tiles
	clc
	adc levels_tile_cell
	sta levels_temp_s+0
	lda #>levels_tiles
	adc levels_tile_cell+1
	sta levels_temp_s+1
	; LineNumber: 53
	; Generic 16 bit op
	ldy #0
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	lda levels_t_x
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$3
	sta mul16x8_num2
	jsr mul16x8_procedure
levels_draw_tile_rightvarInteger_var212 = $56
	sta levels_draw_tile_rightvarInteger_var212
	sty levels_draw_tile_rightvarInteger_var212+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var215 = $58
	sta levels_draw_tile_rightvarInteger_var215
	sty levels_draw_tile_rightvarInteger_var215+1
	; Mul 16x8 setup
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy #0
	lda levels_t_y
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$3
	sta mul16x8_num2
	jsr mul16x8_procedure
	sta mul16x8_num1
	sty mul16x8_num1Hi
	ldy #0
	lda levels_detected_screen_width
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var215
levels_draw_tile_wordAdd213
	sta levels_draw_tile_rightvarInteger_var215
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var215+1
	tay
	lda levels_draw_tile_rightvarInteger_var215
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var212
levels_draw_tile_wordAdd210
	sta levels_draw_tile_rightvarInteger_var212
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var212+1
	tay
	lda levels_draw_tile_rightvarInteger_var212
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 54
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy216
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy216
	; LineNumber: 57
	
; // ROW 2
	lda levels_temp_s
	clc
	adc #$15
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd217
	inc levels_temp_s+1
levels_draw_tile_WordAdd217
	; LineNumber: 58
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd218
	inc levels_dest+1
levels_draw_tile_WordAdd218
	; LineNumber: 59
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy219
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy219
	; LineNumber: 62
	
; // ROW 3
	lda levels_temp_s
	clc
	adc #$15
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd220
	inc levels_temp_s+1
levels_draw_tile_WordAdd220
	; LineNumber: 63
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd221
	inc levels_dest+1
levels_draw_tile_WordAdd221
	; LineNumber: 64
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy222
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy222
	; LineNumber: 66
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 73
levels_draw_level
	; LineNumber: 76
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 77
	lda #<levels_level
	ldx #>levels_level
	sta levels_level_p
	stx levels_level_p+1
	; LineNumber: 88
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop224
	; LineNumber: 81
	; LineNumber: 86
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop243
	; LineNumber: 83
	; LineNumber: 84
	; Load pointer array
	; 8 bit binop
	; Add/sub where right value is constant number
	; 8 bit mul
	ldx levels_t_y ; optimized, look out for bugs
	; Load right hand side
	lda levels_tiles_across
	jsr multiply_eightbit
	txa
	clc
	adc levels_t_x
	 ; end add / sub var with constant
	tay
	lda (levels_level_p),y
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	; LineNumber: 85
	jsr levels_draw_tile
	; LineNumber: 86
levels_draw_level_forloopcounter245
levels_draw_level_loopstart246
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda levels_tiles_across
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop243
levels_draw_level_loopdone254: ;keep
levels_draw_level_forloopend244
levels_draw_level_loopend247
	; LineNumber: 87
levels_draw_level_forloopcounter226
levels_draw_level_loopstart227
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_y
	lda #$6
	cmp levels_t_y ;keep
	bne levels_draw_level_forloop224
levels_draw_level_loopdone255: ;keep
levels_draw_level_forloopend225
levels_draw_level_loopend228
	; LineNumber: 90
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 97
levels_refresh_screen
	; LineNumber: 99
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 118
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop257
	; LineNumber: 104
	; LineNumber: 105
	
; // Need rows at the bottom 
; // for text output
	; Load Integer array
	lda levels_r
	asl
	tax
	lda txt_ytab,x
	ldy txt_ytab+1,x
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 111
	; memcpyfast
	ldy levels_detected_screen_width
	dey
levels_refresh_screen_memcpy266
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy266
	; LineNumber: 117
	
; //MemCpy16(temp_s, dest, detected_screen_width);
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd267
	inc levels_temp_s+1
levels_refresh_screen_WordAdd267
	; LineNumber: 118
levels_refresh_screen_forloopcounter259
levels_refresh_screen_loopstart260
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop257
levels_refresh_screen_loopdone268: ;keep
levels_refresh_screen_forloopend258
levels_refresh_screen_loopend261
	; LineNumber: 120
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 186
	; LineNumber: 185
levels_buf_x	dc.b	0
	; LineNumber: 185
levels_buf_y	dc.b	0
levels_get_buffer_block269
levels_get_buffer
	; LineNumber: 188
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var272 = $56
	sta levels_get_buffer_rightvarInteger_var272
	sty levels_get_buffer_rightvarInteger_var272+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var275 = $58
	sta levels_get_buffer_rightvarInteger_var275
	sty levels_get_buffer_rightvarInteger_var275+1
	; Mul 16x8 setup
	ldy #0
	lda levels_buf_y
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda levels_detected_screen_width
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var275
levels_get_buffer_wordAdd273
	sta levels_get_buffer_rightvarInteger_var275
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var275+1
	tay
	lda levels_get_buffer_rightvarInteger_var275
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var272
levels_get_buffer_wordAdd270
	sta levels_get_buffer_rightvarInteger_var272
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var272+1
	tay
	lda levels_get_buffer_rightvarInteger_var272
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 190
	; LineNumber: 191
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 196
	; LineNumber: 195
levels_plot_x	dc.b	0
	; LineNumber: 195
levels_plot_y	dc.b	0
	; LineNumber: 195
levels_plot_ch	dc.b	0
levels_plot_buffer_block276
levels_plot_buffer
	; LineNumber: 198
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var279 = $56
	sta levels_plot_buffer_rightvarInteger_var279
	sty levels_plot_buffer_rightvarInteger_var279+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var282 = $58
	sta levels_plot_buffer_rightvarInteger_var282
	sty levels_plot_buffer_rightvarInteger_var282+1
	; Mul 16x8 setup
	ldy #0
	lda levels_plot_y
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda levels_detected_screen_width
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var282
levels_plot_buffer_wordAdd280
	sta levels_plot_buffer_rightvarInteger_var282
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var282+1
	tay
	lda levels_plot_buffer_rightvarInteger_var282
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var279
levels_plot_buffer_wordAdd277
	sta levels_plot_buffer_rightvarInteger_var279
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var279+1
	tay
	lda levels_plot_buffer_rightvarInteger_var279
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 199
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 201
	rts
	
; //player inventory/stats
; // ********************************
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 65
init
	; LineNumber: 67
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 71
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 72
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 76
	
; // Clean the screen buffer		
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 77
	lda space_char
	ldy #0
init_fill284
	sta (p),y
	iny
	cpy #$fa
	bne init_fill284
	; LineNumber: 79
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd285
	inc p+1
init_WordAdd285
	; LineNumber: 80
	lda space_char
	ldy #0
init_fill286
	sta (p),y
	iny
	cpy #$fa
	bne init_fill286
	; LineNumber: 82
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd287
	inc p+1
init_WordAdd287
	; LineNumber: 83
	lda space_char
	ldy #0
init_fill288
	sta (p),y
	iny
	cpy #$fa
	bne init_fill288
	; LineNumber: 85
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd289
	inc p+1
init_WordAdd289
	; LineNumber: 86
	lda space_char
	ldy #0
init_fill290
	sta (p),y
	iny
	cpy #$fa
	bne init_fill290
	; LineNumber: 89
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 92
	
; // Set how wide the map should be
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_tiles_across
	; LineNumber: 109
	; Calling storevariable on generic assign expression
	; LineNumber: 113
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 115
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 116
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 119
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 120
	jsr levels_draw_level
	; LineNumber: 123
	
; // Draw the player
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda y
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda player_char
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 126
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 128
	rts
	
; // Set to use the new characterset
; // Force the screen address
; // Tells basic routines where screen memory is located
; // Clear screen,
; // Black screen
; // Ensure no flashing cursor
	; NodeProcedureDecl -1
	; ***********  Defining procedure : vic20_chars
	;    Procedure type : User-defined procedure
	; LineNumber: 164
vic20_chars
	; LineNumber: 166
	
; // Force the screen address
	; Integer constant assigning
	ldy #$10
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 167
	; Poke
	; Optimization: shift is zero
	lda #$8
	sta $900f
	; LineNumber: 170
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 173
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 208
show_start_screen
	; LineNumber: 210
	jsr txt_cls
	; LineNumber: 211
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed324
	jmp show_start_screen_ConditionalTrueBlock294
show_start_screen_localfailed324
	jmp show_start_screen_elsedoneblock296
show_start_screen_ConditionalTrueBlock294: ;Main true block ;keep 
	; LineNumber: 212
	; LineNumber: 215
	
; //                         01234567890123456789012
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 216
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 217
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr326
	sta txt_in_str
	lda #>show_start_screen_stringassignstr326
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 218
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 219
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr328
	sta txt_in_str
	lda #>show_start_screen_stringassignstr328
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 220
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr330
	sta txt_in_str
	lda #>show_start_screen_stringassignstr330
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 221
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr332
	sta txt_in_str
	lda #>show_start_screen_stringassignstr332
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 222
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 223
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr334
	sta txt_in_str
	lda #>show_start_screen_stringassignstr334
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 224
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 225
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr336
	sta txt_in_str
	lda #>show_start_screen_stringassignstr336
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 226
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr338
	sta txt_in_str
	lda #>show_start_screen_stringassignstr338
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 227
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 228
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr340
	sta txt_in_str
	lda #>show_start_screen_stringassignstr340
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 229
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 230
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr342
	sta txt_in_str
	lda #>show_start_screen_stringassignstr342
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 231
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr344
	sta txt_in_str
	lda #>show_start_screen_stringassignstr344
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 232
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr346
	sta txt_in_str
	lda #>show_start_screen_stringassignstr346
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 233
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr348
	sta txt_in_str
	lda #>show_start_screen_stringassignstr348
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 234
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr350
	sta txt_in_str
	lda #>show_start_screen_stringassignstr350
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 235
show_start_screen_elsedoneblock296
	; LineNumber: 239
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 240
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 243
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr352
	sta txt_in_str
	lda #>show_start_screen_stringassignstr352
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 244
	jsr txt_print_space
	; LineNumber: 247
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 248
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 251
	jsr txt_wait_key
	; LineNumber: 254
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 259
show_end_screen
	; LineNumber: 261
	jsr txt_cls
	; LineNumber: 262
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock357
show_end_screen_ConditionalTrueBlock356: ;Main true block ;keep 
	; LineNumber: 262
	; LineNumber: 264
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr366
	sta txt_in_str
	lda #>show_end_screen_stringassignstr366
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 266
	jmp show_end_screen_elsedoneblock358
show_end_screen_elseblock357
	; LineNumber: 267
	; LineNumber: 268
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr369
	sta txt_in_str
	lda #>show_end_screen_stringassignstr369
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 269
show_end_screen_elsedoneblock358
	; LineNumber: 272
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr371
	sta txt_in_str
	lda #>show_end_screen_stringassignstr371
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 274
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 276
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr373
	sta txt_in_str
	lda #>show_end_screen_stringassignstr373
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 278
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 280
	jsr txt_wait_key
	; LineNumber: 283
	rts
	
; //@ifndef ATARI800		
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 288
display_text
	; LineNumber: 290
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 291
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 292
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr376
	sta txt_in_str
	lda #>display_text_stringassignstr376
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 293
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 294
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 295
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 297
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 298
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 299
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 300
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 302
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 303
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 304
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 305
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 308
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 309
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 310
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 311
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 312
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 313
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 316
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 317
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 318
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 319
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 322
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 323
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 324
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 325
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 326
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 327
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 329
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 333
update_status_block378
update_status
	; LineNumber: 334
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 335
	jsr display_text
	; LineNumber: 337
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 341
door
	; LineNumber: 344
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed432
	jmp door_ConditionalTrueBlock381
door_localfailed432
	jmp door_elseblock382
door_ConditionalTrueBlock381: ;Main true block ;keep 
	; LineNumber: 345
	; LineNumber: 346
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 347
	; Assigning a string : new_status
	lda #<door_stringassignstr434
	sta new_status
	lda #>door_stringassignstr434
	sta new_status+1
	jsr update_status
	; LineNumber: 349
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock439
door_ConditionalTrueBlock437: ;Main true block ;keep 
	; LineNumber: 348
	; Assigning a string : new_status
	lda #<door_stringassignstr444
	sta new_status
	lda #>door_stringassignstr444
	sta new_status+1
	jsr update_status
door_elsedoneblock439
	; LineNumber: 350
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock449
door_ConditionalTrueBlock447: ;Main true block ;keep 
	; LineNumber: 349
	; Assigning a string : new_status
	lda #<door_stringassignstr454
	sta new_status
	lda #>door_stringassignstr454
	sta new_status+1
	jsr update_status
door_elsedoneblock449
	; LineNumber: 351
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock459
door_ConditionalTrueBlock457: ;Main true block ;keep 
	; LineNumber: 350
	; Assigning a string : new_status
	lda #<door_stringassignstr464
	sta new_status
	lda #>door_stringassignstr464
	sta new_status+1
	jsr update_status
door_elsedoneblock459
	; LineNumber: 352
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock469
door_ConditionalTrueBlock467: ;Main true block ;keep 
	; LineNumber: 353
	; LineNumber: 354
	; Assigning a string : new_status
	lda #<door_stringassignstr475
	sta new_status
	lda #>door_stringassignstr475
	sta new_status+1
	jsr update_status
	; LineNumber: 355
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd477
	inc levels_current_level+1
door_WordAdd477
	; LineNumber: 356
	; Test Inc dec D
	dec y
	; LineNumber: 357
	jsr levels_draw_level
	; LineNumber: 358
door_elsedoneblock469
	; LineNumber: 360
	jmp door_elsedoneblock383
door_elseblock382
	; LineNumber: 361
	; LineNumber: 362
	; Assigning a string : new_status
	lda #<door_stringassignstr479
	sta new_status
	lda #>door_stringassignstr479
	sta new_status+1
	jsr update_status
	; LineNumber: 365
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 366
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 367
door_elsedoneblock383
	; LineNumber: 369
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 373
combat
	; LineNumber: 376
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	; Right is PURE NUMERIC : Is word =0
	; 8 bit div
	jsr Random
	sta div8x8_d
	; Load right hand side
	lda #$c
	sta div8x8_c
	jsr div8x8_procedure
	; Compare with pure num / var optimization
	cmp #$b;keep
	bcc combat_elseblock484
combat_ConditionalTrueBlock483: ;Main true block ;keep 
	; LineNumber: 379
	; LineNumber: 380
	
; //if((Random::Random()/12)>10) then
	; Assigning a string : new_status
	lda #<combat_stringassignstr501
	sta new_status
	lda #>combat_stringassignstr501
	sta new_status+1
	jsr update_status
	; LineNumber: 381
	jmp combat_elsedoneblock485
combat_elseblock484
	; LineNumber: 383
	; LineNumber: 385
	; Test Inc dec D
	dec health
	; LineNumber: 388
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 389
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 391
	; Assigning a string : new_status
	lda #<combat_stringassignstr504
	sta new_status
	lda #>combat_stringassignstr504
	sta new_status+1
	jsr update_status
	; LineNumber: 393
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock507
	bcs combat_elsedoneblock509
combat_ConditionalTrueBlock507: ;Main true block ;keep 
	; LineNumber: 394
	; LineNumber: 395
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 396
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 397
combat_elsedoneblock509
	; LineNumber: 399
combat_elsedoneblock485
	; LineNumber: 401
	rts
	
; //@endif
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 407
check_collisions
	; LineNumber: 410
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext514
	; LineNumber: 414
	; LineNumber: 416
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr516
	sta new_status
	lda #>check_collisions_stringassignstr516
	sta new_status+1
	jsr update_status
	; LineNumber: 417
	jsr combat
	; LineNumber: 419
	jmp check_collisions_caseend513
check_collisions_casenext514
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext518
	; LineNumber: 422
	; LineNumber: 423
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr520
	sta new_status
	lda #>check_collisions_stringassignstr520
	sta new_status+1
	jsr update_status
	; LineNumber: 424
	jmp check_collisions_caseend513
check_collisions_casenext518
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext522
	; LineNumber: 426
	; LineNumber: 428
	jsr door
	; LineNumber: 429
	jmp check_collisions_caseend513
check_collisions_casenext522
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext524
	; LineNumber: 431
	; LineNumber: 433
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 434
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr526
	sta new_status
	lda #>check_collisions_stringassignstr526
	sta new_status+1
	jsr update_status
	; LineNumber: 435
	jmp check_collisions_caseend513
check_collisions_casenext524
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext528
	; LineNumber: 439
	; LineNumber: 440
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 441
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr530
	sta new_status
	lda #>check_collisions_stringassignstr530
	sta new_status+1
	jsr update_status
	; LineNumber: 443
	jmp check_collisions_caseend513
check_collisions_casenext528
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext532
	; LineNumber: 445
	; LineNumber: 448
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr534
	sta new_status
	lda #>check_collisions_stringassignstr534
	sta new_status+1
	jsr update_status
	; LineNumber: 449
	jsr combat
	; LineNumber: 450
	jmp check_collisions_caseend513
check_collisions_casenext532
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext536
	; LineNumber: 453
	; LineNumber: 454
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd538
	inc gold+1
check_collisions_WordAdd538
	; LineNumber: 455
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr539
	sta new_status
	lda #>check_collisions_stringassignstr539
	sta new_status+1
	jsr update_status
	; LineNumber: 457
	jmp check_collisions_caseend513
check_collisions_casenext536
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext541
	; LineNumber: 460
	; LineNumber: 462
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr543
	sta new_status
	lda #>check_collisions_stringassignstr543
	sta new_status+1
	jsr update_status
	; LineNumber: 463
	jsr combat
	; LineNumber: 465
	jmp check_collisions_caseend513
check_collisions_casenext541
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext545
	; LineNumber: 469
	; LineNumber: 471
	jmp check_collisions_caseend513
check_collisions_casenext545
	; LineNumber: 475
	; LineNumber: 478
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 479
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 484
	
; // Unknown
; //_A:=charat;
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr548
	sta new_status
	lda #>check_collisions_stringassignstr548
	sta new_status+1
	jsr update_status
	; LineNumber: 485
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 486
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 488
check_collisions_caseend513
	; LineNumber: 491
	rts
block1
	; LineNumber: 497
	
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 506
	
; // C64 has it's own special characters
	jsr vic20_chars
	; LineNumber: 507
	lda #$16
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 529
MainProgram_while550
MainProgram_loopstart554
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed646
	jmp MainProgram_ConditionalTrueBlock551
MainProgram_localfailed646
	jmp MainProgram_elsedoneblock553
MainProgram_ConditionalTrueBlock551: ;Main true block ;keep 
	; LineNumber: 529
	; LineNumber: 534
	
; // Borked, will need some work
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 538
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 541
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr648
	sta new_status
	lda #>MainProgram_stringassignstr648
	sta new_status+1
	jsr update_status
	; LineNumber: 542
	jsr display_text
	; LineNumber: 546
MainProgram_while650
MainProgram_loopstart654
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed696
	jmp MainProgram_ConditionalTrueBlock651
MainProgram_localfailed696
	jmp MainProgram_elsedoneblock653
MainProgram_ConditionalTrueBlock651: ;Main true block ;keep 
	; LineNumber: 547
	; LineNumber: 552
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 553
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 556
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 559
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext699
	; LineNumber: 561
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock704
MainProgram_ConditionalTrueBlock702: ;Main true block ;keep 
	; LineNumber: 561
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock704
	jmp MainProgram_caseend698
MainProgram_casenext699
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext707
	; LineNumber: 562
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock712
MainProgram_ConditionalTrueBlock710: ;Main true block ;keep 
	; LineNumber: 562
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock712
	jmp MainProgram_caseend698
MainProgram_casenext707
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext715
	; LineNumber: 563
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock720
MainProgram_ConditionalTrueBlock718: ;Main true block ;keep 
	; LineNumber: 563
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock720
	jmp MainProgram_caseend698
MainProgram_casenext715
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext723
	; LineNumber: 564
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock728
MainProgram_ConditionalTrueBlock726: ;Main true block ;keep 
	; LineNumber: 564
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock728
MainProgram_casenext723
MainProgram_caseend698
	; LineNumber: 572
	
; // Find out if the space we want to move to
; // is empty or if it contains anything special
	lda x
	; Calling storevariable on generic assign expression
	sta levels_buf_x
	lda y
	; Calling storevariable on generic assign expression
	sta levels_buf_y
	jsr levels_get_buffer
	; Calling storevariable on generic assign expression
	sta charat
	; LineNumber: 576
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock734
MainProgram_ConditionalTrueBlock732: ;Main true block ;keep 
	; LineNumber: 577
	; LineNumber: 580
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
	; LineNumber: 582
MainProgram_elsedoneblock734
	; LineNumber: 588
	
; // Remove old position
; // Rather than blank could also get background
; // from the level, but this is easier
	lda oldx
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda oldy
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda space_char
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 592
	
; // Keep the new position and output
; // our player
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda y
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda player_char
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 596
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 598
	jmp MainProgram_while650
MainProgram_elsedoneblock653
MainProgram_loopend655
	; LineNumber: 602
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 605
	jmp MainProgram_while550
MainProgram_elsedoneblock553
MainProgram_loopend555
	; LineNumber: 607
	; End of program
	; Ending memory block at $1210
show_start_screen_stringassignstr298		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr300		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr302		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr304		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr306		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr308		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr310		dc.b	"(C)2022"
	dc.b	0
show_start_screen_stringassignstr312		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr314		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr316		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr318		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr320		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr322		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr326		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr328		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr330		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr332		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr334		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr336		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr338		dc.b	"(C)2022"
	dc.b	0
show_start_screen_stringassignstr340		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr342		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr344		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr346		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr348		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr350		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr352		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr360		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr363		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr366		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr369		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr371		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr373		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr376		dc.b	"                    "
	dc.b	0
door_stringassignstr385		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr392		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr395		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr402		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr405		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr412		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr415		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr422		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr426		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr430		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr434		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr441		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr444		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr451		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr454		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr461		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr464		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr471		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr475		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr479		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr487		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr490		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr501		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr504		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr516		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr520		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr526		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr530		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr534		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr539		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr543		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr548		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr557		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr648		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
EndBlock1210:
