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
	; LineNumber: 474
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
	incbin "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///levels/map - Tiles.bin"
	; LineNumber: 31
levels_level
	incbin "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///levels/map.bin"
	; LineNumber: 32
levels_level_p	= $0D
	; LineNumber: 29
	; LineNumber: 35
player_char	dc.b	$00
	; LineNumber: 36
space_char	dc.b	$20
	; LineNumber: 38
key_press	dc.b	$00
	; LineNumber: 39
charat	dc.b	0
	; LineNumber: 40
game_won	dc.b	0
	; LineNumber: 40
game_running	dc.b	0
	; LineNumber: 41
x	dc.b	0
	; LineNumber: 41
y	dc.b	0
	; LineNumber: 41
oldx	dc.b	0
	; LineNumber: 41
oldy	dc.b	0
	; LineNumber: 43
new_status	= $10
	; LineNumber: 43
the_status	= $12
	; LineNumber: 43
p	= $22
	; LineNumber: 46
keys	dc.b	$00
	; LineNumber: 47
gold	dc.w	$00
	; LineNumber: 48
health	dc.b	$0c
	; LineNumber: 51
attack	dc.b	$0c
	; LineNumber: 52
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
	
; // Source
; // Dest
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 86
levels_draw_level
	; LineNumber: 89
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 90
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
	; LineNumber: 101
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop218
	; LineNumber: 94
	; LineNumber: 99
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop237
	; LineNumber: 96
	; LineNumber: 97
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
	; LineNumber: 98
	jsr levels_draw_tile
	; LineNumber: 99
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
	; LineNumber: 100
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
	; LineNumber: 103
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 110
levels_refresh_screen
	; LineNumber: 112
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 126
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop251
	; LineNumber: 117
	; LineNumber: 118
	
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
	; LineNumber: 120
	; memcpyfast
	ldy levels_detected_screen_width
	dey
levels_refresh_screen_memcpy260
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy260
	; LineNumber: 125
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd261
	inc levels_temp_s+1
levels_refresh_screen_WordAdd261
	; LineNumber: 126
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
	; LineNumber: 128
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 194
	; LineNumber: 193
levels_buf_x	dc.b	0
	; LineNumber: 193
levels_buf_y	dc.b	0
levels_get_buffer_block263
levels_get_buffer
	; LineNumber: 196
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
	; LineNumber: 198
	; LineNumber: 199
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 204
	; LineNumber: 203
levels_plot_x	dc.b	0
	; LineNumber: 203
levels_plot_y	dc.b	0
	; LineNumber: 203
levels_plot_ch	dc.b	0
levels_plot_buffer_block270
levels_plot_buffer
	; LineNumber: 206
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
	; LineNumber: 207
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 209
	rts
	
; //player inventory/stats
; // ********************************
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 60
init
	; LineNumber: 62
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 66
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 67
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 71
	
; // Clean the screen buffer		
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 72
	lda space_char
	ldy #0
init_fill278
	sta (p),y
	iny
	cpy #$fa
	bne init_fill278
	; LineNumber: 74
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd279
	inc p+1
init_WordAdd279
	; LineNumber: 75
	lda space_char
	ldy #0
init_fill280
	sta (p),y
	iny
	cpy #$fa
	bne init_fill280
	; LineNumber: 77
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd281
	inc p+1
init_WordAdd281
	; LineNumber: 78
	lda space_char
	ldy #0
init_fill282
	sta (p),y
	iny
	cpy #$fa
	bne init_fill282
	; LineNumber: 80
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd283
	inc p+1
init_WordAdd283
	; LineNumber: 81
	lda space_char
	ldy #0
init_fill284
	sta (p),y
	iny
	cpy #$fa
	bne init_fill284
	; LineNumber: 84
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 86
	lda #$a
	; Calling storevariable on generic assign expression
	sta levels_tiles_across
	; LineNumber: 105
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 107
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 108
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 111
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 112
	jsr levels_draw_level
	; LineNumber: 115
	
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
	; LineNumber: 118
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 119
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : c64_chars
	;    Procedure type : User-defined procedure
	; LineNumber: 125
	; LineNumber: 124
dest	= $24
	; LineNumber: 124
temp_s	= $68
c64_chars_block285
c64_chars
	; LineNumber: 128
	
; // Set to use the new characterset
	; Set bank
	lda #$2
	sta $dd00
	; LineNumber: 129
	lda $d018
	and #%11110001
	ora #8
	sta $d018
	; LineNumber: 132
	
; // Force the screen address
	; Integer constant assigning
	ldy #$44
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 135
	
; // Tells basic routines where screen memory is located
	; Poke
	; Optimization: shift is zero
	lda #$44
	sta $288
	; LineNumber: 138
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 141
	
; // Black screen
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $d020
	; LineNumber: 142
	; Poke
	; Optimization: shift is zero
	sta $d021
	; LineNumber: 146
	
; // Ensure no flashing cursor
	jsr txt_cursor_off
	; LineNumber: 148
	rts
	
; // Force the screen address
; // Clear screen,
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 189
show_start_screen
	; LineNumber: 191
	jsr txt_cls
	; LineNumber: 192
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed318
	jmp show_start_screen_ConditionalTrueBlock288
show_start_screen_localfailed318
	jmp show_start_screen_elsedoneblock290
show_start_screen_ConditionalTrueBlock288: ;Main true block ;keep 
	; LineNumber: 193
	; LineNumber: 196
	
; //                         01234567890123456789012
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 197
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 198
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
	; LineNumber: 199
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 200
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
	; LineNumber: 201
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
	; LineNumber: 202
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
	; LineNumber: 203
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 204
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
	; LineNumber: 205
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 206
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
	; LineNumber: 207
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
	; LineNumber: 208
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 209
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
	; LineNumber: 210
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 211
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
	; LineNumber: 212
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
	; LineNumber: 213
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
	; LineNumber: 214
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
	; LineNumber: 215
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
	; LineNumber: 216
show_start_screen_elsedoneblock290
	; LineNumber: 220
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 221
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 224
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr346
	sta txt_in_str
	lda #>show_start_screen_stringassignstr346
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 225
	jsr txt_print_space
	; LineNumber: 228
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 229
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 232
	jsr txt_wait_key
	; LineNumber: 235
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 240
show_end_screen
	; LineNumber: 242
	jsr txt_cls
	; LineNumber: 243
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock351
show_end_screen_ConditionalTrueBlock350: ;Main true block ;keep 
	; LineNumber: 243
	; LineNumber: 245
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr360
	sta txt_in_str
	lda #>show_end_screen_stringassignstr360
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 247
	jmp show_end_screen_elsedoneblock352
show_end_screen_elseblock351
	; LineNumber: 248
	; LineNumber: 249
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr363
	sta txt_in_str
	lda #>show_end_screen_stringassignstr363
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 250
show_end_screen_elsedoneblock352
	; LineNumber: 253
	
; // Wait for keypress
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
	; LineNumber: 255
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 257
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
	; LineNumber: 259
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 261
	jsr txt_wait_key
	; LineNumber: 264
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 269
display_text
	; LineNumber: 271
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 272
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 273
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr370
	sta txt_in_str
	lda #>display_text_stringassignstr370
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 274
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 275
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 276
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 278
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 279
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 280
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 281
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 283
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 284
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 285
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 286
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 289
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 290
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 291
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 292
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 293
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 294
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 297
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 298
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 299
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 300
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 303
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 304
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 305
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 306
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 307
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 308
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 310
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 314
	; LineNumber: 313
update_status_block372
update_status
	; LineNumber: 315
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 316
	jsr display_text
	; LineNumber: 318
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 322
door
	; LineNumber: 325
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed426
	jmp door_ConditionalTrueBlock375
door_localfailed426
	jmp door_elseblock376
door_ConditionalTrueBlock375: ;Main true block ;keep 
	; LineNumber: 326
	; LineNumber: 327
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 328
	; Assigning a string : new_status
	lda #<door_stringassignstr428
	sta new_status
	lda #>door_stringassignstr428
	sta new_status+1
	jsr update_status
	; LineNumber: 330
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock433
door_ConditionalTrueBlock431: ;Main true block ;keep 
	; LineNumber: 329
	; Assigning a string : new_status
	lda #<door_stringassignstr438
	sta new_status
	lda #>door_stringassignstr438
	sta new_status+1
	jsr update_status
door_elsedoneblock433
	; LineNumber: 331
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock443
door_ConditionalTrueBlock441: ;Main true block ;keep 
	; LineNumber: 330
	; Assigning a string : new_status
	lda #<door_stringassignstr448
	sta new_status
	lda #>door_stringassignstr448
	sta new_status+1
	jsr update_status
door_elsedoneblock443
	; LineNumber: 332
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock453
door_ConditionalTrueBlock451: ;Main true block ;keep 
	; LineNumber: 331
	; Assigning a string : new_status
	lda #<door_stringassignstr458
	sta new_status
	lda #>door_stringassignstr458
	sta new_status+1
	jsr update_status
door_elsedoneblock453
	; LineNumber: 333
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock463
door_ConditionalTrueBlock461: ;Main true block ;keep 
	; LineNumber: 334
	; LineNumber: 335
	; Assigning a string : new_status
	lda #<door_stringassignstr469
	sta new_status
	lda #>door_stringassignstr469
	sta new_status+1
	jsr update_status
	; LineNumber: 336
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd471
	inc levels_current_level+1
door_WordAdd471
	; LineNumber: 337
	; Test Inc dec D
	dec y
	; LineNumber: 338
	jsr levels_draw_level
	; LineNumber: 339
door_elsedoneblock463
	; LineNumber: 341
	jmp door_elsedoneblock377
door_elseblock376
	; LineNumber: 342
	; LineNumber: 343
	; Assigning a string : new_status
	lda #<door_stringassignstr473
	sta new_status
	lda #>door_stringassignstr473
	sta new_status+1
	jsr update_status
	; LineNumber: 346
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 347
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 348
door_elsedoneblock377
	; LineNumber: 350
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 354
combat
	; LineNumber: 357
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
	bcc combat_elseblock478
combat_ConditionalTrueBlock477: ;Main true block ;keep 
	; LineNumber: 358
	; LineNumber: 359
	; Assigning a string : new_status
	lda #<combat_stringassignstr495
	sta new_status
	lda #>combat_stringassignstr495
	sta new_status+1
	jsr update_status
	; LineNumber: 360
	jmp combat_elsedoneblock479
combat_elseblock478
	; LineNumber: 362
	; LineNumber: 364
	; Test Inc dec D
	dec health
	; LineNumber: 367
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 368
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 370
	; Assigning a string : new_status
	lda #<combat_stringassignstr498
	sta new_status
	lda #>combat_stringassignstr498
	sta new_status+1
	jsr update_status
	; LineNumber: 372
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock501
	bcs combat_elsedoneblock503
combat_ConditionalTrueBlock501: ;Main true block ;keep 
	; LineNumber: 373
	; LineNumber: 374
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 375
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 376
combat_elsedoneblock503
	; LineNumber: 378
combat_elsedoneblock479
	; LineNumber: 380
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 386
check_collisions
	; LineNumber: 389
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext508
	; LineNumber: 393
	; LineNumber: 395
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr510
	sta new_status
	lda #>check_collisions_stringassignstr510
	sta new_status+1
	jsr update_status
	; LineNumber: 396
	jsr combat
	; LineNumber: 398
	jmp check_collisions_caseend507
check_collisions_casenext508
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext512
	; LineNumber: 401
	; LineNumber: 402
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr514
	sta new_status
	lda #>check_collisions_stringassignstr514
	sta new_status+1
	jsr update_status
	; LineNumber: 403
	jmp check_collisions_caseend507
check_collisions_casenext512
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext516
	; LineNumber: 405
	; LineNumber: 407
	jsr door
	; LineNumber: 408
	jmp check_collisions_caseend507
check_collisions_casenext516
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext518
	; LineNumber: 410
	; LineNumber: 412
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 413
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr520
	sta new_status
	lda #>check_collisions_stringassignstr520
	sta new_status+1
	jsr update_status
	; LineNumber: 414
	jmp check_collisions_caseend507
check_collisions_casenext518
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext522
	; LineNumber: 418
	; LineNumber: 419
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 420
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr524
	sta new_status
	lda #>check_collisions_stringassignstr524
	sta new_status+1
	jsr update_status
	; LineNumber: 422
	jmp check_collisions_caseend507
check_collisions_casenext522
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext526
	; LineNumber: 424
	; LineNumber: 427
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr528
	sta new_status
	lda #>check_collisions_stringassignstr528
	sta new_status+1
	jsr update_status
	; LineNumber: 428
	jsr combat
	; LineNumber: 429
	jmp check_collisions_caseend507
check_collisions_casenext526
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext530
	; LineNumber: 432
	; LineNumber: 433
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd532
	inc gold+1
check_collisions_WordAdd532
	; LineNumber: 434
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr533
	sta new_status
	lda #>check_collisions_stringassignstr533
	sta new_status+1
	jsr update_status
	; LineNumber: 436
	jmp check_collisions_caseend507
check_collisions_casenext530
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext535
	; LineNumber: 439
	; LineNumber: 441
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr537
	sta new_status
	lda #>check_collisions_stringassignstr537
	sta new_status+1
	jsr update_status
	; LineNumber: 442
	jsr combat
	; LineNumber: 444
	jmp check_collisions_caseend507
check_collisions_casenext535
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext539
	; LineNumber: 448
	; LineNumber: 450
	jmp check_collisions_caseend507
check_collisions_casenext539
	; LineNumber: 454
	; LineNumber: 457
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 458
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 463
	
; // Unknown
; //_A:=charat;
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr542
	sta new_status
	lda #>check_collisions_stringassignstr542
	sta new_status+1
	jsr update_status
	; LineNumber: 464
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 465
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 467
check_collisions_caseend507
	; LineNumber: 470
	rts
block1
	; LineNumber: 476
	
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 480
	
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 481
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 508
MainProgram_while544
MainProgram_loopstart548
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed640
	jmp MainProgram_ConditionalTrueBlock545
MainProgram_localfailed640
	jmp MainProgram_elsedoneblock547
MainProgram_ConditionalTrueBlock545: ;Main true block ;keep 
	; LineNumber: 508
	; LineNumber: 513
	
; // Borked, will need some work
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 517
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 520
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr642
	sta new_status
	lda #>MainProgram_stringassignstr642
	sta new_status+1
	jsr update_status
	; LineNumber: 521
	jsr display_text
	; LineNumber: 525
MainProgram_while644
MainProgram_loopstart648
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed690
	jmp MainProgram_ConditionalTrueBlock645
MainProgram_localfailed690
	jmp MainProgram_elsedoneblock647
MainProgram_ConditionalTrueBlock645: ;Main true block ;keep 
	; LineNumber: 526
	; LineNumber: 531
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 532
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 535
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 538
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext693
	; LineNumber: 540
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock698
MainProgram_ConditionalTrueBlock696: ;Main true block ;keep 
	; LineNumber: 540
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock698
	jmp MainProgram_caseend692
MainProgram_casenext693
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext701
	; LineNumber: 541
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock706
MainProgram_ConditionalTrueBlock704: ;Main true block ;keep 
	; LineNumber: 541
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock706
	jmp MainProgram_caseend692
MainProgram_casenext701
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext709
	; LineNumber: 542
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock714
MainProgram_ConditionalTrueBlock712: ;Main true block ;keep 
	; LineNumber: 542
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock714
	jmp MainProgram_caseend692
MainProgram_casenext709
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext717
	; LineNumber: 543
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock722
MainProgram_ConditionalTrueBlock720: ;Main true block ;keep 
	; LineNumber: 543
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock722
MainProgram_casenext717
MainProgram_caseend692
	; LineNumber: 551
	
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
	; LineNumber: 555
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock728
MainProgram_ConditionalTrueBlock726: ;Main true block ;keep 
	; LineNumber: 556
	; LineNumber: 559
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
	; LineNumber: 561
MainProgram_elsedoneblock728
	; LineNumber: 567
	
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
	; LineNumber: 571
	
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
	; LineNumber: 575
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 577
	jmp MainProgram_while644
MainProgram_elsedoneblock647
MainProgram_loopend649
	; LineNumber: 581
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 584
	jmp MainProgram_while544
MainProgram_elsedoneblock547
MainProgram_loopend549
	; LineNumber: 586
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
show_start_screen_stringassignstr304		dc.b	"(C)2021"
	dc.b	0
show_start_screen_stringassignstr306		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr308		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr310		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr312		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr314		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr316		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr320		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr322		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr324		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr326		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr328		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr330		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr332		dc.b	"(C)2021"
	dc.b	0
show_start_screen_stringassignstr334		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr336		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr338		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr340		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr342		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr344		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr346		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr354		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr357		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr360		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr363		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr365		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr367		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr370		dc.b	"                    "
	dc.b	0
door_stringassignstr379		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr386		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr389		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr396		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr399		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr406		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr409		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr416		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr420		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr424		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr428		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr435		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr438		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr445		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr448		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr455		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr458		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr465		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr469		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr473		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr481		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr484		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr495		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr498		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr510		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr514		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr520		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr524		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr528		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr533		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr537		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr542		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr551		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr642		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
	org $6000
charset
	incbin "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///levels/map - Chars.bin"
EndBlock6000
