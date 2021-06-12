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
	; LineNumber: 191
	jmp block1
	; LineNumber: 5
txt_temp_address_p	= $02
	; LineNumber: 6
txt_ytab	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w 0
	; LineNumber: 12
txt_next_digit	dc.w	0
	; LineNumber: 13
txt_temp_num_p	=  $04
	; LineNumber: 14
txt_temp_num	dc.w	0
	; LineNumber: 15
txt_temp_i	dc.b	$00
	; LineNumber: 5
levels_r	dc.b	0
	; LineNumber: 23
levels_temp_s	=  $08
	; LineNumber: 23
levels_dest	=  $16
	; LineNumber: 23
levels_ch_index	=  $0B
	; LineNumber: 27
levels_screen_buffer	dc.b	 
	org levels_screen_buffer+1000
	; LineNumber: 30
levels_level
	incbin "/Users/chris.garrett/GitHub/dungeonc64///map.flf"
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
	; LineNumber: 29
keys	dc.b	$00
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
	; LineNumber: 254
txt_cls
	; LineNumber: 255
	; Assigning to register
	; Assigning register : _a
	lda #$93
	; LineNumber: 256
	jsr $ffd2
	; LineNumber: 257
	jsr txt_DefineScreen
	; LineNumber: 260
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_DefineScreen
	;    Procedure type : User-defined procedure
	; LineNumber: 266
	; LineNumber: 264
txt_temp_c_p	=  $0D
	; LineNumber: 265
txt_y	dc.b	0
txt_DefineScreen_block5
txt_DefineScreen
	; LineNumber: 268
	; Binary clause INTEGER: NOTEQUALS
	; Load Integer array
	ldx #0 ; watch for bug, Integer array has max index of 128
	lda txt_ytab,x
	ldy txt_ytab+1,x
txt_DefineScreen_rightvarInteger_var11 = $54
	sta txt_DefineScreen_rightvarInteger_var11
	sty txt_DefineScreen_rightvarInteger_var11+1
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_DefineScreen_rightvarInteger_var11+1   ; compare high bytes
	cmp #$00 ;keep
	beq txt_DefineScreen_pass112
	jmp txt_DefineScreen_ConditionalTrueBlock7
txt_DefineScreen_pass112
	lda txt_DefineScreen_rightvarInteger_var11
	cmp #$00 ;keep
	beq txt_DefineScreen_elsedoneblock9
	jmp txt_DefineScreen_ConditionalTrueBlock7
txt_DefineScreen_ConditionalTrueBlock7: ;Main true block ;keep 
	; LineNumber: 269
	; LineNumber: 270
	rts
	; LineNumber: 271
txt_DefineScreen_elsedoneblock9
	; LineNumber: 273
	lda #$00
	ldx #$04
	sta txt_temp_address_p
	stx txt_temp_address_p+1
	; LineNumber: 281
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop14
	; LineNumber: 276
	; LineNumber: 277
	ldy #$28 ; optimized, look out for bugs
	lda #$20
txt_DefineScreen_fill23
	sta (txt_temp_address_p),y
	dey
	bpl txt_DefineScreen_fill23
	; LineNumber: 278
	; integer assignment NodeVar
	ldy txt_temp_address_p+1 ; keep
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
	; LineNumber: 279
	lda txt_temp_address_p
	clc
	adc #$28
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd24
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd24
	; LineNumber: 280
txt_DefineScreen_forloopcounter16
txt_DefineScreen_loopstart17
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop14
txt_DefineScreen_loopdone25: ;keep
txt_DefineScreen_forloopend15
txt_DefineScreen_loopend18
	; LineNumber: 282
	lda #$00
	ldx #$d8
	sta txt_temp_c_p
	stx txt_temp_c_p+1
	; LineNumber: 283
	lda #$0
	ldy #0
txt_DefineScreen_fill26
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill26
	; LineNumber: 284
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd27
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd27
	; LineNumber: 285
	lda #$0
	ldy #0
txt_DefineScreen_fill28
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill28
	; LineNumber: 286
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd29
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd29
	; LineNumber: 287
	lda #$0
	ldy #0
txt_DefineScreen_fill30
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill30
	; LineNumber: 288
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd31
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd31
	; LineNumber: 289
	lda #$0
	ldy #0
txt_DefineScreen_fill32
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill32
	; LineNumber: 291
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 296
	; LineNumber: 293
txt__text_x	dc.b	0
	; LineNumber: 293
txt__text_y	dc.b	0
txt_move_to_block33
txt_move_to
	; LineNumber: 297
	; ****** Inline assembler section
	clc
	; LineNumber: 298
	; Assigning to register
	; Assigning register : _y
	ldy txt__text_x
	; LineNumber: 299
	; Assigning to register
	; Assigning register : _x
	ldx txt__text_y
	; LineNumber: 300
	jsr $fff0
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 347
	; LineNumber: 346
txt_CH	dc.b	0
txt_put_ch_block34
txt_put_ch
	; LineNumber: 348
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 349
	jsr $ffd2
	; LineNumber: 351
	rts
	
; // Clear keyboard buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_clear_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 355
txt_clear_buffer
	; LineNumber: 357
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $c6
	; LineNumber: 358
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 364
	; LineNumber: 363
txt_ink	dc.b	$00
txt_get_key_block36
txt_get_key
	; LineNumber: 365
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 366
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 367
txt_get_key_while37
txt_get_key_loopstart41
	; Binary clause Simplified: EQUALS
	lda txt_ink
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_get_key_elsedoneblock40
txt_get_key_ConditionalTrueBlock38: ;Main true block ;keep 
	; LineNumber: 368
	; LineNumber: 369
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 370
	jmp txt_get_key_while37
txt_get_key_elsedoneblock40
txt_get_key_loopend42
	; LineNumber: 371
	jsr $e5b4
	; LineNumber: 372
	; Assigning from register
	sta txt_ink
	; LineNumber: 373
	rts
	; LineNumber: 374
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 379
	; LineNumber: 378
txt_tmp_key	dc.b	$00
txt_wait_key_block45
txt_wait_key
	; LineNumber: 381
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 382
txt_wait_key_while46
txt_wait_key_loopstart50
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock49
txt_wait_key_ConditionalTrueBlock47: ;Main true block ;keep 
	; LineNumber: 383
	; LineNumber: 384
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 385
	jmp txt_wait_key_while46
txt_wait_key_elsedoneblock49
txt_wait_key_loopend51
	; LineNumber: 387
	jsr txt_clear_buffer
	; LineNumber: 388
	rts
	
; //CURSOR_OFF
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_off
	;    Procedure type : User-defined procedure
	; LineNumber: 409
txt_cursor_off
	; LineNumber: 411
	; Poke
	; Optimization: shift is zero
	lda #$1
	sta $cc
	; LineNumber: 414
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 439
txt_cursor_return
	; LineNumber: 441
	; Assigning to register
	; Assigning register : _a
	lda #$d
	; LineNumber: 442
	jsr $ffd2
	; LineNumber: 444
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 465
	; LineNumber: 464
txt_next_ch	dc.b	0
	; LineNumber: 462
txt_in_str	=  $0D
	; LineNumber: 462
txt_CRLF	dc.b	$01
txt_print_string_block56
txt_print_string
	; LineNumber: 467
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 468
txt_print_string_while57
txt_print_string_loopstart61
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock60
txt_print_string_ConditionalTrueBlock58: ;Main true block ;keep 
	; LineNumber: 468
	; LineNumber: 470
	; Assigning to register
	; Assigning register : _a
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; LineNumber: 471
	jsr $ffd2
	; LineNumber: 472
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 473
	jmp txt_print_string_while57
txt_print_string_elsedoneblock60
txt_print_string_loopend62
	; LineNumber: 475
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock68
txt_print_string_ConditionalTrueBlock66: ;Main true block ;keep 
	; LineNumber: 476
	; LineNumber: 477
	jsr txt_cursor_return
	; LineNumber: 479
txt_print_string_elsedoneblock68
	; LineNumber: 480
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_dec
	;    Procedure type : User-defined procedure
	; LineNumber: 622
	; LineNumber: 621
txt__in_n	dc.b	0
	; LineNumber: 621
txt__add_cr	dc.b	0
txt_print_dec_block71
txt_print_dec
	; LineNumber: 624
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_digit
	sty txt_next_digit+1
	; LineNumber: 625
	lda #$00
	ldx #$00
	sta txt_temp_num_p
	stx txt_temp_num_p+1
	; LineNumber: 626
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 627
	; Calling storevariable on generic assign expression
	sta txt_temp_i
	; LineNumber: 629
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$a;keep
	bcc txt_print_dec_localfailed117
	jmp txt_print_dec_ConditionalTrueBlock73
txt_print_dec_localfailed117
	jmp txt_print_dec_elseblock74
txt_print_dec_ConditionalTrueBlock73: ;Main true block ;keep 
	; LineNumber: 629
	; LineNumber: 632
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed140
	jmp txt_print_dec_ConditionalTrueBlock120
txt_print_dec_localfailed140
	jmp txt_print_dec_elseblock121
txt_print_dec_ConditionalTrueBlock120: ;Main true block ;keep 
	; LineNumber: 633
	; LineNumber: 635
	
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
	; LineNumber: 636
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 640
	
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
txt_print_dec_rightvarInteger_var144 =  $56
	sta txt_print_dec_rightvarInteger_var144
	sty txt_print_dec_rightvarInteger_var144+1
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
	sbc txt_print_dec_rightvarInteger_var144
txt_print_dec_wordAdd142
	sta txt_print_dec_rightvarInteger_var144
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var144+1
	tay
	lda txt_print_dec_rightvarInteger_var144
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 641
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock148
	bne txt_print_dec_ConditionalTrueBlock146
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock148
	beq txt_print_dec_elsedoneblock148
txt_print_dec_ConditionalTrueBlock146: ;Main true block ;keep 
	; LineNumber: 640
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd152
	dec txt_temp_num+1
txt_print_dec_WordAdd152
txt_print_dec_elsedoneblock148
	; LineNumber: 642
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	lda txt_temp_num
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 645
	
; // right digit
	; Modulo
	lda #$a
txt_print_dec_val_var153 =  $56
	sta txt_print_dec_val_var153
	lda txt__in_n
	sec
txt_print_dec_modulo154
	sbc txt_print_dec_val_var153
	bcs txt_print_dec_modulo154
	adc txt_print_dec_val_var153
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 646
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 649
	jmp txt_print_dec_elsedoneblock122
txt_print_dec_elseblock121
	; LineNumber: 650
	; LineNumber: 653
	
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
	; LineNumber: 654
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 657
	
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
txt_print_dec_rightvarInteger_var157 =  $56
	sta txt_print_dec_rightvarInteger_var157
	sty txt_print_dec_rightvarInteger_var157+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var157+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var157
	bcs txt_print_dec_wordAdd156
	dey
txt_print_dec_wordAdd156
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 658
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 659
txt_print_dec_elsedoneblock122
	; LineNumber: 662
	jmp txt_print_dec_elsedoneblock75
txt_print_dec_elseblock74
	; LineNumber: 663
	; LineNumber: 664
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 665
txt_print_dec_elsedoneblock75
	; LineNumber: 667
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock162
txt_print_dec_ConditionalTrueBlock160: ;Main true block ;keep 
	; LineNumber: 666
	jsr txt_cursor_return
txt_print_dec_elsedoneblock162
	; LineNumber: 668
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 125
levels_draw_level
	; LineNumber: 205
	
; //		draw_tile(0,0,0);
; //		draw_tile(1,0,1);		
; //		draw_tile(2,0,1);		
; //		draw_tile(3,0,1);		
; //		draw_tile(4,0,1);		
; //		draw_tile(5,0,1);		
; //		draw_tile(6,0,1);		
; //		draw_tile(7,0,1);		
; //		draw_tile(8,0,1);		
; //		draw_tile(9,0,1);	
; //		draw_tile(10,0,2);	
; //		draw_tile(11,0,3);			
; //		draw_tile(12,0,2);	
; //
; //		draw_tile(0,1,4);
; //		draw_tile(1,1,5);		
; //		draw_tile(2,1,5);		
; //		draw_tile(3,1,5);		
; //		draw_tile(4,1,5);		
; //		draw_tile(5,1,5);		
; //		draw_tile(6,1,5);		
; //		draw_tile(7,1,5);		
; //		draw_tile(8,1,6);	
; //		
; //		draw_tile(0,2,4);
; //		draw_tile(1,2,5);		
; //		draw_tile(2,2,5);		
; //		draw_tile(3,2,5);		
; //		draw_tile(4,2,5);		
; //		draw_tile(5,2,5);		
; //		draw_tile(6,2,5);		
; //		draw_tile(7,2,5);		
; //		draw_tile(8,2,6);	
; //		
; //		draw_tile(0,3,4);
; //		draw_tile(1,3,5);		
; //		draw_tile(2,3,5);		
; //		draw_tile(3,3,5);		
; //		draw_tile(4,3,5);		
; //		draw_tile(5,3,5);		
; //		draw_tile(6,3,5);		
; //		draw_tile(7,3,5);		
; //		draw_tile(8,3,6);	
; //		
; //		draw_tile(0,4,4);
; //		draw_tile(1,4,5);		
; //		draw_tile(2,4,5);		
; //		draw_tile(3,4,5);		
; //		draw_tile(4,4,5);		
; //		draw_tile(5,4,5);		
; //		draw_tile(6,4,5);		
; //		draw_tile(7,4,5);		
; //		draw_tile(8,4,6);	
; //		
; //		
; //		draw_tile(0,5,0);
; //		draw_tile(1,5,1);		
; //		draw_tile(2,5,1);		
; //		draw_tile(3,5,1);		
; //		draw_tile(4,5,1);		
; //		draw_tile(5,5,1);		
; //		draw_tile(6,5,1);		
; //		draw_tile(7,5,1);		
; //		draw_tile(8,5,2);		
; //
; //		draw_tile(0,6,4);
; //		draw_tile(1,6,5);		
; //		draw_tile(2,6,5);		
; //		draw_tile(3,6,5);		
; //		draw_tile(4,6,5);		
; //		draw_tile(5,6,5);		
; //		draw_tile(6,6,5);		
; //		draw_tile(7,6,5);		
; //		draw_tile(8,6,6);	
; //		
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 207
	
; //temp_s:=#level;
	; INTEGER optimization: a=b+c 
	lda #<levels_level
	clc
	adc #$2d
	sta levels_temp_s+0
	lda #>levels_level
	adc #$00
	sta levels_temp_s+1
	; LineNumber: 214
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_draw_level_forloop167
	; LineNumber: 210
	; LineNumber: 211
	; memcpyfast
	ldy #39
levels_draw_level_memcpy177
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_level_memcpy177
	; LineNumber: 212
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd178
	inc levels_dest+1
levels_draw_level_WordAdd178
	; LineNumber: 213
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd179
	inc levels_temp_s+1
levels_draw_level_WordAdd179
	; LineNumber: 214
levels_draw_level_forloopcounter169
levels_draw_level_loopstart170
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_draw_level_forloop167
levels_draw_level_loopdone180: ;keep
levels_draw_level_forloopend168
levels_draw_level_loopend171
	; LineNumber: 217
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 235
levels_refresh_screen
	; LineNumber: 238
	
; //CopyFullScreen(#screen_buffer,SCREEN_CHAR_LOC);
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 247
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop182
	; LineNumber: 243
	; LineNumber: 244
	
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
	; LineNumber: 245
	; memcpyfast
	ldy #39
levels_refresh_screen_memcpy191
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy191
	; LineNumber: 246
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd192
	inc levels_temp_s+1
levels_refresh_screen_WordAdd192
	; LineNumber: 247
levels_refresh_screen_forloopcounter184
levels_refresh_screen_loopstart185
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop182
levels_refresh_screen_loopdone193: ;keep
levels_refresh_screen_forloopend183
levels_refresh_screen_loopend186
	; LineNumber: 251
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 256
	; LineNumber: 255
levels_buf_x	dc.b	0
	; LineNumber: 255
levels_buf_y	dc.b	0
levels_get_buffer_block194
levels_get_buffer
	; LineNumber: 258
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var197 =  $56
	sta levels_get_buffer_rightvarInteger_var197
	sty levels_get_buffer_rightvarInteger_var197+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var200 =  $58
	sta levels_get_buffer_rightvarInteger_var200
	sty levels_get_buffer_rightvarInteger_var200+1
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
	adc levels_get_buffer_rightvarInteger_var200
levels_get_buffer_wordAdd198
	sta levels_get_buffer_rightvarInteger_var200
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var200+1
	tay
	lda levels_get_buffer_rightvarInteger_var200
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var197
levels_get_buffer_wordAdd195
	sta levels_get_buffer_rightvarInteger_var197
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var197+1
	tay
	lda levels_get_buffer_rightvarInteger_var197
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 260
	; LineNumber: 261
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 266
	; LineNumber: 265
levels_plot_x	dc.b	0
	; LineNumber: 265
levels_plot_y	dc.b	0
	; LineNumber: 265
levels_plot_ch	dc.b	0
levels_plot_buffer_block201
levels_plot_buffer
	; LineNumber: 268
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var204 =  $56
	sta levels_plot_buffer_rightvarInteger_var204
	sty levels_plot_buffer_rightvarInteger_var204+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var207 =  $58
	sta levels_plot_buffer_rightvarInteger_var207
	sty levels_plot_buffer_rightvarInteger_var207+1
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
	adc levels_plot_buffer_rightvarInteger_var207
levels_plot_buffer_wordAdd205
	sta levels_plot_buffer_rightvarInteger_var207
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var207+1
	tay
	lda levels_plot_buffer_rightvarInteger_var207
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var204
levels_plot_buffer_wordAdd202
	sta levels_plot_buffer_rightvarInteger_var204
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var204+1
	tay
	lda levels_plot_buffer_rightvarInteger_var204
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 269
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 271
	rts
	
; //player inventory
; // ********************************
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 36
init
	; LineNumber: 39
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 40
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 43
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 46
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 48
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 49
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 52
	
; // Draw current level
	jsr levels_draw_level
	; LineNumber: 55
	
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
	; LineNumber: 58
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 59
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : c64_chars
	;    Procedure type : User-defined procedure
	; LineNumber: 65
	; LineNumber: 64
dest	=  $0D
	; LineNumber: 64
temp_s	=  $10
c64_chars_block209
c64_chars
	; LineNumber: 67
	
; // Set to use the new characterset
	; Set bank
	lda #$2
	sta $dd00
	; LineNumber: 68
	lda $d018
	and #%11110001
	ora #8
	sta $d018
	; LineNumber: 71
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 74
	
; // Black screen
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $d020
	; LineNumber: 75
	; Poke
	; Optimization: shift is zero
	sta $d021
	; LineNumber: 78
	
; // Forecolour to white for now
	; Clear screen with offset
	lda #$1
	ldx #$fa
c64_chars_clearloop210
	dex
	sta $0000+$d800,x
	sta $00fa+$d800,x
	sta $01f4+$d800,x
	sta $02ee+$d800,x
	bne c64_chars_clearloop210
	; LineNumber: 81
	
; // Ensure no flashing cursor
	jsr txt_cursor_off
	; LineNumber: 83
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 88
show_start_screen
	; LineNumber: 90
	jsr txt_cls
	; LineNumber: 91
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_elsedoneblock215
show_start_screen_ConditionalTrueBlock213: ;Main true block ;keep 
	; LineNumber: 91
	; LineNumber: 93
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr220
	sta txt_in_str
	lda #>show_start_screen_stringassignstr220
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 94
show_start_screen_elsedoneblock215
	; LineNumber: 96
	jsr txt_wait_key
	; LineNumber: 99
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 104
show_end_screen
	; LineNumber: 106
	jsr txt_cls
	; LineNumber: 107
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock225
show_end_screen_ConditionalTrueBlock224: ;Main true block ;keep 
	; LineNumber: 107
	; LineNumber: 109
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr234
	sta txt_in_str
	lda #>show_end_screen_stringassignstr234
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 111
	jmp show_end_screen_elsedoneblock226
show_end_screen_elseblock225
	; LineNumber: 112
	; LineNumber: 113
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr237
	sta txt_in_str
	lda #>show_end_screen_stringassignstr237
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 114
show_end_screen_elsedoneblock226
	; LineNumber: 116
	jsr txt_wait_key
	; LineNumber: 119
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 123
door
	; LineNumber: 126
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_elseblock242
door_ConditionalTrueBlock241: ;Main true block ;keep 
	; LineNumber: 127
	; LineNumber: 128
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 129
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr251
	sta txt_in_str
	lda #>door_stringassignstr251
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 131
	jmp door_elsedoneblock243
door_elseblock242
	; LineNumber: 132
	; LineNumber: 134
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr254
	sta txt_in_str
	lda #>door_stringassignstr254
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 137
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 138
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 139
door_elsedoneblock243
	; LineNumber: 141
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 145
check_collisions
	; LineNumber: 147
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 148
	lda #$b
	cmp charat ;keep
	bne check_collisions_casenext258
	; LineNumber: 150
	; LineNumber: 152
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 153
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr260
	sta txt_in_str
	lda #>check_collisions_stringassignstr260
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 154
	jmp check_collisions_caseend257
check_collisions_casenext258
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext262
	; LineNumber: 157
	; LineNumber: 158
	
; // Artifact
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr264
	sta txt_in_str
	lda #>check_collisions_stringassignstr264
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 159
	jmp check_collisions_caseend257
check_collisions_casenext262
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext266
	; LineNumber: 160
	jsr door
	jmp check_collisions_caseend257
check_collisions_casenext266
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext268
	; LineNumber: 161
	jsr door
	jmp check_collisions_caseend257
check_collisions_casenext268
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext270
	; LineNumber: 166
	; LineNumber: 168
	jmp check_collisions_caseend257
check_collisions_casenext270
	; LineNumber: 172
	; LineNumber: 175
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 176
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 179
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 180
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr273
	sta txt_in_str
	lda #>check_collisions_stringassignstr273
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 181
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 182
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 184
check_collisions_caseend257
	; LineNumber: 187
	rts
block1
	; LineNumber: 197
	
; // ********************************
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 198
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 205
MainProgram_while275
MainProgram_loopstart279
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed393
	jmp MainProgram_ConditionalTrueBlock276
MainProgram_localfailed393
	jmp MainProgram_elsedoneblock278
MainProgram_ConditionalTrueBlock276: ;Main true block ;keep 
	; LineNumber: 205
	; LineNumber: 210
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 214
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 219
MainProgram_while395
MainProgram_loopstart399
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed453
	jmp MainProgram_ConditionalTrueBlock396
MainProgram_localfailed453
	jmp MainProgram_elsedoneblock398
MainProgram_ConditionalTrueBlock396: ;Main true block ;keep 
	; LineNumber: 220
	; LineNumber: 225
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 226
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 229
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 232
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext456
	; LineNumber: 234
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock461
MainProgram_ConditionalTrueBlock459: ;Main true block ;keep 
	; LineNumber: 234
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock461
	jmp MainProgram_caseend455
MainProgram_casenext456
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext464
	; LineNumber: 235
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock469
MainProgram_ConditionalTrueBlock467: ;Main true block ;keep 
	; LineNumber: 235
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock469
	jmp MainProgram_caseend455
MainProgram_casenext464
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext472
	; LineNumber: 236
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock477
MainProgram_ConditionalTrueBlock475: ;Main true block ;keep 
	; LineNumber: 236
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock477
	jmp MainProgram_caseend455
MainProgram_casenext472
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext480
	; LineNumber: 237
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock485
MainProgram_ConditionalTrueBlock483: ;Main true block ;keep 
	; LineNumber: 237
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock485
MainProgram_casenext480
MainProgram_caseend455
	; LineNumber: 245
	
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
	; LineNumber: 249
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock491
MainProgram_ConditionalTrueBlock489: ;Main true block ;keep 
	; LineNumber: 250
	; LineNumber: 253
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock503
MainProgram_ConditionalTrueBlock501: ;Main true block ;keep 
	; LineNumber: 252
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock503
	; LineNumber: 257
MainProgram_elsedoneblock491
	; LineNumber: 263
	
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
	; LineNumber: 267
	
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
	; LineNumber: 271
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 273
	jmp MainProgram_while395
MainProgram_elsedoneblock398
MainProgram_loopend400
	; LineNumber: 277
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 280
	jmp MainProgram_while275
MainProgram_elsedoneblock278
MainProgram_loopend280
	; LineNumber: 282
	; End of program
	; Ending memory block
EndBlock810
show_start_screen_stringassignstr217		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_start_screen_stringassignstr220		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_end_screen_stringassignstr228		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr231		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr234		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr237		dc.b	"EEK YOU DIED!"
	dc.b	0
door_stringassignstr245		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr248		dc.b	"YOU NEED A KEY!          "
	dc.b	0
door_stringassignstr251		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr254		dc.b	"YOU NEED A KEY!          "
	dc.b	0
check_collisions_stringassignstr260		dc.b	"KEY!              "
	dc.b	0
check_collisions_stringassignstr264		dc.b	"ARTIFACT!         "
	dc.b	0
check_collisions_stringassignstr273		dc.b	"EXISTING TILE:       "
	dc.b	0
	org $2000
charset
	incbin "/Users/chris.garrett/GitHub/dungeonc64///custom.bin"
EndBlock2000
