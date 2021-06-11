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
	; LineNumber: 269
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
	; LineNumber: 32
zeronine	dc.b $038, $044, $082, $082, $082, $044, $038, $00
	dc.b $030, $050, $090, $010, $010, $010, $0fe, $00
	dc.b $07c, $082, $02, $07c, $080, $082, $0fe, $00
	dc.b $0fe, $084, $08, $01c, $082, $082, $07c, $00
	dc.b $0c, $018, $028, $04a, $0fe, $0a, $01c, $00
	dc.b $0fe, $082, $0fc, $02, $082, $082, $07c, $00
	dc.b $07c, $082, $080, $0fc, $082, $082, $07c, $00
	dc.b $0fe, $084, $08, $08, $010, $010, $038, $00
	dc.b $07c, $082, $082, $07c, $082, $082, $07c, $00
	dc.b $07c, $082, $082, $082, $07c, $04, $078, $00
	; LineNumber: 45
custom	dc.b $00, $00, $07e, $00, $03c, $00, $018, $00
	dc.b $00, $0ef, $08a, $0c, $00, $0fe, $0aa, $080
	dc.b $00, $00, $00, $018, $00, $03c, $00, $07e
	dc.b $00, $00, $03c, $07e, $0fe, $07a, $07e, $0fe
	dc.b $07e
	; LineNumber: 53
alpha	dc.b $05c, $057, $0e9, $059, $039, $01e, $014, $036
	dc.b $010, $028, $028, $044, $07c, $044, $0ee, $00
	dc.b $0fc, $042, $042, $07c, $042, $042, $0fc, $00
	dc.b $038, $044, $082, $080, $082, $044, $038, $00
	dc.b $0fc, $042, $042, $042, $042, $042, $0fc, $00
	dc.b $0fe, $042, $048, $078, $048, $042, $0fe, $00
	dc.b $0fe, $042, $048, $078, $048, $040, $0e0, $00
	dc.b $03c, $042, $080, $08e, $082, $042, $03c, $00
	dc.b $0ee, $044, $07c, $044, $044, $044, $0ee, $00
	dc.b $0fe, $010, $010, $010, $010, $010, $0fe, $00
	dc.b $07c, $010, $010, $010, $090, $090, $060, $00
	dc.b $0ee, $044, $048, $070, $048, $044, $0ee, $00
	dc.b $0e0, $040, $040, $040, $042, $042, $0fe, $00
	dc.b $0ee, $054, $054, $054, $044, $044, $0ee, $00
	dc.b $0ee, $064, $054, $054, $04c, $04c, $0e4, $00
	dc.b $038, $044, $082, $082, $082, $044, $038, $00
	dc.b $0fc, $042, $042, $042, $07c, $040, $0e0, $00
	dc.b $038, $044, $082, $082, $092, $04c, $03a, $00
	dc.b $0fc, $042, $042, $042, $07c, $048, $0ee, $00
	dc.b $07c, $082, $080, $07c, $02, $082, $07c, $00
	dc.b $0fe, $092, $010, $010, $010, $010, $038, $00
	dc.b $0ee, $044, $044, $044, $044, $044, $038, $00
	dc.b $0ee, $044, $044, $028, $028, $028, $010, $00
	dc.b $0ee, $044, $044, $054, $054, $06c, $044, $00
	dc.b $0ee, $044, $028, $010, $028, $044, $0ee, $00
	dc.b $0ee, $044, $028, $028, $010, $010, $038, $00
	dc.b $0fe, $084, $08, $010, $020, $042, $0fe, $00
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
	; LineNumber: 264
txt_temp_c_p	=  $0D
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
	ldx #$04
	sta txt_temp_address_p
	stx txt_temp_address_p+1
	; LineNumber: 281
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop13
	; LineNumber: 276
	; LineNumber: 277
	ldy #$28 ; optimized, look out for bugs
	lda #$20
txt_DefineScreen_fill22
	sta (txt_temp_address_p),y
	dey
	bpl txt_DefineScreen_fill22
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
	bcc txt_DefineScreen_WordAdd23
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd23
	; LineNumber: 280
txt_DefineScreen_forloopcounter15
txt_DefineScreen_loopstart16
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop13
txt_DefineScreen_loopdone24: ;keep
txt_DefineScreen_forloopend14
txt_DefineScreen_loopend17
	; LineNumber: 282
	lda #$00
	ldx #$d8
	sta txt_temp_c_p
	stx txt_temp_c_p+1
	; LineNumber: 283
	lda #$0
	ldy #0
txt_DefineScreen_fill25
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill25
	; LineNumber: 284
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd26
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd26
	; LineNumber: 285
	lda #$0
	ldy #0
txt_DefineScreen_fill27
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill27
	; LineNumber: 286
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd28
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd28
	; LineNumber: 287
	lda #$0
	ldy #0
txt_DefineScreen_fill29
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill29
	; LineNumber: 288
	lda txt_temp_c_p
	clc
	adc #$ff
	sta txt_temp_c_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd30
	inc txt_temp_c_p+1
txt_DefineScreen_WordAdd30
	; LineNumber: 289
	lda #$0
	ldy #0
txt_DefineScreen_fill31
	sta (txt_temp_c_p),y
	iny
	cpy #$ff
	bne txt_DefineScreen_fill31
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
txt_move_to_block32
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
txt_put_ch_block33
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
txt_get_key_block35
txt_get_key
	; LineNumber: 365
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 366
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 367
txt_get_key_while36
txt_get_key_loopstart40
	; Binary clause Simplified: EQUALS
	lda txt_ink
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_get_key_elsedoneblock39
txt_get_key_ConditionalTrueBlock37: ;Main true block ;keep 
	; LineNumber: 368
	; LineNumber: 369
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_ink
	; LineNumber: 370
	jmp txt_get_key_while36
txt_get_key_elsedoneblock39
txt_get_key_loopend41
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
txt_wait_key_block44
txt_wait_key
	; LineNumber: 381
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 382
txt_wait_key_while45
txt_wait_key_loopstart49
	; Binary clause Simplified: EQUALS
	lda txt_tmp_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock48
txt_wait_key_ConditionalTrueBlock46: ;Main true block ;keep 
	; LineNumber: 383
	; LineNumber: 384
	; Peek
	lda $c6 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_tmp_key
	; LineNumber: 385
	jmp txt_wait_key_while45
txt_wait_key_elsedoneblock48
txt_wait_key_loopend50
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
txt_print_string_block55
txt_print_string
	; LineNumber: 467
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 468
txt_print_string_while56
txt_print_string_loopstart60
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock59
txt_print_string_ConditionalTrueBlock57: ;Main true block ;keep 
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
	jmp txt_print_string_while56
txt_print_string_elsedoneblock59
txt_print_string_loopend61
	; LineNumber: 475
	
; //cursor_down();
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock67
txt_print_string_ConditionalTrueBlock65: ;Main true block ;keep 
	; LineNumber: 476
	; LineNumber: 477
	jsr txt_cursor_return
	; LineNumber: 479
txt_print_string_elsedoneblock67
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
txt_print_dec_block70
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
	bcc txt_print_dec_localfailed116
	jmp txt_print_dec_ConditionalTrueBlock72
txt_print_dec_localfailed116
	jmp txt_print_dec_elseblock73
txt_print_dec_ConditionalTrueBlock72: ;Main true block ;keep 
	; LineNumber: 629
	; LineNumber: 632
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed139
	jmp txt_print_dec_ConditionalTrueBlock119
txt_print_dec_localfailed139
	jmp txt_print_dec_elseblock120
txt_print_dec_ConditionalTrueBlock119: ;Main true block ;keep 
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
txt_print_dec_rightvarInteger_var143 =  $56
	sta txt_print_dec_rightvarInteger_var143
	sty txt_print_dec_rightvarInteger_var143+1
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
	sbc txt_print_dec_rightvarInteger_var143
txt_print_dec_wordAdd141
	sta txt_print_dec_rightvarInteger_var143
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var143+1
	tay
	lda txt_print_dec_rightvarInteger_var143
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 641
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock147
	bne txt_print_dec_ConditionalTrueBlock145
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock147
	beq txt_print_dec_elsedoneblock147
txt_print_dec_ConditionalTrueBlock145: ;Main true block ;keep 
	; LineNumber: 640
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd151
	dec txt_temp_num+1
txt_print_dec_WordAdd151
txt_print_dec_elsedoneblock147
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
txt_print_dec_val_var152 =  $56
	sta txt_print_dec_val_var152
	lda txt__in_n
	sec
txt_print_dec_modulo153
	sbc txt_print_dec_val_var152
	bcs txt_print_dec_modulo153
	adc txt_print_dec_val_var152
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
	jmp txt_print_dec_elsedoneblock121
txt_print_dec_elseblock120
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
txt_print_dec_rightvarInteger_var156 =  $56
	sta txt_print_dec_rightvarInteger_var156
	sty txt_print_dec_rightvarInteger_var156+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var156+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var156
	bcs txt_print_dec_wordAdd155
	dey
txt_print_dec_wordAdd155
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
txt_print_dec_elsedoneblock121
	; LineNumber: 662
	jmp txt_print_dec_elsedoneblock74
txt_print_dec_elseblock73
	; LineNumber: 663
	; LineNumber: 664
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 665
txt_print_dec_elsedoneblock74
	; LineNumber: 667
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock161
txt_print_dec_ConditionalTrueBlock159: ;Main true block ;keep 
	; LineNumber: 666
	jsr txt_cursor_return
txt_print_dec_elsedoneblock161
	; LineNumber: 668
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
levels_draw_level_forloop166
	; LineNumber: 20
	; LineNumber: 21
	; memcpyfast
	ldy #39
levels_draw_level_memcpy176
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_level_memcpy176
	; LineNumber: 22
	lda levels_dest
	clc
	adc #$28
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd177
	inc levels_dest+1
levels_draw_level_WordAdd177
	; LineNumber: 23
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_level_WordAdd178
	inc levels_temp_s+1
levels_draw_level_WordAdd178
	; LineNumber: 24
levels_draw_level_forloopcounter168
levels_draw_level_loopstart169
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_draw_level_forloop166
levels_draw_level_loopdone179: ;keep
levels_draw_level_forloopend167
levels_draw_level_loopend170
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
levels_refresh_screen_forloop181
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
levels_refresh_screen_memcpy190
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy190
	; LineNumber: 56
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd191
	inc levels_temp_s+1
levels_refresh_screen_WordAdd191
	; LineNumber: 57
levels_refresh_screen_forloopcounter183
levels_refresh_screen_loopstart184
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$14
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop181
levels_refresh_screen_loopdone192: ;keep
levels_refresh_screen_forloopend182
levels_refresh_screen_loopend185
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
levels_get_buffer_block193
levels_get_buffer
	; LineNumber: 68
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var196 =  $56
	sta levels_get_buffer_rightvarInteger_var196
	sty levels_get_buffer_rightvarInteger_var196+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var199 =  $58
	sta levels_get_buffer_rightvarInteger_var199
	sty levels_get_buffer_rightvarInteger_var199+1
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
	adc levels_get_buffer_rightvarInteger_var199
levels_get_buffer_wordAdd197
	sta levels_get_buffer_rightvarInteger_var199
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var199+1
	tay
	lda levels_get_buffer_rightvarInteger_var199
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var196
levels_get_buffer_wordAdd194
	sta levels_get_buffer_rightvarInteger_var196
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var196+1
	tay
	lda levels_get_buffer_rightvarInteger_var196
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
levels_plot_buffer_block200
levels_plot_buffer
	; LineNumber: 78
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var203 =  $56
	sta levels_plot_buffer_rightvarInteger_var203
	sty levels_plot_buffer_rightvarInteger_var203+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var206 =  $58
	sta levels_plot_buffer_rightvarInteger_var206
	sty levels_plot_buffer_rightvarInteger_var206+1
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
	adc levels_plot_buffer_rightvarInteger_var206
levels_plot_buffer_wordAdd204
	sta levels_plot_buffer_rightvarInteger_var206
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var206+1
	tay
	lda levels_plot_buffer_rightvarInteger_var206
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var203
levels_plot_buffer_wordAdd201
	sta levels_plot_buffer_rightvarInteger_var203
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var203+1
	tay
	lda levels_plot_buffer_rightvarInteger_var203
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
; // Custom characterset
; // rem character 60
; // rem character 61
; // rem character 62
; // rem door char
; // rem character 0
; // rem character 1
; // rem character 2
; // rem character 3
; // rem character 4
; // rem character 5
; // rem character 6
; // rem character 7
; // rem character 8
; // rem character 9
; // rem character 10
; // rem character 11
; // rem character 12
; // rem character 13
; // rem character 14
; // rem character 15
; // rem character 16
; // rem character 17
; // rem character 18
; // rem character 19
; // rem character 20
; // rem character 21
; // rem character 22
; // rem character 23
; // rem character 24
; // rem character 25
; // rem character 26
	; NodeProcedureDecl -1
	; ***********  Defining procedure : c64_chars
	;    Procedure type : User-defined procedure
	; LineNumber: 88
	; LineNumber: 87
dest	=  $0D
	; LineNumber: 87
temp_s	=  $10
c64_chars_block207
c64_chars
	; LineNumber: 90
	
; // Set to use the new characterset
	; Copy charset from ROM
	sei 
	lda #$33 ;from rom - rom visible at d800
	sta $01
	ldy #$00
c64_chars_charsetcopy208
	lda $D000 + $00,y
	sta $3000+$00,y
	lda $D000 + $64,y
	sta $3000+$64,y
	lda $D000 + $c8,y
	sta $3000+$c8,y
	lda $D000 + $12c,y
	sta $3000+$12c,y
	lda $D000 + $190,y
	sta $3000+$190,y
	lda $D000 + $1f4,y
	sta $3000+$1f4,y
	lda $D000 + $258,y
	sta $3000+$258,y
	lda $D000 + $2bc,y
	sta $3000+$2bc,y
	dey
	bne c64_chars_charsetcopy208
	lda #$37
	sta $01
	; LineNumber: 90
	lda $d018
	and #%11110001
	ora #12
	sta $d018
	; LineNumber: 94
	
; // Destination address
	lda #$00
	ldx #$30
	sta dest
	stx dest+1
	; LineNumber: 95
	lda #<alpha
	ldx #>alpha
	sta temp_s
	stx temp_s+1
	; LineNumber: 96
	; memcpy
	ldy #0
c64_chars_memcpy209
	lda (temp_s),y
	sta (dest),y
	iny
	cpy #$d8
	bne c64_chars_memcpy209
	; LineNumber: 99
	
; // Copy selected 0-9 bytes
	lda #$80
	ldx #$31
	sta dest
	stx dest+1
	; LineNumber: 100
	lda #<zeronine
	ldx #>zeronine
	sta temp_s
	stx temp_s+1
	; LineNumber: 101
	; memcpyfast
	ldy #79
c64_chars_memcpy210
	lda (temp_s),y
	sta (dest),y
	dey
	bpl c64_chars_memcpy210
	; LineNumber: 104
	
; // Copy char 48 bytes
	lda #$60
	ldx #$31
	sta dest
	stx dest+1
	; LineNumber: 105
	; INTEGER optimization: a=b+c 
	lda #<custom
	clc
	adc #$00
	sta temp_s+0
	lda #>custom
	adc #$00
	sta temp_s+1
	; LineNumber: 106
	; memcpyfast
	ldy #7
c64_chars_memcpy212
	lda (temp_s),y
	sta (dest),y
	dey
	bpl c64_chars_memcpy212
	; LineNumber: 109
	
; // Copy remaining 4 custom char bytes
	lda #$e0
	ldx #$31
	sta dest
	stx dest+1
	; LineNumber: 110
	; INTEGER optimization: a=b+c 
	lda #<custom
	clc
	adc #$00
	sta temp_s+0
	lda #>custom
	adc #$00
	sta temp_s+1
	; LineNumber: 111
	; memcpyfast
	ldy #23
c64_chars_memcpy214
	lda (temp_s),y
	sta (dest),y
	dey
	bpl c64_chars_memcpy214
	; LineNumber: 112
	lda #$18
	ldx #$31
	sta dest
	stx dest+1
	; LineNumber: 113
	; INTEGER optimization: a=b+c 
	lda #<custom
	clc
	adc #$18
	sta temp_s+0
	lda #>custom
	adc #$00
	sta temp_s+1
	; LineNumber: 114
	; memcpyfast
	ldy #7
c64_chars_memcpy216
	lda (temp_s),y
	sta (dest),y
	dey
	bpl c64_chars_memcpy216
	; LineNumber: 117
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 120
	
; // Black screen
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $d020
	; LineNumber: 121
	; Poke
	; Optimization: shift is zero
	sta $d021
	; LineNumber: 124
	
; // Forecolour to white for now
	; Clear screen with offset
	lda #$1
	ldx #$fa
c64_chars_clearloop217
	dex
	sta $0000+$d800,x
	sta $00fa+$d800,x
	sta $01f4+$d800,x
	sta $02ee+$d800,x
	bne c64_chars_clearloop217
	; LineNumber: 127
	
; // Ensure no flashing cursor
	jsr txt_cursor_off
	; LineNumber: 129
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 135
show_start_screen
	; LineNumber: 137
	jsr txt_cls
	; LineNumber: 138
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_elsedoneblock222
show_start_screen_ConditionalTrueBlock220: ;Main true block ;keep 
	; LineNumber: 138
	; LineNumber: 140
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr227
	sta txt_in_str
	lda #>show_start_screen_stringassignstr227
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 141
show_start_screen_elsedoneblock222
	; LineNumber: 143
	jsr txt_wait_key
	; LineNumber: 146
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 151
show_end_screen
	; LineNumber: 153
	jsr txt_cls
	; LineNumber: 154
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock232
show_end_screen_ConditionalTrueBlock231: ;Main true block ;keep 
	; LineNumber: 154
	; LineNumber: 156
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr241
	sta txt_in_str
	lda #>show_end_screen_stringassignstr241
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 158
	jmp show_end_screen_elsedoneblock233
show_end_screen_elseblock232
	; LineNumber: 159
	; LineNumber: 160
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr244
	sta txt_in_str
	lda #>show_end_screen_stringassignstr244
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 161
show_end_screen_elsedoneblock233
	; LineNumber: 163
	jsr txt_wait_key
	; LineNumber: 166
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 170
door
	; LineNumber: 173
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_elseblock249
door_ConditionalTrueBlock248: ;Main true block ;keep 
	; LineNumber: 174
	; LineNumber: 175
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 176
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr258
	sta txt_in_str
	lda #>door_stringassignstr258
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 178
	jmp door_elsedoneblock250
door_elseblock249
	; LineNumber: 179
	; LineNumber: 181
	; Assigning a string : txt_in_str
	lda #<door_stringassignstr261
	sta txt_in_str
	lda #>door_stringassignstr261
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 184
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 185
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 186
door_elsedoneblock250
	; LineNumber: 188
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 192
check_collisions
	; LineNumber: 194
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 195
	lda #$b
	cmp charat ;keep
	bne check_collisions_casenext265
	; LineNumber: 197
	; LineNumber: 199
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 200
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr267
	sta txt_in_str
	lda #>check_collisions_stringassignstr267
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 201
	jmp check_collisions_caseend264
check_collisions_casenext265
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext269
	; LineNumber: 204
	; LineNumber: 205
	
; // Artifact
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr271
	sta txt_in_str
	lda #>check_collisions_stringassignstr271
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 206
	jmp check_collisions_caseend264
check_collisions_casenext269
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext273
	; LineNumber: 207
	jsr door
	jmp check_collisions_caseend264
check_collisions_casenext273
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext275
	; LineNumber: 208
	jsr door
	jmp check_collisions_caseend264
check_collisions_casenext275
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext277
	; LineNumber: 213
	; LineNumber: 215
	jmp check_collisions_caseend264
check_collisions_casenext277
	; LineNumber: 219
	; LineNumber: 222
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 223
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 226
	
; // Unknown
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 227
	; Assigning a string : txt_in_str
	lda #<check_collisions_stringassignstr280
	sta txt_in_str
	lda #>check_collisions_stringassignstr280
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 228
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 229
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 231
check_collisions_caseend264
	; LineNumber: 234
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 238
init
	; LineNumber: 241
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 242
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 245
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 248
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 250
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 251
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 254
	
; // Draw current level
	jsr levels_draw_level
	; LineNumber: 257
	
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
	; LineNumber: 260
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 261
	rts
block1
	; LineNumber: 275
	
; // C64 has it's own special characters
	jsr c64_chars
	; LineNumber: 276
	lda #$0
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 283
MainProgram_while283
MainProgram_loopstart287
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed401
	jmp MainProgram_ConditionalTrueBlock284
MainProgram_localfailed401
	jmp MainProgram_elsedoneblock286
MainProgram_ConditionalTrueBlock284: ;Main true block ;keep 
	; LineNumber: 283
	; LineNumber: 288
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 292
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 297
MainProgram_while403
MainProgram_loopstart407
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed461
	jmp MainProgram_ConditionalTrueBlock404
MainProgram_localfailed461
	jmp MainProgram_elsedoneblock406
MainProgram_ConditionalTrueBlock404: ;Main true block ;keep 
	; LineNumber: 298
	; LineNumber: 303
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 304
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 307
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 310
	lda #$51
	cmp key_press ;keep
	bne MainProgram_casenext464
	; LineNumber: 312
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock469
MainProgram_ConditionalTrueBlock467: ;Main true block ;keep 
	; LineNumber: 312
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock469
	jmp MainProgram_caseend463
MainProgram_casenext464
	lda #$41
	cmp key_press ;keep
	bne MainProgram_casenext472
	; LineNumber: 313
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock477
MainProgram_ConditionalTrueBlock475: ;Main true block ;keep 
	; LineNumber: 313
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock477
	jmp MainProgram_caseend463
MainProgram_casenext472
	lda #$4f
	cmp key_press ;keep
	bne MainProgram_casenext480
	; LineNumber: 314
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock485
MainProgram_ConditionalTrueBlock483: ;Main true block ;keep 
	; LineNumber: 314
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock485
	jmp MainProgram_caseend463
MainProgram_casenext480
	lda #$50
	cmp key_press ;keep
	bne MainProgram_casenext488
	; LineNumber: 315
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock493
MainProgram_ConditionalTrueBlock491: ;Main true block ;keep 
	; LineNumber: 315
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock493
MainProgram_casenext488
MainProgram_caseend463
	; LineNumber: 323
	
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
	; LineNumber: 327
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq MainProgram_elsedoneblock499
MainProgram_ConditionalTrueBlock497: ;Main true block ;keep 
	; LineNumber: 328
	; LineNumber: 331
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock511
MainProgram_ConditionalTrueBlock509: ;Main true block ;keep 
	; LineNumber: 330
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock511
	; LineNumber: 335
MainProgram_elsedoneblock499
	; LineNumber: 341
	
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
	; LineNumber: 345
	
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
	; LineNumber: 349
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 351
	jmp MainProgram_while403
MainProgram_elsedoneblock406
MainProgram_loopend408
	; LineNumber: 355
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 358
	jmp MainProgram_while283
MainProgram_elsedoneblock286
MainProgram_loopend288
	; LineNumber: 360
	; End of program
	; Ending memory block
EndBlock810
show_start_screen_stringassignstr224		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_start_screen_stringassignstr227		dc.b	"DUNGEON CRAWL GAME FOR COMMODORES"
	dc.b	0
show_end_screen_stringassignstr235		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr238		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr241		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr244		dc.b	"EEK YOU DIED!"
	dc.b	0
door_stringassignstr252		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr255		dc.b	"YOU NEED A KEY!          "
	dc.b	0
door_stringassignstr258		dc.b	"KEY USED!                "
	dc.b	0
door_stringassignstr261		dc.b	"YOU NEED A KEY!          "
	dc.b	0
check_collisions_stringassignstr267		dc.b	"KEY!              "
	dc.b	0
check_collisions_stringassignstr271		dc.b	"ARTIFACT!         "
	dc.b	0
check_collisions_stringassignstr280		dc.b	"EXISTING TILE:       "
	dc.b	0
