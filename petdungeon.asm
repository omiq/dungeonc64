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
	; LineNumber: 372
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
levels_level_p	= $0D
	; LineNumber: 17
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
new_status	= $10
	; LineNumber: 27
the_status	= $12
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
	; LineNumber: 23
	; LineNumber: 22
	; LineNumber: 22
	; LineNumber: 22
levels_draw_tile_block197
levels_draw_tile
	; LineNumber: 26
	
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
levels_draw_tile_rightvarInteger_var203 = $56
	sta levels_draw_tile_rightvarInteger_var203
	sty levels_draw_tile_rightvarInteger_var203+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var206 = $58
	sta levels_draw_tile_rightvarInteger_var206
	sty levels_draw_tile_rightvarInteger_var206+1
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
	; LineNumber: 30
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy207
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy207
	; LineNumber: 32
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd208
	inc levels_temp_s+1
levels_draw_tile_WordAdd208
	; LineNumber: 33
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd209
	inc levels_dest+1
levels_draw_tile_WordAdd209
	; LineNumber: 34
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy210
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy210
	; LineNumber: 36
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd211
	inc levels_dest+1
levels_draw_tile_WordAdd211
	; LineNumber: 37
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd212
	inc levels_temp_s+1
levels_draw_tile_WordAdd212
	; LineNumber: 38
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy213
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy213
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
	; LineNumber: 63
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop218
	; LineNumber: 56
	; LineNumber: 61
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop237
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
levels_draw_level_forloopcounter239
levels_draw_level_loopstart240
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda #$a
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop237
levels_draw_level_loopdone248: ;keep
levels_draw_level_forloopend238
levels_draw_level_loopend241
	; LineNumber: 62
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
levels_refresh_screen_forloop251
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
levels_refresh_screen_memcpy260
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy260
	; LineNumber: 80
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd261
	inc levels_temp_s+1
levels_refresh_screen_WordAdd261
	; LineNumber: 81
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
levels_get_buffer_block263
levels_get_buffer
	; LineNumber: 92
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
levels_plot_buffer_block270
levels_plot_buffer
	; LineNumber: 102
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
	; NodeProcedureDecl -1
	; ***********  Defining procedure : c64_chars
	;    Procedure type : User-defined procedure
	; LineNumber: 73
	; LineNumber: 72
dest	= $22
	; LineNumber: 72
temp_s	= $24
c64_chars_block278
c64_chars
	; LineNumber: 76
	
; // Set to use the new characterset
	; Set bank
	lda #$2
	sta $dd00
	; LineNumber: 77
	lda $d018
	and #%11110001
	ora #8
	sta $d018
	; LineNumber: 80
	
; // Force the screen address
	; Integer constant assigning
	ldy #$44
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 83
	
; // Tells basic routines where screen memory is located
	; Poke
	; Optimization: shift is zero
	lda #$44
	sta $288
	; LineNumber: 86
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 89
	
; // Black screen
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $d020
	; LineNumber: 90
	; Poke
	; Optimization: shift is zero
	sta $d021
	; LineNumber: 94
	
; // Ensure no flashing cursor
	jsr txt_cursor_off
	; LineNumber: 96
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 101
show_start_screen
	; LineNumber: 103
	jsr txt_cls
	; LineNumber: 104
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed317
	jmp show_start_screen_ConditionalTrueBlock281
show_start_screen_localfailed317
	jmp show_start_screen_elsedoneblock283
show_start_screen_ConditionalTrueBlock281: ;Main true block ;keep 
	; LineNumber: 105
	; LineNumber: 107
	
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 108
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 109
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr319
	sta txt_in_str
	lda #>show_start_screen_stringassignstr319
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 110
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 111
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr321
	sta txt_in_str
	lda #>show_start_screen_stringassignstr321
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 112
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
	; LineNumber: 113
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
	; LineNumber: 114
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 115
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
	; LineNumber: 116
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 117
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
	; LineNumber: 118
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
	; LineNumber: 119
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 120
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
	; LineNumber: 121
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 122
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
	; LineNumber: 123
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
	; LineNumber: 124
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
	; LineNumber: 125
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
	; LineNumber: 126
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
	; LineNumber: 127
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
	; LineNumber: 128
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
	; LineNumber: 129
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
	; LineNumber: 130
show_start_screen_elsedoneblock283
	; LineNumber: 133
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 134
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 135
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr351
	sta txt_in_str
	lda #>show_start_screen_stringassignstr351
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 136
	jsr txt_print_space
	; LineNumber: 137
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 138
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 139
	jsr txt_wait_key
	; LineNumber: 142
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 147
show_end_screen
	; LineNumber: 149
	jsr txt_cls
	; LineNumber: 150
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock356
show_end_screen_ConditionalTrueBlock355: ;Main true block ;keep 
	; LineNumber: 150
	; LineNumber: 152
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr365
	sta txt_in_str
	lda #>show_end_screen_stringassignstr365
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 154
	jmp show_end_screen_elsedoneblock357
show_end_screen_elseblock356
	; LineNumber: 155
	; LineNumber: 156
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr368
	sta txt_in_str
	lda #>show_end_screen_stringassignstr368
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 157
show_end_screen_elsedoneblock357
	; LineNumber: 160
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr370
	sta txt_in_str
	lda #>show_end_screen_stringassignstr370
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda #$28
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 161
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 162
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
	; LineNumber: 163
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 164
	jsr txt_wait_key
	; LineNumber: 167
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 170
display_text
	; LineNumber: 172
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 173
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 174
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr375
	sta txt_in_str
	lda #>display_text_stringassignstr375
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 175
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 176
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 177
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 179
	lda #$19
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 180
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 181
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 182
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 184
	lda #$19
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$17
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 185
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 186
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 187
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 190
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 191
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 192
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 193
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 194
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 195
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 198
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 199
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 200
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 201
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 204
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$17
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 205
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 206
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 207
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 208
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 209
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 214
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 217
	; LineNumber: 216
update_status_block377
update_status
	; LineNumber: 219
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 220
	jsr display_text
	; LineNumber: 222
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 226
door
	; LineNumber: 229
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed431
	jmp door_ConditionalTrueBlock380
door_localfailed431
	jmp door_elseblock381
door_ConditionalTrueBlock380: ;Main true block ;keep 
	; LineNumber: 230
	; LineNumber: 231
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 232
	; Assigning a string : new_status
	lda #<door_stringassignstr433
	sta new_status
	lda #>door_stringassignstr433
	sta new_status+1
	jsr update_status
	; LineNumber: 234
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock438
door_ConditionalTrueBlock436: ;Main true block ;keep 
	; LineNumber: 233
	; Assigning a string : new_status
	lda #<door_stringassignstr443
	sta new_status
	lda #>door_stringassignstr443
	sta new_status+1
	jsr update_status
door_elsedoneblock438
	; LineNumber: 235
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock448
door_ConditionalTrueBlock446: ;Main true block ;keep 
	; LineNumber: 234
	; Assigning a string : new_status
	lda #<door_stringassignstr453
	sta new_status
	lda #>door_stringassignstr453
	sta new_status+1
	jsr update_status
door_elsedoneblock448
	; LineNumber: 236
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock458
door_ConditionalTrueBlock456: ;Main true block ;keep 
	; LineNumber: 235
	; Assigning a string : new_status
	lda #<door_stringassignstr463
	sta new_status
	lda #>door_stringassignstr463
	sta new_status+1
	jsr update_status
door_elsedoneblock458
	; LineNumber: 237
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock468
door_ConditionalTrueBlock466: ;Main true block ;keep 
	; LineNumber: 238
	; LineNumber: 239
	; Assigning a string : new_status
	lda #<door_stringassignstr474
	sta new_status
	lda #>door_stringassignstr474
	sta new_status+1
	jsr update_status
	; LineNumber: 240
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd476
	inc levels_current_level+1
door_WordAdd476
	; LineNumber: 241
	; Test Inc dec D
	dec y
	; LineNumber: 242
	jsr levels_draw_level
	; LineNumber: 243
door_elsedoneblock468
	; LineNumber: 245
	jmp door_elsedoneblock382
door_elseblock381
	; LineNumber: 246
	; LineNumber: 247
	; Assigning a string : new_status
	lda #<door_stringassignstr478
	sta new_status
	lda #>door_stringassignstr478
	sta new_status+1
	jsr update_status
	; LineNumber: 250
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 251
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 252
door_elsedoneblock382
	; LineNumber: 254
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 258
combat
	; LineNumber: 261
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
	bcc combat_elseblock483
combat_ConditionalTrueBlock482: ;Main true block ;keep 
	; LineNumber: 262
	; LineNumber: 263
	; Assigning a string : new_status
	lda #<combat_stringassignstr500
	sta new_status
	lda #>combat_stringassignstr500
	sta new_status+1
	jsr update_status
	; LineNumber: 264
	jmp combat_elsedoneblock484
combat_elseblock483
	; LineNumber: 266
	; LineNumber: 268
	; Test Inc dec D
	dec health
	; LineNumber: 271
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 272
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 274
	; Assigning a string : new_status
	lda #<combat_stringassignstr503
	sta new_status
	lda #>combat_stringassignstr503
	sta new_status+1
	jsr update_status
	; LineNumber: 276
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock506
	bcs combat_elsedoneblock508
combat_ConditionalTrueBlock506: ;Main true block ;keep 
	; LineNumber: 277
	; LineNumber: 278
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 279
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 280
combat_elsedoneblock508
	; LineNumber: 282
combat_elsedoneblock484
	; LineNumber: 284
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 288
check_collisions
	; LineNumber: 291
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext513
	; LineNumber: 295
	; LineNumber: 297
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr515
	sta new_status
	lda #>check_collisions_stringassignstr515
	sta new_status+1
	jsr update_status
	; LineNumber: 298
	jsr combat
	; LineNumber: 300
	jmp check_collisions_caseend512
check_collisions_casenext513
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext517
	; LineNumber: 303
	; LineNumber: 304
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr519
	sta new_status
	lda #>check_collisions_stringassignstr519
	sta new_status+1
	jsr update_status
	; LineNumber: 305
	jmp check_collisions_caseend512
check_collisions_casenext517
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext521
	; LineNumber: 306
	jsr door
	jmp check_collisions_caseend512
check_collisions_casenext521
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext523
	; LineNumber: 309
	; LineNumber: 311
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 312
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr525
	sta new_status
	lda #>check_collisions_stringassignstr525
	sta new_status+1
	jsr update_status
	; LineNumber: 313
	jmp check_collisions_caseend512
check_collisions_casenext523
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext527
	; LineNumber: 317
	; LineNumber: 318
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 319
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr529
	sta new_status
	lda #>check_collisions_stringassignstr529
	sta new_status+1
	jsr update_status
	; LineNumber: 321
	jmp check_collisions_caseend512
check_collisions_casenext527
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext531
	; LineNumber: 323
	; LineNumber: 326
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr533
	sta new_status
	lda #>check_collisions_stringassignstr533
	sta new_status+1
	jsr update_status
	; LineNumber: 327
	jsr combat
	; LineNumber: 328
	jmp check_collisions_caseend512
check_collisions_casenext531
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext535
	; LineNumber: 331
	; LineNumber: 332
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd537
	inc gold+1
check_collisions_WordAdd537
	; LineNumber: 333
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr538
	sta new_status
	lda #>check_collisions_stringassignstr538
	sta new_status+1
	jsr update_status
	; LineNumber: 335
	jmp check_collisions_caseend512
check_collisions_casenext535
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext540
	; LineNumber: 338
	; LineNumber: 340
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr542
	sta new_status
	lda #>check_collisions_stringassignstr542
	sta new_status+1
	jsr update_status
	; LineNumber: 341
	jsr combat
	; LineNumber: 343
	jmp check_collisions_caseend512
check_collisions_casenext540
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext544
	; LineNumber: 347
	; LineNumber: 349
	jmp check_collisions_caseend512
check_collisions_casenext544
	; LineNumber: 353
	; LineNumber: 356
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 357
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 360
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 361
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr547
	sta new_status
	lda #>check_collisions_stringassignstr547
	sta new_status+1
	jsr update_status
	; LineNumber: 362
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 363
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 365
check_collisions_caseend512
	; LineNumber: 368
	rts
block1
	; LineNumber: 378
	
; // ********************************
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 379
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 386
MainProgram_while549
MainProgram_loopstart553
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed669
	jmp MainProgram_ConditionalTrueBlock550
MainProgram_localfailed669
	jmp MainProgram_elsedoneblock552
MainProgram_ConditionalTrueBlock550: ;Main true block ;keep 
	; LineNumber: 386
	; LineNumber: 391
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 395
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 396
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr671
	sta new_status
	lda #>MainProgram_stringassignstr671
	sta new_status+1
	jsr update_status
	; LineNumber: 397
	jsr display_text
	; LineNumber: 401
MainProgram_while673
MainProgram_loopstart677
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed731
	jmp MainProgram_ConditionalTrueBlock674
MainProgram_localfailed731
	jmp MainProgram_elsedoneblock676
MainProgram_ConditionalTrueBlock674: ;Main true block ;keep 
	; LineNumber: 402
	; LineNumber: 407
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 408
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 411
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 414
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext734
	; LineNumber: 416
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock739
MainProgram_ConditionalTrueBlock737: ;Main true block ;keep 
	; LineNumber: 416
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock739
	jmp MainProgram_caseend733
MainProgram_casenext734
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext742
	; LineNumber: 417
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock747
MainProgram_ConditionalTrueBlock745: ;Main true block ;keep 
	; LineNumber: 417
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock747
	jmp MainProgram_caseend733
MainProgram_casenext742
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext750
	; LineNumber: 418
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock755
MainProgram_ConditionalTrueBlock753: ;Main true block ;keep 
	; LineNumber: 418
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock755
	jmp MainProgram_caseend733
MainProgram_casenext750
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext758
	; LineNumber: 419
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock763
MainProgram_ConditionalTrueBlock761: ;Main true block ;keep 
	; LineNumber: 419
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock763
MainProgram_casenext758
MainProgram_caseend733
	; LineNumber: 427
	
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
	; LineNumber: 431
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock769
MainProgram_ConditionalTrueBlock767: ;Main true block ;keep 
	; LineNumber: 432
	; LineNumber: 435
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock781
MainProgram_ConditionalTrueBlock779: ;Main true block ;keep 
	; LineNumber: 434
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock781
	; LineNumber: 439
MainProgram_elsedoneblock769
	; LineNumber: 445
	
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
	; LineNumber: 449
	
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
	; LineNumber: 453
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 455
	jmp MainProgram_while673
MainProgram_elsedoneblock676
MainProgram_loopend678
	; LineNumber: 459
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 462
	jmp MainProgram_while549
MainProgram_elsedoneblock552
MainProgram_loopend554
	; LineNumber: 464
	; End of program
	; Ending memory block
EndBlock810
show_start_screen_stringassignstr285		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr287		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr289		dc.b	"A DUNGEON CRAWL ADVENTURE"
	dc.b	0
show_start_screen_stringassignstr291		dc.b	"FOR COMMODORE PET AND C64"
	dc.b	0
show_start_screen_stringassignstr293		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr295		dc.b	"CHRIS GARRETT / RETROGAMECODERS"
	dc.b	0
show_start_screen_stringassignstr297		dc.b	"(C)2021"
	dc.b	0
show_start_screen_stringassignstr299		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr301		dc.b	"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr303		dc.b	"@ = YOU"
	dc.b	0
show_start_screen_stringassignstr305		dc.b	"k = KEY"
	dc.b	0
show_start_screen_stringassignstr307		dc.b	"c = DOOR"
	dc.b	0
show_start_screen_stringassignstr309		dc.b	"s = HEALTH"
	dc.b	0
show_start_screen_stringassignstr311		dc.b	"x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr313		dc.b	"z = GEM"
	dc.b	0
show_start_screen_stringassignstr315		dc.b	"rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr319		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr321		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr323		dc.b	"A DUNGEON CRAWL ADVENTURE"
	dc.b	0
show_start_screen_stringassignstr325		dc.b	"FOR COMMODORE PET AND C64"
	dc.b	0
show_start_screen_stringassignstr327		dc.b	"ddddddddddddddddddddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr329		dc.b	"CHRIS GARRETT / RETROGAMECODERS"
	dc.b	0
show_start_screen_stringassignstr331		dc.b	"(C)2021"
	dc.b	0
show_start_screen_stringassignstr333		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr335		dc.b	"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr337		dc.b	"@ = YOU"
	dc.b	0
show_start_screen_stringassignstr339		dc.b	"k = KEY"
	dc.b	0
show_start_screen_stringassignstr341		dc.b	"c = DOOR"
	dc.b	0
show_start_screen_stringassignstr343		dc.b	"s = HEALTH"
	dc.b	0
show_start_screen_stringassignstr345		dc.b	"x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr347		dc.b	"z = GEM"
	dc.b	0
show_start_screen_stringassignstr349		dc.b	"rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr351		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
show_end_screen_stringassignstr359		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr362		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr365		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr368		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr370		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr372		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr375		dc.b	"                    "
	dc.b	0
door_stringassignstr384		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr391		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr394		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr401		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr404		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr411		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr414		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr421		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr425		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr429		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr433		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr440		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr443		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr450		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr453		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr460		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr463		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr470		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr474		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr478		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr486		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr489		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr500		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr503		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr515		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr519		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr525		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr529		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr533		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr538		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr542		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr547		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr556		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr671		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
	org $6000
charset
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/chars.bin"
EndBlock6000
