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
	; LineNumber: 323
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
txt_DefineScreen_block6
txt_DefineScreen
	; LineNumber: 267
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
	; LineNumber: 268
	; LineNumber: 269
	rts
	; LineNumber: 270
txt_DefineScreen_elsedoneblock10
	; LineNumber: 273
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
txt_DefineScreen_elsedoneblock18
	; LineNumber: 286
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop21
	; LineNumber: 281
	; LineNumber: 282
	
; // Fill the lookup table with screen positions		
	ldx #$28 ; optimized, look out for bugs
	lda #$20
txt_DefineScreen_fill30
	; integer assignment NodeVar
	ldy txt_temp_address_p+1 ; keep
	lda txt_temp_address_p,x
	dex
	bpl txt_DefineScreen_fill30
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
	bcc txt_DefineScreen_WordAdd31
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd31
	; LineNumber: 285
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
	; LineNumber: 287
	
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
txt_move_to_block34
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
txt_put_ch_block35
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
txt_get_key_block37
txt_get_key
	; LineNumber: 364
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 365
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 366
txt_get_key_while38
txt_get_key_loopstart42
	; Binary clause Simplified: EQUALS
	lda txt_ink
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_get_key_elsedoneblock41
txt_get_key_ConditionalTrueBlock39: ;Main true block ;keep 
	; LineNumber: 367
	; LineNumber: 368
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 369
	jmp txt_get_key_while38
txt_get_key_elsedoneblock41
txt_get_key_loopend43
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
txt_wait_key_block46
txt_wait_key
	; LineNumber: 380
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 381
txt_wait_key_while47
txt_wait_key_loopstart51
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock50
txt_wait_key_ConditionalTrueBlock48: ;Main true block ;keep 
	; LineNumber: 382
	; LineNumber: 383
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 384
	jmp txt_wait_key_while47
txt_wait_key_elsedoneblock50
txt_wait_key_loopend52
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
txt_print_string_block57
txt_print_string
	; LineNumber: 466
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 467
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
	jmp txt_print_string_while58
txt_print_string_elsedoneblock61
txt_print_string_loopend63
	; LineNumber: 474
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock69
txt_print_string_ConditionalTrueBlock67: ;Main true block ;keep 
	; LineNumber: 475
	; LineNumber: 476
	jsr txt_cursor_return
	; LineNumber: 478
txt_print_string_elsedoneblock69
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
txt_print_dec_block72
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
	bcc txt_print_dec_localfailed118
	jmp txt_print_dec_ConditionalTrueBlock74
txt_print_dec_localfailed118
	jmp txt_print_dec_elseblock75
txt_print_dec_ConditionalTrueBlock74: ;Main true block ;keep 
	; LineNumber: 628
	; LineNumber: 631
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed141
	jmp txt_print_dec_ConditionalTrueBlock121
txt_print_dec_localfailed141
	jmp txt_print_dec_elseblock122
txt_print_dec_ConditionalTrueBlock121: ;Main true block ;keep 
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
txt_print_dec_rightvarInteger_var145 = $56
	sta txt_print_dec_rightvarInteger_var145
	sty txt_print_dec_rightvarInteger_var145+1
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
	sbc txt_print_dec_rightvarInteger_var145
txt_print_dec_wordAdd143
	sta txt_print_dec_rightvarInteger_var145
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var145+1
	tay
	lda txt_print_dec_rightvarInteger_var145
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 640
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock149
	bne txt_print_dec_ConditionalTrueBlock147
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock149
	beq txt_print_dec_elsedoneblock149
txt_print_dec_ConditionalTrueBlock147: ;Main true block ;keep 
	; LineNumber: 639
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd153
	dec txt_temp_num+1
txt_print_dec_WordAdd153
txt_print_dec_elsedoneblock149
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
txt_print_dec_val_var154 = $56
	sta txt_print_dec_val_var154
	lda txt__in_n
	sec
txt_print_dec_modulo155
	sbc txt_print_dec_val_var154
	bcs txt_print_dec_modulo155
	adc txt_print_dec_val_var154
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
	jmp txt_print_dec_elsedoneblock123
txt_print_dec_elseblock122
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
txt_print_dec_rightvarInteger_var158 = $56
	sta txt_print_dec_rightvarInteger_var158
	sty txt_print_dec_rightvarInteger_var158+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var158+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var158
	bcs txt_print_dec_wordAdd157
	dey
txt_print_dec_wordAdd157
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
txt_print_dec_elsedoneblock123
	; LineNumber: 661
	jmp txt_print_dec_elsedoneblock76
txt_print_dec_elseblock75
	; LineNumber: 662
	; LineNumber: 663
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 664
txt_print_dec_elsedoneblock76
	; LineNumber: 666
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock163
txt_print_dec_ConditionalTrueBlock161: ;Main true block ;keep 
	; LineNumber: 665
	jsr txt_cursor_return
txt_print_dec_elsedoneblock163
	; LineNumber: 667
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 210
	; LineNumber: 209
levels_level_size	dc.w	$3e8
levels_draw_level_block166
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
levels_draw_level_forloop168
	; LineNumber: 218
	; LineNumber: 219
	; memcpyfast
	ldy #39
levels_draw_level_memcpy178
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_level_memcpy178
	; LineNumber: 220
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd179
	inc levels_dest+1
levels_draw_level_WordAdd179
	; LineNumber: 221
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd180
	inc levels_temp_s+1
levels_draw_level_WordAdd180
	; LineNumber: 222
levels_draw_level_forloopcounter170
levels_draw_level_loopstart171
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_draw_level_forloop168
levels_draw_level_loopdone181: ;keep
levels_draw_level_forloopend169
levels_draw_level_loopend172
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
levels_refresh_screen_forloop183
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
levels_refresh_screen_memcpy192
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy192
	; LineNumber: 254
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd193
	inc levels_temp_s+1
levels_refresh_screen_WordAdd193
	; LineNumber: 255
levels_refresh_screen_forloopcounter185
levels_refresh_screen_loopstart186
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop183
levels_refresh_screen_loopdone194: ;keep
levels_refresh_screen_forloopend184
levels_refresh_screen_loopend187
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
levels_get_buffer_block195
levels_get_buffer
	; LineNumber: 266
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var198 = $56
	sta levels_get_buffer_rightvarInteger_var198
	sty levels_get_buffer_rightvarInteger_var198+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var201 = $58
	sta levels_get_buffer_rightvarInteger_var201
	sty levels_get_buffer_rightvarInteger_var201+1
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
	adc levels_get_buffer_rightvarInteger_var201
levels_get_buffer_wordAdd199
	sta levels_get_buffer_rightvarInteger_var201
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var201+1
	tay
	lda levels_get_buffer_rightvarInteger_var201
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var198
levels_get_buffer_wordAdd196
	sta levels_get_buffer_rightvarInteger_var198
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var198+1
	tay
	lda levels_get_buffer_rightvarInteger_var198
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
levels_plot_buffer_block202
levels_plot_buffer
	; LineNumber: 276
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var205 = $56
	sta levels_plot_buffer_rightvarInteger_var205
	sty levels_plot_buffer_rightvarInteger_var205+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var208 = $58
	sta levels_plot_buffer_rightvarInteger_var208
	sty levels_plot_buffer_rightvarInteger_var208+1
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
	adc levels_plot_buffer_rightvarInteger_var208
levels_plot_buffer_wordAdd206
	sta levels_plot_buffer_rightvarInteger_var208
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var208+1
	tay
	lda levels_plot_buffer_rightvarInteger_var208
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var205
levels_plot_buffer_wordAdd203
	sta levels_plot_buffer_rightvarInteger_var205
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var205+1
	tay
	lda levels_plot_buffer_rightvarInteger_var205
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
c64_chars_block210
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
	bne show_start_screen_elsedoneblock215
show_start_screen_ConditionalTrueBlock213: ;Main true block ;keep 
	; LineNumber: 105
	; LineNumber: 107
	
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 108
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr220
	sta txt_in_str
	lda #>show_start_screen_stringassignstr220
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 109
show_start_screen_elsedoneblock215
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
	beq show_end_screen_elseblock225
show_end_screen_ConditionalTrueBlock224: ;Main true block ;keep 
	; LineNumber: 122
	; LineNumber: 124
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr234
	sta txt_in_str
	lda #>show_end_screen_stringassignstr234
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 126
	jmp show_end_screen_elsedoneblock226
show_end_screen_elseblock225
	; LineNumber: 127
	; LineNumber: 128
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr237
	sta txt_in_str
	lda #>show_end_screen_stringassignstr237
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 129
show_end_screen_elsedoneblock226
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
	lda #<display_text_stringassignstr240
	sta txt_in_str
	lda #>display_text_stringassignstr240
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
update_status_block242
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
	bcc door_elseblock246
door_ConditionalTrueBlock245: ;Main true block ;keep 
	; LineNumber: 197
	; LineNumber: 198
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 199
	; Assigning a string : new_status
	lda #<door_stringassignstr255
	sta new_status
	lda #>door_stringassignstr255
	sta new_status+1
	jsr update_status
	; LineNumber: 201
	jmp door_elsedoneblock247
door_elseblock246
	; LineNumber: 202
	; LineNumber: 203
	; Assigning a string : new_status
	lda #<door_stringassignstr258
	sta new_status
	lda #>door_stringassignstr258
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
door_elsedoneblock247
	; LineNumber: 210
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 214
combat
	; LineNumber: 217
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
	bcc combat_elseblock263
combat_ConditionalTrueBlock262: ;Main true block ;keep 
	; LineNumber: 218
	; LineNumber: 219
	; Assigning a string : new_status
	lda #<combat_stringassignstr280
	sta new_status
	lda #>combat_stringassignstr280
	sta new_status+1
	jsr update_status
	; LineNumber: 220
	jmp combat_elsedoneblock264
combat_elseblock263
	; LineNumber: 222
	; LineNumber: 224
	; Test Inc dec D
	dec health
	; LineNumber: 227
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 228
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 230
	; Assigning a string : new_status
	lda #<combat_stringassignstr283
	sta new_status
	lda #>combat_stringassignstr283
	sta new_status+1
	jsr update_status
	; LineNumber: 232
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock286
	bcs combat_elsedoneblock288
combat_ConditionalTrueBlock286: ;Main true block ;keep 
	; LineNumber: 233
	; LineNumber: 234
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 235
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 236
combat_elsedoneblock288
	; LineNumber: 238
combat_elsedoneblock264
	; LineNumber: 240
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 244
check_collisions
	; LineNumber: 247
	lda #$b
	cmp charat ;keep
	bne check_collisions_casenext293
	; LineNumber: 249
	; LineNumber: 251
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 252
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr295
	sta new_status
	lda #>check_collisions_stringassignstr295
	sta new_status+1
	jsr update_status
	; LineNumber: 253
	jmp check_collisions_caseend292
check_collisions_casenext293
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext297
	; LineNumber: 256
	; LineNumber: 258
	
; // Spider
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr299
	sta new_status
	lda #>check_collisions_stringassignstr299
	sta new_status+1
	jsr update_status
	; LineNumber: 259
	jsr combat
	; LineNumber: 261
	jmp check_collisions_caseend292
check_collisions_casenext297
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext301
	; LineNumber: 264
	; LineNumber: 265
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr303
	sta new_status
	lda #>check_collisions_stringassignstr303
	sta new_status+1
	jsr update_status
	; LineNumber: 266
	jmp check_collisions_caseend292
check_collisions_casenext301
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext305
	; LineNumber: 267
	jsr door
	jmp check_collisions_caseend292
check_collisions_casenext305
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext307
	; LineNumber: 268
	jsr door
	jmp check_collisions_caseend292
check_collisions_casenext307
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext309
	; LineNumber: 275
	; LineNumber: 276
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 277
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr311
	sta new_status
	lda #>check_collisions_stringassignstr311
	sta new_status+1
	jsr update_status
	; LineNumber: 279
	jmp check_collisions_caseend292
check_collisions_casenext309
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext313
	; LineNumber: 281
	; LineNumber: 284
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr315
	sta new_status
	lda #>check_collisions_stringassignstr315
	sta new_status+1
	jsr update_status
	; LineNumber: 285
	jsr combat
	; LineNumber: 286
	jmp check_collisions_caseend292
check_collisions_casenext313
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext317
	; LineNumber: 289
	; LineNumber: 290
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd319
	inc gold+1
check_collisions_WordAdd319
	; LineNumber: 291
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr320
	sta new_status
	lda #>check_collisions_stringassignstr320
	sta new_status+1
	jsr update_status
	; LineNumber: 293
	jmp check_collisions_caseend292
check_collisions_casenext317
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext322
	; LineNumber: 298
	; LineNumber: 300
	jmp check_collisions_caseend292
check_collisions_casenext322
	; LineNumber: 304
	; LineNumber: 307
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 308
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 311
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 312
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr325
	sta new_status
	lda #>check_collisions_stringassignstr325
	sta new_status+1
	jsr update_status
	; LineNumber: 313
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 314
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 316
check_collisions_caseend292
	; LineNumber: 319
	rts
block1
	; LineNumber: 329
	
; // ********************************
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 330
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 337
MainProgram_while327
MainProgram_loopstart331
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed447
	jmp MainProgram_ConditionalTrueBlock328
MainProgram_localfailed447
	jmp MainProgram_elsedoneblock330
MainProgram_ConditionalTrueBlock328: ;Main true block ;keep 
	; LineNumber: 337
	; LineNumber: 342
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 346
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 347
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr449
	sta new_status
	lda #>MainProgram_stringassignstr449
	sta new_status+1
	jsr update_status
	; LineNumber: 348
	jsr display_text
	; LineNumber: 352
MainProgram_while451
MainProgram_loopstart455
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed509
	jmp MainProgram_ConditionalTrueBlock452
MainProgram_localfailed509
	jmp MainProgram_elsedoneblock454
MainProgram_ConditionalTrueBlock452: ;Main true block ;keep 
	; LineNumber: 353
	; LineNumber: 358
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 359
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 362
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 365
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext512
	; LineNumber: 367
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock517
MainProgram_ConditionalTrueBlock515: ;Main true block ;keep 
	; LineNumber: 367
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock517
	jmp MainProgram_caseend511
MainProgram_casenext512
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext520
	; LineNumber: 368
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock525
MainProgram_ConditionalTrueBlock523: ;Main true block ;keep 
	; LineNumber: 368
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock525
	jmp MainProgram_caseend511
MainProgram_casenext520
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext528
	; LineNumber: 369
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock533
MainProgram_ConditionalTrueBlock531: ;Main true block ;keep 
	; LineNumber: 369
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock533
	jmp MainProgram_caseend511
MainProgram_casenext528
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext536
	; LineNumber: 370
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock541
MainProgram_ConditionalTrueBlock539: ;Main true block ;keep 
	; LineNumber: 370
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock541
MainProgram_casenext536
MainProgram_caseend511
	; LineNumber: 378
	
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
	; LineNumber: 382
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock547
MainProgram_ConditionalTrueBlock545: ;Main true block ;keep 
	; LineNumber: 383
	; LineNumber: 386
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock559
MainProgram_ConditionalTrueBlock557: ;Main true block ;keep 
	; LineNumber: 385
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock559
	; LineNumber: 390
MainProgram_elsedoneblock547
	; LineNumber: 396
	
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
	; LineNumber: 400
	
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
	; LineNumber: 404
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 406
	jmp MainProgram_while451
MainProgram_elsedoneblock454
MainProgram_loopend456
	; LineNumber: 410
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 413
	jmp MainProgram_while327
MainProgram_elsedoneblock330
MainProgram_loopend332
	; LineNumber: 415
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
display_text_stringassignstr240		dc.b	"                    "
	dc.b	0
door_stringassignstr249		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr252		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr255		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr258		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr266		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr269		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr280		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr283		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr295		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr299		dc.b	"SPIDER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr303		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr311		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr315		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr320		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr325		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr334		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr449		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
	org $6000
charset
	incbin "/Users/chris.garrett/GitHub/dungeonc64///custom.bin"
EndBlock6000
