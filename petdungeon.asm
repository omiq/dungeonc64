 processor 6502
	org $1201
	; Starting new memory block at $1201
StartBlock1201
	.byte $b ; lo byte of next line
	.byte $12 ; hi byte of next line
	.byte $0a, $00 ; line 10 (lo, hi)
	.byte $9e, $20 ; SYS token and a space
	.byte   $34,$36,$32,$34
	.byte $00, $00, $00 ; end of program
	; Ending memory block
EndBlock1201
	org $1210
	; Starting new memory block at $1210
StartBlock1210
dungeon64
	; LineNumber: 398
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
txt_in_str	=   $04
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
levels_temp_s	=   $08
	; LineNumber: 8
levels_dest	=   $16
	; LineNumber: 8
levels_ch_index	=   $0B
	; LineNumber: 12
levels_screen_buffer	dc.b	 
	org levels_screen_buffer+1000
	; LineNumber: 14
levels_tiles
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/tiles.bin"
	; LineNumber: 16
levels_level
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map.bin"
	; LineNumber: 17
levels_level_p	=   $0D
	; LineNumber: 21
player_char	dc.b	$00
	; LineNumber: 22
key_press	dc.b	$00
	; LineNumber: 23
charat	dc.b	0
	; LineNumber: 24
game_won	dc.b	0
	; LineNumber: 24
game_running	dc.b	0
	; LineNumber: 25
x	dc.b	0
	; LineNumber: 25
y	dc.b	0
	; LineNumber: 25
oldx	dc.b	0
	; LineNumber: 25
oldy	dc.b	0
	; LineNumber: 27
new_status	=   $10
	; LineNumber: 27
the_status	=   $12
	; LineNumber: 30
keys	dc.b	$00
	; LineNumber: 31
gold	dc.w	$00
	; LineNumber: 32
health	dc.b	$0c
	; LineNumber: 35
attack	dc.b	$0c
	; LineNumber: 36
defense	dc.b	$0c
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init16x8div
	;    Procedure type : Built-in function
	;    Requires initialization : no
initdiv16x8_divisor = $4c     ;$59 used for hi-byte
initdiv16x8_dividend = $4e	  ;$fc used for hi-byte
initdiv16x8_remainder = $50	  ;$fe used for hi-byte
initdiv16x8_result = $4e ;save memory by reusing divident to store the result
divide16x8	lda #0	        ;preset remainder to 0
	sta initdiv16x8_remainder
	sta initdiv16x8_remainder+1
	ldx #16	        ;repeat for each bit: ...
divloop16	asl initdiv16x8_dividend	;dividend lb & hb*2, msb -> Carry
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
skip16	dex
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
mul16x8_enterLoop  ; accumulating multiply entry point (enter with .A=lo, .Y=hi)
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
div8x8_loop1 rol div8x8_d
	rol
	cmp div8x8_c
	bcc div8x8_loop2
	sbc div8x8_c
div8x8_loop2 dex
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
	; LineNumber: 475
	; LineNumber: 475
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
	; LineNumber: 634
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
	; LineNumber: 651
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
	; LineNumber: 663
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
txt_print_string_centered_int_shift_var97 =   $56
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
txt_print_dec_rightvarInteger_var180 =   $56
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
txt_print_dec_val_var189 =   $56
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
txt_print_dec_rightvarInteger_var193 =   $56
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
	; LineNumber: 23
	; LineNumber: 22
	; LineNumber: 22
	; LineNumber: 22
levels_draw_tile_block201
levels_draw_tile
	; LineNumber: 26
	
; // Source
	; Generic 16 bit op
	lda #<levels_tiles
	ldy #>levels_tiles
levels_draw_tile_rightvarInteger_var204 =   $56
	sta levels_draw_tile_rightvarInteger_var204
	sty levels_draw_tile_rightvarInteger_var204+1
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy #0
	lda levels_tile_no
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$9
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var204
levels_draw_tile_wordAdd202
	sta levels_draw_tile_rightvarInteger_var204
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var204+1
	tay
	lda levels_draw_tile_rightvarInteger_var204
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 29
	
; // Dest
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
levels_draw_tile_rightvarInteger_var207 =   $56
	sta levels_draw_tile_rightvarInteger_var207
	sty levels_draw_tile_rightvarInteger_var207+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var210 =   $58
	sta levels_draw_tile_rightvarInteger_var210
	sty levels_draw_tile_rightvarInteger_var210+1
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
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
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$28
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var210
levels_draw_tile_wordAdd208
	sta levels_draw_tile_rightvarInteger_var210
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var210+1
	tay
	lda levels_draw_tile_rightvarInteger_var210
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var207
levels_draw_tile_wordAdd205
	sta levels_draw_tile_rightvarInteger_var207
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var207+1
	tay
	lda levels_draw_tile_rightvarInteger_var207
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 30
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy211
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy211
	; LineNumber: 32
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd212
	inc levels_temp_s+1
levels_draw_tile_WordAdd212
	; LineNumber: 33
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd213
	inc levels_dest+1
levels_draw_tile_WordAdd213
	; LineNumber: 34
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy214
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy214
	; LineNumber: 36
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd215
	inc levels_dest+1
levels_draw_tile_WordAdd215
	; LineNumber: 37
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd216
	inc levels_temp_s+1
levels_draw_tile_WordAdd216
	; LineNumber: 38
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy217
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy217
	; LineNumber: 40
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 48
levels_draw_level
	; LineNumber: 51
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 52
	; Generic 16 bit op
	lda #<levels_level
	ldy #>levels_level
levels_draw_level_rightvarInteger_var221 =   $56
	sta levels_draw_level_rightvarInteger_var221
	sty levels_draw_level_rightvarInteger_var221+1
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy levels_current_level+1
	lda levels_current_level
	sta mul16x8_num1
	sty mul16x8_num1Hi
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$3c
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_draw_level_rightvarInteger_var221
levels_draw_level_wordAdd219
	sta levels_draw_level_rightvarInteger_var221
	; High-bit binop
	tya
	adc levels_draw_level_rightvarInteger_var221+1
	tay
	lda levels_draw_level_rightvarInteger_var221
	sta levels_level_p
	sty levels_level_p+1
	; LineNumber: 63
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop222
	; LineNumber: 56
	; LineNumber: 61
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop241
	; LineNumber: 58
	; LineNumber: 59
	; Load pointer array
	; 8 bit binop
	; Add/sub where right value is constant number
	; Right is PURE NUMERIC : Is word =0
	; 8 bit mul
	ldx levels_t_y ; optimized, look out for bugs
	; Load right hand side
	lda #$a
	jsr multiply_eightbit
	txa
	clc
	adc levels_t_x
	 ; end add / sub var with constant
	tay
	lda (levels_level_p),y
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	; LineNumber: 60
	jsr levels_draw_tile
	; LineNumber: 61
levels_draw_level_forloopcounter243
levels_draw_level_loopstart244
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda #$a
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop241
levels_draw_level_loopdone252: ;keep
levels_draw_level_forloopend242
levels_draw_level_loopend245
	; LineNumber: 62
levels_draw_level_forloopcounter224
levels_draw_level_loopstart225
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_y
	lda #$6
	cmp levels_t_y ;keep
	bne levels_draw_level_forloop222
levels_draw_level_loopdone253: ;keep
levels_draw_level_forloopend223
levels_draw_level_loopend226
	; LineNumber: 65
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 69
levels_refresh_screen
	; LineNumber: 72
	
; //CopyFullScreen(#screen_buffer,SCREEN_CHAR_LOC);
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 81
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop255
	; LineNumber: 77
	; LineNumber: 78
	
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
	; LineNumber: 79
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy264
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy264
	; LineNumber: 80
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd265
	inc levels_temp_s+1
levels_refresh_screen_WordAdd265
	; LineNumber: 81
levels_refresh_screen_forloopcounter257
levels_refresh_screen_loopstart258
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop255
levels_refresh_screen_loopdone266: ;keep
levels_refresh_screen_forloopend256
levels_refresh_screen_loopend259
	; LineNumber: 85
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 90
	; LineNumber: 89
levels_buf_x	dc.b	0
	; LineNumber: 89
levels_buf_y	dc.b	0
levels_get_buffer_block267
levels_get_buffer
	; LineNumber: 92
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var270 =   $56
	sta levels_get_buffer_rightvarInteger_var270
	sty levels_get_buffer_rightvarInteger_var270+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var273 =   $58
	sta levels_get_buffer_rightvarInteger_var273
	sty levels_get_buffer_rightvarInteger_var273+1
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy #0
	lda levels_buf_y
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$28
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var273
levels_get_buffer_wordAdd271
	sta levels_get_buffer_rightvarInteger_var273
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var273+1
	tay
	lda levels_get_buffer_rightvarInteger_var273
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var270
levels_get_buffer_wordAdd268
	sta levels_get_buffer_rightvarInteger_var270
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var270+1
	tay
	lda levels_get_buffer_rightvarInteger_var270
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 94
	; LineNumber: 95
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 100
	; LineNumber: 99
levels_plot_x	dc.b	0
	; LineNumber: 99
levels_plot_y	dc.b	0
	; LineNumber: 99
levels_plot_ch	dc.b	0
levels_plot_buffer_block274
levels_plot_buffer
	; LineNumber: 102
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var277 =   $56
	sta levels_plot_buffer_rightvarInteger_var277
	sty levels_plot_buffer_rightvarInteger_var277+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var280 =   $58
	sta levels_plot_buffer_rightvarInteger_var280
	sty levels_plot_buffer_rightvarInteger_var280+1
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy #0
	lda levels_plot_y
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$28
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var280
levels_plot_buffer_wordAdd278
	sta levels_plot_buffer_rightvarInteger_var280
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var280+1
	tay
	lda levels_plot_buffer_rightvarInteger_var280
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var277
levels_plot_buffer_wordAdd275
	sta levels_plot_buffer_rightvarInteger_var277
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var277+1
	tay
	lda levels_plot_buffer_rightvarInteger_var277
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 103
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 105
	rts
	
; //player inventory/stats
; // ********************************
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 43
init
	; LineNumber: 46
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 47
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 50
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 53
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 55
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 56
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 59
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 60
	jsr levels_draw_level
	; LineNumber: 63
	
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
	; LineNumber: 66
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 67
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
	; LineNumber: 107
	; LineNumber: 103
sw	dc.w	$1e
	; LineNumber: 104
sh	dc.w	$18
	; LineNumber: 105
ox	dc.w	$fffb
	; LineNumber: 106
oy	dc.w	$ffed
vic20_chars_block282
vic20_chars
	; LineNumber: 110
	
; // Force the screen address
; //txt::temp_address_p:=$1000;
	; Poke
	; Optimization: shift is zero
	lda #$8
	sta $900f
	; LineNumber: 113
	; Poke
	; Optimization: shift is zero
	lda #$f0
	sta $9005
	; LineNumber: 114
	
; // set screen map: $1c00
	; Poke
	; Optimization: shift is zero
	; integer assignment NodeVar
	lda sw
	sta $9002
	; LineNumber: 115
	
; // width
	; Poke
	; Optimization: shift is zero
	; Generic 16 bit op
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy sh+1
	lda sh
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$2
	sta mul16x8_num2
	jsr mul16x8_procedure
vic20_chars_rightvarInteger_var285 =   $56
	sta vic20_chars_rightvarInteger_var285
	sty vic20_chars_rightvarInteger_var285+1
	; Generic 16 bit op
	ldy #0
	lda #$80
vic20_chars_rightvarInteger_var288 =   $58
	sta vic20_chars_rightvarInteger_var288
	sty vic20_chars_rightvarInteger_var288+1
	; Peek
	lda $9003 + $0;keep
	; Low bit binop:
	and vic20_chars_rightvarInteger_var288
vic20_chars_wordAdd286
	sta vic20_chars_rightvarInteger_var288
	; High-bit binop
	tya
	and vic20_chars_rightvarInteger_var288+1
	tay
	lda vic20_chars_rightvarInteger_var288
	; Low bit binop:
	ora vic20_chars_rightvarInteger_var285
vic20_chars_wordAdd283
	sta vic20_chars_rightvarInteger_var285
	; High-bit binop
	tya
	ora vic20_chars_rightvarInteger_var285+1
	tay
	lda vic20_chars_rightvarInteger_var285
	sta $9003
	; LineNumber: 116
	
; // height
	; Poke
	; Optimization: shift is zero
	; Generic 16 bit op
	; integer assignment NodeVar
	ldy ox+1 ; keep
	lda ox
vic20_chars_rightvarInteger_var291 =   $56
	sta vic20_chars_rightvarInteger_var291
	sty vic20_chars_rightvarInteger_var291+1
	; Peek
	lda $9000 + $0;keep
	; Low bit binop:
	clc
	adc vic20_chars_rightvarInteger_var291
vic20_chars_wordAdd289
	sta vic20_chars_rightvarInteger_var291
	; High-bit binop
	tya
	adc vic20_chars_rightvarInteger_var291+1
	tay
	lda vic20_chars_rightvarInteger_var291
	sta $9000
	; LineNumber: 117
	
; // picture origin x offset
	; Poke
	; Optimization: shift is zero
	; Generic 16 bit op
	; integer assignment NodeVar
	ldy oy+1 ; keep
	lda oy
vic20_chars_rightvarInteger_var294 =   $56
	sta vic20_chars_rightvarInteger_var294
	sty vic20_chars_rightvarInteger_var294+1
	; Peek
	lda $9001 + $0;keep
	; Low bit binop:
	clc
	adc vic20_chars_rightvarInteger_var294
vic20_chars_wordAdd292
	sta vic20_chars_rightvarInteger_var294
	; High-bit binop
	tya
	adc vic20_chars_rightvarInteger_var294+1
	tay
	lda vic20_chars_rightvarInteger_var294
	sta $9001
	; LineNumber: 122
	rts
	
; // picture origin y offset		
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 127
show_start_screen
	; LineNumber: 129
	jsr txt_cls
	; LineNumber: 130
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed333
	jmp show_start_screen_ConditionalTrueBlock297
show_start_screen_localfailed333
	jmp show_start_screen_elsedoneblock299
show_start_screen_ConditionalTrueBlock297: ;Main true block ;keep 
	; LineNumber: 131
	; LineNumber: 133
	
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 134
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 135
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr335
	sta txt_in_str
	lda #>show_start_screen_stringassignstr335
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 136
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 137
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr337
	sta txt_in_str
	lda #>show_start_screen_stringassignstr337
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 138
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr339
	sta txt_in_str
	lda #>show_start_screen_stringassignstr339
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 139
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr341
	sta txt_in_str
	lda #>show_start_screen_stringassignstr341
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 140
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 141
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr343
	sta txt_in_str
	lda #>show_start_screen_stringassignstr343
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 142
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 143
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr345
	sta txt_in_str
	lda #>show_start_screen_stringassignstr345
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 144
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr347
	sta txt_in_str
	lda #>show_start_screen_stringassignstr347
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 145
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 146
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr349
	sta txt_in_str
	lda #>show_start_screen_stringassignstr349
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 147
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 148
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr351
	sta txt_in_str
	lda #>show_start_screen_stringassignstr351
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 149
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr353
	sta txt_in_str
	lda #>show_start_screen_stringassignstr353
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 150
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr355
	sta txt_in_str
	lda #>show_start_screen_stringassignstr355
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 151
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr357
	sta txt_in_str
	lda #>show_start_screen_stringassignstr357
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 152
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr359
	sta txt_in_str
	lda #>show_start_screen_stringassignstr359
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 153
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr361
	sta txt_in_str
	lda #>show_start_screen_stringassignstr361
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 154
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr363
	sta txt_in_str
	lda #>show_start_screen_stringassignstr363
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 155
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr365
	sta txt_in_str
	lda #>show_start_screen_stringassignstr365
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 156
show_start_screen_elsedoneblock299
	; LineNumber: 159
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 160
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 161
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr367
	sta txt_in_str
	lda #>show_start_screen_stringassignstr367
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 162
	jsr txt_print_space
	; LineNumber: 163
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 164
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 165
	jsr txt_wait_key
	; LineNumber: 168
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 173
show_end_screen
	; LineNumber: 175
	jsr txt_cls
	; LineNumber: 176
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock372
show_end_screen_ConditionalTrueBlock371: ;Main true block ;keep 
	; LineNumber: 176
	; LineNumber: 178
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr381
	sta txt_in_str
	lda #>show_end_screen_stringassignstr381
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 180
	jmp show_end_screen_elsedoneblock373
show_end_screen_elseblock372
	; LineNumber: 181
	; LineNumber: 182
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr384
	sta txt_in_str
	lda #>show_end_screen_stringassignstr384
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 183
show_end_screen_elsedoneblock373
	; LineNumber: 186
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr386
	sta txt_in_str
	lda #>show_end_screen_stringassignstr386
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 187
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 188
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr388
	sta txt_in_str
	lda #>show_end_screen_stringassignstr388
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 189
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 190
	jsr txt_wait_key
	; LineNumber: 193
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 196
display_text
	; LineNumber: 198
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 199
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 200
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr391
	sta txt_in_str
	lda #>display_text_stringassignstr391
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 201
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 202
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 203
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 205
	lda #$19
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 206
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 207
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 208
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 210
	lda #$19
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$17
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 211
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 212
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 213
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 216
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 217
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 218
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 219
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 220
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 221
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 224
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 225
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 226
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 227
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 230
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$17
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 231
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 232
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 233
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 234
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 235
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 240
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 243
	; LineNumber: 242
update_status_block393
update_status
	; LineNumber: 245
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 246
	jsr display_text
	; LineNumber: 248
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 252
door
	; LineNumber: 255
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed447
	jmp door_ConditionalTrueBlock396
door_localfailed447
	jmp door_elseblock397
door_ConditionalTrueBlock396: ;Main true block ;keep 
	; LineNumber: 256
	; LineNumber: 257
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 258
	; Assigning a string : new_status
	lda #<door_stringassignstr449
	sta new_status
	lda #>door_stringassignstr449
	sta new_status+1
	jsr update_status
	; LineNumber: 260
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock454
door_ConditionalTrueBlock452: ;Main true block ;keep 
	; LineNumber: 259
	; Assigning a string : new_status
	lda #<door_stringassignstr459
	sta new_status
	lda #>door_stringassignstr459
	sta new_status+1
	jsr update_status
door_elsedoneblock454
	; LineNumber: 261
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock464
door_ConditionalTrueBlock462: ;Main true block ;keep 
	; LineNumber: 260
	; Assigning a string : new_status
	lda #<door_stringassignstr469
	sta new_status
	lda #>door_stringassignstr469
	sta new_status+1
	jsr update_status
door_elsedoneblock464
	; LineNumber: 262
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock474
door_ConditionalTrueBlock472: ;Main true block ;keep 
	; LineNumber: 261
	; Assigning a string : new_status
	lda #<door_stringassignstr479
	sta new_status
	lda #>door_stringassignstr479
	sta new_status+1
	jsr update_status
door_elsedoneblock474
	; LineNumber: 263
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock484
door_ConditionalTrueBlock482: ;Main true block ;keep 
	; LineNumber: 264
	; LineNumber: 265
	; Assigning a string : new_status
	lda #<door_stringassignstr490
	sta new_status
	lda #>door_stringassignstr490
	sta new_status+1
	jsr update_status
	; LineNumber: 266
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd492
	inc levels_current_level+1
door_WordAdd492
	; LineNumber: 267
	; Test Inc dec D
	dec y
	; LineNumber: 268
	jsr levels_draw_level
	; LineNumber: 269
door_elsedoneblock484
	; LineNumber: 271
	jmp door_elsedoneblock398
door_elseblock397
	; LineNumber: 272
	; LineNumber: 273
	; Assigning a string : new_status
	lda #<door_stringassignstr494
	sta new_status
	lda #>door_stringassignstr494
	sta new_status+1
	jsr update_status
	; LineNumber: 276
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 277
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 278
door_elsedoneblock398
	; LineNumber: 280
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 284
combat
	; LineNumber: 287
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
	bcc combat_elseblock499
combat_ConditionalTrueBlock498: ;Main true block ;keep 
	; LineNumber: 288
	; LineNumber: 289
	; Assigning a string : new_status
	lda #<combat_stringassignstr516
	sta new_status
	lda #>combat_stringassignstr516
	sta new_status+1
	jsr update_status
	; LineNumber: 290
	jmp combat_elsedoneblock500
combat_elseblock499
	; LineNumber: 292
	; LineNumber: 294
	; Test Inc dec D
	dec health
	; LineNumber: 297
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 298
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 300
	; Assigning a string : new_status
	lda #<combat_stringassignstr519
	sta new_status
	lda #>combat_stringassignstr519
	sta new_status+1
	jsr update_status
	; LineNumber: 302
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock522
	bcs combat_elsedoneblock524
combat_ConditionalTrueBlock522: ;Main true block ;keep 
	; LineNumber: 303
	; LineNumber: 304
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 305
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 306
combat_elsedoneblock524
	; LineNumber: 308
combat_elsedoneblock500
	; LineNumber: 310
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 314
check_collisions
	; LineNumber: 317
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext529
	; LineNumber: 321
	; LineNumber: 323
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr531
	sta new_status
	lda #>check_collisions_stringassignstr531
	sta new_status+1
	jsr update_status
	; LineNumber: 324
	jsr combat
	; LineNumber: 326
	jmp check_collisions_caseend528
check_collisions_casenext529
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext533
	; LineNumber: 329
	; LineNumber: 330
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr535
	sta new_status
	lda #>check_collisions_stringassignstr535
	sta new_status+1
	jsr update_status
	; LineNumber: 331
	jmp check_collisions_caseend528
check_collisions_casenext533
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext537
	; LineNumber: 332
	jsr door
	jmp check_collisions_caseend528
check_collisions_casenext537
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext539
	; LineNumber: 335
	; LineNumber: 337
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 338
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr541
	sta new_status
	lda #>check_collisions_stringassignstr541
	sta new_status+1
	jsr update_status
	; LineNumber: 339
	jmp check_collisions_caseend528
check_collisions_casenext539
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext543
	; LineNumber: 343
	; LineNumber: 344
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 345
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr545
	sta new_status
	lda #>check_collisions_stringassignstr545
	sta new_status+1
	jsr update_status
	; LineNumber: 347
	jmp check_collisions_caseend528
check_collisions_casenext543
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext547
	; LineNumber: 349
	; LineNumber: 352
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr549
	sta new_status
	lda #>check_collisions_stringassignstr549
	sta new_status+1
	jsr update_status
	; LineNumber: 353
	jsr combat
	; LineNumber: 354
	jmp check_collisions_caseend528
check_collisions_casenext547
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext551
	; LineNumber: 357
	; LineNumber: 358
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd553
	inc gold+1
check_collisions_WordAdd553
	; LineNumber: 359
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr554
	sta new_status
	lda #>check_collisions_stringassignstr554
	sta new_status+1
	jsr update_status
	; LineNumber: 361
	jmp check_collisions_caseend528
check_collisions_casenext551
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext556
	; LineNumber: 364
	; LineNumber: 366
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr558
	sta new_status
	lda #>check_collisions_stringassignstr558
	sta new_status+1
	jsr update_status
	; LineNumber: 367
	jsr combat
	; LineNumber: 369
	jmp check_collisions_caseend528
check_collisions_casenext556
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext560
	; LineNumber: 373
	; LineNumber: 375
	jmp check_collisions_caseend528
check_collisions_casenext560
	; LineNumber: 379
	; LineNumber: 382
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 383
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 386
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 387
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr563
	sta new_status
	lda #>check_collisions_stringassignstr563
	sta new_status+1
	jsr update_status
	; LineNumber: 388
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 389
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 391
check_collisions_caseend528
	; LineNumber: 394
	rts
block1
	; LineNumber: 410
	
; // ********************************
; // C64 has it's own special characters
	; LineNumber: 411
	jsr vic20_chars
	; LineNumber: 417
MainProgram_while565
MainProgram_loopstart569
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed685
	jmp MainProgram_ConditionalTrueBlock566
MainProgram_localfailed685
	jmp MainProgram_elsedoneblock568
MainProgram_ConditionalTrueBlock566: ;Main true block ;keep 
	; LineNumber: 417
	; LineNumber: 422
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 426
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 427
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr687
	sta new_status
	lda #>MainProgram_stringassignstr687
	sta new_status+1
	jsr update_status
	; LineNumber: 428
	jsr display_text
	; LineNumber: 432
MainProgram_while689
MainProgram_loopstart693
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed747
	jmp MainProgram_ConditionalTrueBlock690
MainProgram_localfailed747
	jmp MainProgram_elsedoneblock692
MainProgram_ConditionalTrueBlock690: ;Main true block ;keep 
	; LineNumber: 433
	; LineNumber: 438
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 439
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 442
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 445
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext750
	; LineNumber: 447
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock755
MainProgram_ConditionalTrueBlock753: ;Main true block ;keep 
	; LineNumber: 447
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock755
	jmp MainProgram_caseend749
MainProgram_casenext750
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext758
	; LineNumber: 448
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock763
MainProgram_ConditionalTrueBlock761: ;Main true block ;keep 
	; LineNumber: 448
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock763
	jmp MainProgram_caseend749
MainProgram_casenext758
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext766
	; LineNumber: 449
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock771
MainProgram_ConditionalTrueBlock769: ;Main true block ;keep 
	; LineNumber: 449
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock771
	jmp MainProgram_caseend749
MainProgram_casenext766
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext774
	; LineNumber: 450
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock779
MainProgram_ConditionalTrueBlock777: ;Main true block ;keep 
	; LineNumber: 450
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock779
MainProgram_casenext774
MainProgram_caseend749
	; LineNumber: 458
	
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
	; LineNumber: 462
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock785
MainProgram_ConditionalTrueBlock783: ;Main true block ;keep 
	; LineNumber: 463
	; LineNumber: 466
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock797
MainProgram_ConditionalTrueBlock795: ;Main true block ;keep 
	; LineNumber: 465
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock797
	; LineNumber: 470
MainProgram_elsedoneblock785
	; LineNumber: 476
	
; // Remove old position
; // Rather than blank could also get background
; // from the level, but this is easier
	lda oldx
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda oldy
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$20
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 480
	
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
	; LineNumber: 484
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 486
	jmp MainProgram_while689
MainProgram_elsedoneblock692
MainProgram_loopend694
	; LineNumber: 490
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 493
	jmp MainProgram_while565
MainProgram_elsedoneblock568
MainProgram_loopend570
	; LineNumber: 495
	; End of program
	; Ending memory block
EndBlock1210
show_start_screen_stringassignstr301		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr303		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr305		dc.b	"A DUNGEON CRAWL ADVENTURE"
	dc.b	0
show_start_screen_stringassignstr307		dc.b	"FOR COMMODORE PET AND C64"
	dc.b	0
show_start_screen_stringassignstr309		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr311		dc.b	"CHRIS GARRETT / RETROGAMECODERS"
	dc.b	0
show_start_screen_stringassignstr313		dc.b	"(C)2021"
	dc.b	0
show_start_screen_stringassignstr315		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr317		dc.b	"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr319		dc.b	"@ = YOU"
	dc.b	0
show_start_screen_stringassignstr321		dc.b	"k = KEY"
	dc.b	0
show_start_screen_stringassignstr323		dc.b	"c = DOOR"
	dc.b	0
show_start_screen_stringassignstr325		dc.b	"s = HEALTH"
	dc.b	0
show_start_screen_stringassignstr327		dc.b	"x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr329		dc.b	"z = GEM"
	dc.b	0
show_start_screen_stringassignstr331		dc.b	"rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr335		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr337		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr339		dc.b	"A DUNGEON CRAWL ADVENTURE"
	dc.b	0
show_start_screen_stringassignstr341		dc.b	"FOR COMMODORE PET AND C64"
	dc.b	0
show_start_screen_stringassignstr343		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr345		dc.b	"CHRIS GARRETT / RETROGAMECODERS"
	dc.b	0
show_start_screen_stringassignstr347		dc.b	"(C)2021"
	dc.b	0
show_start_screen_stringassignstr349		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr351		dc.b	"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr353		dc.b	"@ = YOU"
	dc.b	0
show_start_screen_stringassignstr355		dc.b	"k = KEY"
	dc.b	0
show_start_screen_stringassignstr357		dc.b	"c = DOOR"
	dc.b	0
show_start_screen_stringassignstr359		dc.b	"s = HEALTH"
	dc.b	0
show_start_screen_stringassignstr361		dc.b	"x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr363		dc.b	"z = GEM"
	dc.b	0
show_start_screen_stringassignstr365		dc.b	"rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr367		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
show_end_screen_stringassignstr375		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr378		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr381		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr384		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr386		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr388		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr391		dc.b	"                    "
	dc.b	0
door_stringassignstr400		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr407		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr410		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr417		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr420		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr427		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr430		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr437		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr441		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr445		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr449		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr456		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr459		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr466		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr469		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr476		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr479		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr486		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr490		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr494		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr502		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr505		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr516		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr519		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr531		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr535		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr541		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr545		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr549		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr554		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr558		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr563		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr572		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr687		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
