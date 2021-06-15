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
	; LineNumber: 381
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
txt_in_str	=  $04
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
levels_temp_s	=  $08
	; LineNumber: 8
levels_dest	=  $16
	; LineNumber: 8
levels_ch_index	=  $0B
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
levels_level_p	=  $0D
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
new_status	=  $10
	; LineNumber: 27
the_status	=  $12
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
txt_print_string_centered_int_shift_var97 =  $56
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
txt_print_dec_rightvarInteger_var180 =  $56
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
txt_print_dec_val_var189 =  $56
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
txt_print_dec_rightvarInteger_var193 =  $56
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
levels_draw_tile_rightvarInteger_var204 =  $56
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
levels_draw_tile_rightvarInteger_var207 =  $56
	sta levels_draw_tile_rightvarInteger_var207
	sty levels_draw_tile_rightvarInteger_var207+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var210 =  $58
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
levels_draw_level_rightvarInteger_var221 =  $56
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
levels_get_buffer_rightvarInteger_var270 =  $56
	sta levels_get_buffer_rightvarInteger_var270
	sty levels_get_buffer_rightvarInteger_var270+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var273 =  $58
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
levels_plot_buffer_rightvarInteger_var277 =  $56
	sta levels_plot_buffer_rightvarInteger_var277
	sty levels_plot_buffer_rightvarInteger_var277+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var280 =  $58
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
	; LineNumber: 101
vic20_chars
	; LineNumber: 103
	
; // Force the screen address
	; Integer constant assigning
	ldy #$10
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 103
	; Poke
	; Optimization: shift is zero
	lda #$8
	sta $900f
	; LineNumber: 105
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 110
show_start_screen
	; LineNumber: 112
	jsr txt_cls
	; LineNumber: 113
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed321
	jmp show_start_screen_ConditionalTrueBlock285
show_start_screen_localfailed321
	jmp show_start_screen_elsedoneblock287
show_start_screen_ConditionalTrueBlock285: ;Main true block ;keep 
	; LineNumber: 114
	; LineNumber: 116
	
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 117
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 118
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr323
	sta txt_in_str
	lda #>show_start_screen_stringassignstr323
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 119
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 120
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr325
	sta txt_in_str
	lda #>show_start_screen_stringassignstr325
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 121
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr327
	sta txt_in_str
	lda #>show_start_screen_stringassignstr327
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 122
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr329
	sta txt_in_str
	lda #>show_start_screen_stringassignstr329
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 123
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 124
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr331
	sta txt_in_str
	lda #>show_start_screen_stringassignstr331
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 125
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 126
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr333
	sta txt_in_str
	lda #>show_start_screen_stringassignstr333
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 127
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
	; LineNumber: 128
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 129
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
	; LineNumber: 130
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 131
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
	; LineNumber: 132
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
	; LineNumber: 133
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
	; LineNumber: 134
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
	; LineNumber: 135
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
	; LineNumber: 136
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
	; LineNumber: 137
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
	; LineNumber: 138
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
	; LineNumber: 139
show_start_screen_elsedoneblock287
	; LineNumber: 142
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 143
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 144
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr355
	sta txt_in_str
	lda #>show_start_screen_stringassignstr355
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 145
	jsr txt_print_space
	; LineNumber: 146
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 147
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 148
	jsr txt_wait_key
	; LineNumber: 151
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 156
show_end_screen
	; LineNumber: 158
	jsr txt_cls
	; LineNumber: 159
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock360
show_end_screen_ConditionalTrueBlock359: ;Main true block ;keep 
	; LineNumber: 159
	; LineNumber: 161
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr369
	sta txt_in_str
	lda #>show_end_screen_stringassignstr369
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 163
	jmp show_end_screen_elsedoneblock361
show_end_screen_elseblock360
	; LineNumber: 164
	; LineNumber: 165
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr372
	sta txt_in_str
	lda #>show_end_screen_stringassignstr372
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 166
show_end_screen_elsedoneblock361
	; LineNumber: 169
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr374
	sta txt_in_str
	lda #>show_end_screen_stringassignstr374
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 170
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 171
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr376
	sta txt_in_str
	lda #>show_end_screen_stringassignstr376
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 172
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 173
	jsr txt_wait_key
	; LineNumber: 176
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 179
display_text
	; LineNumber: 181
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 182
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 183
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr379
	sta txt_in_str
	lda #>display_text_stringassignstr379
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 184
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 185
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 186
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 188
	lda #$19
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 189
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 190
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 191
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 193
	lda #$19
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$17
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 194
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 195
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 196
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 199
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 200
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 201
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 202
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 203
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 204
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 207
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 208
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 209
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 210
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 213
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$17
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 214
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 215
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 216
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 217
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 218
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 223
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 226
	; LineNumber: 225
update_status_block381
update_status
	; LineNumber: 228
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 229
	jsr display_text
	; LineNumber: 231
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 235
door
	; LineNumber: 238
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed435
	jmp door_ConditionalTrueBlock384
door_localfailed435
	jmp door_elseblock385
door_ConditionalTrueBlock384: ;Main true block ;keep 
	; LineNumber: 239
	; LineNumber: 240
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 241
	; Assigning a string : new_status
	lda #<door_stringassignstr437
	sta new_status
	lda #>door_stringassignstr437
	sta new_status+1
	jsr update_status
	; LineNumber: 243
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock442
door_ConditionalTrueBlock440: ;Main true block ;keep 
	; LineNumber: 242
	; Assigning a string : new_status
	lda #<door_stringassignstr447
	sta new_status
	lda #>door_stringassignstr447
	sta new_status+1
	jsr update_status
door_elsedoneblock442
	; LineNumber: 244
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock452
door_ConditionalTrueBlock450: ;Main true block ;keep 
	; LineNumber: 243
	; Assigning a string : new_status
	lda #<door_stringassignstr457
	sta new_status
	lda #>door_stringassignstr457
	sta new_status+1
	jsr update_status
door_elsedoneblock452
	; LineNumber: 245
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock462
door_ConditionalTrueBlock460: ;Main true block ;keep 
	; LineNumber: 244
	; Assigning a string : new_status
	lda #<door_stringassignstr467
	sta new_status
	lda #>door_stringassignstr467
	sta new_status+1
	jsr update_status
door_elsedoneblock462
	; LineNumber: 246
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock472
door_ConditionalTrueBlock470: ;Main true block ;keep 
	; LineNumber: 247
	; LineNumber: 248
	; Assigning a string : new_status
	lda #<door_stringassignstr478
	sta new_status
	lda #>door_stringassignstr478
	sta new_status+1
	jsr update_status
	; LineNumber: 249
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd480
	inc levels_current_level+1
door_WordAdd480
	; LineNumber: 250
	; Test Inc dec D
	dec y
	; LineNumber: 251
	jsr levels_draw_level
	; LineNumber: 252
door_elsedoneblock472
	; LineNumber: 254
	jmp door_elsedoneblock386
door_elseblock385
	; LineNumber: 255
	; LineNumber: 256
	; Assigning a string : new_status
	lda #<door_stringassignstr482
	sta new_status
	lda #>door_stringassignstr482
	sta new_status+1
	jsr update_status
	; LineNumber: 259
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 260
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 261
door_elsedoneblock386
	; LineNumber: 263
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 267
combat
	; LineNumber: 270
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
	bcc combat_elseblock487
combat_ConditionalTrueBlock486: ;Main true block ;keep 
	; LineNumber: 271
	; LineNumber: 272
	; Assigning a string : new_status
	lda #<combat_stringassignstr504
	sta new_status
	lda #>combat_stringassignstr504
	sta new_status+1
	jsr update_status
	; LineNumber: 273
	jmp combat_elsedoneblock488
combat_elseblock487
	; LineNumber: 275
	; LineNumber: 277
	; Test Inc dec D
	dec health
	; LineNumber: 280
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 281
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 283
	; Assigning a string : new_status
	lda #<combat_stringassignstr507
	sta new_status
	lda #>combat_stringassignstr507
	sta new_status+1
	jsr update_status
	; LineNumber: 285
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock510
	bcs combat_elsedoneblock512
combat_ConditionalTrueBlock510: ;Main true block ;keep 
	; LineNumber: 286
	; LineNumber: 287
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 288
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 289
combat_elsedoneblock512
	; LineNumber: 291
combat_elsedoneblock488
	; LineNumber: 293
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 297
check_collisions
	; LineNumber: 300
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext517
	; LineNumber: 304
	; LineNumber: 306
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr519
	sta new_status
	lda #>check_collisions_stringassignstr519
	sta new_status+1
	jsr update_status
	; LineNumber: 307
	jsr combat
	; LineNumber: 309
	jmp check_collisions_caseend516
check_collisions_casenext517
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext521
	; LineNumber: 312
	; LineNumber: 313
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr523
	sta new_status
	lda #>check_collisions_stringassignstr523
	sta new_status+1
	jsr update_status
	; LineNumber: 314
	jmp check_collisions_caseend516
check_collisions_casenext521
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext525
	; LineNumber: 315
	jsr door
	jmp check_collisions_caseend516
check_collisions_casenext525
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext527
	; LineNumber: 318
	; LineNumber: 320
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 321
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr529
	sta new_status
	lda #>check_collisions_stringassignstr529
	sta new_status+1
	jsr update_status
	; LineNumber: 322
	jmp check_collisions_caseend516
check_collisions_casenext527
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext531
	; LineNumber: 326
	; LineNumber: 327
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 328
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr533
	sta new_status
	lda #>check_collisions_stringassignstr533
	sta new_status+1
	jsr update_status
	; LineNumber: 330
	jmp check_collisions_caseend516
check_collisions_casenext531
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext535
	; LineNumber: 332
	; LineNumber: 335
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr537
	sta new_status
	lda #>check_collisions_stringassignstr537
	sta new_status+1
	jsr update_status
	; LineNumber: 336
	jsr combat
	; LineNumber: 337
	jmp check_collisions_caseend516
check_collisions_casenext535
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext539
	; LineNumber: 340
	; LineNumber: 341
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd541
	inc gold+1
check_collisions_WordAdd541
	; LineNumber: 342
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr542
	sta new_status
	lda #>check_collisions_stringassignstr542
	sta new_status+1
	jsr update_status
	; LineNumber: 344
	jmp check_collisions_caseend516
check_collisions_casenext539
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext544
	; LineNumber: 347
	; LineNumber: 349
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr546
	sta new_status
	lda #>check_collisions_stringassignstr546
	sta new_status+1
	jsr update_status
	; LineNumber: 350
	jsr combat
	; LineNumber: 352
	jmp check_collisions_caseend516
check_collisions_casenext544
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext548
	; LineNumber: 356
	; LineNumber: 358
	jmp check_collisions_caseend516
check_collisions_casenext548
	; LineNumber: 362
	; LineNumber: 365
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 366
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 369
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 370
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr551
	sta new_status
	lda #>check_collisions_stringassignstr551
	sta new_status+1
	jsr update_status
	; LineNumber: 371
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 372
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 374
check_collisions_caseend516
	; LineNumber: 377
	rts
block1
	; LineNumber: 393
	
; // ********************************
; // C64 has it's own special characters
	; LineNumber: 394
	jsr vic20_chars
	; LineNumber: 400
MainProgram_while553
MainProgram_loopstart557
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed673
	jmp MainProgram_ConditionalTrueBlock554
MainProgram_localfailed673
	jmp MainProgram_elsedoneblock556
MainProgram_ConditionalTrueBlock554: ;Main true block ;keep 
	; LineNumber: 400
	; LineNumber: 405
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 409
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 410
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr675
	sta new_status
	lda #>MainProgram_stringassignstr675
	sta new_status+1
	jsr update_status
	; LineNumber: 411
	jsr display_text
	; LineNumber: 415
MainProgram_while677
MainProgram_loopstart681
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed735
	jmp MainProgram_ConditionalTrueBlock678
MainProgram_localfailed735
	jmp MainProgram_elsedoneblock680
MainProgram_ConditionalTrueBlock678: ;Main true block ;keep 
	; LineNumber: 416
	; LineNumber: 421
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 422
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 425
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 428
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext738
	; LineNumber: 430
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock743
MainProgram_ConditionalTrueBlock741: ;Main true block ;keep 
	; LineNumber: 430
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock743
	jmp MainProgram_caseend737
MainProgram_casenext738
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext746
	; LineNumber: 431
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock751
MainProgram_ConditionalTrueBlock749: ;Main true block ;keep 
	; LineNumber: 431
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock751
	jmp MainProgram_caseend737
MainProgram_casenext746
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext754
	; LineNumber: 432
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock759
MainProgram_ConditionalTrueBlock757: ;Main true block ;keep 
	; LineNumber: 432
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock759
	jmp MainProgram_caseend737
MainProgram_casenext754
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext762
	; LineNumber: 433
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock767
MainProgram_ConditionalTrueBlock765: ;Main true block ;keep 
	; LineNumber: 433
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock767
MainProgram_casenext762
MainProgram_caseend737
	; LineNumber: 441
	
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
	; LineNumber: 445
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock773
MainProgram_ConditionalTrueBlock771: ;Main true block ;keep 
	; LineNumber: 446
	; LineNumber: 449
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock785
MainProgram_ConditionalTrueBlock783: ;Main true block ;keep 
	; LineNumber: 448
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock785
	; LineNumber: 453
MainProgram_elsedoneblock773
	; LineNumber: 459
	
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
	; LineNumber: 463
	
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
	; LineNumber: 467
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 469
	jmp MainProgram_while677
MainProgram_elsedoneblock680
MainProgram_loopend682
	; LineNumber: 473
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 476
	jmp MainProgram_while553
MainProgram_elsedoneblock556
MainProgram_loopend558
	; LineNumber: 478
	; End of program
	; Ending memory block
EndBlock1210
show_start_screen_stringassignstr289		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr291		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr293		dc.b	"A DUNGEON CRAWL ADVENTURE"
	dc.b	0
show_start_screen_stringassignstr295		dc.b	"FOR COMMODORE PET AND C64"
	dc.b	0
show_start_screen_stringassignstr297		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr299		dc.b	"CHRIS GARRETT / RETROGAMECODERS"
	dc.b	0
show_start_screen_stringassignstr301		dc.b	"(C)2021"
	dc.b	0
show_start_screen_stringassignstr303		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr305		dc.b	"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr307		dc.b	"@ = YOU"
	dc.b	0
show_start_screen_stringassignstr309		dc.b	"k = KEY"
	dc.b	0
show_start_screen_stringassignstr311		dc.b	"c = DOOR"
	dc.b	0
show_start_screen_stringassignstr313		dc.b	"s = HEALTH"
	dc.b	0
show_start_screen_stringassignstr315		dc.b	"x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr317		dc.b	"z = GEM"
	dc.b	0
show_start_screen_stringassignstr319		dc.b	"rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr323		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr325		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr327		dc.b	"A DUNGEON CRAWL ADVENTURE"
	dc.b	0
show_start_screen_stringassignstr329		dc.b	"FOR COMMODORE PET AND C64"
	dc.b	0
show_start_screen_stringassignstr331		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr333		dc.b	"CHRIS GARRETT / RETROGAMECODERS"
	dc.b	0
show_start_screen_stringassignstr335		dc.b	"(C)2021"
	dc.b	0
show_start_screen_stringassignstr337		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr339		dc.b	"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr341		dc.b	"@ = YOU"
	dc.b	0
show_start_screen_stringassignstr343		dc.b	"k = KEY"
	dc.b	0
show_start_screen_stringassignstr345		dc.b	"c = DOOR"
	dc.b	0
show_start_screen_stringassignstr347		dc.b	"s = HEALTH"
	dc.b	0
show_start_screen_stringassignstr349		dc.b	"x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr351		dc.b	"z = GEM"
	dc.b	0
show_start_screen_stringassignstr353		dc.b	"rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr355		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
show_end_screen_stringassignstr363		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr366		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr369		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr372		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr374		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr376		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr379		dc.b	"                    "
	dc.b	0
door_stringassignstr388		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr395		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr398		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr405		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr408		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr415		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr418		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr425		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr429		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr433		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr437		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr444		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr447		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr454		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr457		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr464		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr467		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr474		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr478		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr482		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr490		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr493		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr504		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr507		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr519		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr523		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr529		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr533		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr537		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr542		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr546		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr551		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr560		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr675		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
