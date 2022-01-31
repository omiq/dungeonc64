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
	; LineNumber: 558
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
levels_level1
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map1.bin"
	; LineNumber: 34
levels_level2
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map2.bin"
	; LineNumber: 35
levels_level3
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map3.bin"
	; LineNumber: 36
	; LineNumber: 42
player_char	dc.b	$00
	; LineNumber: 43
space_char	dc.b	$20
	; LineNumber: 45
key_press	dc.b	$00
	; LineNumber: 46
charat	dc.b	0
	; LineNumber: 47
game_won	dc.b	0
	; LineNumber: 47
game_running	dc.b	0
	; LineNumber: 48
x	dc.b	0
	; LineNumber: 48
y	dc.b	0
	; LineNumber: 48
oldx	dc.b	0
	; LineNumber: 48
oldy	dc.b	0
	; LineNumber: 50
new_status	= $10
	; LineNumber: 50
the_status	= $12
	; LineNumber: 50
p	= $22
	; LineNumber: 53
keys	dc.b	$00
	; LineNumber: 54
gold	dc.w	$00
	; LineNumber: 55
health	dc.b	$0c
	; LineNumber: 58
attack	dc.b	$0c
	; LineNumber: 59
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
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 40
	; LineNumber: 39
levels_buf_x	dc.b	0
	; LineNumber: 39
levels_buf_y	dc.b	0
levels_get_buffer_block197
levels_get_buffer
	; LineNumber: 42
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var200 = $56
	sta levels_get_buffer_rightvarInteger_var200
	sty levels_get_buffer_rightvarInteger_var200+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var203 = $58
	sta levels_get_buffer_rightvarInteger_var203
	sty levels_get_buffer_rightvarInteger_var203+1
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
	adc levels_get_buffer_rightvarInteger_var203
levels_get_buffer_wordAdd201
	sta levels_get_buffer_rightvarInteger_var203
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var203+1
	tay
	lda levels_get_buffer_rightvarInteger_var203
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var200
levels_get_buffer_wordAdd198
	sta levels_get_buffer_rightvarInteger_var200
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var200+1
	tay
	lda levels_get_buffer_rightvarInteger_var200
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 44
	; LineNumber: 45
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 50
	; LineNumber: 49
levels_plot_x	dc.b	0
	; LineNumber: 49
levels_plot_y	dc.b	0
	; LineNumber: 49
levels_plot_ch	dc.b	0
levels_plot_buffer_block204
levels_plot_buffer
	; LineNumber: 52
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var207 = $56
	sta levels_plot_buffer_rightvarInteger_var207
	sty levels_plot_buffer_rightvarInteger_var207+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var210 = $58
	sta levels_plot_buffer_rightvarInteger_var210
	sty levels_plot_buffer_rightvarInteger_var210+1
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
	adc levels_plot_buffer_rightvarInteger_var210
levels_plot_buffer_wordAdd208
	sta levels_plot_buffer_rightvarInteger_var210
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var210+1
	tay
	lda levels_plot_buffer_rightvarInteger_var210
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var207
levels_plot_buffer_wordAdd205
	sta levels_plot_buffer_rightvarInteger_var207
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var207+1
	tay
	lda levels_plot_buffer_rightvarInteger_var207
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 53
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 55
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_tile
	;    Procedure type : User-defined procedure
	; LineNumber: 64
	; LineNumber: 61
levels_tremainder	dc.b	0
	; LineNumber: 62
levels_trow	dc.b	0
	; LineNumber: 63
levels_tile_cell	dc.w	0
levels_draw_tile_block211
levels_draw_tile
	; LineNumber: 67
	
; // Get starting byte
	; Modulo
	lda #$7
levels_draw_tile_val_var212 = $56
	sta levels_draw_tile_val_var212
	lda levels_tile_no
	sec
levels_draw_tile_modulo213
	sbc levels_draw_tile_val_var212
	bcs levels_draw_tile_modulo213
	adc levels_draw_tile_val_var212
	; Calling storevariable on generic assign expression
	sta levels_tremainder
	; LineNumber: 68
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
	; LineNumber: 69
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
levels_draw_tile_rightvarInteger_var218 = $56
	sta levels_draw_tile_rightvarInteger_var218
	sty levels_draw_tile_rightvarInteger_var218+1
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
	adc levels_draw_tile_rightvarInteger_var218
levels_draw_tile_wordAdd216
	sta levels_draw_tile_rightvarInteger_var218
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var218+1
	tay
	lda levels_draw_tile_rightvarInteger_var218
	; Calling storevariable on generic assign expression
	sta levels_tile_cell
	sty levels_tile_cell+1
	; LineNumber: 73
	
; // ROW 1
	; INTEGER optimization: a=b+c 
	lda #<levels_tiles
	clc
	adc levels_tile_cell
	sta levels_temp_s+0
	lda #>levels_tiles
	adc levels_tile_cell+1
	sta levels_temp_s+1
	; LineNumber: 74
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
levels_draw_tile_rightvarInteger_var222 = $56
	sta levels_draw_tile_rightvarInteger_var222
	sty levels_draw_tile_rightvarInteger_var222+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var225 = $58
	sta levels_draw_tile_rightvarInteger_var225
	sty levels_draw_tile_rightvarInteger_var225+1
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
	adc levels_draw_tile_rightvarInteger_var225
levels_draw_tile_wordAdd223
	sta levels_draw_tile_rightvarInteger_var225
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var225+1
	tay
	lda levels_draw_tile_rightvarInteger_var225
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var222
levels_draw_tile_wordAdd220
	sta levels_draw_tile_rightvarInteger_var222
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var222+1
	tay
	lda levels_draw_tile_rightvarInteger_var222
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 75
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy226
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy226
	; LineNumber: 78
	
; // ROW 2
	lda levels_temp_s
	clc
	adc #$15
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd227
	inc levels_temp_s+1
levels_draw_tile_WordAdd227
	; LineNumber: 79
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd228
	inc levels_dest+1
levels_draw_tile_WordAdd228
	; LineNumber: 80
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy229
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy229
	; LineNumber: 83
	
; // ROW 3
	lda levels_temp_s
	clc
	adc #$15
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd230
	inc levels_temp_s+1
levels_draw_tile_WordAdd230
	; LineNumber: 84
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd231
	inc levels_dest+1
levels_draw_tile_WordAdd231
	; LineNumber: 85
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy232
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy232
	; LineNumber: 87
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 94
levels_draw_level
	; LineNumber: 97
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 99
	; Binary clause INTEGER: EQUALS
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bne levels_draw_level_elsedoneblock237
	lda levels_current_level
	cmp #$00 ;keep
	bne levels_draw_level_elsedoneblock237
	jmp levels_draw_level_ConditionalTrueBlock235
levels_draw_level_ConditionalTrueBlock235: ;Main true block ;keep 
	; LineNumber: 100
	; LineNumber: 101
	lda #<levels_level1
	ldx #>levels_level1
	sta levels_level_p
	stx levels_level_p+1
	; LineNumber: 102
levels_draw_level_elsedoneblock237
	; LineNumber: 104
	; Binary clause INTEGER: EQUALS
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bne levels_draw_level_elsedoneblock243
	lda levels_current_level
	cmp #$01 ;keep
	bne levels_draw_level_elsedoneblock243
	jmp levels_draw_level_ConditionalTrueBlock241
levels_draw_level_ConditionalTrueBlock241: ;Main true block ;keep 
	; LineNumber: 105
	; LineNumber: 106
	lda #<levels_level2
	ldx #>levels_level2
	sta levels_level_p
	stx levels_level_p+1
	; LineNumber: 107
levels_draw_level_elsedoneblock243
	; LineNumber: 109
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bcc levels_draw_level_elsedoneblock249
	bne levels_draw_level_ConditionalTrueBlock247
	lda levels_current_level
	cmp #$01 ;keep
	bcc levels_draw_level_elsedoneblock249
	beq levels_draw_level_elsedoneblock249
levels_draw_level_ConditionalTrueBlock247: ;Main true block ;keep 
	; LineNumber: 110
	; LineNumber: 111
	lda #<levels_level3
	ldx #>levels_level3
	sta levels_level_p
	stx levels_level_p+1
	; LineNumber: 112
levels_draw_level_elsedoneblock249
	; LineNumber: 123
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop252
	; LineNumber: 116
	; LineNumber: 121
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop271
	; LineNumber: 118
	; LineNumber: 119
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
	; LineNumber: 120
	jsr levels_draw_tile
	; LineNumber: 121
levels_draw_level_forloopcounter273
levels_draw_level_loopstart274
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda levels_tiles_across
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop271
levels_draw_level_loopdone282: ;keep
levels_draw_level_forloopend272
levels_draw_level_loopend275
	; LineNumber: 122
levels_draw_level_forloopcounter254
levels_draw_level_loopstart255
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_y
	lda #$6
	cmp levels_t_y ;keep
	bne levels_draw_level_forloop252
levels_draw_level_loopdone283: ;keep
levels_draw_level_forloopend253
levels_draw_level_loopend256
	; LineNumber: 128
	
; // Let's drop some keys
; // Key = 75
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$4b
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 129
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$4b
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 132
	
; // Gobbo
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$57
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 135
	
; // Gold
	lda #$c
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5a
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 138
	
; // Rat
	lda #$12
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5e
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 142
	
; // Health
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$e
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$53
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 145
	
; // South Door
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$11
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$43
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 148
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 155
levels_refresh_screen
	; LineNumber: 157
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 176
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop285
	; LineNumber: 162
	; LineNumber: 163
	
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
	; LineNumber: 169
	; memcpyfast
	ldy levels_detected_screen_width
	dey
levels_refresh_screen_memcpy294
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy294
	; LineNumber: 175
	
; //MemCpy16(temp_s, dest, detected_screen_width);
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd295
	inc levels_temp_s+1
levels_refresh_screen_WordAdd295
	; LineNumber: 176
levels_refresh_screen_forloopcounter287
levels_refresh_screen_loopstart288
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop285
levels_refresh_screen_loopdone296: ;keep
levels_refresh_screen_forloopend286
levels_refresh_screen_loopend289
	; LineNumber: 178
	rts
	
; //player inventory/stats
; // ********************************
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 67
init
	; LineNumber: 69
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 73
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 74
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 78
	
; // Clean the screen buffer		
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 79
	lda space_char
	ldy #0
init_fill298
	sta (p),y
	iny
	cpy #$fa
	bne init_fill298
	; LineNumber: 81
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd299
	inc p+1
init_WordAdd299
	; LineNumber: 82
	lda space_char
	ldy #0
init_fill300
	sta (p),y
	iny
	cpy #$fa
	bne init_fill300
	; LineNumber: 84
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd301
	inc p+1
init_WordAdd301
	; LineNumber: 85
	lda space_char
	ldy #0
init_fill302
	sta (p),y
	iny
	cpy #$fa
	bne init_fill302
	; LineNumber: 87
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd303
	inc p+1
init_WordAdd303
	; LineNumber: 88
	lda space_char
	ldy #0
init_fill304
	sta (p),y
	iny
	cpy #$fa
	bne init_fill304
	; LineNumber: 91
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 94
	
; // Set how wide the map should be
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_tiles_across
	; LineNumber: 115
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 117
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 118
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 121
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 122
	jsr levels_draw_level
	; LineNumber: 125
	
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
	; LineNumber: 128
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 130
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : c64_chars
	;    Procedure type : User-defined procedure
	; LineNumber: 136
	; LineNumber: 135
dest	= $24
	; LineNumber: 135
temp_s	= $68
c64_chars_block305
c64_chars
	; LineNumber: 139
	
; // Set to use the new characterset
	; Set bank
	lda #$2
	sta $dd00
	; LineNumber: 140
	lda $d018
	and #%11110001
	ora #8
	sta $d018
	; LineNumber: 143
	
; // Force the screen address
	; Integer constant assigning
	ldy #$44
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 146
	
; // Tells basic routines where screen memory is located
	; Poke
	; Optimization: shift is zero
	lda #$44
	sta $288
	; LineNumber: 149
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 152
	
; // Black screen
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $d020
	; LineNumber: 153
	; Poke
	; Optimization: shift is zero
	sta $d021
	; LineNumber: 157
	
; // Ensure no flashing cursor
	jsr txt_cursor_off
	; LineNumber: 159
	rts
	
; // Force the screen address
; // Clear screen,
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 210
show_start_screen
	; LineNumber: 212
	jsr txt_cls
	; LineNumber: 213
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed338
	jmp show_start_screen_ConditionalTrueBlock308
show_start_screen_localfailed338
	jmp show_start_screen_elsedoneblock310
show_start_screen_ConditionalTrueBlock308: ;Main true block ;keep 
	; LineNumber: 214
	; LineNumber: 217
	
; //                         01234567890123456789012
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 218
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 219
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
	; LineNumber: 220
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 221
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
	; LineNumber: 222
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
	; LineNumber: 223
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
	; LineNumber: 224
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 225
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
	; LineNumber: 226
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 227
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
	; LineNumber: 228
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr352
	sta txt_in_str
	lda #>show_start_screen_stringassignstr352
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
	lda #<show_start_screen_stringassignstr354
	sta txt_in_str
	lda #>show_start_screen_stringassignstr354
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 231
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 232
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr356
	sta txt_in_str
	lda #>show_start_screen_stringassignstr356
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
	lda #<show_start_screen_stringassignstr358
	sta txt_in_str
	lda #>show_start_screen_stringassignstr358
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
	lda #<show_start_screen_stringassignstr360
	sta txt_in_str
	lda #>show_start_screen_stringassignstr360
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
	lda #<show_start_screen_stringassignstr362
	sta txt_in_str
	lda #>show_start_screen_stringassignstr362
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 236
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr364
	sta txt_in_str
	lda #>show_start_screen_stringassignstr364
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 237
show_start_screen_elsedoneblock310
	; LineNumber: 241
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 242
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 245
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr366
	sta txt_in_str
	lda #>show_start_screen_stringassignstr366
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 246
	jsr txt_print_space
	; LineNumber: 249
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 250
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 253
	jsr txt_wait_key
	; LineNumber: 256
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 261
show_end_screen
	; LineNumber: 263
	jsr txt_cls
	; LineNumber: 264
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock371
show_end_screen_ConditionalTrueBlock370: ;Main true block ;keep 
	; LineNumber: 264
	; LineNumber: 266
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr380
	sta txt_in_str
	lda #>show_end_screen_stringassignstr380
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 268
	jmp show_end_screen_elsedoneblock372
show_end_screen_elseblock371
	; LineNumber: 269
	; LineNumber: 270
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr383
	sta txt_in_str
	lda #>show_end_screen_stringassignstr383
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 271
show_end_screen_elsedoneblock372
	; LineNumber: 274
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr385
	sta txt_in_str
	lda #>show_end_screen_stringassignstr385
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 276
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 278
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr387
	sta txt_in_str
	lda #>show_end_screen_stringassignstr387
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 280
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 282
	jsr txt_wait_key
	; LineNumber: 285
	rts
	
; //@ifndef ATARI800		
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 290
display_text
	; LineNumber: 292
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 293
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 294
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr390
	sta txt_in_str
	lda #>display_text_stringassignstr390
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 295
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 296
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 297
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 299
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 300
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 301
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 302
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 304
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 305
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 306
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 307
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 310
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 311
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 312
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 313
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 314
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 315
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 318
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 319
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 320
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 321
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 324
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 325
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 326
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 327
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 328
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 329
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 331
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 335
update_status_block392
update_status
	; LineNumber: 336
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 337
	jsr display_text
	; LineNumber: 339
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 343
door
	; LineNumber: 346
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed473
	jmp door_ConditionalTrueBlock395
door_localfailed473: ;keep
	; ; logical OR, second chance
	; Binary clause Simplified: EQUALS
	lda charat
	; Compare with pure num / var optimization
	cmp #$5d;keep
	bne door_localfailed472
	jmp door_ConditionalTrueBlock395
door_localfailed472
	jmp door_elseblock396
door_ConditionalTrueBlock395: ;Main true block ;keep 
	; LineNumber: 346
	; LineNumber: 350
	; Binary clause Simplified: NOTEQUALS
	lda charat
	; Compare with pure num / var optimization
	cmp #$5d;keep
	beq door_elsedoneblock478
door_ConditionalTrueBlock476: ;Main true block ;keep 
	; LineNumber: 350
	; LineNumber: 352
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 353
	; Assigning a string : new_status
	lda #<door_stringassignstr483
	sta new_status
	lda #>door_stringassignstr483
	sta new_status+1
	jsr update_status
	; LineNumber: 355
	
; // Place the open door
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda y
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5d
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 358
door_elsedoneblock478
	; LineNumber: 362
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock488
door_ConditionalTrueBlock486: ;Main true block ;keep 
	; LineNumber: 361
	; Assigning a string : new_status
	lda #<door_stringassignstr493
	sta new_status
	lda #>door_stringassignstr493
	sta new_status+1
	jsr update_status
door_elsedoneblock488
	; LineNumber: 363
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock498
door_ConditionalTrueBlock496: ;Main true block ;keep 
	; LineNumber: 362
	; Assigning a string : new_status
	lda #<door_stringassignstr503
	sta new_status
	lda #>door_stringassignstr503
	sta new_status+1
	jsr update_status
door_elsedoneblock498
	; LineNumber: 366
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock508
door_ConditionalTrueBlock506: ;Main true block ;keep 
	; LineNumber: 367
	; LineNumber: 368
	; Binary clause INTEGER: GREATEREQUAL
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bcc door_elsedoneblock524
	bne door_ConditionalTrueBlock522
	lda levels_current_level
	cmp #$01 ;keep
	bcc door_elsedoneblock524
door_ConditionalTrueBlock522: ;Main true block ;keep 
	; LineNumber: 367
	
; // North Door
	lda levels_current_level
	sec
	sbc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs door_WordAdd528
	dec levels_current_level+1
door_WordAdd528
door_elsedoneblock524
	; LineNumber: 369
	; Assigning a string : new_status
	lda #<door_stringassignstr529
	sta new_status
	lda #>door_stringassignstr529
	sta new_status+1
	jsr update_status
	; LineNumber: 370
	lda #$10
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 371
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 372
	jsr levels_draw_level
	; LineNumber: 374
	
; // Place the open door
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$11
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5d
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 375
door_elsedoneblock508
	; LineNumber: 378
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock534
door_ConditionalTrueBlock532: ;Main true block ;keep 
	; LineNumber: 379
	; LineNumber: 382
	
; // South Door
; // Ta-da
	; Assigning a string : new_status
	lda #<door_stringassignstr540
	sta new_status
	lda #>door_stringassignstr540
	sta new_status+1
	jsr update_status
	; LineNumber: 383
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd542
	inc levels_current_level+1
door_WordAdd542
	; LineNumber: 384
	lda #$1
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 385
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 386
	jsr levels_draw_level
	; LineNumber: 388
	
; // Place the open door
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5d
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 389
door_elsedoneblock534
	; LineNumber: 393
	
; // Reset to new position
	; 8 bit binop
	; Add/sub right value is variable/expression
	; 8 bit binop
	; Add/sub where right value is constant number
	lda oldx
	sec
	sbc x
	 ; end add / sub var with constant
door_rightvarAddSub_var543 = $56
	sta door_rightvarAddSub_var543
	lda x
	sec
	sbc door_rightvarAddSub_var543
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 394
	; 8 bit binop
	; Add/sub right value is variable/expression
	; 8 bit binop
	; Add/sub where right value is constant number
	lda oldy
	sec
	sbc y
	 ; end add / sub var with constant
door_rightvarAddSub_var544 = $56
	sta door_rightvarAddSub_var544
	lda y
	sec
	sbc door_rightvarAddSub_var544
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 397
	jmp door_elsedoneblock397
door_elseblock396
	; LineNumber: 398
	; LineNumber: 399
	; Assigning a string : new_status
	lda #<door_stringassignstr546
	sta new_status
	lda #>door_stringassignstr546
	sta new_status+1
	jsr update_status
	; LineNumber: 402
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 403
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 404
door_elsedoneblock397
	; LineNumber: 406
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 410
combat
	; LineNumber: 413
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
	bcc combat_localfailed585
	jmp combat_ConditionalTrueBlock550
combat_localfailed585
	jmp combat_elseblock551
combat_ConditionalTrueBlock550: ;Main true block ;keep 
	; LineNumber: 414
	; LineNumber: 416
	; Binary clause Simplified: EQUALS
	lda charat
	; Compare with pure num / var optimization
	cmp #$57;keep
	bne combat_elseblock591
combat_ConditionalTrueBlock590: ;Main true block ;keep 
	; LineNumber: 417
	; LineNumber: 419
	
; // Gobbo drops key
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda y
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$4b
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 422
	
; // Reset player to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 423
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 424
	; Assigning a string : new_status
	lda #<combat_stringassignstr600
	sta new_status
	lda #>combat_stringassignstr600
	sta new_status+1
	jsr update_status
	; LineNumber: 425
	jmp combat_elsedoneblock592
combat_elseblock591
	; LineNumber: 427
	; LineNumber: 428
	; Assigning a string : new_status
	lda #<combat_stringassignstr603
	sta new_status
	lda #>combat_stringassignstr603
	sta new_status+1
	jsr update_status
	; LineNumber: 429
combat_elsedoneblock592
	; LineNumber: 430
	jmp combat_elsedoneblock552
combat_elseblock551
	; LineNumber: 432
	; LineNumber: 434
	; Test Inc dec D
	dec health
	; LineNumber: 437
	
; // Repel to position
	; 8 bit binop
	; Add/sub where right value is constant number
	; Right is PURE NUMERIC : Is word =0
	; 8 bit mul of power 2
	; 8 bit binop
	; Add/sub where right value is constant number
	lda oldx
	sec
	sbc x
	 ; end add / sub var with constant
	asl
	clc
	adc x
	 ; end add / sub var with constant
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 438
	; 8 bit binop
	; Add/sub where right value is constant number
	; Right is PURE NUMERIC : Is word =0
	; 8 bit mul of power 2
	; 8 bit binop
	; Add/sub where right value is constant number
	lda oldy
	sec
	sbc y
	 ; end add / sub var with constant
	asl
	clc
	adc y
	 ; end add / sub var with constant
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 442
	
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
	; LineNumber: 443
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq combat_elsedoneblock609
combat_ConditionalTrueBlock607: ;Main true block ;keep 
	; LineNumber: 444
	; LineNumber: 445
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 446
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 447
combat_elsedoneblock609
	; LineNumber: 449
	; Assigning a string : new_status
	lda #<combat_stringassignstr612
	sta new_status
	lda #>combat_stringassignstr612
	sta new_status+1
	jsr update_status
	; LineNumber: 451
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock615
	bcs combat_elsedoneblock617
combat_ConditionalTrueBlock615: ;Main true block ;keep 
	; LineNumber: 452
	; LineNumber: 453
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 454
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 455
combat_elsedoneblock617
	; LineNumber: 457
combat_elsedoneblock552
	; LineNumber: 459
	rts
	
; //@endif
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 465
check_collisions
	; LineNumber: 468
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext622
	; LineNumber: 472
	; LineNumber: 474
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr624
	sta new_status
	lda #>check_collisions_stringassignstr624
	sta new_status+1
	jsr update_status
	; LineNumber: 475
	jsr combat
	; LineNumber: 477
	jmp check_collisions_caseend621
check_collisions_casenext622
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext626
	; LineNumber: 480
	; LineNumber: 481
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr628
	sta new_status
	lda #>check_collisions_stringassignstr628
	sta new_status+1
	jsr update_status
	; LineNumber: 482
	jmp check_collisions_caseend621
check_collisions_casenext626
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext630
	; LineNumber: 484
	; LineNumber: 486
	jsr door
	; LineNumber: 487
	jmp check_collisions_caseend621
check_collisions_casenext630
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext632
	; LineNumber: 489
	; LineNumber: 491
	
; // Opendoor
	jsr door
	; LineNumber: 492
	jmp check_collisions_caseend621
check_collisions_casenext632
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext634
	; LineNumber: 494
	; LineNumber: 496
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 497
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr636
	sta new_status
	lda #>check_collisions_stringassignstr636
	sta new_status+1
	jsr update_status
	; LineNumber: 498
	jmp check_collisions_caseend621
check_collisions_casenext634
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext638
	; LineNumber: 502
	; LineNumber: 503
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 504
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr640
	sta new_status
	lda #>check_collisions_stringassignstr640
	sta new_status+1
	jsr update_status
	; LineNumber: 506
	jmp check_collisions_caseend621
check_collisions_casenext638
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext642
	; LineNumber: 508
	; LineNumber: 511
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr644
	sta new_status
	lda #>check_collisions_stringassignstr644
	sta new_status+1
	jsr update_status
	; LineNumber: 512
	jsr combat
	; LineNumber: 513
	jmp check_collisions_caseend621
check_collisions_casenext642
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext646
	; LineNumber: 516
	; LineNumber: 517
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd648
	inc gold+1
check_collisions_WordAdd648
	; LineNumber: 518
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr649
	sta new_status
	lda #>check_collisions_stringassignstr649
	sta new_status+1
	jsr update_status
	; LineNumber: 520
	jmp check_collisions_caseend621
check_collisions_casenext646
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext651
	; LineNumber: 523
	; LineNumber: 525
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr653
	sta new_status
	lda #>check_collisions_stringassignstr653
	sta new_status+1
	jsr update_status
	; LineNumber: 526
	jsr combat
	; LineNumber: 528
	jmp check_collisions_caseend621
check_collisions_casenext651
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext655
	; LineNumber: 532
	; LineNumber: 534
	jmp check_collisions_caseend621
check_collisions_casenext655
	; LineNumber: 538
	; LineNumber: 541
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 542
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 547
	
; // Unknown
; //_A:=charat;
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr658
	sta new_status
	lda #>check_collisions_stringassignstr658
	sta new_status+1
	jsr update_status
	; LineNumber: 548
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 549
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 551
check_collisions_caseend621
	; LineNumber: 554
	rts
block1
	; LineNumber: 560
	
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 564
	
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 565
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 592
MainProgram_while660
MainProgram_loopstart664
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed756
	jmp MainProgram_ConditionalTrueBlock661
MainProgram_localfailed756
	jmp MainProgram_elsedoneblock663
MainProgram_ConditionalTrueBlock661: ;Main true block ;keep 
	; LineNumber: 592
	; LineNumber: 597
	
; // Borked, will need some work
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 601
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 604
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr758
	sta new_status
	lda #>MainProgram_stringassignstr758
	sta new_status+1
	jsr update_status
	; LineNumber: 605
	jsr display_text
	; LineNumber: 609
MainProgram_while760
MainProgram_loopstart764
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed806
	jmp MainProgram_ConditionalTrueBlock761
MainProgram_localfailed806
	jmp MainProgram_elsedoneblock763
MainProgram_ConditionalTrueBlock761: ;Main true block ;keep 
	; LineNumber: 610
	; LineNumber: 615
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 616
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 619
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 622
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext809
	; LineNumber: 624
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock814
MainProgram_ConditionalTrueBlock812: ;Main true block ;keep 
	; LineNumber: 624
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock814
	jmp MainProgram_caseend808
MainProgram_casenext809
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext817
	; LineNumber: 625
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock822
MainProgram_ConditionalTrueBlock820: ;Main true block ;keep 
	; LineNumber: 625
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock822
	jmp MainProgram_caseend808
MainProgram_casenext817
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext825
	; LineNumber: 626
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock830
MainProgram_ConditionalTrueBlock828: ;Main true block ;keep 
	; LineNumber: 626
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock830
	jmp MainProgram_caseend808
MainProgram_casenext825
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext833
	; LineNumber: 627
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock838
MainProgram_ConditionalTrueBlock836: ;Main true block ;keep 
	; LineNumber: 627
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock838
MainProgram_casenext833
MainProgram_caseend808
	; LineNumber: 635
	
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
	; LineNumber: 639
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock844
MainProgram_ConditionalTrueBlock842: ;Main true block ;keep 
	; LineNumber: 640
	; LineNumber: 643
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
	; LineNumber: 645
MainProgram_elsedoneblock844
	; LineNumber: 651
	
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
	; LineNumber: 655
	
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
	; LineNumber: 659
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 661
	jmp MainProgram_while760
MainProgram_elsedoneblock763
MainProgram_loopend765
	; LineNumber: 665
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 668
	jmp MainProgram_while660
MainProgram_elsedoneblock663
MainProgram_loopend665
	; LineNumber: 670
	; End of program
	; Ending memory block at $810
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
show_start_screen_stringassignstr324		dc.b	"(C)2022"
	dc.b	0
show_start_screen_stringassignstr326		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr328		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr330		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr332		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr334		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr336		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr340		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr342		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr344		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr346		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr348		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr350		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr352		dc.b	"(C)2022"
	dc.b	0
show_start_screen_stringassignstr354		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr356		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr358		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr360		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr362		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr364		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr366		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr374		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr377		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr380		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr383		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr385		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr387		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr390		dc.b	"                    "
	dc.b	0
door_stringassignstr404		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr407		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr414		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr417		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr424		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr427		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr442		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr453		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr460		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr464		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr470		dc.b	"YOU NEED A KEY!                    "
	dc.b	0
door_stringassignstr480		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr483		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr490		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr493		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr500		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr503		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr518		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr529		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr536		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr540		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr546		dc.b	"YOU NEED A KEY!                    "
	dc.b	0
combat_stringassignstr559		dc.b	"GOBBO DROPPED A KEY!             "
	dc.b	0
combat_stringassignstr562		dc.b	"YOU WON THIS FIGHT               "
	dc.b	0
combat_stringassignstr565		dc.b	"GOBBO DROPPED A KEY!             "
	dc.b	0
combat_stringassignstr568		dc.b	"YOU WON THIS FIGHT               "
	dc.b	0
combat_stringassignstr577		dc.b	"YOU LOST THIS FIGHT                  "
	dc.b	0
combat_stringassignstr594		dc.b	"GOBBO DROPPED A KEY!             "
	dc.b	0
combat_stringassignstr597		dc.b	"YOU WON THIS FIGHT               "
	dc.b	0
combat_stringassignstr600		dc.b	"GOBBO DROPPED A KEY!             "
	dc.b	0
combat_stringassignstr603		dc.b	"YOU WON THIS FIGHT               "
	dc.b	0
combat_stringassignstr612		dc.b	"YOU LOST THIS FIGHT                  "
	dc.b	0
check_collisions_stringassignstr624		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr628		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr636		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr640		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr644		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr649		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr653		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr658		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr667		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr758		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
EndBlock810:
	org $6000
StartBlock6000:
	org $6000
charset:
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///c64chars.bin"
EndBlock6000:
