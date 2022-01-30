 processor 6502
	org $801
StartBlock801:
	; Starting new memory block at $801
	.byte $b ; lo byte of next line
	.byte $8 ; hi byte of next line
	.byte $0a, $00 ; line 10 (lo, hi)
	.byte $9e, $20 ; SYS token and a space
	.byte   $32,$30,$36,$34
	.byte $00, $00, $00 ; end of program
	; Ending memory block at $801
EndBlock801:
	org $810
StartBlock810:
	; Starting new memory block at $810
dungeon64
	; LineNumber: 496
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
	; LineNumber: 10
levels_tiles_across	dc.b	0
	; LineNumber: 11
levels_detected_screen_width	dc.b	0
	; LineNumber: 18
levels_screen_buffer	dc.b	 
	org levels_screen_buffer+1000
	; LineNumber: 20
levels_level_p	=  $0D
	; LineNumber: 21
levels_tiles
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///tiles.bin"
	; LineNumber: 33
levels_level
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map.bin"
	; LineNumber: 35
	; LineNumber: 41
player_char	dc.b	$00
	; LineNumber: 42
space_char	dc.b	$20
	; LineNumber: 44
key_press	dc.b	$00
	; LineNumber: 45
charat	dc.b	0
	; LineNumber: 46
game_won	dc.b	0
	; LineNumber: 46
game_running	dc.b	0
	; LineNumber: 47
x	dc.b	0
	; LineNumber: 47
y	dc.b	0
	; LineNumber: 47
oldx	dc.b	0
	; LineNumber: 47
oldy	dc.b	0
	; LineNumber: 49
new_status	=  $10
	; LineNumber: 49
the_status	=  $12
	; LineNumber: 49
p	=  $22
	; LineNumber: 52
keys	dc.b	$00
	; LineNumber: 53
gold	dc.w	$00
	; LineNumber: 54
health	dc.b	$0c
	; LineNumber: 57
attack	dc.b	$0c
	; LineNumber: 58
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
txt_print_string_centered_int_shift_var93 =  $56
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
txt_print_dec_rightvarInteger_var176 =  $56
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
txt_print_dec_val_var185 =  $56
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
txt_print_dec_rightvarInteger_var189 =  $56
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
	; LineNumber: 43
	; LineNumber: 40
levels_tremainder	dc.b	0
	; LineNumber: 41
levels_trow	dc.b	0
	; LineNumber: 42
levels_tile_cell	dc.w	0
levels_draw_tile_block197
levels_draw_tile
	; LineNumber: 46
	
; // Get starting byte
	; Modulo
	lda #$7
levels_draw_tile_val_var198 =  $56
	sta levels_draw_tile_val_var198
	lda levels_tile_no
	sec
levels_draw_tile_modulo199
	sbc levels_draw_tile_val_var198
	bcs levels_draw_tile_modulo199
	adc levels_draw_tile_val_var198
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
levels_draw_tile_rightvarInteger_var204 =  $56
	sta levels_draw_tile_rightvarInteger_var204
	sty levels_draw_tile_rightvarInteger_var204+1
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
	adc levels_draw_tile_rightvarInteger_var204
levels_draw_tile_wordAdd202
	sta levels_draw_tile_rightvarInteger_var204
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var204+1
	tay
	lda levels_draw_tile_rightvarInteger_var204
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
levels_draw_tile_rightvarInteger_var208 =  $56
	sta levels_draw_tile_rightvarInteger_var208
	sty levels_draw_tile_rightvarInteger_var208+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var211 =  $58
	sta levels_draw_tile_rightvarInteger_var211
	sty levels_draw_tile_rightvarInteger_var211+1
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
	adc levels_draw_tile_rightvarInteger_var211
levels_draw_tile_wordAdd209
	sta levels_draw_tile_rightvarInteger_var211
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var211+1
	tay
	lda levels_draw_tile_rightvarInteger_var211
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
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 54
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy212
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy212
	; LineNumber: 57
	
; // ROW 2
	lda levels_temp_s
	clc
	adc #$15
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd213
	inc levels_temp_s+1
levels_draw_tile_WordAdd213
	; LineNumber: 58
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd214
	inc levels_dest+1
levels_draw_tile_WordAdd214
	; LineNumber: 59
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy215
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy215
	; LineNumber: 62
	
; // ROW 3
	lda levels_temp_s
	clc
	adc #$15
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd216
	inc levels_temp_s+1
levels_draw_tile_WordAdd216
	; LineNumber: 63
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd217
	inc levels_dest+1
levels_draw_tile_WordAdd217
	; LineNumber: 64
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy218
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy218
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
levels_draw_level_forloop220
	; LineNumber: 81
	; LineNumber: 86
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop239
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
levels_draw_level_forloopcounter241
levels_draw_level_loopstart242
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda levels_tiles_across
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop239
levels_draw_level_loopdone250: ;keep
levels_draw_level_forloopend240
levels_draw_level_loopend243
	; LineNumber: 87
levels_draw_level_forloopcounter222
levels_draw_level_loopstart223
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_y
	lda #$6
	cmp levels_t_y ;keep
	bne levels_draw_level_forloop220
levels_draw_level_loopdone251: ;keep
levels_draw_level_forloopend221
levels_draw_level_loopend224
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
levels_refresh_screen_forloop253
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
levels_refresh_screen_memcpy262
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy262
	; LineNumber: 117
	
; //MemCpy16(temp_s, dest, detected_screen_width);
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd263
	inc levels_temp_s+1
levels_refresh_screen_WordAdd263
	; LineNumber: 118
levels_refresh_screen_forloopcounter255
levels_refresh_screen_loopstart256
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop253
levels_refresh_screen_loopdone264: ;keep
levels_refresh_screen_forloopend254
levels_refresh_screen_loopend257
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
levels_get_buffer_block265
levels_get_buffer
	; LineNumber: 188
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var268 =  $56
	sta levels_get_buffer_rightvarInteger_var268
	sty levels_get_buffer_rightvarInteger_var268+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var271 =  $58
	sta levels_get_buffer_rightvarInteger_var271
	sty levels_get_buffer_rightvarInteger_var271+1
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
	adc levels_get_buffer_rightvarInteger_var271
levels_get_buffer_wordAdd269
	sta levels_get_buffer_rightvarInteger_var271
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var271+1
	tay
	lda levels_get_buffer_rightvarInteger_var271
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var268
levels_get_buffer_wordAdd266
	sta levels_get_buffer_rightvarInteger_var268
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var268+1
	tay
	lda levels_get_buffer_rightvarInteger_var268
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
levels_plot_buffer_block272
levels_plot_buffer
	; LineNumber: 198
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var275 =  $56
	sta levels_plot_buffer_rightvarInteger_var275
	sty levels_plot_buffer_rightvarInteger_var275+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var278 =  $58
	sta levels_plot_buffer_rightvarInteger_var278
	sty levels_plot_buffer_rightvarInteger_var278+1
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
	adc levels_plot_buffer_rightvarInteger_var278
levels_plot_buffer_wordAdd276
	sta levels_plot_buffer_rightvarInteger_var278
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var278+1
	tay
	lda levels_plot_buffer_rightvarInteger_var278
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var275
levels_plot_buffer_wordAdd273
	sta levels_plot_buffer_rightvarInteger_var275
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var275+1
	tay
	lda levels_plot_buffer_rightvarInteger_var275
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
	; LineNumber: 66
init
	; LineNumber: 68
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 72
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 73
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 77
	
; // Clean the screen buffer		
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 78
	lda space_char
	ldy #0
init_fill280
	sta (p),y
	iny
	cpy #$fa
	bne init_fill280
	; LineNumber: 80
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd281
	inc p+1
init_WordAdd281
	; LineNumber: 81
	lda space_char
	ldy #0
init_fill282
	sta (p),y
	iny
	cpy #$fa
	bne init_fill282
	; LineNumber: 83
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd283
	inc p+1
init_WordAdd283
	; LineNumber: 84
	lda space_char
	ldy #0
init_fill284
	sta (p),y
	iny
	cpy #$fa
	bne init_fill284
	; LineNumber: 86
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd285
	inc p+1
init_WordAdd285
	; LineNumber: 87
	lda space_char
	ldy #0
init_fill286
	sta (p),y
	iny
	cpy #$fa
	bne init_fill286
	; LineNumber: 90
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 93
	
; // Set how wide the map should be
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_tiles_across
	; LineNumber: 114
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 116
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 117
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 120
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 121
	jsr levels_draw_level
	; LineNumber: 124
	
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
	; LineNumber: 127
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 129
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : c64_chars
	;    Procedure type : User-defined procedure
	; LineNumber: 135
	; LineNumber: 134
dest	=  $24
	; LineNumber: 134
temp_s	=  $68
c64_chars_block287
c64_chars
	; LineNumber: 138
	
; // Set to use the new characterset
	; Set bank
	lda #$2
	sta $dd00
	; LineNumber: 139
	lda $d018
	and #%11110001
	ora #8
	sta $d018
	; LineNumber: 142
	
; // Force the screen address
	; Integer constant assigning
	ldy #$44
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 145
	
; // Tells basic routines where screen memory is located
	; Poke
	; Optimization: shift is zero
	lda #$44
	sta $288
	; LineNumber: 148
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 151
	
; // Black screen
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $d020
	; LineNumber: 152
	; Poke
	; Optimization: shift is zero
	sta $d021
	; LineNumber: 156
	
; // Ensure no flashing cursor
	jsr txt_cursor_off
	; LineNumber: 158
	rts
	
; // Force the screen address
; // Clear screen,
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 209
show_start_screen
	; LineNumber: 211
	jsr txt_cls
	; LineNumber: 212
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed320
	jmp show_start_screen_ConditionalTrueBlock290
show_start_screen_localfailed320
	jmp show_start_screen_elsedoneblock292
show_start_screen_ConditionalTrueBlock290: ;Main true block ;keep 
	; LineNumber: 213
	; LineNumber: 216
	
; //                         01234567890123456789012
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 217
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 218
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
	; LineNumber: 219
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 220
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
	; LineNumber: 221
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
	; LineNumber: 222
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
	; LineNumber: 223
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 224
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
	; LineNumber: 225
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 226
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
	; LineNumber: 227
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
	; LineNumber: 228
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 229
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
	; LineNumber: 230
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 231
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
	; LineNumber: 232
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
	; LineNumber: 233
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
	; LineNumber: 234
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
	; LineNumber: 235
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
	; LineNumber: 236
show_start_screen_elsedoneblock292
	; LineNumber: 240
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 241
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 244
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr348
	sta txt_in_str
	lda #>show_start_screen_stringassignstr348
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 245
	jsr txt_print_space
	; LineNumber: 248
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 249
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 252
	jsr txt_wait_key
	; LineNumber: 255
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 260
show_end_screen
	; LineNumber: 262
	jsr txt_cls
	; LineNumber: 263
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock353
show_end_screen_ConditionalTrueBlock352: ;Main true block ;keep 
	; LineNumber: 263
	; LineNumber: 265
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr362
	sta txt_in_str
	lda #>show_end_screen_stringassignstr362
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 267
	jmp show_end_screen_elsedoneblock354
show_end_screen_elseblock353
	; LineNumber: 268
	; LineNumber: 269
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr365
	sta txt_in_str
	lda #>show_end_screen_stringassignstr365
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 270
show_end_screen_elsedoneblock354
	; LineNumber: 273
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr367
	sta txt_in_str
	lda #>show_end_screen_stringassignstr367
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 275
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 277
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
	; LineNumber: 279
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 281
	jsr txt_wait_key
	; LineNumber: 284
	rts
	
; //@ifndef ATARI800		
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 289
display_text
	; LineNumber: 291
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 292
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 293
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr372
	sta txt_in_str
	lda #>display_text_stringassignstr372
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 294
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 295
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 296
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 298
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 299
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 300
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 301
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 303
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 304
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 305
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 306
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 309
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 310
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 311
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 312
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 313
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 314
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 317
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 318
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 319
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 320
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 323
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 324
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 325
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 326
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 327
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 328
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 330
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 334
update_status_block374
update_status
	; LineNumber: 335
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 336
	jsr display_text
	; LineNumber: 338
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 342
door
	; LineNumber: 345
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed428
	jmp door_ConditionalTrueBlock377
door_localfailed428
	jmp door_elseblock378
door_ConditionalTrueBlock377: ;Main true block ;keep 
	; LineNumber: 346
	; LineNumber: 347
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 348
	; Assigning a string : new_status
	lda #<door_stringassignstr430
	sta new_status
	lda #>door_stringassignstr430
	sta new_status+1
	jsr update_status
	; LineNumber: 350
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock435
door_ConditionalTrueBlock433: ;Main true block ;keep 
	; LineNumber: 349
	; Assigning a string : new_status
	lda #<door_stringassignstr440
	sta new_status
	lda #>door_stringassignstr440
	sta new_status+1
	jsr update_status
door_elsedoneblock435
	; LineNumber: 351
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock445
door_ConditionalTrueBlock443: ;Main true block ;keep 
	; LineNumber: 350
	; Assigning a string : new_status
	lda #<door_stringassignstr450
	sta new_status
	lda #>door_stringassignstr450
	sta new_status+1
	jsr update_status
door_elsedoneblock445
	; LineNumber: 352
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock455
door_ConditionalTrueBlock453: ;Main true block ;keep 
	; LineNumber: 351
	; Assigning a string : new_status
	lda #<door_stringassignstr460
	sta new_status
	lda #>door_stringassignstr460
	sta new_status+1
	jsr update_status
door_elsedoneblock455
	; LineNumber: 353
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock465
door_ConditionalTrueBlock463: ;Main true block ;keep 
	; LineNumber: 354
	; LineNumber: 355
	; Assigning a string : new_status
	lda #<door_stringassignstr471
	sta new_status
	lda #>door_stringassignstr471
	sta new_status+1
	jsr update_status
	; LineNumber: 356
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd473
	inc levels_current_level+1
door_WordAdd473
	; LineNumber: 357
	; Test Inc dec D
	dec y
	; LineNumber: 358
	jsr levels_draw_level
	; LineNumber: 359
door_elsedoneblock465
	; LineNumber: 361
	jmp door_elsedoneblock379
door_elseblock378
	; LineNumber: 362
	; LineNumber: 363
	; Assigning a string : new_status
	lda #<door_stringassignstr475
	sta new_status
	lda #>door_stringassignstr475
	sta new_status+1
	jsr update_status
	; LineNumber: 366
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 367
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 368
door_elsedoneblock379
	; LineNumber: 370
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 374
combat
	; LineNumber: 377
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
	bcc combat_elseblock480
combat_ConditionalTrueBlock479: ;Main true block ;keep 
	; LineNumber: 380
	; LineNumber: 381
	
; //if((Random::Random()/12)>10) then
	; Assigning a string : new_status
	lda #<combat_stringassignstr497
	sta new_status
	lda #>combat_stringassignstr497
	sta new_status+1
	jsr update_status
	; LineNumber: 382
	jmp combat_elsedoneblock481
combat_elseblock480
	; LineNumber: 384
	; LineNumber: 386
	; Test Inc dec D
	dec health
	; LineNumber: 389
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 390
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 392
	; Assigning a string : new_status
	lda #<combat_stringassignstr500
	sta new_status
	lda #>combat_stringassignstr500
	sta new_status+1
	jsr update_status
	; LineNumber: 394
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock503
	bcs combat_elsedoneblock505
combat_ConditionalTrueBlock503: ;Main true block ;keep 
	; LineNumber: 395
	; LineNumber: 396
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 397
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 398
combat_elsedoneblock505
	; LineNumber: 400
combat_elsedoneblock481
	; LineNumber: 402
	rts
	
; //@endif
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 408
check_collisions
	; LineNumber: 411
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext510
	; LineNumber: 415
	; LineNumber: 417
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr512
	sta new_status
	lda #>check_collisions_stringassignstr512
	sta new_status+1
	jsr update_status
	; LineNumber: 418
	jsr combat
	; LineNumber: 420
	jmp check_collisions_caseend509
check_collisions_casenext510
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext514
	; LineNumber: 423
	; LineNumber: 424
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr516
	sta new_status
	lda #>check_collisions_stringassignstr516
	sta new_status+1
	jsr update_status
	; LineNumber: 425
	jmp check_collisions_caseend509
check_collisions_casenext514
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext518
	; LineNumber: 427
	; LineNumber: 429
	jsr door
	; LineNumber: 430
	jmp check_collisions_caseend509
check_collisions_casenext518
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext520
	; LineNumber: 432
	; LineNumber: 434
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 435
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr522
	sta new_status
	lda #>check_collisions_stringassignstr522
	sta new_status+1
	jsr update_status
	; LineNumber: 436
	jmp check_collisions_caseend509
check_collisions_casenext520
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext524
	; LineNumber: 440
	; LineNumber: 441
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 442
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr526
	sta new_status
	lda #>check_collisions_stringassignstr526
	sta new_status+1
	jsr update_status
	; LineNumber: 444
	jmp check_collisions_caseend509
check_collisions_casenext524
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext528
	; LineNumber: 446
	; LineNumber: 449
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr530
	sta new_status
	lda #>check_collisions_stringassignstr530
	sta new_status+1
	jsr update_status
	; LineNumber: 450
	jsr combat
	; LineNumber: 451
	jmp check_collisions_caseend509
check_collisions_casenext528
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext532
	; LineNumber: 454
	; LineNumber: 455
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd534
	inc gold+1
check_collisions_WordAdd534
	; LineNumber: 456
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr535
	sta new_status
	lda #>check_collisions_stringassignstr535
	sta new_status+1
	jsr update_status
	; LineNumber: 458
	jmp check_collisions_caseend509
check_collisions_casenext532
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext537
	; LineNumber: 461
	; LineNumber: 463
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr539
	sta new_status
	lda #>check_collisions_stringassignstr539
	sta new_status+1
	jsr update_status
	; LineNumber: 464
	jsr combat
	; LineNumber: 466
	jmp check_collisions_caseend509
check_collisions_casenext537
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext541
	; LineNumber: 470
	; LineNumber: 472
	jmp check_collisions_caseend509
check_collisions_casenext541
	; LineNumber: 476
	; LineNumber: 479
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 480
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 485
	
; // Unknown
; //_A:=charat;
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr544
	sta new_status
	lda #>check_collisions_stringassignstr544
	sta new_status+1
	jsr update_status
	; LineNumber: 486
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 487
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 489
check_collisions_caseend509
	; LineNumber: 492
	rts
block1
	; LineNumber: 498
	
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 502
	
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 503
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 530
MainProgram_while546
MainProgram_loopstart550
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed642
	jmp MainProgram_ConditionalTrueBlock547
MainProgram_localfailed642
	jmp MainProgram_elsedoneblock549
MainProgram_ConditionalTrueBlock547: ;Main true block ;keep 
	; LineNumber: 530
	; LineNumber: 535
	
; // Borked, will need some work
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 539
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 542
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr644
	sta new_status
	lda #>MainProgram_stringassignstr644
	sta new_status+1
	jsr update_status
	; LineNumber: 543
	jsr display_text
	; LineNumber: 547
MainProgram_while646
MainProgram_loopstart650
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed692
	jmp MainProgram_ConditionalTrueBlock647
MainProgram_localfailed692
	jmp MainProgram_elsedoneblock649
MainProgram_ConditionalTrueBlock647: ;Main true block ;keep 
	; LineNumber: 548
	; LineNumber: 553
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 554
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 557
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 560
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext695
	; LineNumber: 562
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock700
MainProgram_ConditionalTrueBlock698: ;Main true block ;keep 
	; LineNumber: 562
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock700
	jmp MainProgram_caseend694
MainProgram_casenext695
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext703
	; LineNumber: 563
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock708
MainProgram_ConditionalTrueBlock706: ;Main true block ;keep 
	; LineNumber: 563
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock708
	jmp MainProgram_caseend694
MainProgram_casenext703
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext711
	; LineNumber: 564
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock716
MainProgram_ConditionalTrueBlock714: ;Main true block ;keep 
	; LineNumber: 564
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock716
	jmp MainProgram_caseend694
MainProgram_casenext711
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext719
	; LineNumber: 565
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock724
MainProgram_ConditionalTrueBlock722: ;Main true block ;keep 
	; LineNumber: 565
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock724
MainProgram_casenext719
MainProgram_caseend694
	; LineNumber: 573
	
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
	; LineNumber: 577
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock730
MainProgram_ConditionalTrueBlock728: ;Main true block ;keep 
	; LineNumber: 578
	; LineNumber: 581
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
	; LineNumber: 583
MainProgram_elsedoneblock730
	; LineNumber: 589
	
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
	; LineNumber: 593
	
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
	; LineNumber: 597
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 599
	jmp MainProgram_while646
MainProgram_elsedoneblock649
MainProgram_loopend651
	; LineNumber: 603
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 606
	jmp MainProgram_while546
MainProgram_elsedoneblock549
MainProgram_loopend551
	; LineNumber: 608
	; End of program
	; Ending memory block at $810
show_start_screen_stringassignstr294		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr296		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr298		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr300		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr302		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr304		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr306		dc.b	"(C)2022"
	dc.b	0
show_start_screen_stringassignstr308		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr310		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr312		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr314		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr316		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr318		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr322		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr324		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr326		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr328		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr330		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr332		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr334		dc.b	"(C)2022"
	dc.b	0
show_start_screen_stringassignstr336		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr338		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr340		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr342		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr344		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr346		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr348		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr356		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr359		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr362		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr365		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr367		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr369		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr372		dc.b	"                    "
	dc.b	0
door_stringassignstr381		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr388		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr391		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr398		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr401		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr408		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr411		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr418		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr422		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr426		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr430		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr437		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr440		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr447		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr450		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr457		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr460		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr467		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr471		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr475		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr483		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr486		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr497		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr500		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr512		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr516		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr522		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr526		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr530		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr535		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr539		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr544		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr553		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr644		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
EndBlock810:
	org $6000
StartBlock6000:
	org $6000
charset:
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///c64chars.bin"
EndBlock6000:
