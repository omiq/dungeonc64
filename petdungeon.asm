 processor 6502
	org $401
	; Starting new memory block at $401
StartBlock401
	.byte $b ; lo byte of next line
	.byte $4 ; hi byte of next line
	.byte $0a, $00 ; line 10 (lo, hi)
	.byte $9e, $20 ; SYS token and a space
	.byte   $31,$30,$34,$30
	.byte $00, $00, $00 ; end of program
	; Ending memory block
EndBlock401
	org $410
	; Starting new memory block at $410
StartBlock410
dungeon64
	; LineNumber: 166
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
	; LineNumber: 11
levels_level	dc.b	 
	org levels_level+1000
	; LineNumber: 13
levels_wall_tiles	dc.b $0f0, $0f1, $0f2, $0f2, $0f1, $0f2, $0f1, $0f2
	dc.b $0f2, $0f2, $0f2, $0f1, $0f3, $020, $020, $020
	dc.b $020, $020, $020, $020, $0eb, $020, $0eb, $020
	dc.b $0eb, $020, $020, $020, $020, $020, $020, $020
	dc.b $0f3, $020, $0f3, $020, $0eb, $020, $020, $020
	dc.b $020, $020, $020, $020, $0f3, $020, $0f3, $020
	dc.b $0eb, $0f1, $0f2, $0f2, $0f1, $0f2, $0f1, $0f2
	dc.b $0fd, $0f2, $0f2, $0f1, $0f3, $020, $020, $020
	dc.b $020, $020, $020, $020, $0eb, $020, $0eb, $020
	dc.b $0f3, $020, $020, $020, $020, $020, $020, $020
	dc.b $0eb, $020, $0eb, $020, $0eb, $020, $020, $020
	dc.b $020, $020, $020, $020, $0f3, $020, $0f3, $020
	dc.b $0ed, $0f1, $0f2, $0f2, $0f1, $0f2, $0f1, $0f2
	dc.b $0fd, $0f2, $0f2, $0f1
	; LineNumber: 26
levels_temp_s	=  $08
	; LineNumber: 26
levels_dest	=  $16
	; LineNumber: 26
levels_ch_index	=  $0B
	; LineNumber: 30
levels_screen_buffer	dc.b	 
	org levels_screen_buffer+1000
	; LineNumber: 15
player_char	dc.b	$00
	; LineNumber: 16
key_press	dc.b	$00
	; LineNumber: 17
charat	dc.b	0
	; LineNumber: 18
game_won	dc.b	0
	; LineNumber: 18
game_running	dc.b	0
	; LineNumber: 19
x	dc.b	0
	; LineNumber: 19
y	dc.b	0
	; LineNumber: 19
oldx	dc.b	0
	; LineNumber: 19
oldy	dc.b	0
	; LineNumber: 23
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
	adc #80
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
	ldx #$80
	sta txt_temp_address_p
	stx txt_temp_address_p+1
	; LineNumber: 280
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop14
	; LineNumber: 276
	; LineNumber: 277
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
	; LineNumber: 278
	lda txt_temp_address_p
	clc
	adc #$28
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd22
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd22
	; LineNumber: 279
txt_DefineScreen_forloopcounter16
txt_DefineScreen_loopstart17
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop14
txt_DefineScreen_loopdone23: ;keep
txt_DefineScreen_forloopend15
txt_DefineScreen_loopend18
	; LineNumber: 280
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 285
	; LineNumber: 284
txt_temp_p	=  $0D
	; LineNumber: 282
txt__text_x	dc.b	0
	; LineNumber: 282
txt__text_y	dc.b	0
txt_move_to_block24
txt_move_to
	; LineNumber: 286
	; Load Integer array
	lda txt__text_y
	asl
	tax
	lda txt_ytab,x
	ldy txt_ytab+1,x
	sta txt_temp_p
	sty txt_temp_p+1
	; LineNumber: 286
	; Poke
	; Optimization: shift is zero
	sta $c4
	; LineNumber: 287
	
; // LSB
	; Poke
	; Optimization: shift is zero
	lda txt_temp_p+1
	sta $c5
	; LineNumber: 289
	
; // MSB
	; Poke
	; Optimization: shift is zero
	lda txt__text_x
	sta $c6
	; LineNumber: 290
	jsr $e07f
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 337
	; LineNumber: 336
txt_CH	dc.b	0
txt_put_ch_block25
txt_put_ch
	; LineNumber: 338
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 339
	jsr $ffd2
	; LineNumber: 341
	rts
	
; // Clear keyboard buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_clear_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 345
txt_clear_buffer
	; LineNumber: 346
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 347
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $9e
	; LineNumber: 348
	; Poke
	; Optimization: shift is zero
	sta $26f
	; LineNumber: 349
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 356
	; LineNumber: 355
txt__keyp	dc.b	$00
txt_get_key_block27
txt_get_key
	; LineNumber: 357
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__keyp
	; LineNumber: 360
	
; // Read the buffer
	; Peek
	lda $26f + $0;keep
	; Calling storevariable on generic assign expression
	sta txt__keyp
	; LineNumber: 361
	jsr txt_clear_buffer
	; LineNumber: 363
	lda txt__keyp
	rts
	; LineNumber: 364
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 369
	; LineNumber: 368
txt_tmp_key_count	dc.b	$00
txt_wait_key_block28
txt_wait_key
	; LineNumber: 372
txt_wait_key_while29
txt_wait_key_loopstart33
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key_count
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock32
txt_wait_key_ConditionalTrueBlock30: ;Main true block ;keep 
	; LineNumber: 373
	; LineNumber: 374
	; Peek
	lda $9e + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key_count
	; LineNumber: 375
	jmp txt_wait_key_while29
txt_wait_key_elsedoneblock32
txt_wait_key_loopend34
	; LineNumber: 377
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_tmp_key_count
	; LineNumber: 378
	jsr txt_clear_buffer
	; LineNumber: 379
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 430
txt_cursor_return
	; LineNumber: 432
	; Assigning to register
	; Assigning register : _a
	lda #$d
	; LineNumber: 433
	jsr $ffd2
	; LineNumber: 435
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 456
	; LineNumber: 455
txt_next_ch	dc.b	0
	; LineNumber: 453
txt_in_str	=  $0D
	; LineNumber: 453
txt_CRLF	dc.b	$01
txt_print_string_block38
txt_print_string
	; LineNumber: 458
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 459
txt_print_string_while39
txt_print_string_loopstart43
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock42
txt_print_string_ConditionalTrueBlock40: ;Main true block ;keep 
	; LineNumber: 459
	; LineNumber: 461
	; Assigning to register
	; Assigning register : _a
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; LineNumber: 462
	jsr $ffd2
	; LineNumber: 463
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 464
	jmp txt_print_string_while39
txt_print_string_elsedoneblock42
txt_print_string_loopend44
	; LineNumber: 466
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock50
txt_print_string_ConditionalTrueBlock48: ;Main true block ;keep 
	; LineNumber: 467
	; LineNumber: 468
	jsr txt_cursor_return
	; LineNumber: 470
txt_print_string_elsedoneblock50
	; LineNumber: 471
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_dec
	;    Procedure type : User-defined procedure
	; LineNumber: 613
	; LineNumber: 612
txt__in_n	dc.b	0
	; LineNumber: 612
txt__add_cr	dc.b	0
txt_print_dec_block53
txt_print_dec
	; LineNumber: 615
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_digit
	sty txt_next_digit+1
	; LineNumber: 616
	lda #$00
	ldx #$00
	sta txt_temp_num_p
	stx txt_temp_num_p+1
	; LineNumber: 617
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 618
	; Calling storevariable on generic assign expression
	sta txt_temp_i
	; LineNumber: 620
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$a;keep
	bcc txt_print_dec_localfailed99
	jmp txt_print_dec_ConditionalTrueBlock55
txt_print_dec_localfailed99
	jmp txt_print_dec_elseblock56
txt_print_dec_ConditionalTrueBlock55: ;Main true block ;keep 
	; LineNumber: 620
	; LineNumber: 623
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed122
	jmp txt_print_dec_ConditionalTrueBlock102
txt_print_dec_localfailed122
	jmp txt_print_dec_elseblock103
txt_print_dec_ConditionalTrueBlock102: ;Main true block ;keep 
	; LineNumber: 624
	; LineNumber: 626
	
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
	; LineNumber: 627
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 631
	
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
txt_print_dec_rightvarInteger_var126 =  $56
	sta txt_print_dec_rightvarInteger_var126
	sty txt_print_dec_rightvarInteger_var126+1
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
	sbc txt_print_dec_rightvarInteger_var126
txt_print_dec_wordAdd124
	sta txt_print_dec_rightvarInteger_var126
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var126+1
	tay
	lda txt_print_dec_rightvarInteger_var126
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 632
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock130
	bne txt_print_dec_ConditionalTrueBlock128
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock130
	beq txt_print_dec_elsedoneblock130
txt_print_dec_ConditionalTrueBlock128: ;Main true block ;keep 
	; LineNumber: 631
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd134
	dec txt_temp_num+1
txt_print_dec_WordAdd134
txt_print_dec_elsedoneblock130
	; LineNumber: 633
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	lda txt_temp_num
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 636
	
; // right digit
	; Modulo
	lda #$a
txt_print_dec_val_var135 =  $56
	sta txt_print_dec_val_var135
	lda txt__in_n
	sec
txt_print_dec_modulo136
	sbc txt_print_dec_val_var135
	bcs txt_print_dec_modulo136
	adc txt_print_dec_val_var135
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 637
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 640
	jmp txt_print_dec_elsedoneblock104
txt_print_dec_elseblock103
	; LineNumber: 641
	; LineNumber: 644
	
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
	; LineNumber: 645
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 648
	
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
txt_print_dec_rightvarInteger_var139 =  $56
	sta txt_print_dec_rightvarInteger_var139
	sty txt_print_dec_rightvarInteger_var139+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var139+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var139
	bcs txt_print_dec_wordAdd138
	dey
txt_print_dec_wordAdd138
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 649
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 650
txt_print_dec_elsedoneblock104
	; LineNumber: 653
	jmp txt_print_dec_elsedoneblock57
txt_print_dec_elseblock56
	; LineNumber: 654
	; LineNumber: 655
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 656
txt_print_dec_elsedoneblock57
	; LineNumber: 658
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock144
txt_print_dec_ConditionalTrueBlock142: ;Main true block ;keep 
	; LineNumber: 657
	jsr txt_cursor_return
txt_print_dec_elsedoneblock144
	; LineNumber: 659
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_tile
	;    Procedure type : User-defined procedure
	; LineNumber: 33
	; LineNumber: 32
levels_t_x	dc.b	0
	; LineNumber: 32
levels_t_y	dc.b	0
	; LineNumber: 32
levels_tile_no	dc.b	0
levels_draw_tile_block147
levels_draw_tile
	; LineNumber: 36
	
; // Source
	lda #<levels_wall_tiles
	ldx #>levels_wall_tiles
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 38
	lda #$0
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext149
	; LineNumber: 40
	; LineNumber: 42
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext149
	lda #$1
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext151
	; LineNumber: 46
	; LineNumber: 47
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd153
	inc levels_temp_s+1
levels_draw_tile_WordAdd153
	; LineNumber: 48
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext151
	lda #$2
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext154
	; LineNumber: 51
	; LineNumber: 52
	lda levels_temp_s
	clc
	adc #$06
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd156
	inc levels_temp_s+1
levels_draw_tile_WordAdd156
	; LineNumber: 53
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext154
	lda #$3
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext157
	; LineNumber: 56
	; LineNumber: 57
	lda levels_temp_s
	clc
	adc #$09
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd159
	inc levels_temp_s+1
levels_draw_tile_WordAdd159
	; LineNumber: 58
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext157
	lda #$4
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext160
	; LineNumber: 61
	; LineNumber: 62
	lda levels_temp_s
	clc
	adc #$0c
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd162
	inc levels_temp_s+1
levels_draw_tile_WordAdd162
	; LineNumber: 63
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext160
	lda #$5
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext163
	; LineNumber: 66
	; LineNumber: 67
	; Generic 16 bit op
	ldy #0
	lda #$3
levels_draw_tile_rightvarInteger_var167 =  $56
	sta levels_draw_tile_rightvarInteger_var167
	sty levels_draw_tile_rightvarInteger_var167+1
	; HandleVarBinopB16bit
	; RHS is pure, optimization
	; integer assignment NodeVar
	ldy levels_temp_s+1 ; keep
	lda levels_temp_s
	clc
	adc #$0c
	; Testing for byte:  #$00
	; RHS is word, no optimization
	pha 
	tya 
	adc #$00
	tay 
	pla 
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var167
levels_draw_tile_wordAdd165
	sta levels_draw_tile_rightvarInteger_var167
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var167+1
	tay
	lda levels_draw_tile_rightvarInteger_var167
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 68
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext163
	lda #$6
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext169
	; LineNumber: 71
	; LineNumber: 72
	; Generic 16 bit op
	ldy #0
	lda #$6
levels_draw_tile_rightvarInteger_var173 =  $56
	sta levels_draw_tile_rightvarInteger_var173
	sty levels_draw_tile_rightvarInteger_var173+1
	; HandleVarBinopB16bit
	; RHS is pure, optimization
	; integer assignment NodeVar
	ldy levels_temp_s+1 ; keep
	lda levels_temp_s
	clc
	adc #$0c
	; Testing for byte:  #$00
	; RHS is word, no optimization
	pha 
	tya 
	adc #$00
	tay 
	pla 
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var173
levels_draw_tile_wordAdd171
	sta levels_draw_tile_rightvarInteger_var173
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var173+1
	tay
	lda levels_draw_tile_rightvarInteger_var173
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 73
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext169
	lda #$7
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext175
	; LineNumber: 76
	; LineNumber: 77
	; Generic 16 bit op
	ldy #0
	lda #$9
levels_draw_tile_rightvarInteger_var179 =  $56
	sta levels_draw_tile_rightvarInteger_var179
	sty levels_draw_tile_rightvarInteger_var179+1
	; HandleVarBinopB16bit
	; RHS is pure, optimization
	; integer assignment NodeVar
	ldy levels_temp_s+1 ; keep
	lda levels_temp_s
	clc
	adc #$0c
	; Testing for byte:  #$00
	; RHS is word, no optimization
	pha 
	tya 
	adc #$00
	tay 
	pla 
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var179
levels_draw_tile_wordAdd177
	sta levels_draw_tile_rightvarInteger_var179
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var179+1
	tay
	lda levels_draw_tile_rightvarInteger_var179
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 78
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext175
	lda #$8
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext181
	; LineNumber: 81
	; LineNumber: 82
	; Generic 16 bit op
	ldy #0
	lda #$0
levels_draw_tile_rightvarInteger_var185 =  $56
	sta levels_draw_tile_rightvarInteger_var185
	sty levels_draw_tile_rightvarInteger_var185+1
	; HandleVarBinopB16bit
	; RHS is pure, optimization
	; integer assignment NodeVar
	ldy levels_temp_s+1 ; keep
	lda levels_temp_s
	clc
	adc #$18
	; Testing for byte:  #$00
	; RHS is word, no optimization
	pha 
	tya 
	adc #$00
	tay 
	pla 
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var185
levels_draw_tile_wordAdd183
	sta levels_draw_tile_rightvarInteger_var185
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var185+1
	tay
	lda levels_draw_tile_rightvarInteger_var185
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 83
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext181
	lda #$9
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext187
	; LineNumber: 86
	; LineNumber: 87
	; Generic 16 bit op
	ldy #0
	lda #$3
levels_draw_tile_rightvarInteger_var191 =  $56
	sta levels_draw_tile_rightvarInteger_var191
	sty levels_draw_tile_rightvarInteger_var191+1
	; HandleVarBinopB16bit
	; RHS is pure, optimization
	; integer assignment NodeVar
	ldy levels_temp_s+1 ; keep
	lda levels_temp_s
	clc
	adc #$18
	; Testing for byte:  #$00
	; RHS is word, no optimization
	pha 
	tya 
	adc #$00
	tay 
	pla 
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var191
levels_draw_tile_wordAdd189
	sta levels_draw_tile_rightvarInteger_var191
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var191+1
	tay
	lda levels_draw_tile_rightvarInteger_var191
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 88
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext187
	lda #$a
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext193
	; LineNumber: 91
	; LineNumber: 92
	; Generic 16 bit op
	ldy #0
	lda #$6
levels_draw_tile_rightvarInteger_var197 =  $56
	sta levels_draw_tile_rightvarInteger_var197
	sty levels_draw_tile_rightvarInteger_var197+1
	; HandleVarBinopB16bit
	; RHS is pure, optimization
	; integer assignment NodeVar
	ldy levels_temp_s+1 ; keep
	lda levels_temp_s
	clc
	adc #$18
	; Testing for byte:  #$00
	; RHS is word, no optimization
	pha 
	tya 
	adc #$00
	tay 
	pla 
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var197
levels_draw_tile_wordAdd195
	sta levels_draw_tile_rightvarInteger_var197
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var197+1
	tay
	lda levels_draw_tile_rightvarInteger_var197
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 93
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext193
	lda #$b
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext199
	; LineNumber: 96
	; LineNumber: 97
	; Generic 16 bit op
	ldy #0
	lda #$9
levels_draw_tile_rightvarInteger_var203 =  $56
	sta levels_draw_tile_rightvarInteger_var203
	sty levels_draw_tile_rightvarInteger_var203+1
	; HandleVarBinopB16bit
	; RHS is pure, optimization
	; integer assignment NodeVar
	ldy levels_temp_s+1 ; keep
	lda levels_temp_s
	clc
	adc #$18
	; Testing for byte:  #$00
	; RHS is word, no optimization
	pha 
	tya 
	adc #$00
	tay 
	pla 
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
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 98
	jmp levels_draw_tile_caseend148
levels_draw_tile_casenext199
	lda #$c
	cmp levels_tile_no ;keep
	bne levels_draw_tile_casenext205
	; LineNumber: 101
	; LineNumber: 103
levels_draw_tile_casenext205
levels_draw_tile_caseend148
	; LineNumber: 108
	
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
levels_draw_tile_rightvarInteger_var209 =  $56
	sta levels_draw_tile_rightvarInteger_var209
	sty levels_draw_tile_rightvarInteger_var209+1
	; Generic 16 bit op
	lda #<levels_level
	ldy #>levels_level
levels_draw_tile_rightvarInteger_var212 =  $58
	sta levels_draw_tile_rightvarInteger_var212
	sty levels_draw_tile_rightvarInteger_var212+1
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy #0
	lda levels_t_y
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$78
	sta mul16x8_num2
	jsr mul16x8_procedure
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
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var209
levels_draw_tile_wordAdd207
	sta levels_draw_tile_rightvarInteger_var209
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var209+1
	tay
	lda levels_draw_tile_rightvarInteger_var209
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 109
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy213
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy213
	; LineNumber: 111
	lda levels_temp_s
	clc
	adc #$0c
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd214
	inc levels_temp_s+1
levels_draw_tile_WordAdd214
	; LineNumber: 112
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd215
	inc levels_dest+1
levels_draw_tile_WordAdd215
	; LineNumber: 113
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy216
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy216
	; LineNumber: 115
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd217
	inc levels_dest+1
levels_draw_tile_WordAdd217
	; LineNumber: 116
	lda levels_temp_s
	clc
	adc #$0c
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd218
	inc levels_temp_s+1
levels_draw_tile_WordAdd218
	; LineNumber: 117
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy219
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy219
	; LineNumber: 119
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 122
levels_draw_level
	; LineNumber: 125
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
	; Calling storevariable on generic assign expression
	sta levels_t_y
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 126
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 127
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 128
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 129
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 130
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 131
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 132
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 133
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 134
	lda #$9
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 135
	lda #$a
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 136
	lda #$b
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 137
	lda #$c
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 139
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 140
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_x
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 141
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 142
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 143
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 144
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 145
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 146
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 147
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 149
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 150
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 151
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_x
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 152
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 153
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 154
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 155
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 156
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 157
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 159
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 160
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 161
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 162
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_x
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 163
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 164
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 165
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 166
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 167
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 169
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_y
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 170
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 171
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 172
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 173
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_x
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 174
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 175
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 176
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 177
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 180
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 181
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 182
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 183
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 184
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 185
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_x
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 186
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 187
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 188
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 190
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 191
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 192
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 193
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 194
	lda #$4
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 195
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 196
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_x
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 197
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_y
	lda #$5
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 198
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_t_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_t_y
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	jsr levels_draw_tile
	; LineNumber: 202
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 203
	lda #<levels_level
	ldx #>levels_level
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 210
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_draw_level_forloop221
	; LineNumber: 206
	; LineNumber: 207
	
; //+45;
	; memcpyfast
	ldy #39
levels_draw_level_memcpy231
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_level_memcpy231
	; LineNumber: 208
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd232
	inc levels_dest+1
levels_draw_level_WordAdd232
	; LineNumber: 209
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd233
	inc levels_temp_s+1
levels_draw_level_WordAdd233
	; LineNumber: 210
levels_draw_level_forloopcounter223
levels_draw_level_loopstart224
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_draw_level_forloop221
levels_draw_level_loopdone234: ;keep
levels_draw_level_forloopend222
levels_draw_level_loopend225
	; LineNumber: 213
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 231
levels_refresh_screen
	; LineNumber: 234
	
; //CopyFullScreen(#screen_buffer,SCREEN_CHAR_LOC);
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 243
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop236
	; LineNumber: 239
	; LineNumber: 240
	
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
	; LineNumber: 241
	; memcpyfast
	ldy #39
levels_refresh_screen_memcpy245
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy245
	; LineNumber: 242
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd246
	inc levels_temp_s+1
levels_refresh_screen_WordAdd246
	; LineNumber: 243
levels_refresh_screen_forloopcounter238
levels_refresh_screen_loopstart239
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop236
levels_refresh_screen_loopdone247: ;keep
levels_refresh_screen_forloopend237
levels_refresh_screen_loopend240
	; LineNumber: 247
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 252
	; LineNumber: 251
levels_buf_x	dc.b	0
	; LineNumber: 251
levels_buf_y	dc.b	0
levels_get_buffer_block248
levels_get_buffer
	; LineNumber: 254
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var251 =  $56
	sta levels_get_buffer_rightvarInteger_var251
	sty levels_get_buffer_rightvarInteger_var251+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var254 =  $58
	sta levels_get_buffer_rightvarInteger_var254
	sty levels_get_buffer_rightvarInteger_var254+1
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
	adc levels_get_buffer_rightvarInteger_var254
levels_get_buffer_wordAdd252
	sta levels_get_buffer_rightvarInteger_var254
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var254+1
	tay
	lda levels_get_buffer_rightvarInteger_var254
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var251
levels_get_buffer_wordAdd249
	sta levels_get_buffer_rightvarInteger_var251
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var251+1
	tay
	lda levels_get_buffer_rightvarInteger_var251
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 256
	; LineNumber: 257
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 262
	; LineNumber: 261
levels_plot_x	dc.b	0
	; LineNumber: 261
levels_plot_y	dc.b	0
	; LineNumber: 261
levels_plot_ch	dc.b	0
levels_plot_buffer_block255
levels_plot_buffer
	; LineNumber: 264
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var258 =  $56
	sta levels_plot_buffer_rightvarInteger_var258
	sty levels_plot_buffer_rightvarInteger_var258+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var261 =  $58
	sta levels_plot_buffer_rightvarInteger_var261
	sty levels_plot_buffer_rightvarInteger_var261+1
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
	adc levels_plot_buffer_rightvarInteger_var261
levels_plot_buffer_wordAdd259
	sta levels_plot_buffer_rightvarInteger_var261
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var261+1
	tay
	lda levels_plot_buffer_rightvarInteger_var261
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var258
levels_plot_buffer_wordAdd256
	sta levels_plot_buffer_rightvarInteger_var258
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var258+1
	tay
	lda levels_plot_buffer_rightvarInteger_var258
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 265
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 267
	rts
	
; //player inventory
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 32
show_start_screen
	; LineNumber: 34
	jsr txt_cls
	; LineNumber: 35
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_elsedoneblock266
show_start_screen_ConditionalTrueBlock264: ;Main true block ;keep 
	; LineNumber: 35
	; LineNumber: 37
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr271
	sta txt_in_str
	lda #>show_start_screen_stringassignstr271
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 38
show_start_screen_elsedoneblock266
	; LineNumber: 40
	jsr txt_wait_key
	; LineNumber: 43
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 48
show_end_screen
	; LineNumber: 50
	jsr txt_cls
	; LineNumber: 51
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock276
show_end_screen_ConditionalTrueBlock275: ;Main true block ;keep 
	; LineNumber: 51
	; LineNumber: 53
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr285
	sta txt_in_str
	lda #>show_end_screen_stringassignstr285
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 55
	jmp show_end_screen_elsedoneblock277
show_end_screen_elseblock276
	; LineNumber: 56
	; LineNumber: 57
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr288
	sta txt_in_str
	lda #>show_end_screen_stringassignstr288
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 58
show_end_screen_elsedoneblock277
	; LineNumber: 60
	jsr txt_wait_key
	; LineNumber: 63
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 67
door
	; LineNumber: 70
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_elseblock293
door_ConditionalTrueBlock292: ;Main true block ;keep 
	; LineNumber: 71
	; LineNumber: 72
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 73
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr302
	sta txt_in_str
	lda #>door_stringassignstr302
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 75
	jmp door_elsedoneblock294
door_elseblock293
	; LineNumber: 76
	; LineNumber: 78
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr305
	sta txt_in_str
	lda #>door_stringassignstr305
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 81
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 82
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 83
door_elsedoneblock294
	; LineNumber: 85
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 89
check_collisions
	; LineNumber: 91
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 92
	lda #$b
	cmp charat ;keep
	bne check_collisions_casenext309
	; LineNumber: 94
	; LineNumber: 96
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 97
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr311
	sta txt_in_str
	lda #>check_collisions_stringassignstr311
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 98
	jmp check_collisions_caseend308
check_collisions_casenext309
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext313
	; LineNumber: 101
	; LineNumber: 102
	
; // Artifact
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr315
	sta txt_in_str
	lda #>check_collisions_stringassignstr315
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 103
	jmp check_collisions_caseend308
check_collisions_casenext313
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext317
	; LineNumber: 104
	jsr door
	jmp check_collisions_caseend308
check_collisions_casenext317
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext319
	; LineNumber: 105
	jsr door
	jmp check_collisions_caseend308
check_collisions_casenext319
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext321
	; LineNumber: 110
	; LineNumber: 112
	jmp check_collisions_caseend308
check_collisions_casenext321
	; LineNumber: 116
	; LineNumber: 119
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 120
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 123
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 124
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr324
	sta txt_in_str
	lda #>check_collisions_stringassignstr324
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 125
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 126
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 128
check_collisions_caseend308
	; LineNumber: 131
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 135
init
	; LineNumber: 138
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 139
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 142
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 145
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 147
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 148
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 151
	
; // Draw current level
	jsr levels_draw_level
	; LineNumber: 154
	
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
	; LineNumber: 157
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 158
	rts
block1
	; LineNumber: 180
MainProgram_while327
MainProgram_loopstart331
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed445
	jmp MainProgram_ConditionalTrueBlock328
MainProgram_localfailed445
	jmp MainProgram_elsedoneblock330
MainProgram_ConditionalTrueBlock328: ;Main true block ;keep 
	; LineNumber: 180
	; LineNumber: 185
	
; // C64 has it's own special characters
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 189
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 194
MainProgram_while447
MainProgram_loopstart451
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed505
	jmp MainProgram_ConditionalTrueBlock448
MainProgram_localfailed505
	jmp MainProgram_elsedoneblock450
MainProgram_ConditionalTrueBlock448: ;Main true block ;keep 
	; LineNumber: 195
	; LineNumber: 200
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 201
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 204
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 207
	lda #$38
	cmp key_press ;keep
	bne MainProgram_casenext508
	; LineNumber: 209
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock513
MainProgram_ConditionalTrueBlock511: ;Main true block ;keep 
	; LineNumber: 209
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock513
	jmp MainProgram_caseend507
MainProgram_casenext508
	lda #$35
	cmp key_press ;keep
	bne MainProgram_casenext516
	; LineNumber: 210
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock521
MainProgram_ConditionalTrueBlock519: ;Main true block ;keep 
	; LineNumber: 210
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock521
	jmp MainProgram_caseend507
MainProgram_casenext516
	lda #$34
	cmp key_press ;keep
	bne MainProgram_casenext524
	; LineNumber: 211
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock529
MainProgram_ConditionalTrueBlock527: ;Main true block ;keep 
	; LineNumber: 211
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock529
	jmp MainProgram_caseend507
MainProgram_casenext524
	lda #$36
	cmp key_press ;keep
	bne MainProgram_casenext532
	; LineNumber: 212
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock537
MainProgram_ConditionalTrueBlock535: ;Main true block ;keep 
	; LineNumber: 212
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock537
MainProgram_casenext532
MainProgram_caseend507
	; LineNumber: 220
	
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
	; LineNumber: 224
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock543
MainProgram_ConditionalTrueBlock541: ;Main true block ;keep 
	; LineNumber: 225
	; LineNumber: 228
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock555
MainProgram_ConditionalTrueBlock553: ;Main true block ;keep 
	; LineNumber: 227
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock555
	; LineNumber: 232
MainProgram_elsedoneblock543
	; LineNumber: 238
	
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
	; LineNumber: 242
	
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
	; LineNumber: 246
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 248
	jmp MainProgram_while447
MainProgram_elsedoneblock450
MainProgram_loopend452
	; LineNumber: 252
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 255
	jmp MainProgram_while327
MainProgram_elsedoneblock330
MainProgram_loopend332
	; LineNumber: 257
	; End of program
	; Ending memory block
EndBlock410
show_start_screen_stringassignstr268		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_start_screen_stringassignstr271		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_end_screen_stringassignstr279		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr282		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr285		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr288		dc.b	"EEK YOU DIED!"
	dc.b	0
door_stringassignstr296		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr299		dc.b	"YOU NEED A KEY!          "
	dc.b	0
door_stringassignstr302		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr305		dc.b	"YOU NEED A KEY!          "
	dc.b	0
check_collisions_stringassignstr311		dc.b	"KEY!              "
	dc.b	0
check_collisions_stringassignstr315		dc.b	"ARTIFACT!         "
	dc.b	0
check_collisions_stringassignstr324		dc.b	"EXISTING TILE:       "
	dc.b	0
