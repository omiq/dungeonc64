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
	; LineNumber: 6
levels_level
	incbin "/Users/chris.garrett/GitHub/dungeonc64///map-pet.flf"
	; LineNumber: 7
levels_temp_s	=  $08
	; LineNumber: 7
levels_dest	=  $16
	; LineNumber: 7
levels_ch_index	=  $0B
	; LineNumber: 11
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
txt_DefineScreen_block4
txt_DefineScreen
	; LineNumber: 268
	; Binary clause INTEGER: NOTEQUALS
	; Load Integer array
	ldx #0 ; watch for bug, Integer array has max index of 128
	lda txt_ytab,x
	ldy txt_ytab+1,x
txt_DefineScreen_rightvarInteger_var10 = $54
	sta txt_DefineScreen_rightvarInteger_var10
	sty txt_DefineScreen_rightvarInteger_var10+1
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_DefineScreen_rightvarInteger_var10+1   ; compare high bytes
	cmp #$00 ;keep
	beq txt_DefineScreen_pass111
	jmp txt_DefineScreen_ConditionalTrueBlock6
txt_DefineScreen_pass111
	lda txt_DefineScreen_rightvarInteger_var10
	cmp #$00 ;keep
	beq txt_DefineScreen_elsedoneblock8
	jmp txt_DefineScreen_ConditionalTrueBlock6
txt_DefineScreen_ConditionalTrueBlock6: ;Main true block ;keep 
	; LineNumber: 269
	; LineNumber: 270
	rts
	; LineNumber: 271
txt_DefineScreen_elsedoneblock8
	; LineNumber: 273
	lda #$00
	ldx #$80
	sta txt_temp_address_p
	stx txt_temp_address_p+1
	; LineNumber: 280
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop13
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
	bcc txt_DefineScreen_WordAdd21
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd21
	; LineNumber: 279
txt_DefineScreen_forloopcounter15
txt_DefineScreen_loopstart16
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop13
txt_DefineScreen_loopdone22: ;keep
txt_DefineScreen_forloopend14
txt_DefineScreen_loopend17
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
txt_move_to_block23
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
txt_put_ch_block24
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
txt_get_key_block26
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
txt_wait_key_block27
txt_wait_key
	; LineNumber: 372
txt_wait_key_while28
txt_wait_key_loopstart32
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key_count
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock31
txt_wait_key_ConditionalTrueBlock29: ;Main true block ;keep 
	; LineNumber: 373
	; LineNumber: 374
	; Peek
	lda $9e + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key_count
	; LineNumber: 375
	jmp txt_wait_key_while28
txt_wait_key_elsedoneblock31
txt_wait_key_loopend33
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
txt_print_string_block37
txt_print_string
	; LineNumber: 458
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 459
txt_print_string_while38
txt_print_string_loopstart42
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock41
txt_print_string_ConditionalTrueBlock39: ;Main true block ;keep 
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
	jmp txt_print_string_while38
txt_print_string_elsedoneblock41
txt_print_string_loopend43
	; LineNumber: 466
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock49
txt_print_string_ConditionalTrueBlock47: ;Main true block ;keep 
	; LineNumber: 467
	; LineNumber: 468
	jsr txt_cursor_return
	; LineNumber: 470
txt_print_string_elsedoneblock49
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
txt_print_dec_block52
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
	bcc txt_print_dec_localfailed98
	jmp txt_print_dec_ConditionalTrueBlock54
txt_print_dec_localfailed98
	jmp txt_print_dec_elseblock55
txt_print_dec_ConditionalTrueBlock54: ;Main true block ;keep 
	; LineNumber: 620
	; LineNumber: 623
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed121
	jmp txt_print_dec_ConditionalTrueBlock101
txt_print_dec_localfailed121
	jmp txt_print_dec_elseblock102
txt_print_dec_ConditionalTrueBlock101: ;Main true block ;keep 
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
txt_print_dec_rightvarInteger_var125 =  $56
	sta txt_print_dec_rightvarInteger_var125
	sty txt_print_dec_rightvarInteger_var125+1
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
	sbc txt_print_dec_rightvarInteger_var125
txt_print_dec_wordAdd123
	sta txt_print_dec_rightvarInteger_var125
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var125+1
	tay
	lda txt_print_dec_rightvarInteger_var125
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 632
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock129
	bne txt_print_dec_ConditionalTrueBlock127
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock129
	beq txt_print_dec_elsedoneblock129
txt_print_dec_ConditionalTrueBlock127: ;Main true block ;keep 
	; LineNumber: 631
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd133
	dec txt_temp_num+1
txt_print_dec_WordAdd133
txt_print_dec_elsedoneblock129
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
txt_print_dec_val_var134 =  $56
	sta txt_print_dec_val_var134
	lda txt__in_n
	sec
txt_print_dec_modulo135
	sbc txt_print_dec_val_var134
	bcs txt_print_dec_modulo135
	adc txt_print_dec_val_var134
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
	jmp txt_print_dec_elsedoneblock103
txt_print_dec_elseblock102
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
txt_print_dec_rightvarInteger_var138 =  $56
	sta txt_print_dec_rightvarInteger_var138
	sty txt_print_dec_rightvarInteger_var138+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var138+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var138
	bcs txt_print_dec_wordAdd137
	dey
txt_print_dec_wordAdd137
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
txt_print_dec_elsedoneblock103
	; LineNumber: 653
	jmp txt_print_dec_elsedoneblock56
txt_print_dec_elseblock55
	; LineNumber: 654
	; LineNumber: 655
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 656
txt_print_dec_elsedoneblock56
	; LineNumber: 658
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock143
txt_print_dec_ConditionalTrueBlock141: ;Main true block ;keep 
	; LineNumber: 657
	jsr txt_cursor_return
txt_print_dec_elsedoneblock143
	; LineNumber: 659
	rts
	
; // screen buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 14
levels_draw_level
	; LineNumber: 16
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 17
	; INTEGER optimization: a=b+c 
	lda #<levels_level
	clc
	adc #$2d
	sta levels_temp_s+0
	lda #>levels_level
	adc #$00
	sta levels_temp_s+1
	; LineNumber: 24
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_draw_level_forloop148
	; LineNumber: 20
	; LineNumber: 21
	; memcpyfast
	ldy #39
levels_draw_level_memcpy158
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_level_memcpy158
	; LineNumber: 22
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd159
	inc levels_dest+1
levels_draw_level_WordAdd159
	; LineNumber: 23
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd160
	inc levels_temp_s+1
levels_draw_level_WordAdd160
	; LineNumber: 24
levels_draw_level_forloopcounter150
levels_draw_level_loopstart151
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_draw_level_forloop148
levels_draw_level_loopdone161: ;keep
levels_draw_level_forloopend149
levels_draw_level_loopend152
	; LineNumber: 27
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 45
levels_refresh_screen
	; LineNumber: 48
	
; //CopyFullScreen(#screen_buffer,SCREEN_CHAR_LOC);
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 57
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop163
	; LineNumber: 53
	; LineNumber: 54
	
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
	; LineNumber: 55
	; memcpyfast
	ldy #39
levels_refresh_screen_memcpy172
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy172
	; LineNumber: 56
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd173
	inc levels_temp_s+1
levels_refresh_screen_WordAdd173
	; LineNumber: 57
levels_refresh_screen_forloopcounter165
levels_refresh_screen_loopstart166
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop163
levels_refresh_screen_loopdone174: ;keep
levels_refresh_screen_forloopend164
levels_refresh_screen_loopend167
	; LineNumber: 61
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 66
	; LineNumber: 65
levels_buf_x	dc.b	0
	; LineNumber: 65
levels_buf_y	dc.b	0
levels_get_buffer_block175
levels_get_buffer
	; LineNumber: 68
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var178 =  $56
	sta levels_get_buffer_rightvarInteger_var178
	sty levels_get_buffer_rightvarInteger_var178+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var181 =  $58
	sta levels_get_buffer_rightvarInteger_var181
	sty levels_get_buffer_rightvarInteger_var181+1
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
	adc levels_get_buffer_rightvarInteger_var181
levels_get_buffer_wordAdd179
	sta levels_get_buffer_rightvarInteger_var181
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var181+1
	tay
	lda levels_get_buffer_rightvarInteger_var181
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var178
levels_get_buffer_wordAdd176
	sta levels_get_buffer_rightvarInteger_var178
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var178+1
	tay
	lda levels_get_buffer_rightvarInteger_var178
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 70
	; LineNumber: 71
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 76
	; LineNumber: 75
levels_plot_x	dc.b	0
	; LineNumber: 75
levels_plot_y	dc.b	0
	; LineNumber: 75
levels_plot_ch	dc.b	0
levels_plot_buffer_block182
levels_plot_buffer
	; LineNumber: 78
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var185 =  $56
	sta levels_plot_buffer_rightvarInteger_var185
	sty levels_plot_buffer_rightvarInteger_var185+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var188 =  $58
	sta levels_plot_buffer_rightvarInteger_var188
	sty levels_plot_buffer_rightvarInteger_var188+1
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
	adc levels_plot_buffer_rightvarInteger_var188
levels_plot_buffer_wordAdd186
	sta levels_plot_buffer_rightvarInteger_var188
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var188+1
	tay
	lda levels_plot_buffer_rightvarInteger_var188
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var185
levels_plot_buffer_wordAdd183
	sta levels_plot_buffer_rightvarInteger_var185
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var185+1
	tay
	lda levels_plot_buffer_rightvarInteger_var185
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 79
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 81
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
	bne show_start_screen_elsedoneblock193
show_start_screen_ConditionalTrueBlock191: ;Main true block ;keep 
	; LineNumber: 35
	; LineNumber: 37
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr198
	sta txt_in_str
	lda #>show_start_screen_stringassignstr198
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 38
show_start_screen_elsedoneblock193
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
	beq show_end_screen_elseblock203
show_end_screen_ConditionalTrueBlock202: ;Main true block ;keep 
	; LineNumber: 51
	; LineNumber: 53
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr212
	sta txt_in_str
	lda #>show_end_screen_stringassignstr212
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 55
	jmp show_end_screen_elsedoneblock204
show_end_screen_elseblock203
	; LineNumber: 56
	; LineNumber: 57
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr215
	sta txt_in_str
	lda #>show_end_screen_stringassignstr215
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 58
show_end_screen_elsedoneblock204
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
	bcc door_elseblock220
door_ConditionalTrueBlock219: ;Main true block ;keep 
	; LineNumber: 71
	; LineNumber: 72
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 73
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr229
	sta txt_in_str
	lda #>door_stringassignstr229
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 75
	jmp door_elsedoneblock221
door_elseblock220
	; LineNumber: 76
	; LineNumber: 78
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr232
	sta txt_in_str
	lda #>door_stringassignstr232
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
door_elsedoneblock221
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
	bne check_collisions_casenext236
	; LineNumber: 94
	; LineNumber: 96
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 97
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr238
	sta txt_in_str
	lda #>check_collisions_stringassignstr238
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 98
	jmp check_collisions_caseend235
check_collisions_casenext236
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext240
	; LineNumber: 101
	; LineNumber: 102
	
; // Artifact
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr242
	sta txt_in_str
	lda #>check_collisions_stringassignstr242
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 103
	jmp check_collisions_caseend235
check_collisions_casenext240
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext244
	; LineNumber: 104
	jsr door
	jmp check_collisions_caseend235
check_collisions_casenext244
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext246
	; LineNumber: 105
	jsr door
	jmp check_collisions_caseend235
check_collisions_casenext246
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext248
	; LineNumber: 110
	; LineNumber: 112
	jmp check_collisions_caseend235
check_collisions_casenext248
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
	lda #<check_collisions_stringassignstr251
	sta txt_in_str
	lda #>check_collisions_stringassignstr251
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
check_collisions_caseend235
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
MainProgram_while254
MainProgram_loopstart258
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed372
	jmp MainProgram_ConditionalTrueBlock255
MainProgram_localfailed372
	jmp MainProgram_elsedoneblock257
MainProgram_ConditionalTrueBlock255: ;Main true block ;keep 
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
MainProgram_while374
MainProgram_loopstart378
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed432
	jmp MainProgram_ConditionalTrueBlock375
MainProgram_localfailed432
	jmp MainProgram_elsedoneblock377
MainProgram_ConditionalTrueBlock375: ;Main true block ;keep 
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
	bne MainProgram_casenext435
	; LineNumber: 209
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock440
MainProgram_ConditionalTrueBlock438: ;Main true block ;keep 
	; LineNumber: 209
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock440
	jmp MainProgram_caseend434
MainProgram_casenext435
	lda #$35
	cmp key_press ;keep
	bne MainProgram_casenext443
	; LineNumber: 210
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock448
MainProgram_ConditionalTrueBlock446: ;Main true block ;keep 
	; LineNumber: 210
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock448
	jmp MainProgram_caseend434
MainProgram_casenext443
	lda #$34
	cmp key_press ;keep
	bne MainProgram_casenext451
	; LineNumber: 211
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock456
MainProgram_ConditionalTrueBlock454: ;Main true block ;keep 
	; LineNumber: 211
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock456
	jmp MainProgram_caseend434
MainProgram_casenext451
	lda #$36
	cmp key_press ;keep
	bne MainProgram_casenext459
	; LineNumber: 212
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock464
MainProgram_ConditionalTrueBlock462: ;Main true block ;keep 
	; LineNumber: 212
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock464
MainProgram_casenext459
MainProgram_caseend434
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
	beq MainProgram_elsedoneblock470
MainProgram_ConditionalTrueBlock468: ;Main true block ;keep 
	; LineNumber: 225
	; LineNumber: 228
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock482
MainProgram_ConditionalTrueBlock480: ;Main true block ;keep 
	; LineNumber: 227
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock482
	; LineNumber: 232
MainProgram_elsedoneblock470
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
	jmp MainProgram_while374
MainProgram_elsedoneblock377
MainProgram_loopend379
	; LineNumber: 252
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 255
	jmp MainProgram_while254
MainProgram_elsedoneblock257
MainProgram_loopend259
	; LineNumber: 257
	; End of program
	; Ending memory block
EndBlock410
show_start_screen_stringassignstr195		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_start_screen_stringassignstr198		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_end_screen_stringassignstr206		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr209		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr212		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr215		dc.b	"EEK YOU DIED!"
	dc.b	0
door_stringassignstr223		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr226		dc.b	"YOU NEED A KEY!          "
	dc.b	0
door_stringassignstr229		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr232		dc.b	"YOU NEED A KEY!          "
	dc.b	0
check_collisions_stringassignstr238		dc.b	"KEY!              "
	dc.b	0
check_collisions_stringassignstr242		dc.b	"ARTIFACT!         "
	dc.b	0
check_collisions_stringassignstr251		dc.b	"EXISTING TILE:       "
	dc.b	0
