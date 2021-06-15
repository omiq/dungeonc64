 processor 6502
	org $801
	; Starting new memory block at $801
StartBlock801
	.byte $b ; lo byte of next line
	.byte $8 ; hi byte of next line
	.byte $0a, $00 ; line 10 (lo, hi)
	.byte $9e, $20 ; SYS token and a space
	.byte   $32,$30,$36,$34
	.byte $00, $00, $00 ; end of program
	; Ending memory block
EndBlock801
	org $810
	; Starting new memory block at $810
StartBlock810
dungeon64
	; LineNumber: 449
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
	; LineNumber: 22
levels_tiles
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map - Tiles.bin"
	; LineNumber: 31
levels_level
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map.bin"
	; LineNumber: 32
levels_level_p	= $0D
	; LineNumber: 25
	; LineNumber: 31
player_char	dc.b	$00
	; LineNumber: 32
space_char	dc.b	$20
	; LineNumber: 34
key_press	dc.b	$00
	; LineNumber: 35
charat	dc.b	0
	; LineNumber: 36
game_won	dc.b	0
	; LineNumber: 36
game_running	dc.b	0
	; LineNumber: 37
x	dc.b	0
	; LineNumber: 37
y	dc.b	0
	; LineNumber: 37
oldx	dc.b	0
	; LineNumber: 37
oldy	dc.b	0
	; LineNumber: 39
new_status	= $10
	; LineNumber: 39
the_status	= $12
	; LineNumber: 39
p	= $22
	; LineNumber: 42
keys	dc.b	$00
	; LineNumber: 43
gold	dc.w	$00
	; LineNumber: 44
health	dc.b	$0c
	; LineNumber: 47
attack	dc.b	$0c
	; LineNumber: 48
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
	adc #40
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
	eor $dc04
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
	; LineNumber: 278
	; LineNumber: 277
txt_y	dc.b	0
txt_DefineScreen_block6
txt_DefineScreen
	; LineNumber: 280
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
	; LineNumber: 281
	; LineNumber: 282
	rts
	; LineNumber: 283
txt_DefineScreen_elsedoneblock10
	; LineNumber: 286
	; Binary clause INTEGER: EQUALS
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_address_p+1   ; compare high bytes
	cmp #$00 ;keep
	bne txt_DefineScreen_elsedoneblock18
	lda txt_temp_address_p
	cmp #$00 ;keep
	bne txt_DefineScreen_elsedoneblock18
	jmp txt_DefineScreen_ConditionalTrueBlock16
txt_DefineScreen_ConditionalTrueBlock16: ;Main true block ;keep 
	; LineNumber: 287
	; LineNumber: 289
	
; // Where is screen ram right now?
; // Custom
	; Integer constant assigning
	ldy #$04
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 290
txt_DefineScreen_elsedoneblock18
	; LineNumber: 299
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop21
	; LineNumber: 294
	; LineNumber: 295
	
; // Fill the lookup table with screen positions		
	ldx #$28 ; optimized, look out for bugs
	lda #$20
txt_DefineScreen_fill30
	; integer assignment NodeVar
	ldy txt_temp_address_p+1 ; keep
	lda txt_temp_address_p,x
	dex
	bpl txt_DefineScreen_fill30
	; LineNumber: 296
	; integer assignment NodeVar
	lda txt_temp_address_p
	; Calling storevariable on generic assign expression
	pha
	lda txt_y
	asl
	tax
	pla
	sta txt_ytab,x
	tya
	sta txt_ytab+1,x
	; LineNumber: 297
	lda txt_temp_address_p
	clc
	adc #$28
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd31
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd31
	; LineNumber: 298
txt_DefineScreen_forloopcounter23
txt_DefineScreen_loopstart24
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop21
txt_DefineScreen_loopdone32: ;keep
txt_DefineScreen_forloopend22
txt_DefineScreen_loopend25
	; LineNumber: 300
	
; // Fill colour white
	; Clear screen with offset
	lda #$1
	ldx #$fa
txt_DefineScreen_clearloop33
	dex
	sta $0000+$d800,x
	sta $00fa+$d800,x
	sta $01f4+$d800,x
	sta $02ee+$d800,x
	bne txt_DefineScreen_clearloop33
	; LineNumber: 303
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 308
	; LineNumber: 305
txt__text_x	dc.b	0
	; LineNumber: 305
txt__text_y	dc.b	0
txt_move_to_block34
txt_move_to
	; LineNumber: 309
	; ****** Inline assembler section
	clc
	; LineNumber: 310
	; Assigning to register
	; Assigning register : _y
	ldy txt__text_x
	; LineNumber: 311
	; Assigning to register
	; Assigning register : _x
	ldx txt__text_y
	; LineNumber: 312
	jsr $fff0
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 359
	; LineNumber: 358
txt_CH	dc.b	0
txt_put_ch_block35
txt_put_ch
	; LineNumber: 360
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 361
	jsr $ffd2
	; LineNumber: 363
	rts
	
; // Clear keyboard buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_clear_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 367
txt_clear_buffer
	; LineNumber: 369
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $c6
	; LineNumber: 370
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 376
	; LineNumber: 375
txt_ink	dc.b	$00
txt_get_key_block37
txt_get_key
	; LineNumber: 377
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 378
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 379
txt_get_key_while38
txt_get_key_loopstart42
	; Binary clause Simplified: EQUALS
	lda txt_ink
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_get_key_elsedoneblock41
txt_get_key_ConditionalTrueBlock39: ;Main true block ;keep 
	; LineNumber: 380
	; LineNumber: 381
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 382
	jmp txt_get_key_while38
txt_get_key_elsedoneblock41
txt_get_key_loopend43
	; LineNumber: 383
	jsr $e5b4
	; LineNumber: 384
	; Assigning from register
	sta txt_ink
	; LineNumber: 385
	rts
	; LineNumber: 386
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 391
	; LineNumber: 390
txt_tmp_key	dc.b	$00
txt_wait_key_block46
txt_wait_key
	; LineNumber: 393
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 394
txt_wait_key_while47
txt_wait_key_loopstart51
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock50
txt_wait_key_ConditionalTrueBlock48: ;Main true block ;keep 
	; LineNumber: 395
	; LineNumber: 396
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 397
	jmp txt_wait_key_while47
txt_wait_key_elsedoneblock50
txt_wait_key_loopend52
	; LineNumber: 399
	jsr txt_clear_buffer
	; LineNumber: 400
	rts
	
; //CURSOR_OFF
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_off
	;    Procedure type : User-defined procedure
	; LineNumber: 421
txt_cursor_off
	; LineNumber: 423
	; Poke
	; Optimization: shift is zero
	lda #$1
	sta $cc
	; LineNumber: 426
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 451
txt_cursor_return
	; LineNumber: 453
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 455
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 476
	; LineNumber: 475
txt_next_ch	dc.b	0
	; LineNumber: 473
	; LineNumber: 473
txt_print_string_block57
txt_print_string
	; LineNumber: 478
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 479
txt_print_string_while58
txt_print_string_loopstart62
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock61
txt_print_string_ConditionalTrueBlock59: ;Main true block ;keep 
	; LineNumber: 479
	; LineNumber: 481
	; Assigning to register
	; Assigning register : _a
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; LineNumber: 482
	jsr $ffd2
	; LineNumber: 483
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 484
	jmp txt_print_string_while58
txt_print_string_elsedoneblock61
txt_print_string_loopend63
	; LineNumber: 486
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock69
txt_print_string_ConditionalTrueBlock67: ;Main true block ;keep 
	; LineNumber: 487
	; LineNumber: 488
	jsr txt_cursor_return
	; LineNumber: 490
txt_print_string_elsedoneblock69
	; LineNumber: 491
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_str_len
	;    Procedure type : User-defined procedure
	; LineNumber: 632
	; LineNumber: 631
txt_str_len_block72
txt_str_len
	; LineNumber: 634
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 637
txt_str_len_while73
txt_str_len_loopstart77
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_i
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_str_len_elsedoneblock76
txt_str_len_ConditionalTrueBlock74: ;Main true block ;keep 
	; LineNumber: 637
	; LineNumber: 639
	
; // get the Str_Len by counting until char is 0
	; Test Inc dec D
	inc txt_i
	; LineNumber: 640
	jmp txt_str_len_while73
txt_str_len_elsedoneblock76
txt_str_len_loopend78
	; LineNumber: 644
	; LineNumber: 645
	lda txt_i
	rts
	
; // Return
; // print X spaces
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_space
	;    Procedure type : User-defined procedure
	; LineNumber: 649
	; LineNumber: 648
txt_print_space_block81
txt_print_space
	; LineNumber: 651
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 656
	; Calling storevariable on generic assign expression
txt_print_space_forloop82
	; LineNumber: 653
	; LineNumber: 654
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 655
txt_print_space_forloopcounter84
txt_print_space_loopstart85
	; Compare is onpage
	; Test Inc dec D
	inc txt_i
	; integer assignment NodeVar
	ldy txt_max_digits+1 ; keep
	lda txt_max_digits
	cmp txt_i ;keep
	bne txt_print_space_forloop82
txt_print_space_loopdone89: ;keep
txt_print_space_forloopend83
txt_print_space_loopend86
	; LineNumber: 657
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string_centered
	;    Procedure type : User-defined procedure
	; LineNumber: 661
	; LineNumber: 660
	; LineNumber: 660
	; LineNumber: 660
txt__sc_w	dc.b	0
txt_print_string_centered_block90
txt_print_string_centered
	; LineNumber: 663
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 664
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 667
	
; // Get the length of the string
	jsr txt_str_len
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 670
	
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
	bcs txt_print_string_centered_skip92
	dey
txt_print_string_centered_skip92
txt_print_string_centered_int_shift_var93 = $56
	sta txt_print_string_centered_int_shift_var93
	sty txt_print_string_centered_int_shift_var93+1
		lsr txt_print_string_centered_int_shift_var93+1
	ror txt_print_string_centered_int_shift_var93+0

	lda txt_print_string_centered_int_shift_var93
	ldy txt_print_string_centered_int_shift_var93+1
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 673
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_max_digits+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_string_centered_elseblock96
	bne txt_print_string_centered_localsuccess100
	lda txt_max_digits
	cmp #$00 ;keep
	bcc txt_print_string_centered_elseblock96
	beq txt_print_string_centered_elseblock96
txt_print_string_centered_localsuccess100: ;keep
	; ; logical AND, second requirement
	; Binary clause Simplified: LESS
	lda txt_i
	; Compare with pure num / var optimization
	cmp #$28;keep
	bcs txt_print_string_centered_elseblock96
txt_print_string_centered_ConditionalTrueBlock95: ;Main true block ;keep 
	; LineNumber: 673
	; LineNumber: 677
	
; // Is it worth padding?
; // Add the padding
	jsr txt_print_space
	; LineNumber: 680
	
; // print the string
	jsr txt_print_string
	; LineNumber: 683
	jmp txt_print_string_centered_elsedoneblock97
txt_print_string_centered_elseblock96
	; LineNumber: 684
	; LineNumber: 686
	
; // print the string
	jsr txt_print_string
	; LineNumber: 687
txt_print_string_centered_elsedoneblock97
	; LineNumber: 691
	rts
	
; // NOT atari
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_dec
	;    Procedure type : User-defined procedure
	; LineNumber: 696
	; LineNumber: 695
txt__in_n	dc.b	0
	; LineNumber: 695
txt__add_cr	dc.b	0
txt_print_dec_block103
txt_print_dec
	; LineNumber: 698
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_digit
	sty txt_next_digit+1
	; LineNumber: 699
	lda #$00
	ldx #$00
	sta txt_temp_num_p
	stx txt_temp_num_p+1
	; LineNumber: 700
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 701
	; Calling storevariable on generic assign expression
	sta txt_temp_i
	; LineNumber: 703
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$a;keep
	bcc txt_print_dec_localfailed149
	jmp txt_print_dec_ConditionalTrueBlock105
txt_print_dec_localfailed149
	jmp txt_print_dec_elseblock106
txt_print_dec_ConditionalTrueBlock105: ;Main true block ;keep 
	; LineNumber: 703
	; LineNumber: 706
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed172
	jmp txt_print_dec_ConditionalTrueBlock152
txt_print_dec_localfailed172
	jmp txt_print_dec_elseblock153
txt_print_dec_ConditionalTrueBlock152: ;Main true block ;keep 
	; LineNumber: 707
	; LineNumber: 709
	
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
	; LineNumber: 710
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 714
	
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
txt_print_dec_rightvarInteger_var176 = $56
	sta txt_print_dec_rightvarInteger_var176
	sty txt_print_dec_rightvarInteger_var176+1
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
	sbc txt_print_dec_rightvarInteger_var176
txt_print_dec_wordAdd174
	sta txt_print_dec_rightvarInteger_var176
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var176+1
	tay
	lda txt_print_dec_rightvarInteger_var176
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 715
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock180
	bne txt_print_dec_ConditionalTrueBlock178
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock180
	beq txt_print_dec_elsedoneblock180
txt_print_dec_ConditionalTrueBlock178: ;Main true block ;keep 
	; LineNumber: 714
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd184
	dec txt_temp_num+1
txt_print_dec_WordAdd184
txt_print_dec_elsedoneblock180
	; LineNumber: 716
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	lda txt_temp_num
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 719
	
; // right digit
	; Modulo
	lda #$a
txt_print_dec_val_var185 = $56
	sta txt_print_dec_val_var185
	lda txt__in_n
	sec
txt_print_dec_modulo186
	sbc txt_print_dec_val_var185
	bcs txt_print_dec_modulo186
	adc txt_print_dec_val_var185
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 720
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 723
	jmp txt_print_dec_elsedoneblock154
txt_print_dec_elseblock153
	; LineNumber: 724
	; LineNumber: 727
	
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
	; LineNumber: 728
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 731
	
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
txt_print_dec_rightvarInteger_var189 = $56
	sta txt_print_dec_rightvarInteger_var189
	sty txt_print_dec_rightvarInteger_var189+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var189+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var189
	bcs txt_print_dec_wordAdd188
	dey
txt_print_dec_wordAdd188
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 732
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 733
txt_print_dec_elsedoneblock154
	; LineNumber: 736
	jmp txt_print_dec_elsedoneblock107
txt_print_dec_elseblock106
	; LineNumber: 737
	; LineNumber: 738
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 739
txt_print_dec_elsedoneblock107
	; LineNumber: 741
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock194
txt_print_dec_ConditionalTrueBlock192: ;Main true block ;keep 
	; LineNumber: 740
	jsr txt_cursor_return
txt_print_dec_elsedoneblock194
	; LineNumber: 742
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_tile
	;    Procedure type : User-defined procedure
	; LineNumber: 38
	; LineNumber: 37
	; LineNumber: 37
	; LineNumber: 37
levels_draw_tile_block197
levels_draw_tile
	; LineNumber: 41
	
; // Source
	; Generic 16 bit op
	lda #<levels_tiles
	ldy #>levels_tiles
levels_draw_tile_rightvarInteger_var200 = $56
	sta levels_draw_tile_rightvarInteger_var200
	sty levels_draw_tile_rightvarInteger_var200+1
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
	adc levels_draw_tile_rightvarInteger_var200
levels_draw_tile_wordAdd198
	sta levels_draw_tile_rightvarInteger_var200
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var200+1
	tay
	lda levels_draw_tile_rightvarInteger_var200
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 44
	
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
levels_draw_tile_rightvarInteger_var203 = $56
	sta levels_draw_tile_rightvarInteger_var203
	sty levels_draw_tile_rightvarInteger_var203+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var206 = $58
	sta levels_draw_tile_rightvarInteger_var206
	sty levels_draw_tile_rightvarInteger_var206+1
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
	adc levels_draw_tile_rightvarInteger_var206
levels_draw_tile_wordAdd204
	sta levels_draw_tile_rightvarInteger_var206
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var206+1
	tay
	lda levels_draw_tile_rightvarInteger_var206
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var203
levels_draw_tile_wordAdd201
	sta levels_draw_tile_rightvarInteger_var203
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var203+1
	tay
	lda levels_draw_tile_rightvarInteger_var203
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 45
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy207
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy207
	; LineNumber: 47
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd208
	inc levels_temp_s+1
levels_draw_tile_WordAdd208
	; LineNumber: 48
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd209
	inc levels_dest+1
levels_draw_tile_WordAdd209
	; LineNumber: 49
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy210
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy210
	; LineNumber: 51
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd211
	inc levels_dest+1
levels_draw_tile_WordAdd211
	; LineNumber: 52
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd212
	inc levels_temp_s+1
levels_draw_tile_WordAdd212
	; LineNumber: 53
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy213
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy213
	; LineNumber: 55
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 63
levels_draw_level
	; LineNumber: 66
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 67
	; Generic 16 bit op
	lda #<levels_level
	ldy #>levels_level
levels_draw_level_rightvarInteger_var217 = $56
	sta levels_draw_level_rightvarInteger_var217
	sty levels_draw_level_rightvarInteger_var217+1
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
	adc levels_draw_level_rightvarInteger_var217
levels_draw_level_wordAdd215
	sta levels_draw_level_rightvarInteger_var217
	; High-bit binop
	tya
	adc levels_draw_level_rightvarInteger_var217+1
	tay
	lda levels_draw_level_rightvarInteger_var217
	sta levels_level_p
	sty levels_level_p+1
	; LineNumber: 78
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop218
	; LineNumber: 71
	; LineNumber: 76
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop237
	; LineNumber: 73
	; LineNumber: 74
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
	; LineNumber: 75
	jsr levels_draw_tile
	; LineNumber: 76
levels_draw_level_forloopcounter239
levels_draw_level_loopstart240
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda levels_tiles_across
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop237
levels_draw_level_loopdone248: ;keep
levels_draw_level_forloopend238
levels_draw_level_loopend241
	; LineNumber: 77
levels_draw_level_forloopcounter220
levels_draw_level_loopstart221
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_y
	lda #$6
	cmp levels_t_y ;keep
	bne levels_draw_level_forloop218
levels_draw_level_loopdone249: ;keep
levels_draw_level_forloopend219
levels_draw_level_loopend222
	; LineNumber: 80
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 87
levels_refresh_screen
	; LineNumber: 89
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 98
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop251
	; LineNumber: 94
	; LineNumber: 95
	
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
	; LineNumber: 96
	; memcpyfast
	ldy levels_detected_screen_width
	dey
levels_refresh_screen_memcpy260
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy260
	; LineNumber: 97
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd261
	inc levels_temp_s+1
levels_refresh_screen_WordAdd261
	; LineNumber: 98
levels_refresh_screen_forloopcounter253
levels_refresh_screen_loopstart254
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop251
levels_refresh_screen_loopdone262: ;keep
levels_refresh_screen_forloopend252
levels_refresh_screen_loopend255
	; LineNumber: 100
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 166
	; LineNumber: 165
levels_buf_x	dc.b	0
	; LineNumber: 165
levels_buf_y	dc.b	0
levels_get_buffer_block263
levels_get_buffer
	; LineNumber: 168
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var266 = $56
	sta levels_get_buffer_rightvarInteger_var266
	sty levels_get_buffer_rightvarInteger_var266+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var269 = $58
	sta levels_get_buffer_rightvarInteger_var269
	sty levels_get_buffer_rightvarInteger_var269+1
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
	adc levels_get_buffer_rightvarInteger_var269
levels_get_buffer_wordAdd267
	sta levels_get_buffer_rightvarInteger_var269
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var269+1
	tay
	lda levels_get_buffer_rightvarInteger_var269
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var266
levels_get_buffer_wordAdd264
	sta levels_get_buffer_rightvarInteger_var266
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var266+1
	tay
	lda levels_get_buffer_rightvarInteger_var266
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 170
	; LineNumber: 171
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 176
	; LineNumber: 175
levels_plot_x	dc.b	0
	; LineNumber: 175
levels_plot_y	dc.b	0
	; LineNumber: 175
levels_plot_ch	dc.b	0
levels_plot_buffer_block270
levels_plot_buffer
	; LineNumber: 178
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var273 = $56
	sta levels_plot_buffer_rightvarInteger_var273
	sty levels_plot_buffer_rightvarInteger_var273+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var276 = $58
	sta levels_plot_buffer_rightvarInteger_var276
	sty levels_plot_buffer_rightvarInteger_var276+1
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
	adc levels_plot_buffer_rightvarInteger_var276
levels_plot_buffer_wordAdd274
	sta levels_plot_buffer_rightvarInteger_var276
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var276+1
	tay
	lda levels_plot_buffer_rightvarInteger_var276
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var273
levels_plot_buffer_wordAdd271
	sta levels_plot_buffer_rightvarInteger_var273
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var273+1
	tay
	lda levels_plot_buffer_rightvarInteger_var273
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 179
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 181
	rts
	
; //player inventory/stats
; // ********************************
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 57
init
	; LineNumber: 60
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 61
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 65
	
; // Clean the screen buffer		
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 66
	lda space_char
	ldy #0
init_fill278
	sta (p),y
	iny
	cpy #$fa
	bne init_fill278
	; LineNumber: 68
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd279
	inc p+1
init_WordAdd279
	; LineNumber: 69
	lda space_char
	ldy #0
init_fill280
	sta (p),y
	iny
	cpy #$fa
	bne init_fill280
	; LineNumber: 71
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd281
	inc p+1
init_WordAdd281
	; LineNumber: 72
	lda space_char
	ldy #0
init_fill282
	sta (p),y
	iny
	cpy #$fa
	bne init_fill282
	; LineNumber: 74
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd283
	inc p+1
init_WordAdd283
	; LineNumber: 75
	lda space_char
	ldy #0
init_fill284
	sta (p),y
	iny
	cpy #$fa
	bne init_fill284
	; LineNumber: 78
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 80
	lda #$a
	; Calling storevariable on generic assign expression
	sta levels_tiles_across
	; LineNumber: 99
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 101
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 102
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 105
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 106
	jsr levels_draw_level
	; LineNumber: 109
	
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
	; LineNumber: 112
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 113
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : c64_chars
	;    Procedure type : User-defined procedure
	; LineNumber: 119
	; LineNumber: 118
dest	= $24
	; LineNumber: 118
temp_s	= $68
c64_chars_block285
c64_chars
	; LineNumber: 122
	
; // Set to use the new characterset
	; Set bank
	lda #$2
	sta $dd00
	; LineNumber: 123
	lda $d018
	and #%11110001
	ora #8
	sta $d018
	; LineNumber: 126
	
; // Force the screen address
	; Integer constant assigning
	ldy #$44
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 129
	
; // Tells basic routines where screen memory is located
	; Poke
	; Optimization: shift is zero
	lda #$44
	sta $288
	; LineNumber: 132
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 135
	
; // Black screen
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $d020
	; LineNumber: 136
	; Poke
	; Optimization: shift is zero
	sta $d021
	; LineNumber: 140
	
; // Ensure no flashing cursor
	jsr txt_cursor_off
	; LineNumber: 142
	rts
	
; // Force the screen address
; // Clear screen,
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 167
show_start_screen
	; LineNumber: 169
	jsr txt_cls
	; LineNumber: 170
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed310
	jmp show_start_screen_ConditionalTrueBlock288
show_start_screen_localfailed310
	jmp show_start_screen_elsedoneblock290
show_start_screen_ConditionalTrueBlock288: ;Main true block ;keep 
	; LineNumber: 171
	; LineNumber: 174
	
; //                         01234567890123456789012
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 175
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 176
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr312
	sta txt_in_str
	lda #>show_start_screen_stringassignstr312
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 177
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 178
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr314
	sta txt_in_str
	lda #>show_start_screen_stringassignstr314
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 179
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr316
	sta txt_in_str
	lda #>show_start_screen_stringassignstr316
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 180
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr318
	sta txt_in_str
	lda #>show_start_screen_stringassignstr318
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 181
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 182
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr320
	sta txt_in_str
	lda #>show_start_screen_stringassignstr320
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 183
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 184
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr322
	sta txt_in_str
	lda #>show_start_screen_stringassignstr322
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 186
	
; //txt::print_string_centered("(C)2021", true, levels::detected_screen_width);	
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 187
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr324
	sta txt_in_str
	lda #>show_start_screen_stringassignstr324
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 188
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 189
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
	; LineNumber: 193
	
; //txt::print_string_centered("@ = YOU k = KEY", true, levels::detected_screen_width);
; //txt::print_string_centered("s = HEALTH c = DOOR", true, levels::detected_screen_width);
; //txt::print_string_centered("z = GEM x = ARTIFACT", true, levels::detected_screen_width);	
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
	; LineNumber: 194
show_start_screen_elsedoneblock290
	; LineNumber: 198
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 199
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 201
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr330
	sta txt_in_str
	lda #>show_start_screen_stringassignstr330
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 202
	jsr txt_print_space
	; LineNumber: 204
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 205
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 207
	jsr txt_wait_key
	; LineNumber: 210
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 215
show_end_screen
	; LineNumber: 217
	jsr txt_cls
	; LineNumber: 218
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock335
show_end_screen_ConditionalTrueBlock334: ;Main true block ;keep 
	; LineNumber: 218
	; LineNumber: 220
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr344
	sta txt_in_str
	lda #>show_end_screen_stringassignstr344
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 222
	jmp show_end_screen_elsedoneblock336
show_end_screen_elseblock335
	; LineNumber: 223
	; LineNumber: 224
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr347
	sta txt_in_str
	lda #>show_end_screen_stringassignstr347
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 225
show_end_screen_elsedoneblock336
	; LineNumber: 228
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr349
	sta txt_in_str
	lda #>show_end_screen_stringassignstr349
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 230
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 232
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr351
	sta txt_in_str
	lda #>show_end_screen_stringassignstr351
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 234
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 236
	jsr txt_wait_key
	; LineNumber: 239
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 244
display_text
	; LineNumber: 246
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 247
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 248
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr354
	sta txt_in_str
	lda #>display_text_stringassignstr354
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 249
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 250
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 251
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 253
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 254
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 255
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 256
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 258
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 259
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 260
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 261
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 264
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 265
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 266
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 267
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 268
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 269
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 272
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 273
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 274
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 275
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 278
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 279
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 280
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 281
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 282
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 283
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 285
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 289
	; LineNumber: 288
update_status_block356
update_status
	; LineNumber: 290
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 291
	jsr display_text
	; LineNumber: 293
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 297
door
	; LineNumber: 300
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed410
	jmp door_ConditionalTrueBlock359
door_localfailed410
	jmp door_elseblock360
door_ConditionalTrueBlock359: ;Main true block ;keep 
	; LineNumber: 301
	; LineNumber: 302
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 303
	; Assigning a string : new_status
	lda #<door_stringassignstr412
	sta new_status
	lda #>door_stringassignstr412
	sta new_status+1
	jsr update_status
	; LineNumber: 305
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock417
door_ConditionalTrueBlock415: ;Main true block ;keep 
	; LineNumber: 304
	; Assigning a string : new_status
	lda #<door_stringassignstr422
	sta new_status
	lda #>door_stringassignstr422
	sta new_status+1
	jsr update_status
door_elsedoneblock417
	; LineNumber: 306
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock427
door_ConditionalTrueBlock425: ;Main true block ;keep 
	; LineNumber: 305
	; Assigning a string : new_status
	lda #<door_stringassignstr432
	sta new_status
	lda #>door_stringassignstr432
	sta new_status+1
	jsr update_status
door_elsedoneblock427
	; LineNumber: 307
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock437
door_ConditionalTrueBlock435: ;Main true block ;keep 
	; LineNumber: 306
	; Assigning a string : new_status
	lda #<door_stringassignstr442
	sta new_status
	lda #>door_stringassignstr442
	sta new_status+1
	jsr update_status
door_elsedoneblock437
	; LineNumber: 308
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock447
door_ConditionalTrueBlock445: ;Main true block ;keep 
	; LineNumber: 309
	; LineNumber: 310
	; Assigning a string : new_status
	lda #<door_stringassignstr453
	sta new_status
	lda #>door_stringassignstr453
	sta new_status+1
	jsr update_status
	; LineNumber: 311
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd455
	inc levels_current_level+1
door_WordAdd455
	; LineNumber: 312
	; Test Inc dec D
	dec y
	; LineNumber: 313
	jsr levels_draw_level
	; LineNumber: 314
door_elsedoneblock447
	; LineNumber: 316
	jmp door_elsedoneblock361
door_elseblock360
	; LineNumber: 317
	; LineNumber: 318
	; Assigning a string : new_status
	lda #<door_stringassignstr457
	sta new_status
	lda #>door_stringassignstr457
	sta new_status+1
	jsr update_status
	; LineNumber: 321
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 322
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 323
door_elsedoneblock361
	; LineNumber: 325
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 329
combat
	; LineNumber: 332
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
	bcc combat_elseblock462
combat_ConditionalTrueBlock461: ;Main true block ;keep 
	; LineNumber: 333
	; LineNumber: 334
	; Assigning a string : new_status
	lda #<combat_stringassignstr479
	sta new_status
	lda #>combat_stringassignstr479
	sta new_status+1
	jsr update_status
	; LineNumber: 335
	jmp combat_elsedoneblock463
combat_elseblock462
	; LineNumber: 337
	; LineNumber: 339
	; Test Inc dec D
	dec health
	; LineNumber: 342
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 343
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 345
	; Assigning a string : new_status
	lda #<combat_stringassignstr482
	sta new_status
	lda #>combat_stringassignstr482
	sta new_status+1
	jsr update_status
	; LineNumber: 347
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock485
	bcs combat_elsedoneblock487
combat_ConditionalTrueBlock485: ;Main true block ;keep 
	; LineNumber: 348
	; LineNumber: 349
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 350
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 351
combat_elsedoneblock487
	; LineNumber: 353
combat_elsedoneblock463
	; LineNumber: 355
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 361
check_collisions
	; LineNumber: 364
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext492
	; LineNumber: 368
	; LineNumber: 370
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr494
	sta new_status
	lda #>check_collisions_stringassignstr494
	sta new_status+1
	jsr update_status
	; LineNumber: 371
	jsr combat
	; LineNumber: 373
	jmp check_collisions_caseend491
check_collisions_casenext492
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext496
	; LineNumber: 376
	; LineNumber: 377
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr498
	sta new_status
	lda #>check_collisions_stringassignstr498
	sta new_status+1
	jsr update_status
	; LineNumber: 378
	jmp check_collisions_caseend491
check_collisions_casenext496
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext500
	; LineNumber: 380
	; LineNumber: 382
	jsr door
	; LineNumber: 383
	jmp check_collisions_caseend491
check_collisions_casenext500
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext502
	; LineNumber: 385
	; LineNumber: 387
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 388
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr504
	sta new_status
	lda #>check_collisions_stringassignstr504
	sta new_status+1
	jsr update_status
	; LineNumber: 389
	jmp check_collisions_caseend491
check_collisions_casenext502
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext506
	; LineNumber: 393
	; LineNumber: 394
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 395
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr508
	sta new_status
	lda #>check_collisions_stringassignstr508
	sta new_status+1
	jsr update_status
	; LineNumber: 397
	jmp check_collisions_caseend491
check_collisions_casenext506
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext510
	; LineNumber: 399
	; LineNumber: 402
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr512
	sta new_status
	lda #>check_collisions_stringassignstr512
	sta new_status+1
	jsr update_status
	; LineNumber: 403
	jsr combat
	; LineNumber: 404
	jmp check_collisions_caseend491
check_collisions_casenext510
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext514
	; LineNumber: 407
	; LineNumber: 408
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd516
	inc gold+1
check_collisions_WordAdd516
	; LineNumber: 409
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr517
	sta new_status
	lda #>check_collisions_stringassignstr517
	sta new_status+1
	jsr update_status
	; LineNumber: 411
	jmp check_collisions_caseend491
check_collisions_casenext514
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext519
	; LineNumber: 414
	; LineNumber: 416
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr521
	sta new_status
	lda #>check_collisions_stringassignstr521
	sta new_status+1
	jsr update_status
	; LineNumber: 417
	jsr combat
	; LineNumber: 419
	jmp check_collisions_caseend491
check_collisions_casenext519
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext523
	; LineNumber: 423
	; LineNumber: 425
	jmp check_collisions_caseend491
check_collisions_casenext523
	; LineNumber: 429
	; LineNumber: 432
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 433
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 437
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 438
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr526
	sta new_status
	lda #>check_collisions_stringassignstr526
	sta new_status+1
	jsr update_status
	; LineNumber: 439
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 440
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 442
check_collisions_caseend491
	; LineNumber: 445
	rts
block1
	; LineNumber: 451
	
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 455
	
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 456
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 483
MainProgram_while528
MainProgram_loopstart532
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed624
	jmp MainProgram_ConditionalTrueBlock529
MainProgram_localfailed624
	jmp MainProgram_elsedoneblock531
MainProgram_ConditionalTrueBlock529: ;Main true block ;keep 
	; LineNumber: 483
	; LineNumber: 488
	
; // Borked, will need some work
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 492
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 495
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr626
	sta new_status
	lda #>MainProgram_stringassignstr626
	sta new_status+1
	jsr update_status
	; LineNumber: 496
	jsr display_text
	; LineNumber: 500
MainProgram_while628
MainProgram_loopstart632
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed674
	jmp MainProgram_ConditionalTrueBlock629
MainProgram_localfailed674
	jmp MainProgram_elsedoneblock631
MainProgram_ConditionalTrueBlock629: ;Main true block ;keep 
	; LineNumber: 501
	; LineNumber: 506
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 507
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 510
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 513
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext677
	; LineNumber: 515
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock682
MainProgram_ConditionalTrueBlock680: ;Main true block ;keep 
	; LineNumber: 515
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock682
	jmp MainProgram_caseend676
MainProgram_casenext677
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext685
	; LineNumber: 516
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock690
MainProgram_ConditionalTrueBlock688: ;Main true block ;keep 
	; LineNumber: 516
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock690
	jmp MainProgram_caseend676
MainProgram_casenext685
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext693
	; LineNumber: 517
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock698
MainProgram_ConditionalTrueBlock696: ;Main true block ;keep 
	; LineNumber: 517
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock698
	jmp MainProgram_caseend676
MainProgram_casenext693
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext701
	; LineNumber: 518
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock706
MainProgram_ConditionalTrueBlock704: ;Main true block ;keep 
	; LineNumber: 518
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock706
MainProgram_casenext701
MainProgram_caseend676
	; LineNumber: 526
	
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
	; LineNumber: 530
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock712
MainProgram_ConditionalTrueBlock710: ;Main true block ;keep 
	; LineNumber: 531
	; LineNumber: 534
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
	; LineNumber: 536
MainProgram_elsedoneblock712
	; LineNumber: 542
	
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
	; LineNumber: 546
	
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
	; LineNumber: 550
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 552
	jmp MainProgram_while628
MainProgram_elsedoneblock631
MainProgram_loopend633
	; LineNumber: 556
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 559
	jmp MainProgram_while528
MainProgram_elsedoneblock531
MainProgram_loopend533
	; LineNumber: 561
	; End of program
	; Ending memory block
EndBlock810
show_start_screen_stringassignstr292		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr294		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr296		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr298		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr300		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr302		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr304		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr306		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr308		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr312		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr314		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr316		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr318		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr320		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr322		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr324		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr326		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr328		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr330		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr338		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr341		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr344		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr347		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr349		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr351		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr354		dc.b	"                    "
	dc.b	0
door_stringassignstr363		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr370		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr373		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr380		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr383		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr390		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr393		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr400		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr404		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr408		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr412		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr419		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr422		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr429		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr432		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr439		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr442		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr449		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr453		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr457		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr465		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr468		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr479		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr482		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr494		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr498		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr504		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr508		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr512		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr517		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr521		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr526		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr535		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr626		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
	org $6000
charset
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map - Chars.bin"
EndBlock6000
