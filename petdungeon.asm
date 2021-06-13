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
	; LineNumber: 275
	jmp block1
	; LineNumber: 5
txt_temp_address_p	dc.w	$00
	; LineNumber: 6
txt_ytab	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w $00, $00, $00, $00, $00, $00, $00, $00
	dc.w 0
	; LineNumber: 12
txt_next_digit	dc.w	0
	; LineNumber: 13
txt_temp_num_p	= $02
	; LineNumber: 14
txt_temp_num	dc.w	0
	; LineNumber: 15
txt_temp_i	dc.b	$00
	; LineNumber: 5
levels_r	dc.b	0
	; LineNumber: 6
levels_current_level	dc.w	$00
	; LineNumber: 23
levels_temp_s	= $04
	; LineNumber: 23
levels_dest	= $08
	; LineNumber: 23
levels_ch_index	= $16
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
	; LineNumber: 27
new_status	= $0B
	; LineNumber: 27
the_status	= $0D
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
	; LineNumber: 265
	; LineNumber: 264
txt_y	dc.b	0
txt_DefineScreen_block5
txt_DefineScreen
	; LineNumber: 267
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
	; LineNumber: 268
	; LineNumber: 269
	rts
	; LineNumber: 270
txt_DefineScreen_elsedoneblock9
	; LineNumber: 273
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
	; LineNumber: 274
	; LineNumber: 276
	
; // Where is screen ram right now?
; // Custom
	; Integer constant assigning
	ldy #$04
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 277
txt_DefineScreen_elsedoneblock17
	; LineNumber: 286
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop20
	; LineNumber: 281
	; LineNumber: 282
	
; // Fill the lookup table with screen positions		
	ldx #$28 ; optimized, look out for bugs
	lda #$20
txt_DefineScreen_fill29
	; integer assignment NodeVar
	ldy txt_temp_address_p+1 ; keep
	lda txt_temp_address_p,x
	dex
	bpl txt_DefineScreen_fill29
	; LineNumber: 283
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
	; LineNumber: 284
	lda txt_temp_address_p
	clc
	adc #$28
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd30
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd30
	; LineNumber: 285
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
	; LineNumber: 287
	
; // Fill colour white
	; Clear screen with offset
	lda #$1
	ldx #$fa
txt_DefineScreen_clearloop32
	dex
	sta $0000+$d800,x
	sta $00fa+$d800,x
	sta $01f4+$d800,x
	sta $02ee+$d800,x
	bne txt_DefineScreen_clearloop32
	; LineNumber: 290
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 295
	; LineNumber: 292
txt__text_x	dc.b	0
	; LineNumber: 292
txt__text_y	dc.b	0
txt_move_to_block33
txt_move_to
	; LineNumber: 296
	; ****** Inline assembler section
	clc
	; LineNumber: 297
	; Assigning to register
	; Assigning register : _y
	ldy txt__text_x
	; LineNumber: 298
	; Assigning to register
	; Assigning register : _x
	ldx txt__text_y
	; LineNumber: 299
	jsr $fff0
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 346
	; LineNumber: 345
txt_CH	dc.b	0
txt_put_ch_block34
txt_put_ch
	; LineNumber: 347
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 348
	jsr $ffd2
	; LineNumber: 350
	rts
	
; // Clear keyboard buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_clear_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 354
txt_clear_buffer
	; LineNumber: 356
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $c6
	; LineNumber: 357
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 363
	; LineNumber: 362
txt_ink	dc.b	$00
txt_get_key_block36
txt_get_key
	; LineNumber: 364
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 365
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 366
txt_get_key_while37
txt_get_key_loopstart41
	; Binary clause Simplified: EQUALS
	lda txt_ink
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_get_key_elsedoneblock40
txt_get_key_ConditionalTrueBlock38: ;Main true block ;keep 
	; LineNumber: 367
	; LineNumber: 368
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 369
	jmp txt_get_key_while37
txt_get_key_elsedoneblock40
txt_get_key_loopend42
	; LineNumber: 370
	jsr $e5b4
	; LineNumber: 371
	; Assigning from register
	sta txt_ink
	; LineNumber: 372
	rts
	; LineNumber: 373
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 378
	; LineNumber: 377
txt_tmp_key	dc.b	$00
txt_wait_key_block45
txt_wait_key
	; LineNumber: 380
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 381
txt_wait_key_while46
txt_wait_key_loopstart50
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock49
txt_wait_key_ConditionalTrueBlock47: ;Main true block ;keep 
	; LineNumber: 382
	; LineNumber: 383
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 384
	jmp txt_wait_key_while46
txt_wait_key_elsedoneblock49
txt_wait_key_loopend51
	; LineNumber: 386
	jsr txt_clear_buffer
	; LineNumber: 387
	rts
	
; //CURSOR_OFF
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_off
	;    Procedure type : User-defined procedure
	; LineNumber: 408
txt_cursor_off
	; LineNumber: 410
	; Poke
	; Optimization: shift is zero
	lda #$1
	sta $cc
	; LineNumber: 413
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 438
txt_cursor_return
	; LineNumber: 440
	; Assigning to register
	; Assigning register : _a
	lda #$d
	; LineNumber: 441
	jsr $ffd2
	; LineNumber: 443
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 464
	; LineNumber: 463
txt_next_ch	dc.b	0
	; LineNumber: 461
txt_in_str	= $10
	; LineNumber: 461
txt_CRLF	dc.b	$01
txt_print_string_block56
txt_print_string
	; LineNumber: 466
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 467
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
	; LineNumber: 467
	; LineNumber: 469
	; Assigning to register
	; Assigning register : _a
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; LineNumber: 470
	jsr $ffd2
	; LineNumber: 471
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 472
	jmp txt_print_string_while57
txt_print_string_elsedoneblock60
txt_print_string_loopend62
	; LineNumber: 474
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock68
txt_print_string_ConditionalTrueBlock66: ;Main true block ;keep 
	; LineNumber: 475
	; LineNumber: 476
	jsr txt_cursor_return
	; LineNumber: 478
txt_print_string_elsedoneblock68
	; LineNumber: 479
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_dec
	;    Procedure type : User-defined procedure
	; LineNumber: 621
	; LineNumber: 620
txt__in_n	dc.b	0
	; LineNumber: 620
txt__add_cr	dc.b	0
txt_print_dec_block71
txt_print_dec
	; LineNumber: 623
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_digit
	sty txt_next_digit+1
	; LineNumber: 624
	lda #$00
	ldx #$00
	sta txt_temp_num_p
	stx txt_temp_num_p+1
	; LineNumber: 625
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 626
	; Calling storevariable on generic assign expression
	sta txt_temp_i
	; LineNumber: 628
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
	; LineNumber: 628
	; LineNumber: 631
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed140
	jmp txt_print_dec_ConditionalTrueBlock120
txt_print_dec_localfailed140
	jmp txt_print_dec_elseblock121
txt_print_dec_ConditionalTrueBlock120: ;Main true block ;keep 
	; LineNumber: 632
	; LineNumber: 634
	
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
	; LineNumber: 635
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 639
	
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
txt_print_dec_rightvarInteger_var144 = $56
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
	; LineNumber: 640
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
	; LineNumber: 639
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd152
	dec txt_temp_num+1
txt_print_dec_WordAdd152
txt_print_dec_elsedoneblock148
	; LineNumber: 641
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	lda txt_temp_num
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 644
	
; // right digit
	; Modulo
	lda #$a
txt_print_dec_val_var153 = $56
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
	; LineNumber: 645
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 648
	jmp txt_print_dec_elsedoneblock122
txt_print_dec_elseblock121
	; LineNumber: 649
	; LineNumber: 652
	
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
	; LineNumber: 653
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 656
	
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
txt_print_dec_rightvarInteger_var157 = $56
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
	; LineNumber: 657
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 658
txt_print_dec_elsedoneblock122
	; LineNumber: 661
	jmp txt_print_dec_elsedoneblock75
txt_print_dec_elseblock74
	; LineNumber: 662
	; LineNumber: 663
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 664
txt_print_dec_elsedoneblock75
	; LineNumber: 666
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock162
txt_print_dec_ConditionalTrueBlock160: ;Main true block ;keep 
	; LineNumber: 665
	jsr txt_cursor_return
txt_print_dec_elsedoneblock162
	; LineNumber: 667
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 210
	; LineNumber: 209
levels_level_size	dc.w	$3e8
levels_draw_level_block165
levels_draw_level
	; LineNumber: 213
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 215
	
; //temp_s:=#level;
	; INTEGER optimization: a=b+c 
	lda #<levels_level
	clc
	adc #$2e
	sta levels_temp_s+0
	lda #>levels_level
	adc #$00
	sta levels_temp_s+1
	; LineNumber: 222
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_draw_level_forloop167
	; LineNumber: 218
	; LineNumber: 219
	; memcpyfast
	ldy #39
levels_draw_level_memcpy177
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_level_memcpy177
	; LineNumber: 220
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd178
	inc levels_dest+1
levels_draw_level_WordAdd178
	; LineNumber: 221
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd179
	inc levels_temp_s+1
levels_draw_level_WordAdd179
	; LineNumber: 222
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
	; LineNumber: 225
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 243
levels_refresh_screen
	; LineNumber: 246
	
; //CopyFullScreen(#screen_buffer,SCREEN_CHAR_LOC);
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop182
	; LineNumber: 251
	; LineNumber: 252
	
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
	; LineNumber: 253
	; memcpyfast
	ldy #39
levels_refresh_screen_memcpy191
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy191
	; LineNumber: 254
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd192
	inc levels_temp_s+1
levels_refresh_screen_WordAdd192
	; LineNumber: 255
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
	; LineNumber: 259
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 264
	; LineNumber: 263
levels_buf_x	dc.b	0
	; LineNumber: 263
levels_buf_y	dc.b	0
levels_get_buffer_block194
levels_get_buffer
	; LineNumber: 266
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var197 = $56
	sta levels_get_buffer_rightvarInteger_var197
	sty levels_get_buffer_rightvarInteger_var197+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var200 = $58
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
	; LineNumber: 268
	; LineNumber: 269
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 274
	; LineNumber: 273
levels_plot_x	dc.b	0
	; LineNumber: 273
levels_plot_y	dc.b	0
	; LineNumber: 273
levels_plot_ch	dc.b	0
levels_plot_buffer_block201
levels_plot_buffer
	; LineNumber: 276
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var204 = $56
	sta levels_plot_buffer_rightvarInteger_var204
	sty levels_plot_buffer_rightvarInteger_var204+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var207 = $58
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
	; LineNumber: 277
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 279
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
dest	= $10
	; LineNumber: 72
temp_s	= $12
c64_chars_block209
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
	bne show_start_screen_elsedoneblock214
show_start_screen_ConditionalTrueBlock212: ;Main true block ;keep 
	; LineNumber: 105
	; LineNumber: 107
	
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 108
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr219
	sta txt_in_str
	lda #>show_start_screen_stringassignstr219
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 109
show_start_screen_elsedoneblock214
	; LineNumber: 114
	rts
	
; //txt::wait_key();
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 119
show_end_screen
	; LineNumber: 121
	jsr txt_cls
	; LineNumber: 122
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock224
show_end_screen_ConditionalTrueBlock223: ;Main true block ;keep 
	; LineNumber: 122
	; LineNumber: 124
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr233
	sta txt_in_str
	lda #>show_end_screen_stringassignstr233
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 126
	jmp show_end_screen_elsedoneblock225
show_end_screen_elseblock224
	; LineNumber: 127
	; LineNumber: 128
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr236
	sta txt_in_str
	lda #>show_end_screen_stringassignstr236
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 129
show_end_screen_elsedoneblock225
	; LineNumber: 131
	jsr txt_wait_key
	; LineNumber: 134
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 137
display_text
	; LineNumber: 139
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 140
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 141
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr239
	sta txt_in_str
	lda #>display_text_stringassignstr239
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 142
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 143
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 144
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 146
	lda #$19
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 147
	lda #$4b
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 148
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 149
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 151
	lda #$19
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$17
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 152
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 153
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 154
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 157
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 158
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 159
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 160
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 161
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 162
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 165
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 166
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 167
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 168
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 171
	lda #$21
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$17
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 172
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 173
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 174
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 175
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 176
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 181
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 184
	; LineNumber: 183
update_status_block241
update_status
	; LineNumber: 186
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 187
	jsr display_text
	; LineNumber: 189
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 193
door
	; LineNumber: 196
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_elseblock245
door_ConditionalTrueBlock244: ;Main true block ;keep 
	; LineNumber: 197
	; LineNumber: 198
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 199
	; Assigning a string : new_status
	lda #<door_stringassignstr254
	sta new_status
	lda #>door_stringassignstr254
	sta new_status+1
	jsr update_status
	; LineNumber: 201
	jmp door_elsedoneblock246
door_elseblock245
	; LineNumber: 202
	; LineNumber: 203
	; Assigning a string : new_status
	lda #<door_stringassignstr257
	sta new_status
	lda #>door_stringassignstr257
	sta new_status+1
	jsr update_status
	; LineNumber: 206
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 207
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 208
door_elsedoneblock246
	; LineNumber: 210
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 214
check_collisions
	; LineNumber: 217
	lda #$b
	cmp charat ;keep
	bne check_collisions_casenext261
	; LineNumber: 219
	; LineNumber: 221
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 222
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr263
	sta new_status
	lda #>check_collisions_stringassignstr263
	sta new_status+1
	jsr update_status
	; LineNumber: 223
	jmp check_collisions_caseend260
check_collisions_casenext261
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext265
	; LineNumber: 226
	; LineNumber: 227
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr267
	sta new_status
	lda #>check_collisions_stringassignstr267
	sta new_status+1
	jsr update_status
	; LineNumber: 228
	jmp check_collisions_caseend260
check_collisions_casenext265
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext269
	; LineNumber: 229
	jsr door
	jmp check_collisions_caseend260
check_collisions_casenext269
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext271
	; LineNumber: 230
	jsr door
	jmp check_collisions_caseend260
check_collisions_casenext271
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext273
	; LineNumber: 234
	; LineNumber: 235
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd275
	inc gold+1
check_collisions_WordAdd275
	; LineNumber: 236
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr276
	sta new_status
	lda #>check_collisions_stringassignstr276
	sta new_status+1
	jsr update_status
	; LineNumber: 238
	jmp check_collisions_caseend260
check_collisions_casenext273
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext278
	; LineNumber: 242
	; LineNumber: 243
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 244
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr280
	sta new_status
	lda #>check_collisions_stringassignstr280
	sta new_status+1
	jsr update_status
	; LineNumber: 246
	jmp check_collisions_caseend260
check_collisions_casenext278
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext282
	; LineNumber: 250
	; LineNumber: 252
	jmp check_collisions_caseend260
check_collisions_casenext282
	; LineNumber: 256
	; LineNumber: 259
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 260
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 263
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 264
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr285
	sta new_status
	lda #>check_collisions_stringassignstr285
	sta new_status+1
	jsr update_status
	; LineNumber: 265
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 266
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 268
check_collisions_caseend260
	; LineNumber: 271
	rts
block1
	; LineNumber: 281
	
; // ********************************
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 282
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 289
MainProgram_while287
MainProgram_loopstart291
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed407
	jmp MainProgram_ConditionalTrueBlock288
MainProgram_localfailed407
	jmp MainProgram_elsedoneblock290
MainProgram_ConditionalTrueBlock288: ;Main true block ;keep 
	; LineNumber: 289
	; LineNumber: 294
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 298
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 299
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr409
	sta new_status
	lda #>MainProgram_stringassignstr409
	sta new_status+1
	jsr update_status
	; LineNumber: 300
	jsr display_text
	; LineNumber: 304
MainProgram_while411
MainProgram_loopstart415
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed469
	jmp MainProgram_ConditionalTrueBlock412
MainProgram_localfailed469
	jmp MainProgram_elsedoneblock414
MainProgram_ConditionalTrueBlock412: ;Main true block ;keep 
	; LineNumber: 305
	; LineNumber: 310
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 311
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 314
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 317
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext472
	; LineNumber: 319
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock477
MainProgram_ConditionalTrueBlock475: ;Main true block ;keep 
	; LineNumber: 319
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock477
	jmp MainProgram_caseend471
MainProgram_casenext472
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext480
	; LineNumber: 320
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock485
MainProgram_ConditionalTrueBlock483: ;Main true block ;keep 
	; LineNumber: 320
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock485
	jmp MainProgram_caseend471
MainProgram_casenext480
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext488
	; LineNumber: 321
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock493
MainProgram_ConditionalTrueBlock491: ;Main true block ;keep 
	; LineNumber: 321
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock493
	jmp MainProgram_caseend471
MainProgram_casenext488
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext496
	; LineNumber: 322
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock501
MainProgram_ConditionalTrueBlock499: ;Main true block ;keep 
	; LineNumber: 322
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock501
MainProgram_casenext496
MainProgram_caseend471
	; LineNumber: 330
	
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
	; LineNumber: 334
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock507
MainProgram_ConditionalTrueBlock505: ;Main true block ;keep 
	; LineNumber: 335
	; LineNumber: 338
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock519
MainProgram_ConditionalTrueBlock517: ;Main true block ;keep 
	; LineNumber: 337
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock519
	; LineNumber: 342
MainProgram_elsedoneblock507
	; LineNumber: 348
	
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
	; LineNumber: 352
	
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
	; LineNumber: 356
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 358
	jmp MainProgram_while411
MainProgram_elsedoneblock414
MainProgram_loopend416
	; LineNumber: 362
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 365
	jmp MainProgram_while287
MainProgram_elsedoneblock290
MainProgram_loopend292
	; LineNumber: 367
	; End of program
	; Ending memory block
EndBlock810
show_start_screen_stringassignstr216		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_start_screen_stringassignstr219		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_end_screen_stringassignstr227		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr230		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr233		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr236		dc.b	"EEK YOU DIED!"
	dc.b	0
display_text_stringassignstr239		dc.b	"                    "
	dc.b	0
door_stringassignstr248		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr251		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr254		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr257		dc.b	"YOU NEED A KEY!"
	dc.b	0
check_collisions_stringassignstr263		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr267		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr276		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr280		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr285		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr294		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr409		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
	org $6000
charset
	incbin "/Users/chris.garrett/GitHub/dungeonc64///custom.bin"
EndBlock6000
