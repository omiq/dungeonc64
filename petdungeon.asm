 processor 6502
	org $1100
	; Starting new memory block at $1100
StartBlock1100
	; LineNumber: 470
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
levels_b_tab	dc.w	 
	org levels_b_tab+36
	; LineNumber: 18
levels_screen_buffer	dc.b	 
	org levels_screen_buffer+1000
	; LineNumber: 22
levels_tiles
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map - Tiles.bin"
	; LineNumber: 31
levels_level
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map.bin"
	; LineNumber: 32
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
	; LineNumber: 58
i	dc.b	0
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
	; LineNumber: 339
	jmp txt_DefineScreen_elsedoneblock28
txt_DefineScreen_elseblock27
	; LineNumber: 340
	; LineNumber: 342
	
; // if BBC
	; Integer constant assigning
	ldy #$7c
	lda #$00
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 348
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop64
	; LineNumber: 344
	; LineNumber: 345
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
	; LineNumber: 346
	lda txt_temp_address_p
	clc
	adc #$28
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd72
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd72
	; LineNumber: 347
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
	; LineNumber: 348
txt_DefineScreen_elsedoneblock28
	; LineNumber: 350
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 353
	; LineNumber: 352
txt__text_x	dc.b	0
	; LineNumber: 352
txt__text_y	dc.b	0
txt_move_to_block74
txt_move_to
	; LineNumber: 354
	; Assigning to register
	; Assigning register : _a
	lda #$1f
	; LineNumber: 355
	jsr $ffee
	; LineNumber: 356
	; Assigning to register
	; Assigning register : _a
	lda txt__text_x
	; LineNumber: 357
	jsr $ffee
	; LineNumber: 358
	; Assigning to register
	; Assigning register : _a
	lda txt__text_y
	; LineNumber: 359
	jsr $ffee
	; LineNumber: 360
	rts
	
; //CURSOR_OFF
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_off
	;    Procedure type : User-defined procedure
	; LineNumber: 385
txt_cursor_off
	; LineNumber: 387
	; Poke
	; Optimization: shift is zero
	lda #$a
	sta $fe00
	; LineNumber: 388
	; Poke
	; Optimization: shift is zero
	lda #$20
	sta $fe01
	; LineNumber: 390
	rts
	
; //CURSOR Carriage Return
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 395
txt_cursor_return
	; LineNumber: 397
	jsr $ffe7
	; LineNumber: 399
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 437
	; LineNumber: 434
txt_ch	dc.b	0
	; LineNumber: 435
txt_next_ch	dc.b	0
	; LineNumber: 432
	; LineNumber: 432
txt_print_string_block77
txt_print_string
	; LineNumber: 439
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 441
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
	; LineNumber: 442
	; LineNumber: 443
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Calling storevariable on generic assign expression
	sta txt_ch
	; LineNumber: 444
	; Assigning to register
	; Assigning register : _a
	; LineNumber: 445
	jsr $ffee
	; LineNumber: 446
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 447
	jmp txt_print_string_while78
txt_print_string_elsedoneblock81
txt_print_string_loopend83
	; LineNumber: 449
	; Binary clause Simplified: EQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$1;keep
	bne txt_print_string_elsedoneblock89
txt_print_string_ConditionalTrueBlock87: ;Main true block ;keep 
	; LineNumber: 448
	jsr $ffe7
txt_print_string_elsedoneblock89
	; LineNumber: 450
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 454
	; LineNumber: 453
txt_CH	dc.b	0
txt_put_ch_block92
txt_put_ch
	; LineNumber: 455
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 456
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 458
	; Binary clause Simplified: EQUALS
	; Compare with pure num / var optimization
	cmp #$d;keep
	bne txt_put_ch_elseblock95
txt_put_ch_ConditionalTrueBlock94: ;Main true block ;keep 
	; LineNumber: 457
	jsr $ffe7
	jmp txt_put_ch_elsedoneblock96
txt_put_ch_elseblock95
	; LineNumber: 457
	jsr $ffee
txt_put_ch_elsedoneblock96
	; LineNumber: 459
	rts
	
; // Clear keyboard buffer
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_clear_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 463
txt_clear_buffer
	; LineNumber: 464
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 465
	; Assigning to register
	; Assigning register : _a
	lda #$f
	; LineNumber: 466
	jsr $fff4
	; LineNumber: 467
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 474
	; LineNumber: 473
txt__keyp	dc.b	$00
txt_get_key_block102
txt_get_key
	; LineNumber: 476
	; Assigning to register
	; Assigning register : _x
	ldx #$1
	; LineNumber: 477
	; Assigning to register
	; Assigning register : _a
	lda #$4
	; LineNumber: 478
	jsr $fff4
	; LineNumber: 480
	; Assigning to register
	; Assigning register : _x
	ldx #$0
	; LineNumber: 481
	; Assigning to register
	; Assigning register : _a
	lda #$0
	; LineNumber: 482
	jsr $ffe0
	; LineNumber: 484
	; Assigning from register
	sta txt__keyp
	; LineNumber: 485
	jsr txt_clear_buffer
	; LineNumber: 486
	lda txt__keyp
	rts
	; LineNumber: 487
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 490
txt_wait_key
	; LineNumber: 491
	
; //
txt_wait_key_while104
txt_wait_key_loopstart108
	; Binary clause Simplified: EQUALS
	jsr txt_get_key
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne txt_wait_key_elsedoneblock107
txt_wait_key_ConditionalTrueBlock105: ;Main true block ;keep 
	; LineNumber: 492
	; LineNumber: 494
	jmp txt_wait_key_while104
txt_wait_key_elsedoneblock107
txt_wait_key_loopend109
	; LineNumber: 495
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_str_len
	;    Procedure type : User-defined procedure
	; LineNumber: 685
	; LineNumber: 684
txt_str_len_block112
txt_str_len
	; LineNumber: 687
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 690
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
	; LineNumber: 690
	; LineNumber: 692
	
; // get the Str_Len by counting until char is 0
	; Test Inc dec D
	inc txt_i
	; LineNumber: 693
	jmp txt_str_len_while113
txt_str_len_elsedoneblock116
txt_str_len_loopend118
	; LineNumber: 697
	; LineNumber: 698
	lda txt_i
	rts
	
; // Return
; // print X spaces
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_space
	;    Procedure type : User-defined procedure
	; LineNumber: 702
	; LineNumber: 701
txt_print_space_block121
txt_print_space
	; LineNumber: 704
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 709
	; Calling storevariable on generic assign expression
txt_print_space_forloop122
	; LineNumber: 706
	; LineNumber: 707
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 708
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
	; LineNumber: 710
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string_centered
	;    Procedure type : User-defined procedure
	; LineNumber: 714
	; LineNumber: 713
	; LineNumber: 713
	; LineNumber: 713
txt__sc_w	dc.b	0
txt_print_string_centered_block130
txt_print_string_centered
	; LineNumber: 716
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 717
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 720
	
; // Get the length of the string
	jsr txt_str_len
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 723
	
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
	; LineNumber: 726
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
	; LineNumber: 726
	; LineNumber: 730
	
; // Is it worth padding?
; // Add the padding
	jsr txt_print_space
	; LineNumber: 733
	
; // print the string
	jsr txt_print_string
	; LineNumber: 736
	jmp txt_print_string_centered_elsedoneblock137
txt_print_string_centered_elseblock136
	; LineNumber: 737
	; LineNumber: 739
	
; // print the string
	jsr txt_print_string
	; LineNumber: 740
txt_print_string_centered_elsedoneblock137
	; LineNumber: 744
	rts
	
; // NOT atari
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_dec
	;    Procedure type : User-defined procedure
	; LineNumber: 749
	; LineNumber: 748
txt__in_n	dc.b	0
	; LineNumber: 748
txt__add_cr	dc.b	0
txt_print_dec_block143
txt_print_dec
	; LineNumber: 751
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_digit
	sty txt_next_digit+1
	; LineNumber: 752
	lda #$00
	ldx #$00
	sta txt_temp_num_p
	stx txt_temp_num_p+1
	; LineNumber: 753
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_temp_num
	sty txt_temp_num+1
	; LineNumber: 754
	; Calling storevariable on generic assign expression
	sta txt_temp_i
	; LineNumber: 756
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
	; LineNumber: 756
	; LineNumber: 759
	; Binary clause Simplified: GREATEREQUAL
	lda txt__in_n
	; Compare with pure num / var optimization
	cmp #$64;keep
	bcc txt_print_dec_localfailed212
	jmp txt_print_dec_ConditionalTrueBlock192
txt_print_dec_localfailed212
	jmp txt_print_dec_elseblock193
txt_print_dec_ConditionalTrueBlock192: ;Main true block ;keep 
	; LineNumber: 760
	; LineNumber: 762
	
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
	; LineNumber: 763
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 767
	
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
	; LineNumber: 768
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
	; LineNumber: 767
	lda txt_temp_num
	sec
	sbc #$0a
	sta txt_temp_num+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs txt_print_dec_WordAdd224
	dec txt_temp_num+1
txt_print_dec_WordAdd224
txt_print_dec_elsedoneblock220
	; LineNumber: 769
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	lda txt_temp_num
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 772
	
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
	; LineNumber: 773
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 776
	jmp txt_print_dec_elsedoneblock194
txt_print_dec_elseblock193
	; LineNumber: 777
	; LineNumber: 780
	
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
	; LineNumber: 781
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 784
	
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
	; LineNumber: 785
	; Optimizer: a = a +/- b
	ldy txt_temp_num+1
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 786
txt_print_dec_elsedoneblock194
	; LineNumber: 789
	jmp txt_print_dec_elsedoneblock147
txt_print_dec_elseblock146
	; LineNumber: 790
	; LineNumber: 791
	; Optimizer: a = a +/- b
	lda txt__in_n
	clc
	adc #$30
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 792
txt_print_dec_elsedoneblock147
	; LineNumber: 794
	; Binary clause Simplified: NOTEQUALS
	lda txt__add_cr
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_dec_elsedoneblock234
txt_print_dec_ConditionalTrueBlock232: ;Main true block ;keep 
	; LineNumber: 793
	jsr txt_cursor_return
txt_print_dec_elsedoneblock234
	; LineNumber: 795
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_tile
	;    Procedure type : User-defined procedure
	; LineNumber: 38
	; LineNumber: 37
	; LineNumber: 37
	; LineNumber: 37
levels_draw_tile_block237
levels_draw_tile
	; LineNumber: 41
	
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
	; LineNumber: 45
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy247
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy247
	; LineNumber: 47
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd248
	inc levels_temp_s+1
levels_draw_tile_WordAdd248
	; LineNumber: 48
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd249
	inc levels_dest+1
levels_draw_tile_WordAdd249
	; LineNumber: 49
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy250
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy250
	; LineNumber: 51
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd251
	inc levels_dest+1
levels_draw_tile_WordAdd251
	; LineNumber: 52
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd252
	inc levels_temp_s+1
levels_draw_tile_WordAdd252
	; LineNumber: 53
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy253
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy253
	; LineNumber: 55
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 63
levels_draw_level
	; LineNumber: 66
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 67
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
	; LineNumber: 78
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop258
	; LineNumber: 71
	; LineNumber: 76
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop277
	; LineNumber: 73
	; LineNumber: 74
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
	; LineNumber: 75
	jsr levels_draw_tile
	; LineNumber: 76
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
	; LineNumber: 77
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
	; LineNumber: 80
	rts
	
; // Need rows at the bottom 
; // for text output
	; LineNumber: 105
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 116
levels_refresh_screen
	; LineNumber: 118
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 122
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	jsr txt_current_bbc
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc levels_refresh_screen_localfailed345
	jmp levels_refresh_screen_ConditionalTrueBlock292
levels_refresh_screen_localfailed345
	jmp levels_refresh_screen_elseblock293
levels_refresh_screen_ConditionalTrueBlock292: ;Main true block ;keep 
	; LineNumber: 123
	; LineNumber: 130
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop347
	; LineNumber: 126
	; LineNumber: 127
	
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
	; LineNumber: 128
	; memcpyfast
	ldy levels_detected_screen_width
	dey
levels_refresh_screen_memcpy356
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy356
	; LineNumber: 129
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd357
	inc levels_temp_s+1
levels_refresh_screen_WordAdd357
	; LineNumber: 130
levels_refresh_screen_forloopcounter349
levels_refresh_screen_loopstart350
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop347
levels_refresh_screen_loopdone358: ;keep
levels_refresh_screen_forloopend348
levels_refresh_screen_loopend351
	; LineNumber: 132
	jmp levels_refresh_screen_elsedoneblock294
levels_refresh_screen_elseblock293
	; LineNumber: 133
	; LineNumber: 137
	
; // Electron
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 138
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$0
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy361
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy361
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 139
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$1
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy363
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy363
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 140
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$2
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy365
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy365
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 141
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$3
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy367
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy367
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 142
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$4
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy369
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy369
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 143
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$5
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy371
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy371
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 144
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$6
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy373
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy373
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 145
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$7
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy375
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy375
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 146
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$8
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy377
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy377
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 147
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$9
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy379
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy379
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 148
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$a
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy381
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy381
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 149
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$b
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy383
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy383
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 150
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$c
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy385
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy385
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 151
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$d
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy387
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy387
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 152
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$e
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy389
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy389
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 153
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$f
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy391
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy391
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 154
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$10
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy393
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy393
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 155
	; LineNumber: 106
	; LineNumber: 107
	; Load Integer array
	lda #$11
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 108
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy395
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy395
	; LineNumber: 109
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 110
	; LineNumber: 157
levels_refresh_screen_elsedoneblock294
	; LineNumber: 159
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 164
	; LineNumber: 163
levels_buf_x	dc.b	0
	; LineNumber: 163
levels_buf_y	dc.b	0
levels_get_buffer_block396
levels_get_buffer
	; LineNumber: 166
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var399 = $56
	sta levels_get_buffer_rightvarInteger_var399
	sty levels_get_buffer_rightvarInteger_var399+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var402 = $58
	sta levels_get_buffer_rightvarInteger_var402
	sty levels_get_buffer_rightvarInteger_var402+1
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
	adc levels_get_buffer_rightvarInteger_var402
levels_get_buffer_wordAdd400
	sta levels_get_buffer_rightvarInteger_var402
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var402+1
	tay
	lda levels_get_buffer_rightvarInteger_var402
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var399
levels_get_buffer_wordAdd397
	sta levels_get_buffer_rightvarInteger_var399
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var399+1
	tay
	lda levels_get_buffer_rightvarInteger_var399
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 168
	; LineNumber: 169
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 174
	; LineNumber: 173
levels_plot_x	dc.b	0
	; LineNumber: 173
levels_plot_y	dc.b	0
	; LineNumber: 173
levels_plot_ch	dc.b	0
levels_plot_buffer_block403
levels_plot_buffer
	; LineNumber: 176
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var406 = $56
	sta levels_plot_buffer_rightvarInteger_var406
	sty levels_plot_buffer_rightvarInteger_var406+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var409 = $58
	sta levels_plot_buffer_rightvarInteger_var409
	sty levels_plot_buffer_rightvarInteger_var409+1
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
	adc levels_plot_buffer_rightvarInteger_var409
levels_plot_buffer_wordAdd407
	sta levels_plot_buffer_rightvarInteger_var409
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var409+1
	tay
	lda levels_plot_buffer_rightvarInteger_var409
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var406
levels_plot_buffer_wordAdd404
	sta levels_plot_buffer_rightvarInteger_var406
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var406+1
	tay
	lda levels_plot_buffer_rightvarInteger_var406
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 177
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 179
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
init_fill411
	sta (p),y
	iny
	cpy #$fa
	bne init_fill411
	; LineNumber: 89
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd412
	inc p+1
init_WordAdd412
	; LineNumber: 90
	lda space_char
	ldy #0
init_fill413
	sta (p),y
	iny
	cpy #$fa
	bne init_fill413
	; LineNumber: 92
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd414
	inc p+1
init_WordAdd414
	; LineNumber: 93
	lda space_char
	ldy #0
init_fill415
	sta (p),y
	iny
	cpy #$fa
	bne init_fill415
	; LineNumber: 95
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd416
	inc p+1
init_WordAdd416
	; LineNumber: 96
	lda space_char
	ldy #0
init_fill417
	sta (p),y
	iny
	cpy #$fa
	bne init_fill417
	; LineNumber: 99
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 101
	lda #$a
	; Calling storevariable on generic assign expression
	sta levels_tiles_across
	; LineNumber: 106
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 111
	lda #$0
	; Calling storevariable on generic assign expression
	sta i
init_forloop418
	; LineNumber: 108
	; LineNumber: 109
	; integer assignment NodeVar
	ldy p+1 ; keep
	lda p
	; Calling storevariable on generic assign expression
	pha
	lda i
	asl
	tax
	pla
	sta levels_b_tab,x
	tya
	sta levels_b_tab+1,x
	; LineNumber: 110
	lda p
	clc
	adc #$28
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd426
	inc p+1
init_WordAdd426
	; LineNumber: 111
init_forloopcounter420
init_loopstart421
	; Compare is onpage
	; Test Inc dec D
	inc i
	lda #$12
	cmp i ;keep
	bcs init_forloop418
init_loopdone427: ;keep
init_forloopend419
init_loopend422
	; LineNumber: 120
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 122
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 123
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 126
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 127
	jsr levels_draw_level
	; LineNumber: 130
	
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
	; LineNumber: 133
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 134
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
	; LineNumber: 188
show_start_screen
	; LineNumber: 190
	jsr txt_cls
	; LineNumber: 191
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed452
	jmp show_start_screen_ConditionalTrueBlock430
show_start_screen_localfailed452
	jmp show_start_screen_elsedoneblock432
show_start_screen_ConditionalTrueBlock430: ;Main true block ;keep 
	; LineNumber: 192
	; LineNumber: 195
	
; //                         01234567890123456789012
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 196
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 197
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr454
	sta txt_in_str
	lda #>show_start_screen_stringassignstr454
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 198
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 199
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr456
	sta txt_in_str
	lda #>show_start_screen_stringassignstr456
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 200
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr458
	sta txt_in_str
	lda #>show_start_screen_stringassignstr458
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
	lda #<show_start_screen_stringassignstr460
	sta txt_in_str
	lda #>show_start_screen_stringassignstr460
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 202
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 203
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr462
	sta txt_in_str
	lda #>show_start_screen_stringassignstr462
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 204
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 205
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr464
	sta txt_in_str
	lda #>show_start_screen_stringassignstr464
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 207
	
; //txt::print_string_centered("(C)2021", true, levels::detected_screen_width);	
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 208
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr466
	sta txt_in_str
	lda #>show_start_screen_stringassignstr466
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 209
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 210
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr468
	sta txt_in_str
	lda #>show_start_screen_stringassignstr468
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 214
	
; //txt::print_string_centered("@ = YOU k = KEY", true, levels::detected_screen_width);
; //txt::print_string_centered("s = HEALTH c = DOOR", true, levels::detected_screen_width);
; //txt::print_string_centered("z = GEM x = ARTIFACT", true, levels::detected_screen_width);	
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr470
	sta txt_in_str
	lda #>show_start_screen_stringassignstr470
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 215
show_start_screen_elsedoneblock432
	; LineNumber: 219
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 220
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 222
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr472
	sta txt_in_str
	lda #>show_start_screen_stringassignstr472
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 223
	jsr txt_print_space
	; LineNumber: 225
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 226
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 228
	jsr txt_wait_key
	; LineNumber: 231
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 236
show_end_screen
	; LineNumber: 238
	jsr txt_cls
	; LineNumber: 239
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock477
show_end_screen_ConditionalTrueBlock476: ;Main true block ;keep 
	; LineNumber: 239
	; LineNumber: 241
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr486
	sta txt_in_str
	lda #>show_end_screen_stringassignstr486
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 243
	jmp show_end_screen_elsedoneblock478
show_end_screen_elseblock477
	; LineNumber: 244
	; LineNumber: 245
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr489
	sta txt_in_str
	lda #>show_end_screen_stringassignstr489
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 246
show_end_screen_elsedoneblock478
	; LineNumber: 249
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr491
	sta txt_in_str
	lda #>show_end_screen_stringassignstr491
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 251
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 253
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr493
	sta txt_in_str
	lda #>show_end_screen_stringassignstr493
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 255
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 257
	jsr txt_wait_key
	; LineNumber: 260
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 265
display_text
	; LineNumber: 267
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 268
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 269
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr496
	sta txt_in_str
	lda #>display_text_stringassignstr496
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 270
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 271
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 272
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 274
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 275
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 276
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 277
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 279
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 280
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 281
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 282
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 285
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 286
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 287
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 288
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 289
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 290
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 293
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 294
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 295
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 296
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 299
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 300
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 301
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 302
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 303
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 304
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 306
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 310
	; LineNumber: 309
update_status_block498
update_status
	; LineNumber: 311
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 312
	jsr display_text
	; LineNumber: 314
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 382
check_collisions
	; LineNumber: 385
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext501
	; LineNumber: 389
	; LineNumber: 394
	jmp check_collisions_caseend500
check_collisions_casenext501
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext503
	; LineNumber: 397
	; LineNumber: 399
	jmp check_collisions_caseend500
check_collisions_casenext503
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext505
	; LineNumber: 401
	; LineNumber: 404
	jmp check_collisions_caseend500
check_collisions_casenext505
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext507
	; LineNumber: 406
	; LineNumber: 408
	
; // Gazer
; //update_status("GAZER ATTACKS!"); 
; //combat();
; // Artifact
; //update_status("ARTIFACT!");
; //door();
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 410
	jmp check_collisions_caseend500
check_collisions_casenext507
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext509
	; LineNumber: 414
	; LineNumber: 415
	
; //update_status("KEY ACQUIRED");
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 418
	jmp check_collisions_caseend500
check_collisions_casenext509
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext511
	; LineNumber: 420
	; LineNumber: 425
	jmp check_collisions_caseend500
check_collisions_casenext511
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext513
	; LineNumber: 428
	; LineNumber: 429
	
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
	bcc check_collisions_WordAdd515
	inc gold+1
check_collisions_WordAdd515
	; LineNumber: 432
	jmp check_collisions_caseend500
check_collisions_casenext513
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext516
	; LineNumber: 435
	; LineNumber: 440
	jmp check_collisions_caseend500
check_collisions_casenext516
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext518
	; LineNumber: 444
	; LineNumber: 446
	jmp check_collisions_caseend500
check_collisions_casenext518
	; LineNumber: 450
	; LineNumber: 453
	
; //update_status("KA-CHING!");
; // Rat
; //update_status("RAT ATTACKS!"); 
; //combat();
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 454
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 463
check_collisions_caseend500
	; LineNumber: 466
	rts
block1
	; LineNumber: 472
	
; // Unknown
; //_A:=charat;
; //update_status("EXISTING TILE:");
; //txt::move_to(15,19);
; //txt::print_dec(charat, false);
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 486
	
; // C64 has it's own special characters
	jsr txt_cursor_off
	; LineNumber: 487
	lda #$40
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 504
MainProgram_while521
MainProgram_loopstart525
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed617
	jmp MainProgram_ConditionalTrueBlock522
MainProgram_localfailed617
	jmp MainProgram_elsedoneblock524
MainProgram_ConditionalTrueBlock522: ;Main true block ;keep 
	; LineNumber: 504
	; LineNumber: 509
	
; // Borked, will need some work
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 513
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 516
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr619
	sta new_status
	lda #>MainProgram_stringassignstr619
	sta new_status+1
	jsr update_status
	; LineNumber: 517
	jsr display_text
	; LineNumber: 521
MainProgram_while621
MainProgram_loopstart625
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed667
	jmp MainProgram_ConditionalTrueBlock622
MainProgram_localfailed667
	jmp MainProgram_elsedoneblock624
MainProgram_ConditionalTrueBlock622: ;Main true block ;keep 
	; LineNumber: 522
	; LineNumber: 527
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 528
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 531
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 534
	lda #$8b
	cmp key_press ;keep
	bne MainProgram_casenext670
	; LineNumber: 536
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock675
MainProgram_ConditionalTrueBlock673: ;Main true block ;keep 
	; LineNumber: 536
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock675
	jmp MainProgram_caseend669
MainProgram_casenext670
	lda #$8a
	cmp key_press ;keep
	bne MainProgram_casenext678
	; LineNumber: 537
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock683
MainProgram_ConditionalTrueBlock681: ;Main true block ;keep 
	; LineNumber: 537
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock683
	jmp MainProgram_caseend669
MainProgram_casenext678
	lda #$88
	cmp key_press ;keep
	bne MainProgram_casenext686
	; LineNumber: 538
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock691
MainProgram_ConditionalTrueBlock689: ;Main true block ;keep 
	; LineNumber: 538
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock691
	jmp MainProgram_caseend669
MainProgram_casenext686
	lda #$89
	cmp key_press ;keep
	bne MainProgram_casenext694
	; LineNumber: 539
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock699
MainProgram_ConditionalTrueBlock697: ;Main true block ;keep 
	; LineNumber: 539
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock699
MainProgram_casenext694
MainProgram_caseend669
	; LineNumber: 547
	
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
	; LineNumber: 551
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock705
MainProgram_ConditionalTrueBlock703: ;Main true block ;keep 
	; LineNumber: 552
	; LineNumber: 555
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
	; LineNumber: 557
MainProgram_elsedoneblock705
	; LineNumber: 563
	
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
	; LineNumber: 567
	
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
	; LineNumber: 571
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 573
	jmp MainProgram_while621
MainProgram_elsedoneblock624
MainProgram_loopend626
	; LineNumber: 577
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 580
	jmp MainProgram_while521
MainProgram_elsedoneblock524
MainProgram_loopend526
	; LineNumber: 582
	; End of program
	; Ending memory block
EndBlock1100
show_start_screen_stringassignstr434		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr436		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr438		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr440		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr442		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr444		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr446		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr448		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr450		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr454		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr456		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr458		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr460		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr462		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr464		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr466		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr468		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr470		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr472		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr480		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr483		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr486		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr489		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr491		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr493		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr496		dc.b	"                    "
	dc.b	0
MainProgram_stringassignstr528		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr619		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
