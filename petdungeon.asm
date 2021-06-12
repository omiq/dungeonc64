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
	; LineNumber: 196
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
	; LineNumber: 275
	; Binary clause INTEGER: EQUALS
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_address_p+1   ; compare high bytes
	cmp #$00 ;keep
	bne txt_DefineScreen_elsedoneblock17
	lda txt_temp_address_p
	cmp #$00 ;keep
	bne txt_DefineScreen_elsedoneblock17
	jmp txt_DefineScreen_ConditionalTrueBlock15
txt_DefineScreen_ConditionalTrueBlock15: ;Main true block ;keep 
	; LineNumber: 276
	; LineNumber: 278
	
; // Where is screen ram right now?
; // Custom
	lda #$00
	ldx #$04
	sta txt_temp_address_p
	stx txt_temp_address_p+1
	; LineNumber: 279
txt_DefineScreen_elsedoneblock17
	; LineNumber: 290
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop20
	; LineNumber: 285
	; LineNumber: 286
	ldy #$28 ; optimized, look out for bugs
	lda #$20
txt_DefineScreen_fill29
	sta (txt_temp_address_p),y
	dey
	bpl txt_DefineScreen_fill29
	; LineNumber: 287
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
	; LineNumber: 288
	lda txt_temp_address_p
	clc
	adc #$28
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd30
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd30
	; LineNumber: 289
txt_DefineScreen_forloopcounter22
txt_DefineScreen_loopstart23
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop20
txt_DefineScreen_loopdone31: ;keep
txt_DefineScreen_forloopend21
txt_DefineScreen_loopend24
	; LineNumber: 291
	lda #$00
	ldx #$d8
	sta txt_temp_c_p
	stx txt_temp_c_p+1
	; LineNumber: 292
	lda #$0
	ldy #0
txt_DefineScreen_fill32
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill32
	; LineNumber: 293
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd33
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd33
	; LineNumber: 294
	lda #$0
	ldy #0
txt_DefineScreen_fill34
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill34
	; LineNumber: 295
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd35
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd35
	; LineNumber: 296
	lda #$0
	ldy #0
txt_DefineScreen_fill36
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill36
	; LineNumber: 297
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd37
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd37
	; LineNumber: 298
	lda #$0
	ldy #0
txt_DefineScreen_fill38
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill38
	; LineNumber: 300
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 305
	; LineNumber: 302
txt__text_x	dc.b	0
	; LineNumber: 302
txt__text_y	dc.b	0
txt_move_to_block39
txt_move_to
	; LineNumber: 306
	; ****** Inline assembler section
	clc
	; LineNumber: 307
	; Assigning to register
	; Assigning register : _y
	ldy txt__text_x
	; LineNumber: 308
	; Assigning to register
	; Assigning register : _x
	ldx txt__text_y
	; LineNumber: 309
	jsr $fff0
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 356
	; LineNumber: 355
txt_CH	dc.b	0
txt_put_ch_block40
txt_put_ch
	; LineNumber: 357
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 358
	jsr $ffd2
	; LineNumber: 360
	rts
	
; // Clear keyboard buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_clear_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 364
txt_clear_buffer
	; LineNumber: 366
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $c6
	; LineNumber: 367
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 373
	; LineNumber: 372
txt_ink	dc.b	$00
txt_get_key_block42
txt_get_key
	; LineNumber: 374
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 375
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 376
txt_get_key_while43
txt_get_key_loopstart47
	; Binary clause Simplified: EQUALS
	lda txt_ink
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_get_key_elsedoneblock46
txt_get_key_ConditionalTrueBlock44: ;Main true block ;keep 
	; LineNumber: 377
	; LineNumber: 378
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 379
	jmp txt_get_key_while43
txt_get_key_elsedoneblock46
txt_get_key_loopend48
	; LineNumber: 380
	jsr $e5b4
	; LineNumber: 381
	; Assigning from register
	sta txt_ink
	; LineNumber: 382
	rts
	; LineNumber: 383
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 388
	; LineNumber: 387
txt_tmp_key	dc.b	$00
txt_wait_key_block51
txt_wait_key
	; LineNumber: 390
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 391
txt_wait_key_while52
txt_wait_key_loopstart56
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock55
txt_wait_key_ConditionalTrueBlock53: ;Main true block ;keep 
	; LineNumber: 392
	; LineNumber: 393
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 394
	jmp txt_wait_key_while52
txt_wait_key_elsedoneblock55
txt_wait_key_loopend57
	; LineNumber: 396
	jsr txt_clear_buffer
	; LineNumber: 397
	rts
	
; //CURSOR_OFF
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_off
	;    Procedure type : User-defined procedure
	; LineNumber: 418
txt_cursor_off
	; LineNumber: 420
	; Poke
	; Optimization: shift is zero
	lda #$1
	sta $cc
	; LineNumber: 423
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 448
txt_cursor_return
	; LineNumber: 450
	; Assigning to register
	; Assigning register : _a
	lda #$d
	; LineNumber: 451
	jsr $ffd2
	; LineNumber: 453
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 474
	; LineNumber: 473
txt_next_ch	dc.b	0
	; LineNumber: 471
txt_in_str	=  $0D
	; LineNumber: 471
txt_CRLF	dc.b	$01
txt_print_string_block62
txt_print_string
	; LineNumber: 476
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 477
txt_print_string_while63
txt_print_string_loopstart67
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock66
txt_print_string_ConditionalTrueBlock64: ;Main true block ;keep 
	; LineNumber: 477
	; LineNumber: 479
	; Assigning to register
	; Assigning register : _a
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; LineNumber: 480
	jsr $ffd2
	; LineNumber: 481
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 482
	jmp txt_print_string_while63
txt_print_string_elsedoneblock66
txt_print_string_loopend68
	; LineNumber: 484
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock74
txt_print_string_ConditionalTrueBlock72: ;Main true block ;keep 
	; LineNumber: 485
	; LineNumber: 486
	jsr txt_cursor_return
	; LineNumber: 488
txt_print_string_elsedoneblock74
	; LineNumber: 489
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_dec
	;    Procedure type : User-defined procedure
	; LineNumber: 631
	; LineNumber: 630
txt__in_n	dc.b	0
	; LineNumber: 630
txt__add_cr	dc.b	0
txt_print_dec_block77
txt_print_dec
	; LineNumber: 633
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_digit
	sty txt_next_digit+1
	; LineNumber: 634
	lda #$00
	ldx #$00
	sta txt_temp_num_p
	stx txt_temp_num_p+1
	; LineNumber: 635
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 636
	; Calling storevariable on generic assign expression
	sta txt_temp_i
	; LineNumber: 638
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$a;keep
	bcc txt_print_dec_localfailed123
	jmp txt_print_dec_ConditionalTrueBlock79
txt_print_dec_localfailed123
	jmp txt_print_dec_elseblock80
txt_print_dec_ConditionalTrueBlock79: ;Main true block ;keep 
	; LineNumber: 638
	; LineNumber: 641
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed146
	jmp txt_print_dec_ConditionalTrueBlock126
txt_print_dec_localfailed146
	jmp txt_print_dec_elseblock127
txt_print_dec_ConditionalTrueBlock126: ;Main true block ;keep 
	; LineNumber: 642
	; LineNumber: 644
	
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
	; LineNumber: 645
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 649
	
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
txt_print_dec_rightvarInteger_var150 =  $56
	sta txt_print_dec_rightvarInteger_var150
	sty txt_print_dec_rightvarInteger_var150+1
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
	sbc txt_print_dec_rightvarInteger_var150
txt_print_dec_wordAdd148
	sta txt_print_dec_rightvarInteger_var150
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var150+1
	tay
	lda txt_print_dec_rightvarInteger_var150
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 650
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock154
	bne txt_print_dec_ConditionalTrueBlock152
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock154
	beq txt_print_dec_elsedoneblock154
txt_print_dec_ConditionalTrueBlock152: ;Main true block ;keep 
	; LineNumber: 649
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd158
	dec txt_temp_num+1
txt_print_dec_WordAdd158
txt_print_dec_elsedoneblock154
	; LineNumber: 651
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	lda txt_temp_num
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 654
	
; // right digit
	; Modulo
	lda #$a
txt_print_dec_val_var159 =  $56
	sta txt_print_dec_val_var159
	lda txt__in_n
	sec
txt_print_dec_modulo160
	sbc txt_print_dec_val_var159
	bcs txt_print_dec_modulo160
	adc txt_print_dec_val_var159
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 655
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 658
	jmp txt_print_dec_elsedoneblock128
txt_print_dec_elseblock127
	; LineNumber: 659
	; LineNumber: 662
	
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
	; LineNumber: 663
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 666
	
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
txt_print_dec_rightvarInteger_var163 =  $56
	sta txt_print_dec_rightvarInteger_var163
	sty txt_print_dec_rightvarInteger_var163+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var163+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var163
	bcs txt_print_dec_wordAdd162
	dey
txt_print_dec_wordAdd162
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 667
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 668
txt_print_dec_elsedoneblock128
	; LineNumber: 671
	jmp txt_print_dec_elsedoneblock81
txt_print_dec_elseblock80
	; LineNumber: 672
	; LineNumber: 673
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 674
txt_print_dec_elsedoneblock81
	; LineNumber: 676
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock168
txt_print_dec_ConditionalTrueBlock166: ;Main true block ;keep 
	; LineNumber: 675
	jsr txt_cursor_return
txt_print_dec_elsedoneblock168
	; LineNumber: 677
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
levels_draw_level_forloop173
	; LineNumber: 210
	; LineNumber: 211
	; memcpyfast
	ldy #39
levels_draw_level_memcpy183
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_level_memcpy183
	; LineNumber: 212
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd184
	inc levels_dest+1
levels_draw_level_WordAdd184
	; LineNumber: 213
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd185
	inc levels_temp_s+1
levels_draw_level_WordAdd185
	; LineNumber: 214
levels_draw_level_forloopcounter175
levels_draw_level_loopstart176
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_draw_level_forloop173
levels_draw_level_loopdone186: ;keep
levels_draw_level_forloopend174
levels_draw_level_loopend177
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
levels_refresh_screen_forloop188
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
levels_refresh_screen_memcpy197
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy197
	; LineNumber: 246
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd198
	inc levels_temp_s+1
levels_refresh_screen_WordAdd198
	; LineNumber: 247
levels_refresh_screen_forloopcounter190
levels_refresh_screen_loopstart191
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop188
levels_refresh_screen_loopdone199: ;keep
levels_refresh_screen_forloopend189
levels_refresh_screen_loopend192
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
levels_get_buffer_block200
levels_get_buffer
	; LineNumber: 258
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var203 =  $56
	sta levels_get_buffer_rightvarInteger_var203
	sty levels_get_buffer_rightvarInteger_var203+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var206 =  $58
	sta levels_get_buffer_rightvarInteger_var206
	sty levels_get_buffer_rightvarInteger_var206+1
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
	adc levels_get_buffer_rightvarInteger_var206
levels_get_buffer_wordAdd204
	sta levels_get_buffer_rightvarInteger_var206
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var206+1
	tay
	lda levels_get_buffer_rightvarInteger_var206
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
levels_plot_buffer_block207
levels_plot_buffer
	; LineNumber: 268
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var210 =  $56
	sta levels_plot_buffer_rightvarInteger_var210
	sty levels_plot_buffer_rightvarInteger_var210+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var213 =  $58
	sta levels_plot_buffer_rightvarInteger_var213
	sty levels_plot_buffer_rightvarInteger_var213+1
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
	adc levels_plot_buffer_rightvarInteger_var213
levels_plot_buffer_wordAdd211
	sta levels_plot_buffer_rightvarInteger_var213
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var213+1
	tay
	lda levels_plot_buffer_rightvarInteger_var213
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
c64_chars_block215
c64_chars
	; LineNumber: 68
	
; // Set to use the new characterset
	; Set bank
	lda #$2
	sta $dd00
	; LineNumber: 69
	lda $d018
	and #%11110001
	ora #8
	sta $d018
	; LineNumber: 72
	
; // Force the screen address
	lda #$00
	ldx #$44
	sta txt_temp_address_p
	stx txt_temp_address_p+1
	; LineNumber: 73
	; Poke
	; Optimization: shift is zero
	lda #$44
	sta $288
	; LineNumber: 76
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 79
	
; // Black screen
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $d020
	; LineNumber: 80
	; Poke
	; Optimization: shift is zero
	sta $d021
	; LineNumber: 83
	
; // Forecolour to white for now
	; Clear screen with offset
	lda #$1
	ldx #$fa
c64_chars_clearloop216
	dex
	sta $0000+$d800,x
	sta $00fa+$d800,x
	sta $01f4+$d800,x
	sta $02ee+$d800,x
	bne c64_chars_clearloop216
	; LineNumber: 86
	
; // Ensure no flashing cursor
	jsr txt_cursor_off
	; LineNumber: 88
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 93
show_start_screen
	; LineNumber: 95
	jsr txt_cls
	; LineNumber: 96
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_elsedoneblock221
show_start_screen_ConditionalTrueBlock219: ;Main true block ;keep 
	; LineNumber: 96
	; LineNumber: 98
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr226
	sta txt_in_str
	lda #>show_start_screen_stringassignstr226
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 99
show_start_screen_elsedoneblock221
	; LineNumber: 101
	jsr txt_wait_key
	; LineNumber: 104
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 109
show_end_screen
	; LineNumber: 111
	jsr txt_cls
	; LineNumber: 112
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock231
show_end_screen_ConditionalTrueBlock230: ;Main true block ;keep 
	; LineNumber: 112
	; LineNumber: 114
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr240
	sta txt_in_str
	lda #>show_end_screen_stringassignstr240
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 116
	jmp show_end_screen_elsedoneblock232
show_end_screen_elseblock231
	; LineNumber: 117
	; LineNumber: 118
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr243
	sta txt_in_str
	lda #>show_end_screen_stringassignstr243
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 119
show_end_screen_elsedoneblock232
	; LineNumber: 121
	jsr txt_wait_key
	; LineNumber: 124
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 128
door
	; LineNumber: 131
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_elseblock248
door_ConditionalTrueBlock247: ;Main true block ;keep 
	; LineNumber: 132
	; LineNumber: 133
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 134
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr257
	sta txt_in_str
	lda #>door_stringassignstr257
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 136
	jmp door_elsedoneblock249
door_elseblock248
	; LineNumber: 137
	; LineNumber: 139
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr260
	sta txt_in_str
	lda #>door_stringassignstr260
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 142
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 143
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 144
door_elsedoneblock249
	; LineNumber: 146
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 150
check_collisions
	; LineNumber: 152
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 153
	lda #$b
	cmp charat ;keep
	bne check_collisions_casenext264
	; LineNumber: 155
	; LineNumber: 157
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 158
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr266
	sta txt_in_str
	lda #>check_collisions_stringassignstr266
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 159
	jmp check_collisions_caseend263
check_collisions_casenext264
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext268
	; LineNumber: 162
	; LineNumber: 163
	
; // Artifact
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr270
	sta txt_in_str
	lda #>check_collisions_stringassignstr270
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 164
	jmp check_collisions_caseend263
check_collisions_casenext268
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext272
	; LineNumber: 165
	jsr door
	jmp check_collisions_caseend263
check_collisions_casenext272
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext274
	; LineNumber: 166
	jsr door
	jmp check_collisions_caseend263
check_collisions_casenext274
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext276
	; LineNumber: 171
	; LineNumber: 173
	jmp check_collisions_caseend263
check_collisions_casenext276
	; LineNumber: 177
	; LineNumber: 180
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 181
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 184
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 185
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr279
	sta txt_in_str
	lda #>check_collisions_stringassignstr279
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 186
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 187
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 189
check_collisions_caseend263
	; LineNumber: 192
	rts
block1
	; LineNumber: 202
	
; // ********************************
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 203
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 210
MainProgram_while281
MainProgram_loopstart285
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed399
	jmp MainProgram_ConditionalTrueBlock282
MainProgram_localfailed399
	jmp MainProgram_elsedoneblock284
MainProgram_ConditionalTrueBlock282: ;Main true block ;keep 
	; LineNumber: 210
	; LineNumber: 215
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 219
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 224
MainProgram_while401
MainProgram_loopstart405
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed459
	jmp MainProgram_ConditionalTrueBlock402
MainProgram_localfailed459
	jmp MainProgram_elsedoneblock404
MainProgram_ConditionalTrueBlock402: ;Main true block ;keep 
	; LineNumber: 225
	; LineNumber: 230
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 231
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 234
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 237
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext462
	; LineNumber: 239
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock467
MainProgram_ConditionalTrueBlock465: ;Main true block ;keep 
	; LineNumber: 239
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock467
	jmp MainProgram_caseend461
MainProgram_casenext462
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext470
	; LineNumber: 240
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock475
MainProgram_ConditionalTrueBlock473: ;Main true block ;keep 
	; LineNumber: 240
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock475
	jmp MainProgram_caseend461
MainProgram_casenext470
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext478
	; LineNumber: 241
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock483
MainProgram_ConditionalTrueBlock481: ;Main true block ;keep 
	; LineNumber: 241
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock483
	jmp MainProgram_caseend461
MainProgram_casenext478
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext486
	; LineNumber: 242
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock491
MainProgram_ConditionalTrueBlock489: ;Main true block ;keep 
	; LineNumber: 242
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock491
MainProgram_casenext486
MainProgram_caseend461
	; LineNumber: 250
	
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
	; LineNumber: 254
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock497
MainProgram_ConditionalTrueBlock495: ;Main true block ;keep 
	; LineNumber: 255
	; LineNumber: 258
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock509
MainProgram_ConditionalTrueBlock507: ;Main true block ;keep 
	; LineNumber: 257
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock509
	; LineNumber: 262
MainProgram_elsedoneblock497
	; LineNumber: 268
	
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
	; LineNumber: 272
	
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
	; LineNumber: 276
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 278
	jmp MainProgram_while401
MainProgram_elsedoneblock404
MainProgram_loopend406
	; LineNumber: 282
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 285
	jmp MainProgram_while281
MainProgram_elsedoneblock284
MainProgram_loopend286
	; LineNumber: 287
	; End of program
	; Ending memory block
EndBlock810
show_start_screen_stringassignstr223		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_start_screen_stringassignstr226		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_end_screen_stringassignstr234		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr237		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr240		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr243		dc.b	"EEK YOU DIED!"
	dc.b	0
door_stringassignstr251		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr254		dc.b	"YOU NEED A KEY!          "
	dc.b	0
door_stringassignstr257		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr260		dc.b	"YOU NEED A KEY!          "
	dc.b	0
check_collisions_stringassignstr266		dc.b	"KEY!              "
	dc.b	0
check_collisions_stringassignstr270		dc.b	"ARTIFACT!         "
	dc.b	0
check_collisions_stringassignstr279		dc.b	"EXISTING TILE:       "
	dc.b	0
	org $6000
charset
	incbin "/Users/chris.garrett/GitHub/dungeonc64///custom.bin"
EndBlock6000
