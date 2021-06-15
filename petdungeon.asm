 processor 6502
	org $1100
	; Starting new memory block at $1100
StartBlock1100
	; LineNumber: 457
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
	; LineNumber: 16
txt_this_bbc	dc.b	$00
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
	; LineNumber: 12
levels_this_string		dc.b	"                              "
	dc.b	0
	; LineNumber: 15
levels_screen_buffer	dc.b	 
	org levels_screen_buffer+1000
	; LineNumber: 19
levels_tiles
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map - Tiles.bin"
	; LineNumber: 28
levels_level
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map.bin"
	; LineNumber: 29
levels_level_p	= $0D
	; LineNumber: 52
player_char	dc.b	$00
	; LineNumber: 53
space_char	dc.b	$20
	; LineNumber: 55
key_press	dc.b	$00
	; LineNumber: 56
charat	dc.b	0
	; LineNumber: 57
game_won	dc.b	0
	; LineNumber: 57
game_running	dc.b	0
	; LineNumber: 58
x	dc.b	0
	; LineNumber: 58
y	dc.b	0
	; LineNumber: 58
oldx	dc.b	0
	; LineNumber: 58
oldy	dc.b	0
	; LineNumber: 60
new_status	= $10
	; LineNumber: 60
the_status	= $12
	; LineNumber: 60
p	= $22
	; LineNumber: 63
keys	dc.b	$00
	; LineNumber: 64
gold	dc.w	$00
	; LineNumber: 65
health	dc.b	$0c
	; LineNumber: 68
attack	dc.b	$0c
	; LineNumber: 69
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
	;    Procedure type : User-defined procedure
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
	;    Procedure type : User-defined procedure
	; init random256
Random
	lda #$01
	asl
	bcc initrandom256_RandomSkip4
	eor #$4d
initrandom256_RandomSkip4
	sta Random+1
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_screen_mode
	;    Procedure type : User-defined procedure
	; LineNumber: 270
	; LineNumber: 269
txt_selected_mode	dc.b	0
txt_screen_mode_block5
txt_screen_mode
	; LineNumber: 272
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 273
	; Assigning to register
	; Assigning register : _y
	ldy #$0
	; LineNumber: 274
	; Assigning to register
	; Assigning register : _a
	lda #$16
	; LineNumber: 275
	jsr $ffee
	; LineNumber: 276
	; Assigning to register
	; Assigning register : _a
	lda txt_selected_mode
	; LineNumber: 277
	
; // Again, need to replace with a mode param
	jsr $ffee
	; LineNumber: 279
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_current_bbc
	;    Procedure type : User-defined procedure
	; LineNumber: 282
txt_current_bbc
	; LineNumber: 283
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 284
	; Assigning to register
	; Assigning register : _x
	ldx #$1
	; LineNumber: 285
	jsr $fff4
	; LineNumber: 286
	; Assigning from register
	stx txt_this_bbc
	; LineNumber: 287
	lda txt_this_bbc
	rts
	; LineNumber: 288
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cls
	;    Procedure type : User-defined procedure
	; LineNumber: 291
txt_cls
	; LineNumber: 293
	; Binary clause Simplified: EQUALS
	jsr txt_current_bbc
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_cls_elseblock10
txt_cls_ConditionalTrueBlock9: ;Main true block ;keep 
	; LineNumber: 294
	; LineNumber: 296
	
; // Electron
	lda #$6
	; Calling storevariable on generic assign expression
	sta txt_selected_mode
	jsr txt_screen_mode
	; LineNumber: 298
	jmp txt_cls_elsedoneblock11
txt_cls_elseblock10
	; LineNumber: 299
	; LineNumber: 301
	
; // if BBC
	lda #$7
	; Calling storevariable on generic assign expression
	sta txt_selected_mode
	jsr txt_screen_mode
	; LineNumber: 302
txt_cls_elsedoneblock11
	; LineNumber: 304
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 305
	; Assigning to register
	; Assigning register : _y
	ldy #$0
	; LineNumber: 306
	; Assigning to register
	; Assigning register : _a
	lda #$c
	; LineNumber: 307
	jsr $ffee
	; LineNumber: 308
	; Assigning to register
	; Assigning register : _a
	lda #$1e
	; LineNumber: 309
	jsr $ffee
	; LineNumber: 310
	jsr txt_DefineScreen
	; LineNumber: 313
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_DefineScreen
	;    Procedure type : User-defined procedure
	; LineNumber: 319
	; LineNumber: 318
txt_y	dc.b	0
txt_DefineScreen_block16
txt_DefineScreen
	; LineNumber: 321
	; Binary clause INTEGER: NOTEQUALS
	; Load Integer array
	ldx #0 ; watch for bug, Integer array has max index of 128
	lda txt_ytab,x
	ldy txt_ytab+1,x
txt_DefineScreen_rightvarInteger_var22 = $54
	sta txt_DefineScreen_rightvarInteger_var22
	sty txt_DefineScreen_rightvarInteger_var22+1
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_DefineScreen_rightvarInteger_var22+1   ; compare high bytes
	cmp #$00 ;keep
	beq txt_DefineScreen_pass123
	jmp txt_DefineScreen_ConditionalTrueBlock18
txt_DefineScreen_pass123
	lda txt_DefineScreen_rightvarInteger_var22
	cmp #$00 ;keep
	beq txt_DefineScreen_elsedoneblock20
	jmp txt_DefineScreen_ConditionalTrueBlock18
txt_DefineScreen_ConditionalTrueBlock18: ;Main true block ;keep 
	; LineNumber: 322
	; LineNumber: 323
	rts
	; LineNumber: 324
txt_DefineScreen_elsedoneblock20
	; LineNumber: 326
	; Binary clause Simplified: EQUALS
	jsr txt_current_bbc
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_DefineScreen_localfailed51
	jmp txt_DefineScreen_ConditionalTrueBlock26
txt_DefineScreen_localfailed51
	jmp txt_DefineScreen_elseblock27
txt_DefineScreen_ConditionalTrueBlock26: ;Main true block ;keep 
	; LineNumber: 327
	; LineNumber: 329
	
; // Electron
	; Integer constant assigning
	ldy #$60
	lda #$08
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 335
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop53
	; LineNumber: 331
	; LineNumber: 332
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
	; LineNumber: 333
	lda txt_temp_address_p
	clc
	adc #$31
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd61
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd61
	; LineNumber: 334
txt_DefineScreen_forloopcounter55
txt_DefineScreen_loopstart56
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop53
txt_DefineScreen_loopdone62: ;keep
txt_DefineScreen_forloopend54
txt_DefineScreen_loopend57
	; LineNumber: 338
	jmp txt_DefineScreen_elsedoneblock28
txt_DefineScreen_elseblock27
	; LineNumber: 339
	; LineNumber: 341
	
; // if BBC
	; Integer constant assigning
	ldy #$7c
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 347
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop64
	; LineNumber: 343
	; LineNumber: 344
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
	; LineNumber: 345
	lda txt_temp_address_p
	clc
	adc #$28
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd72
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd72
	; LineNumber: 346
txt_DefineScreen_forloopcounter66
txt_DefineScreen_loopstart67
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop64
txt_DefineScreen_loopdone73: ;keep
txt_DefineScreen_forloopend65
txt_DefineScreen_loopend68
	; LineNumber: 347
txt_DefineScreen_elsedoneblock28
	; LineNumber: 349
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 352
	; LineNumber: 351
txt__text_x	dc.b	0
	; LineNumber: 351
txt__text_y	dc.b	0
txt_move_to_block74
txt_move_to
	; LineNumber: 353
	; Assigning to register
	; Assigning register : _a
	lda #$1f
	; LineNumber: 354
	jsr $ffee
	; LineNumber: 355
	; Assigning to register
	; Assigning register : _a
	lda txt__text_x
	; LineNumber: 356
	jsr $ffee
	; LineNumber: 357
	; Assigning to register
	; Assigning register : _a
	lda txt__text_y
	; LineNumber: 358
	jsr $ffee
	; LineNumber: 359
	rts
	
; //CURSOR_OFF
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_off
	;    Procedure type : User-defined procedure
	; LineNumber: 384
txt_cursor_off
	; LineNumber: 386
	; Poke
	; Optimization: shift is zero
	lda #$a
	sta $fe00
	; LineNumber: 387
	; Poke
	; Optimization: shift is zero
	lda #$20
	sta $fe01
	; LineNumber: 389
	rts
	
; //CURSOR Carriage Return
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 394
txt_cursor_return
	; LineNumber: 396
	jsr $ffe7
	; LineNumber: 398
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 436
	; LineNumber: 433
txt_ch	dc.b	0
	; LineNumber: 434
txt_next_ch	dc.b	0
	; LineNumber: 431
	; LineNumber: 431
txt_print_string_block77
txt_print_string
	; LineNumber: 438
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 440
txt_print_string_while78
txt_print_string_loopstart82
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock81
txt_print_string_ConditionalTrueBlock79: ;Main true block ;keep 
	; LineNumber: 441
	; LineNumber: 442
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Calling storevariable on generic assign expression
	sta txt_ch
	; LineNumber: 443
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 444
	jsr $ffee
	; LineNumber: 445
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 446
	jmp txt_print_string_while78
txt_print_string_elsedoneblock81
txt_print_string_loopend83
	; LineNumber: 448
	; Binary clause Simplified: EQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$1;keep
	bne txt_print_string_elsedoneblock89
txt_print_string_ConditionalTrueBlock87: ;Main true block ;keep 
	; LineNumber: 447
	jsr $ffe7
txt_print_string_elsedoneblock89
	; LineNumber: 449
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 453
	; LineNumber: 452
txt_CH	dc.b	0
txt_put_ch_block92
txt_put_ch
	; LineNumber: 454
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 455
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 457
	; Binary clause Simplified: EQUALS
	; Compare with pure num / var optimization
	cmp #$d;keep
	bne txt_put_ch_elseblock95
txt_put_ch_ConditionalTrueBlock94: ;Main true block ;keep 
	; LineNumber: 456
	jsr $ffe7
	jmp txt_put_ch_elsedoneblock96
txt_put_ch_elseblock95
	; LineNumber: 456
	jsr $ffee
txt_put_ch_elsedoneblock96
	; LineNumber: 458
	rts
	
; // Clear keyboard buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_clear_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 462
txt_clear_buffer
	; LineNumber: 463
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 464
	; Assigning to register
	; Assigning register : _a
	lda #$f
	; LineNumber: 465
	jsr $fff4
	; LineNumber: 466
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 473
	; LineNumber: 472
txt__keyp	dc.b	$00
txt_get_key_block102
txt_get_key
	; LineNumber: 475
	; Assigning to register
	; Assigning register : _x
	ldx #$1
	; LineNumber: 476
	; Assigning to register
	; Assigning register : _a
	lda #$4
	; LineNumber: 477
	jsr $fff4
	; LineNumber: 479
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 480
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 481
	jsr $ffe0
	; LineNumber: 483
	; Assigning from register
	sta txt__keyp
	; LineNumber: 484
	jsr txt_clear_buffer
	; LineNumber: 485
	lda txt__keyp
	rts
	; LineNumber: 486
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 489
txt_wait_key
	; LineNumber: 490
	
; //
txt_wait_key_while104
txt_wait_key_loopstart108
	; Binary clause Simplified: EQUALS
	jsr txt_get_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock107
txt_wait_key_ConditionalTrueBlock105: ;Main true block ;keep 
	; LineNumber: 491
	; LineNumber: 493
	jmp txt_wait_key_while104
txt_wait_key_elsedoneblock107
txt_wait_key_loopend109
	; LineNumber: 494
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_str_len
	;    Procedure type : User-defined procedure
	; LineNumber: 684
	; LineNumber: 683
txt_str_len_block112
txt_str_len
	; LineNumber: 686
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 689
txt_str_len_while113
txt_str_len_loopstart117
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_i
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_str_len_elsedoneblock116
txt_str_len_ConditionalTrueBlock114: ;Main true block ;keep 
	; LineNumber: 689
	; LineNumber: 691
	
; // get the Str_Len by counting until char is 0
	; Test Inc dec D
	inc txt_i
	; LineNumber: 692
	jmp txt_str_len_while113
txt_str_len_elsedoneblock116
txt_str_len_loopend118
	; LineNumber: 696
	; LineNumber: 697
	lda txt_i
	rts
	
; // Return
; // print X spaces
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_space
	;    Procedure type : User-defined procedure
	; LineNumber: 701
	; LineNumber: 700
txt_print_space_block121
txt_print_space
	; LineNumber: 703
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 708
	; Calling storevariable on generic assign expression
txt_print_space_forloop122
	; LineNumber: 705
	; LineNumber: 706
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 707
txt_print_space_forloopcounter124
txt_print_space_loopstart125
	; Compare is onpage
	; Test Inc dec D
	inc txt_i
	; integer assignment NodeVar
	ldy txt_max_digits+1 ; keep
	lda txt_max_digits
	cmp txt_i ;keep
	bne txt_print_space_forloop122
txt_print_space_loopdone129: ;keep
txt_print_space_forloopend123
txt_print_space_loopend126
	; LineNumber: 709
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string_centered
	;    Procedure type : User-defined procedure
	; LineNumber: 713
	; LineNumber: 712
	; LineNumber: 712
	; LineNumber: 712
txt__sc_w	dc.b	0
txt_print_string_centered_block130
txt_print_string_centered
	; LineNumber: 715
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 716
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 719
	
; // Get the length of the string
	jsr txt_str_len
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 722
	
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
	bcs txt_print_string_centered_skip132
	dey
txt_print_string_centered_skip132
txt_print_string_centered_int_shift_var133 = $56
	sta txt_print_string_centered_int_shift_var133
	sty txt_print_string_centered_int_shift_var133+1
		lsr txt_print_string_centered_int_shift_var133+1
	ror txt_print_string_centered_int_shift_var133+0

	lda txt_print_string_centered_int_shift_var133
	ldy txt_print_string_centered_int_shift_var133+1
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 725
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_max_digits+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_string_centered_elseblock136
	bne txt_print_string_centered_localsuccess140
	lda txt_max_digits
	cmp #$00 ;keep
	bcc txt_print_string_centered_elseblock136
	beq txt_print_string_centered_elseblock136
txt_print_string_centered_localsuccess140: ;keep
	; ; logical AND, second requirement
	; Binary clause Simplified: LESS
	lda txt_i
	; Compare with pure num / var optimization
	cmp #$28;keep
	bcs txt_print_string_centered_elseblock136
txt_print_string_centered_ConditionalTrueBlock135: ;Main true block ;keep 
	; LineNumber: 725
	; LineNumber: 729
	
; // Is it worth padding?
; // Add the padding
	jsr txt_print_space
	; LineNumber: 732
	
; // print the string
	jsr txt_print_string
	; LineNumber: 735
	jmp txt_print_string_centered_elsedoneblock137
txt_print_string_centered_elseblock136
	; LineNumber: 736
	; LineNumber: 738
	
; // print the string
	jsr txt_print_string
	; LineNumber: 739
txt_print_string_centered_elsedoneblock137
	; LineNumber: 743
	rts
	
; // NOT atari
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_dec
	;    Procedure type : User-defined procedure
	; LineNumber: 748
	; LineNumber: 747
txt__in_n	dc.b	0
	; LineNumber: 747
txt__add_cr	dc.b	0
txt_print_dec_block143
txt_print_dec
	; LineNumber: 750
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_digit
	sty txt_next_digit+1
	; LineNumber: 751
	lda #$00
	ldx #$00
	sta txt_temp_num_p
	stx txt_temp_num_p+1
	; LineNumber: 752
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 753
	; Calling storevariable on generic assign expression
	sta txt_temp_i
	; LineNumber: 755
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$a;keep
	bcc txt_print_dec_localfailed189
	jmp txt_print_dec_ConditionalTrueBlock145
txt_print_dec_localfailed189
	jmp txt_print_dec_elseblock146
txt_print_dec_ConditionalTrueBlock145: ;Main true block ;keep 
	; LineNumber: 755
	; LineNumber: 758
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed212
	jmp txt_print_dec_ConditionalTrueBlock192
txt_print_dec_localfailed212
	jmp txt_print_dec_elseblock193
txt_print_dec_ConditionalTrueBlock192: ;Main true block ;keep 
	; LineNumber: 759
	; LineNumber: 761
	
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
	; LineNumber: 762
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 766
	
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
txt_print_dec_rightvarInteger_var216 = $56
	sta txt_print_dec_rightvarInteger_var216
	sty txt_print_dec_rightvarInteger_var216+1
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
	sbc txt_print_dec_rightvarInteger_var216
txt_print_dec_wordAdd214
	sta txt_print_dec_rightvarInteger_var216
	; High-bit binop
	tya
	sbc txt_print_dec_rightvarInteger_var216+1
	tay
	lda txt_print_dec_rightvarInteger_var216
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 767
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_temp_num+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_dec_elsedoneblock220
	bne txt_print_dec_ConditionalTrueBlock218
	lda txt_temp_num
	cmp #$09 ;keep
	bcc txt_print_dec_elsedoneblock220
	beq txt_print_dec_elsedoneblock220
txt_print_dec_ConditionalTrueBlock218: ;Main true block ;keep 
	; LineNumber: 766
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd224
	dec txt_temp_num+1
txt_print_dec_WordAdd224
txt_print_dec_elsedoneblock220
	; LineNumber: 768
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	lda txt_temp_num
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 771
	
; // right digit
	; Modulo
	lda #$a
txt_print_dec_val_var225 = $56
	sta txt_print_dec_val_var225
	lda txt__in_n
	sec
txt_print_dec_modulo226
	sbc txt_print_dec_val_var225
	bcs txt_print_dec_modulo226
	adc txt_print_dec_val_var225
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 772
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 775
	jmp txt_print_dec_elsedoneblock194
txt_print_dec_elseblock193
	; LineNumber: 776
	; LineNumber: 779
	
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
	; LineNumber: 780
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 783
	
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
txt_print_dec_rightvarInteger_var229 = $56
	sta txt_print_dec_rightvarInteger_var229
	sty txt_print_dec_rightvarInteger_var229+1
	lda txt__in_n+1
	sec
	sbc txt_print_dec_rightvarInteger_var229+1
	tay
	lda txt__in_n
	sec
	sbc txt_print_dec_rightvarInteger_var229
	bcs txt_print_dec_wordAdd228
	dey
txt_print_dec_wordAdd228
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 784
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 785
txt_print_dec_elsedoneblock194
	; LineNumber: 788
	jmp txt_print_dec_elsedoneblock147
txt_print_dec_elseblock146
	; LineNumber: 789
	; LineNumber: 790
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 791
txt_print_dec_elsedoneblock147
	; LineNumber: 793
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock234
txt_print_dec_ConditionalTrueBlock232: ;Main true block ;keep 
	; LineNumber: 792
	jsr txt_cursor_return
txt_print_dec_elsedoneblock234
	; LineNumber: 794
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_tile
	;    Procedure type : User-defined procedure
	; LineNumber: 35
	; LineNumber: 34
	; LineNumber: 34
	; LineNumber: 34
levels_draw_tile_block237
levels_draw_tile
	; LineNumber: 38
	
; // Source
	; Generic 16 bit op
	lda #<levels_tiles
	ldy #>levels_tiles
levels_draw_tile_rightvarInteger_var240 = $56
	sta levels_draw_tile_rightvarInteger_var240
	sty levels_draw_tile_rightvarInteger_var240+1
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
	adc levels_draw_tile_rightvarInteger_var240
levels_draw_tile_wordAdd238
	sta levels_draw_tile_rightvarInteger_var240
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var240+1
	tay
	lda levels_draw_tile_rightvarInteger_var240
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 41
	
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
levels_draw_tile_rightvarInteger_var243 = $56
	sta levels_draw_tile_rightvarInteger_var243
	sty levels_draw_tile_rightvarInteger_var243+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var246 = $58
	sta levels_draw_tile_rightvarInteger_var246
	sty levels_draw_tile_rightvarInteger_var246+1
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
	adc levels_draw_tile_rightvarInteger_var246
levels_draw_tile_wordAdd244
	sta levels_draw_tile_rightvarInteger_var246
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var246+1
	tay
	lda levels_draw_tile_rightvarInteger_var246
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var243
levels_draw_tile_wordAdd241
	sta levels_draw_tile_rightvarInteger_var243
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var243+1
	tay
	lda levels_draw_tile_rightvarInteger_var243
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 42
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy247
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy247
	; LineNumber: 44
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd248
	inc levels_temp_s+1
levels_draw_tile_WordAdd248
	; LineNumber: 45
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd249
	inc levels_dest+1
levels_draw_tile_WordAdd249
	; LineNumber: 46
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy250
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy250
	; LineNumber: 48
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd251
	inc levels_dest+1
levels_draw_tile_WordAdd251
	; LineNumber: 49
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd252
	inc levels_temp_s+1
levels_draw_tile_WordAdd252
	; LineNumber: 50
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy253
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy253
	; LineNumber: 52
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 60
levels_draw_level
	; LineNumber: 63
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 64
	; Generic 16 bit op
	lda #<levels_level
	ldy #>levels_level
levels_draw_level_rightvarInteger_var257 = $56
	sta levels_draw_level_rightvarInteger_var257
	sty levels_draw_level_rightvarInteger_var257+1
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
	adc levels_draw_level_rightvarInteger_var257
levels_draw_level_wordAdd255
	sta levels_draw_level_rightvarInteger_var257
	; High-bit binop
	tya
	adc levels_draw_level_rightvarInteger_var257+1
	tay
	lda levels_draw_level_rightvarInteger_var257
	sta levels_level_p
	sty levels_level_p+1
	; LineNumber: 75
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop258
	; LineNumber: 68
	; LineNumber: 73
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop277
	; LineNumber: 70
	; LineNumber: 71
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
	; LineNumber: 72
	jsr levels_draw_tile
	; LineNumber: 73
levels_draw_level_forloopcounter279
levels_draw_level_loopstart280
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda levels_tiles_across
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop277
levels_draw_level_loopdone288: ;keep
levels_draw_level_forloopend278
levels_draw_level_loopend281
	; LineNumber: 74
levels_draw_level_forloopcounter260
levels_draw_level_loopstart261
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_y
	lda #$6
	cmp levels_t_y ;keep
	bne levels_draw_level_forloop258
levels_draw_level_loopdone289: ;keep
levels_draw_level_forloopend259
levels_draw_level_loopend262
	; LineNumber: 77
	rts
	
; // Need rows at the bottom 
; // for text output
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 104
levels_refresh_screen
	; LineNumber: 106
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 110
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	jsr txt_current_bbc
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc levels_refresh_screen_localfailed321
	jmp levels_refresh_screen_ConditionalTrueBlock292
levels_refresh_screen_localfailed321
	jmp levels_refresh_screen_elseblock293
levels_refresh_screen_ConditionalTrueBlock292: ;Main true block ;keep 
	; LineNumber: 111
	; LineNumber: 118
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop323
	; LineNumber: 114
	; LineNumber: 115
	
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
	; LineNumber: 116
	; memcpyfast
	ldy levels_detected_screen_width
	dey
levels_refresh_screen_memcpy332
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy332
	; LineNumber: 117
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd333
	inc levels_temp_s+1
levels_refresh_screen_WordAdd333
	; LineNumber: 118
levels_refresh_screen_forloopcounter325
levels_refresh_screen_loopstart326
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop323
levels_refresh_screen_loopdone334: ;keep
levels_refresh_screen_forloopend324
levels_refresh_screen_loopend327
	; LineNumber: 120
	jmp levels_refresh_screen_elsedoneblock294
levels_refresh_screen_elseblock293
	; LineNumber: 121
	; LineNumber: 123
	
; // Electron
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 129
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop336
	; LineNumber: 125
	; LineNumber: 126
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy345
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy345
	; LineNumber: 127
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 128
	lda levels_temp_s
	clc
	adc #$28
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd346
	inc levels_temp_s+1
levels_refresh_screen_WordAdd346
	; LineNumber: 129
levels_refresh_screen_forloopcounter338
levels_refresh_screen_loopstart339
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop336
levels_refresh_screen_loopdone347: ;keep
levels_refresh_screen_forloopend337
levels_refresh_screen_loopend340
	; LineNumber: 131
levels_refresh_screen_elsedoneblock294
	; LineNumber: 133
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 138
	; LineNumber: 137
levels_buf_x	dc.b	0
	; LineNumber: 137
levels_buf_y	dc.b	0
levels_get_buffer_block348
levels_get_buffer
	; LineNumber: 140
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var351 = $56
	sta levels_get_buffer_rightvarInteger_var351
	sty levels_get_buffer_rightvarInteger_var351+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var354 = $58
	sta levels_get_buffer_rightvarInteger_var354
	sty levels_get_buffer_rightvarInteger_var354+1
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
	adc levels_get_buffer_rightvarInteger_var354
levels_get_buffer_wordAdd352
	sta levels_get_buffer_rightvarInteger_var354
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var354+1
	tay
	lda levels_get_buffer_rightvarInteger_var354
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var351
levels_get_buffer_wordAdd349
	sta levels_get_buffer_rightvarInteger_var351
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var351+1
	tay
	lda levels_get_buffer_rightvarInteger_var351
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 142
	; LineNumber: 143
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 148
	; LineNumber: 147
levels_plot_x	dc.b	0
	; LineNumber: 147
levels_plot_y	dc.b	0
	; LineNumber: 147
levels_plot_ch	dc.b	0
levels_plot_buffer_block355
levels_plot_buffer
	; LineNumber: 150
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var358 = $56
	sta levels_plot_buffer_rightvarInteger_var358
	sty levels_plot_buffer_rightvarInteger_var358+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var361 = $58
	sta levels_plot_buffer_rightvarInteger_var361
	sty levels_plot_buffer_rightvarInteger_var361+1
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
	adc levels_plot_buffer_rightvarInteger_var361
levels_plot_buffer_wordAdd359
	sta levels_plot_buffer_rightvarInteger_var361
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var361+1
	tay
	lda levels_plot_buffer_rightvarInteger_var361
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var358
levels_plot_buffer_wordAdd356
	sta levels_plot_buffer_rightvarInteger_var358
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var358+1
	tay
	lda levels_plot_buffer_rightvarInteger_var358
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 151
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 153
	rts
	
; //player inventory/stats
; // ********************************
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 78
init
	; LineNumber: 81
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 82
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 86
	
; // Clean the screen buffer		
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 87
	lda space_char
	ldy #0
init_fill363
	sta (p),y
	iny
	cpy #$fa
	bne init_fill363
	; LineNumber: 89
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd364
	inc p+1
init_WordAdd364
	; LineNumber: 90
	lda space_char
	ldy #0
init_fill365
	sta (p),y
	iny
	cpy #$fa
	bne init_fill365
	; LineNumber: 92
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd366
	inc p+1
init_WordAdd366
	; LineNumber: 93
	lda space_char
	ldy #0
init_fill367
	sta (p),y
	iny
	cpy #$fa
	bne init_fill367
	; LineNumber: 95
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd368
	inc p+1
init_WordAdd368
	; LineNumber: 96
	lda space_char
	ldy #0
init_fill369
	sta (p),y
	iny
	cpy #$fa
	bne init_fill369
	; LineNumber: 99
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 101
	lda #$a
	; Calling storevariable on generic assign expression
	sta levels_tiles_across
	; LineNumber: 107
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 109
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 110
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 113
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 114
	jsr levels_draw_level
	; LineNumber: 117
	
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
	; LineNumber: 120
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 121
	rts
	
; // Set to use the new characterset
; // Force the screen address
; // Tells basic routines where screen memory is located
; // Clear screen,
; // Black screen
; // Ensure no flashing cursor
; // Force the screen address
; // Clear screen,
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_start_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 175
show_start_screen
	; LineNumber: 177
	jsr txt_cls
	; LineNumber: 178
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed394
	jmp show_start_screen_ConditionalTrueBlock372
show_start_screen_localfailed394
	jmp show_start_screen_elsedoneblock374
show_start_screen_ConditionalTrueBlock372: ;Main true block ;keep 
	; LineNumber: 179
	; LineNumber: 182
	
; //                         01234567890123456789012
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 183
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 184
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr396
	sta txt_in_str
	lda #>show_start_screen_stringassignstr396
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 185
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 186
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr398
	sta txt_in_str
	lda #>show_start_screen_stringassignstr398
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 187
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr400
	sta txt_in_str
	lda #>show_start_screen_stringassignstr400
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 188
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr402
	sta txt_in_str
	lda #>show_start_screen_stringassignstr402
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 189
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 190
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr404
	sta txt_in_str
	lda #>show_start_screen_stringassignstr404
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 191
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 192
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr406
	sta txt_in_str
	lda #>show_start_screen_stringassignstr406
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 194
	
; //txt::print_string_centered("(C)2021", true, levels::detected_screen_width);	
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 195
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr408
	sta txt_in_str
	lda #>show_start_screen_stringassignstr408
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 196
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 197
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr410
	sta txt_in_str
	lda #>show_start_screen_stringassignstr410
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 201
	
; //txt::print_string_centered("@ = YOU k = KEY", true, levels::detected_screen_width);
; //txt::print_string_centered("s = HEALTH c = DOOR", true, levels::detected_screen_width);
; //txt::print_string_centered("z = GEM x = ARTIFACT", true, levels::detected_screen_width);	
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr412
	sta txt_in_str
	lda #>show_start_screen_stringassignstr412
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 202
show_start_screen_elsedoneblock374
	; LineNumber: 206
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 207
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 209
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr414
	sta txt_in_str
	lda #>show_start_screen_stringassignstr414
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 210
	jsr txt_print_space
	; LineNumber: 212
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 213
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 215
	jsr txt_wait_key
	; LineNumber: 218
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 223
show_end_screen
	; LineNumber: 225
	jsr txt_cls
	; LineNumber: 226
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock419
show_end_screen_ConditionalTrueBlock418: ;Main true block ;keep 
	; LineNumber: 226
	; LineNumber: 228
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr428
	sta txt_in_str
	lda #>show_end_screen_stringassignstr428
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 230
	jmp show_end_screen_elsedoneblock420
show_end_screen_elseblock419
	; LineNumber: 231
	; LineNumber: 232
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr431
	sta txt_in_str
	lda #>show_end_screen_stringassignstr431
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 233
show_end_screen_elsedoneblock420
	; LineNumber: 236
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr433
	sta txt_in_str
	lda #>show_end_screen_stringassignstr433
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 238
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 240
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr435
	sta txt_in_str
	lda #>show_end_screen_stringassignstr435
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 242
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 244
	jsr txt_wait_key
	; LineNumber: 247
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 252
display_text
	; LineNumber: 254
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 256
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr438
	sta txt_in_str
	lda #>display_text_stringassignstr438
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 257
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 258
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 259
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 261
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 262
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 263
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 264
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 266
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 267
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 268
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 269
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 272
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 273
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 274
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 275
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 276
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 277
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 280
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 281
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 282
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 283
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 286
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 287
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 288
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 289
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 290
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 291
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 293
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 297
	; LineNumber: 296
update_status_block440
update_status
	; LineNumber: 298
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 299
	jsr display_text
	; LineNumber: 301
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 369
check_collisions
	; LineNumber: 372
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext443
	; LineNumber: 376
	; LineNumber: 381
	jmp check_collisions_caseend442
check_collisions_casenext443
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext445
	; LineNumber: 384
	; LineNumber: 386
	jmp check_collisions_caseend442
check_collisions_casenext445
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext447
	; LineNumber: 388
	; LineNumber: 391
	jmp check_collisions_caseend442
check_collisions_casenext447
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext449
	; LineNumber: 393
	; LineNumber: 395
	
; // Gazer
; //update_status("GAZER ATTACKS!"); 
; //combat();
; // Artifact
; //update_status("ARTIFACT!");
; //door();
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 397
	jmp check_collisions_caseend442
check_collisions_casenext449
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext451
	; LineNumber: 401
	; LineNumber: 402
	
; //update_status("KEY ACQUIRED");
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 405
	jmp check_collisions_caseend442
check_collisions_casenext451
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext453
	; LineNumber: 407
	; LineNumber: 412
	jmp check_collisions_caseend442
check_collisions_casenext453
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext455
	; LineNumber: 415
	; LineNumber: 416
	
; //update_status("AHH THAT'S BETTER!");
; // Gobbo
; //update_status("GOBBO ATTACKS!");
; //combat();
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd457
	inc gold+1
check_collisions_WordAdd457
	; LineNumber: 419
	jmp check_collisions_caseend442
check_collisions_casenext455
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext458
	; LineNumber: 422
	; LineNumber: 427
	jmp check_collisions_caseend442
check_collisions_casenext458
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext460
	; LineNumber: 431
	; LineNumber: 433
	jmp check_collisions_caseend442
check_collisions_casenext460
	; LineNumber: 437
	; LineNumber: 440
	
; //update_status("KA-CHING!");
; // Rat
; //update_status("RAT ATTACKS!"); 
; //combat();
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 441
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 450
check_collisions_caseend442
	; LineNumber: 453
	rts
block1
	; LineNumber: 459
	
; // Unknown
; //_A:=charat;
; //update_status("EXISTING TILE:");
; //txt::move_to(15,19);
; //txt::print_dec(charat, false);
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 473
	
; // C64 has it's own special characters
	jsr txt_cursor_off
	; LineNumber: 474
	lda #$40
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 491
MainProgram_while463
MainProgram_loopstart467
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed559
	jmp MainProgram_ConditionalTrueBlock464
MainProgram_localfailed559
	jmp MainProgram_elsedoneblock466
MainProgram_ConditionalTrueBlock464: ;Main true block ;keep 
	; LineNumber: 491
	; LineNumber: 496
	
; // Borked, will need some work
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 500
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 503
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr561
	sta new_status
	lda #>MainProgram_stringassignstr561
	sta new_status+1
	jsr update_status
	; LineNumber: 504
	jsr display_text
	; LineNumber: 508
MainProgram_while563
MainProgram_loopstart567
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed609
	jmp MainProgram_ConditionalTrueBlock564
MainProgram_localfailed609
	jmp MainProgram_elsedoneblock566
MainProgram_ConditionalTrueBlock564: ;Main true block ;keep 
	; LineNumber: 509
	; LineNumber: 514
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 515
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 518
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 521
	lda #$8b
	cmp key_press ;keep
	bne MainProgram_casenext612
	; LineNumber: 523
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock617
MainProgram_ConditionalTrueBlock615: ;Main true block ;keep 
	; LineNumber: 523
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock617
	jmp MainProgram_caseend611
MainProgram_casenext612
	lda #$8a
	cmp key_press ;keep
	bne MainProgram_casenext620
	; LineNumber: 524
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock625
MainProgram_ConditionalTrueBlock623: ;Main true block ;keep 
	; LineNumber: 524
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock625
	jmp MainProgram_caseend611
MainProgram_casenext620
	lda #$88
	cmp key_press ;keep
	bne MainProgram_casenext628
	; LineNumber: 525
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock633
MainProgram_ConditionalTrueBlock631: ;Main true block ;keep 
	; LineNumber: 525
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock633
	jmp MainProgram_caseend611
MainProgram_casenext628
	lda #$89
	cmp key_press ;keep
	bne MainProgram_casenext636
	; LineNumber: 526
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock641
MainProgram_ConditionalTrueBlock639: ;Main true block ;keep 
	; LineNumber: 526
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock641
MainProgram_casenext636
MainProgram_caseend611
	; LineNumber: 534
	
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
	; LineNumber: 538
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock647
MainProgram_ConditionalTrueBlock645: ;Main true block ;keep 
	; LineNumber: 539
	; LineNumber: 542
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
	; LineNumber: 544
MainProgram_elsedoneblock647
	; LineNumber: 550
	
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
	; LineNumber: 554
	
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
	; LineNumber: 558
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 560
	jmp MainProgram_while563
MainProgram_elsedoneblock566
MainProgram_loopend568
	; LineNumber: 564
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 567
	jmp MainProgram_while463
MainProgram_elsedoneblock466
MainProgram_loopend468
	; LineNumber: 569
	; End of program
	; Ending memory block
EndBlock1100
show_start_screen_stringassignstr376		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr378		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr380		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr382		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr384		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr386		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr388		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr390		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr392		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr396		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr398		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr400		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr402		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr404		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr406		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr408		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr410		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr412		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr414		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr422		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr425		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr428		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr431		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr433		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr435		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr438		dc.b	"                    "
	dc.b	0
MainProgram_stringassignstr470		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr561		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
