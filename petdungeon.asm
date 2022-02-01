 processor 6502
	org $1100
StartBlock1100:
	; Starting new memory block at $1100
	; LineNumber: 558
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
	; LineNumber: 20
levels_level_p	= $0D
	; LineNumber: 21
levels_tiles
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///tiles.bin"
	; LineNumber: 33
levels_level1
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map1.bin"
	; LineNumber: 34
levels_level2
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map2.bin"
	; LineNumber: 35
levels_level3
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map3.bin"
	; LineNumber: 36
levels_level4
	incbin	 "/Users/chrisg/Dropbox/My Mac (Chriss-Mac-mini.local)/Documents/GitHub/dungeonc64///map4.bin"
	; LineNumber: 42
player_char	dc.b	$00
	; LineNumber: 43
space_char	dc.b	$20
	; LineNumber: 45
key_press	dc.b	$00
	; LineNumber: 46
charat	dc.b	0
	; LineNumber: 47
game_won	dc.b	0
	; LineNumber: 47
game_running	dc.b	0
	; LineNumber: 48
x	dc.b	0
	; LineNumber: 48
y	dc.b	0
	; LineNumber: 48
oldx	dc.b	0
	; LineNumber: 48
oldy	dc.b	0
	; LineNumber: 48
i	dc.b	0
	; LineNumber: 50
new_status	= $10
	; LineNumber: 50
the_status	= $12
	; LineNumber: 50
p	= $22
	; LineNumber: 53
keys	dc.b	$00
	; LineNumber: 54
gold	dc.w	$00
	; LineNumber: 55
health	dc.b	$0c
	; LineNumber: 58
attack	dc.b	$0c
	; LineNumber: 59
defense	dc.b	$0c
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init16x8div
	;    Procedure type : Built-in function
	;    Requires initialization : no
initdiv16x8_divisor = $4c     ;$59 used for hi-byte
initdiv16x8_dividend = $4e	  ;$fc used for hi-byte
initdiv16x8_remainder = $50	  ;$fe used for hi-byte
initdiv16x8_result = $4e ;save memory by reusing divident to store the result
divide16x8
	lda #0	        ;preset remainder to 0
	sta initdiv16x8_remainder
	sta initdiv16x8_remainder+1
	ldx #16	        ;repeat for each bit: ...
divloop16:	asl initdiv16x8_dividend	;dividend lb & hb*2, msb -> Carry
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
skip16
	dex
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
mul16x8_enterLoop
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
div8x8_loop1
	rol div8x8_d
	rol
	cmp div8x8_c
	bcc div8x8_loop2
	sbc div8x8_c
div8x8_loop2
	dex
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
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock89
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
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 40
	; LineNumber: 39
levels_buf_x	dc.b	0
	; LineNumber: 39
levels_buf_y	dc.b	0
levels_get_buffer_block237
levels_get_buffer
	; LineNumber: 42
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var240 = $56
	sta levels_get_buffer_rightvarInteger_var240
	sty levels_get_buffer_rightvarInteger_var240+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var243 = $58
	sta levels_get_buffer_rightvarInteger_var243
	sty levels_get_buffer_rightvarInteger_var243+1
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
	adc levels_get_buffer_rightvarInteger_var243
levels_get_buffer_wordAdd241
	sta levels_get_buffer_rightvarInteger_var243
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var243+1
	tay
	lda levels_get_buffer_rightvarInteger_var243
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var240
levels_get_buffer_wordAdd238
	sta levels_get_buffer_rightvarInteger_var240
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var240+1
	tay
	lda levels_get_buffer_rightvarInteger_var240
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 44
	; LineNumber: 45
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 50
	; LineNumber: 49
levels_plot_x	dc.b	0
	; LineNumber: 49
levels_plot_y	dc.b	0
	; LineNumber: 49
levels_plot_ch	dc.b	0
levels_plot_buffer_block244
levels_plot_buffer
	; LineNumber: 52
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var247 = $56
	sta levels_plot_buffer_rightvarInteger_var247
	sty levels_plot_buffer_rightvarInteger_var247+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var250 = $58
	sta levels_plot_buffer_rightvarInteger_var250
	sty levels_plot_buffer_rightvarInteger_var250+1
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
	adc levels_plot_buffer_rightvarInteger_var250
levels_plot_buffer_wordAdd248
	sta levels_plot_buffer_rightvarInteger_var250
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var250+1
	tay
	lda levels_plot_buffer_rightvarInteger_var250
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var247
levels_plot_buffer_wordAdd245
	sta levels_plot_buffer_rightvarInteger_var247
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var247+1
	tay
	lda levels_plot_buffer_rightvarInteger_var247
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 53
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 55
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_tile
	;    Procedure type : User-defined procedure
	; LineNumber: 64
	; LineNumber: 61
levels_tremainder	dc.b	0
	; LineNumber: 62
levels_trow	dc.b	0
	; LineNumber: 63
levels_tile_cell	dc.w	0
levels_draw_tile_block251
levels_draw_tile
	; LineNumber: 67
	
; // Get starting byte
	; Modulo
	lda #$7
levels_draw_tile_val_var252 = $56
	sta levels_draw_tile_val_var252
	lda levels_tile_no
	sec
levels_draw_tile_modulo253
	sbc levels_draw_tile_val_var252
	bcs levels_draw_tile_modulo253
	adc levels_draw_tile_val_var252
	; Calling storevariable on generic assign expression
	sta levels_tremainder
	; LineNumber: 68
	; Right is PURE NUMERIC : Is word =0
	; 8 bit div
	; 8 bit binop
	; Add/sub where right value is constant number
	lda levels_tile_no
	sec
	sbc levels_tremainder
	 ; end add / sub var with constant
	sta div8x8_d
	; Load right hand side
	lda #$7
	sta div8x8_c
	jsr div8x8_procedure
	; Calling storevariable on generic assign expression
	sta levels_trow
	; LineNumber: 69
	; Generic 16 bit op
	ldy #0
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	lda levels_tremainder
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$3
	sta mul16x8_num2
	jsr mul16x8_procedure
levels_draw_tile_rightvarInteger_var258 = $56
	sta levels_draw_tile_rightvarInteger_var258
	sty levels_draw_tile_rightvarInteger_var258+1
	; Right is PURE NUMERIC : Is word =1
	; 16 bit mul or div
	; Mul 16x8 setup
	ldy #0
	lda levels_trow
	sta mul16x8_num1
	sty mul16x8_num1Hi
	lda #$3f
	sta mul16x8_num2
	jsr mul16x8_procedure
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var258
levels_draw_tile_wordAdd256
	sta levels_draw_tile_rightvarInteger_var258
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var258+1
	tay
	lda levels_draw_tile_rightvarInteger_var258
	; Calling storevariable on generic assign expression
	sta levels_tile_cell
	sty levels_tile_cell+1
	; LineNumber: 73
	
; // ROW 1
	; INTEGER optimization: a=b+c 
	lda #<levels_tiles
	clc
	adc levels_tile_cell
	sta levels_temp_s+0
	lda #>levels_tiles
	adc levels_tile_cell+1
	sta levels_temp_s+1
	; LineNumber: 74
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
levels_draw_tile_rightvarInteger_var262 = $56
	sta levels_draw_tile_rightvarInteger_var262
	sty levels_draw_tile_rightvarInteger_var262+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var265 = $58
	sta levels_draw_tile_rightvarInteger_var265
	sty levels_draw_tile_rightvarInteger_var265+1
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
	adc levels_draw_tile_rightvarInteger_var265
levels_draw_tile_wordAdd263
	sta levels_draw_tile_rightvarInteger_var265
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var265+1
	tay
	lda levels_draw_tile_rightvarInteger_var265
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var262
levels_draw_tile_wordAdd260
	sta levels_draw_tile_rightvarInteger_var262
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var262+1
	tay
	lda levels_draw_tile_rightvarInteger_var262
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 75
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy266
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy266
	; LineNumber: 78
	
; // ROW 2
	lda levels_temp_s
	clc
	adc #$15
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd267
	inc levels_temp_s+1
levels_draw_tile_WordAdd267
	; LineNumber: 79
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd268
	inc levels_dest+1
levels_draw_tile_WordAdd268
	; LineNumber: 80
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy269
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy269
	; LineNumber: 83
	
; // ROW 3
	lda levels_temp_s
	clc
	adc #$15
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd270
	inc levels_temp_s+1
levels_draw_tile_WordAdd270
	; LineNumber: 84
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd271
	inc levels_dest+1
levels_draw_tile_WordAdd271
	; LineNumber: 85
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy272
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy272
	; LineNumber: 87
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 94
levels_draw_level
	; LineNumber: 97
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 99
	; Binary clause INTEGER: EQUALS
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bne levels_draw_level_elsedoneblock277
	lda levels_current_level
	cmp #$00 ;keep
	bne levels_draw_level_elsedoneblock277
	jmp levels_draw_level_ConditionalTrueBlock275
levels_draw_level_ConditionalTrueBlock275: ;Main true block ;keep 
	; LineNumber: 100
	; LineNumber: 101
	lda #<levels_level1
	ldx #>levels_level1
	sta levels_level_p
	stx levels_level_p+1
	; LineNumber: 102
levels_draw_level_elsedoneblock277
	; LineNumber: 104
	; Binary clause INTEGER: EQUALS
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bne levels_draw_level_elsedoneblock283
	lda levels_current_level
	cmp #$01 ;keep
	bne levels_draw_level_elsedoneblock283
	jmp levels_draw_level_ConditionalTrueBlock281
levels_draw_level_ConditionalTrueBlock281: ;Main true block ;keep 
	; LineNumber: 105
	; LineNumber: 106
	lda #<levels_level2
	ldx #>levels_level2
	sta levels_level_p
	stx levels_level_p+1
	; LineNumber: 107
levels_draw_level_elsedoneblock283
	; LineNumber: 109
	; Binary clause INTEGER: EQUALS
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bne levels_draw_level_elsedoneblock289
	lda levels_current_level
	cmp #$02 ;keep
	bne levels_draw_level_elsedoneblock289
	jmp levels_draw_level_ConditionalTrueBlock287
levels_draw_level_ConditionalTrueBlock287: ;Main true block ;keep 
	; LineNumber: 110
	; LineNumber: 111
	lda #<levels_level3
	ldx #>levels_level3
	sta levels_level_p
	stx levels_level_p+1
	; LineNumber: 112
levels_draw_level_elsedoneblock289
	; LineNumber: 114
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bcc levels_draw_level_elsedoneblock295
	bne levels_draw_level_ConditionalTrueBlock293
	lda levels_current_level
	cmp #$02 ;keep
	bcc levels_draw_level_elsedoneblock295
	beq levels_draw_level_elsedoneblock295
levels_draw_level_ConditionalTrueBlock293: ;Main true block ;keep 
	; LineNumber: 115
	; LineNumber: 116
	lda #<levels_level4
	ldx #>levels_level4
	sta levels_level_p
	stx levels_level_p+1
	; LineNumber: 117
levels_draw_level_elsedoneblock295
	; LineNumber: 129
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop298
	; LineNumber: 122
	; LineNumber: 127
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop317
	; LineNumber: 124
	; LineNumber: 125
	; Load pointer array
	; 8 bit binop
	; Add/sub where right value is constant number
	; 8 bit mul
	ldx levels_t_y ; optimized, look out for bugs
	; Load right hand side
	lda levels_tiles_across
	jsr multiply_eightbit
	txa
	clc
	adc levels_t_x
	 ; end add / sub var with constant
	tay
	lda (levels_level_p),y
	; Calling storevariable on generic assign expression
	sta levels_tile_no
	; LineNumber: 126
	jsr levels_draw_tile
	; LineNumber: 127
levels_draw_level_forloopcounter319
levels_draw_level_loopstart320
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda levels_tiles_across
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop317
levels_draw_level_loopdone328: ;keep
levels_draw_level_forloopend318
levels_draw_level_loopend321
	; LineNumber: 128
levels_draw_level_forloopcounter300
levels_draw_level_loopstart301
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_y
	lda #$6
	cmp levels_t_y ;keep
	bne levels_draw_level_forloop298
levels_draw_level_loopdone329: ;keep
levels_draw_level_forloopend299
levels_draw_level_loopend302
	; LineNumber: 134
	
; // Let's drop some keys
; // Key = 75
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$4b
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 135
	lda #$3
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$4b
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 138
	
; // Gobbo
	lda #$2
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$57
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 141
	
; // Gold
	lda #$c
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5a
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 144
	
; // Rat
	lda #$12
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$6
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5e
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 148
	
; // Health
	lda #$1
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$e
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$53
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 151
	
; // South Door
	lda #$8
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$11
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$43
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 154
	rts
	
; // Need rows at the bottom 
; // for text output
; //MemCpy16(temp_s, dest, detected_screen_width);
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 200
levels_refresh_screen
	; LineNumber: 202
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 206
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	jsr txt_current_bbc
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc levels_refresh_screen_localfailed385
	jmp levels_refresh_screen_ConditionalTrueBlock332
levels_refresh_screen_localfailed385
	jmp levels_refresh_screen_elseblock333
levels_refresh_screen_ConditionalTrueBlock332: ;Main true block ;keep 
	; LineNumber: 207
	; LineNumber: 216
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop387
	; LineNumber: 212
	; LineNumber: 213
	
; // Need rows at the bottom 
; // for text output
; // BBC
	; Load Integer array
	lda levels_r
	asl
	tax
	lda txt_ytab,x
	ldy txt_ytab+1,x
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 214
	; memcpyfast
	ldy levels_detected_screen_width
	dey
levels_refresh_screen_memcpy396
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy396
	; LineNumber: 215
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd397
	inc levels_temp_s+1
levels_refresh_screen_WordAdd397
	; LineNumber: 216
levels_refresh_screen_forloopcounter389
levels_refresh_screen_loopstart390
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop387
levels_refresh_screen_loopdone398: ;keep
levels_refresh_screen_forloopend388
levels_refresh_screen_loopend391
	; LineNumber: 218
	jmp levels_refresh_screen_elsedoneblock334
levels_refresh_screen_elseblock333
	; LineNumber: 219
	; LineNumber: 223
	
; // Electron
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 224
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$0
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy401
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy401
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 225
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$1
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy403
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy403
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 226
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$2
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy405
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy405
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 227
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$3
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy407
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy407
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 228
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$4
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy409
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy409
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 229
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$5
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy411
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy411
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 230
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$6
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy413
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy413
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 231
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$7
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy415
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy415
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 232
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$8
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy417
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy417
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 233
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$9
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy419
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy419
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 234
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$a
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy421
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy421
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 235
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$b
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy423
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy423
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 236
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$c
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy425
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy425
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 237
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$d
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy427
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy427
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 238
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$e
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy429
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy429
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 239
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$f
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy431
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy431
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 240
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$10
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy433
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy433
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 241
	; LineNumber: 190
	; LineNumber: 191
	; Load Integer array
	lda #$11
	asl
	tax
	lda levels_b_tab,x
	ldy levels_b_tab+1,x
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 192
	; memcpyfast
	ldy #29
levels_refresh_screen_memcpy435
	lda (levels_temp_s),y
	sta levels_this_string,y
	dey
	bpl levels_refresh_screen_memcpy435
	; LineNumber: 193
	lda #<levels_this_string
	ldx #>levels_this_string
	sta txt_in_str
	stx txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 194
	; LineNumber: 243
levels_refresh_screen_elsedoneblock334
	; LineNumber: 245
	rts
	
; //player inventory/stats
; // ********************************
	; NodeProcedureDecl -1
	; ***********  Defining procedure : init
	;    Procedure type : User-defined procedure
	; LineNumber: 67
init
	; LineNumber: 69
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 73
	
; // Initialise start position
	lda #$5
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 74
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 78
	
; // Clean the screen buffer		
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 79
	lda space_char
	ldy #0
init_fill437
	sta (p),y
	iny
	cpy #$fa
	bne init_fill437
	; LineNumber: 81
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd438
	inc p+1
init_WordAdd438
	; LineNumber: 82
	lda space_char
	ldy #0
init_fill439
	sta (p),y
	iny
	cpy #$fa
	bne init_fill439
	; LineNumber: 84
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd440
	inc p+1
init_WordAdd440
	; LineNumber: 85
	lda space_char
	ldy #0
init_fill441
	sta (p),y
	iny
	cpy #$fa
	bne init_fill441
	; LineNumber: 87
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd442
	inc p+1
init_WordAdd442
	; LineNumber: 88
	lda space_char
	ldy #0
init_fill443
	sta (p),y
	iny
	cpy #$fa
	bne init_fill443
	; LineNumber: 91
	
; // Initialise player inventory
	lda #$0
	; Calling storevariable on generic assign expression
	sta keys
	; LineNumber: 94
	
; // Set how wide the map should be
	lda #$7
	; Calling storevariable on generic assign expression
	sta levels_tiles_across
	; LineNumber: 100
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta p
	stx p+1
	; LineNumber: 105
	lda #$0
	; Calling storevariable on generic assign expression
	sta i
init_forloop444
	; LineNumber: 102
	; LineNumber: 103
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
	; LineNumber: 104
	lda p
	clc
	adc #$28
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd452
	inc p+1
init_WordAdd452
	; LineNumber: 105
init_forloopcounter446
init_loopstart447
	; Compare is onpage
	; Test Inc dec D
	inc i
	lda #$12
	cmp i ;keep
	bcs init_forloop444
init_loopdone453: ;keep
init_forloopend445
init_loopend448
	; LineNumber: 115
	
; // Clear screen,
	jsr txt_cls
	; LineNumber: 117
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 118
	lda #$1
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 121
	
; // Draw current level
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_current_level
	sty levels_current_level+1
	; LineNumber: 122
	jsr levels_draw_level
	; LineNumber: 125
	
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
	; LineNumber: 128
	
; // Update the screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 130
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
	; LineNumber: 210
show_start_screen
	; LineNumber: 212
	jsr txt_cls
	; LineNumber: 213
	; Binary clause Simplified: EQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne show_start_screen_localfailed486
	jmp show_start_screen_ConditionalTrueBlock456
show_start_screen_localfailed486
	jmp show_start_screen_elsedoneblock458
show_start_screen_ConditionalTrueBlock456: ;Main true block ;keep 
	; LineNumber: 214
	; LineNumber: 217
	
; //                         01234567890123456789012
; // Text colour to green:
	lda #$1e
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 218
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 219
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr488
	sta txt_in_str
	lda #>show_start_screen_stringassignstr488
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 220
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 221
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr490
	sta txt_in_str
	lda #>show_start_screen_stringassignstr490
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 222
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr492
	sta txt_in_str
	lda #>show_start_screen_stringassignstr492
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 223
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr494
	sta txt_in_str
	lda #>show_start_screen_stringassignstr494
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 224
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 225
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr496
	sta txt_in_str
	lda #>show_start_screen_stringassignstr496
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 226
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 227
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr498
	sta txt_in_str
	lda #>show_start_screen_stringassignstr498
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 228
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr500
	sta txt_in_str
	lda #>show_start_screen_stringassignstr500
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 229
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 230
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr502
	sta txt_in_str
	lda #>show_start_screen_stringassignstr502
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 231
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 232
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr504
	sta txt_in_str
	lda #>show_start_screen_stringassignstr504
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 233
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr506
	sta txt_in_str
	lda #>show_start_screen_stringassignstr506
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 234
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr508
	sta txt_in_str
	lda #>show_start_screen_stringassignstr508
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 235
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr510
	sta txt_in_str
	lda #>show_start_screen_stringassignstr510
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 236
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr512
	sta txt_in_str
	lda #>show_start_screen_stringassignstr512
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 237
show_start_screen_elsedoneblock458
	; LineNumber: 241
	
; // Wait for keypress
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 242
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 245
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr514
	sta txt_in_str
	lda #>show_start_screen_stringassignstr514
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 246
	jsr txt_print_space
	; LineNumber: 249
	lda #$d
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 250
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 253
	jsr txt_wait_key
	; LineNumber: 256
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : show_end_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 261
show_end_screen
	; LineNumber: 263
	jsr txt_cls
	; LineNumber: 264
	; Binary clause Simplified: NOTEQUALS
	lda game_won
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq show_end_screen_elseblock519
show_end_screen_ConditionalTrueBlock518: ;Main true block ;keep 
	; LineNumber: 264
	; LineNumber: 266
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr528
	sta txt_in_str
	lda #>show_end_screen_stringassignstr528
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 268
	jmp show_end_screen_elsedoneblock520
show_end_screen_elseblock519
	; LineNumber: 269
	; LineNumber: 270
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr531
	sta txt_in_str
	lda #>show_end_screen_stringassignstr531
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 271
show_end_screen_elsedoneblock520
	; LineNumber: 274
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr533
	sta txt_in_str
	lda #>show_end_screen_stringassignstr533
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 276
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 278
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr535
	sta txt_in_str
	lda #>show_end_screen_stringassignstr535
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 280
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 282
	jsr txt_wait_key
	; LineNumber: 285
	rts
	
; //@ifndef ATARI800		
	; NodeProcedureDecl -1
	; ***********  Defining procedure : display_text
	;    Procedure type : User-defined procedure
	; LineNumber: 290
display_text
	; LineNumber: 292
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 293
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 294
	; Assigning a string : txt_in_str
	lda #<display_text_stringassignstr538
	sta txt_in_str
	lda #>display_text_stringassignstr538
	sta txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 295
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 296
	lda the_status
	ldx the_status+1
	sta txt_in_str
	stx txt_in_str+1
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	jsr txt_print_string
	; LineNumber: 297
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 299
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 300
	lda #$cb
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 301
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 302
	lda keys
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 304
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$14
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 305
	lda #$7a
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 306
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 307
	; integer assignment NodeVar
	ldy gold+1 ; keep
	lda gold
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 310
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 311
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 312
	lda #$d3
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 313
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 314
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 315
	lda health
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 318
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$15
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 319
	lda #$76
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 320
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 321
	lda attack
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 324
	lda #$5
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$16
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 325
	lda #$12
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 326
	lda #$d6
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 327
	lda #$92
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 328
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 329
	lda defense
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 331
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 335
update_status_block540
update_status
	; LineNumber: 336
	lda new_status
	ldx new_status+1
	sta the_status
	stx the_status+1
	; LineNumber: 337
	jsr display_text
	; LineNumber: 339
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 343
door
	; LineNumber: 346
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed621
	jmp door_ConditionalTrueBlock543
door_localfailed621: ;keep
	; ; logical OR, second chance
	; Binary clause Simplified: EQUALS
	lda charat
	; Compare with pure num / var optimization
	cmp #$5d;keep
	bne door_localfailed620
	jmp door_ConditionalTrueBlock543
door_localfailed620
	jmp door_elseblock544
door_ConditionalTrueBlock543: ;Main true block ;keep 
	; LineNumber: 346
	; LineNumber: 350
	; Binary clause Simplified: NOTEQUALS
	lda charat
	; Compare with pure num / var optimization
	cmp #$5d;keep
	beq door_elsedoneblock626
door_ConditionalTrueBlock624: ;Main true block ;keep 
	; LineNumber: 350
	; LineNumber: 352
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 353
	; Assigning a string : new_status
	lda #<door_stringassignstr631
	sta new_status
	lda #>door_stringassignstr631
	sta new_status+1
	jsr update_status
	; LineNumber: 355
	
; // Place the open door
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda y
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5d
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 358
door_elsedoneblock626
	; LineNumber: 362
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock636
door_ConditionalTrueBlock634: ;Main true block ;keep 
	; LineNumber: 361
	; Assigning a string : new_status
	lda #<door_stringassignstr641
	sta new_status
	lda #>door_stringassignstr641
	sta new_status+1
	jsr update_status
door_elsedoneblock636
	; LineNumber: 363
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock646
door_ConditionalTrueBlock644: ;Main true block ;keep 
	; LineNumber: 362
	; Assigning a string : new_status
	lda #<door_stringassignstr651
	sta new_status
	lda #>door_stringassignstr651
	sta new_status+1
	jsr update_status
door_elsedoneblock646
	; LineNumber: 366
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock656
door_ConditionalTrueBlock654: ;Main true block ;keep 
	; LineNumber: 367
	; LineNumber: 368
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda levels_current_level+1   ; compare high bytes
	cmp #$00 ;keep
	bcc door_elsedoneblock672
	bne door_ConditionalTrueBlock670
	lda levels_current_level
	cmp #$00 ;keep
	bcc door_elsedoneblock672
	beq door_elsedoneblock672
door_ConditionalTrueBlock670: ;Main true block ;keep 
	; LineNumber: 367
	
; // North Door
	lda levels_current_level
	sec
	sbc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcs door_WordAdd676
	dec levels_current_level+1
door_WordAdd676
door_elsedoneblock672
	; LineNumber: 369
	; Assigning a string : new_status
	lda #<door_stringassignstr677
	sta new_status
	lda #>door_stringassignstr677
	sta new_status+1
	jsr update_status
	; LineNumber: 370
	lda #$10
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 371
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 372
	jsr levels_draw_level
	; LineNumber: 374
	
; // Place the open door
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$11
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5d
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 375
door_elsedoneblock656
	; LineNumber: 378
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock682
door_ConditionalTrueBlock680: ;Main true block ;keep 
	; LineNumber: 379
	; LineNumber: 382
	
; // South Door
; // Ta-da
	; Assigning a string : new_status
	lda #<door_stringassignstr688
	sta new_status
	lda #>door_stringassignstr688
	sta new_status+1
	jsr update_status
	; LineNumber: 383
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd690
	inc levels_current_level+1
door_WordAdd690
	; LineNumber: 384
	lda #$1
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 385
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 386
	jsr levels_draw_level
	; LineNumber: 388
	
; // Place the open door
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$5d
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 389
door_elsedoneblock682
	; LineNumber: 393
	
; // Reset to new position
	; 8 bit binop
	; Add/sub right value is variable/expression
	; 8 bit binop
	; Add/sub where right value is constant number
	lda oldx
	sec
	sbc x
	 ; end add / sub var with constant
door_rightvarAddSub_var691 = $56
	sta door_rightvarAddSub_var691
	lda x
	sec
	sbc door_rightvarAddSub_var691
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 394
	; 8 bit binop
	; Add/sub right value is variable/expression
	; 8 bit binop
	; Add/sub where right value is constant number
	lda oldy
	sec
	sbc y
	 ; end add / sub var with constant
door_rightvarAddSub_var692 = $56
	sta door_rightvarAddSub_var692
	lda y
	sec
	sbc door_rightvarAddSub_var692
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 397
	jmp door_elsedoneblock545
door_elseblock544
	; LineNumber: 398
	; LineNumber: 399
	; Assigning a string : new_status
	lda #<door_stringassignstr694
	sta new_status
	lda #>door_stringassignstr694
	sta new_status+1
	jsr update_status
	; LineNumber: 402
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 403
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 404
door_elsedoneblock545
	; LineNumber: 406
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 410
combat
	; LineNumber: 413
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
	bcc combat_localfailed733
	jmp combat_ConditionalTrueBlock698
combat_localfailed733
	jmp combat_elseblock699
combat_ConditionalTrueBlock698: ;Main true block ;keep 
	; LineNumber: 414
	; LineNumber: 416
	; Binary clause Simplified: EQUALS
	lda charat
	; Compare with pure num / var optimization
	cmp #$57;keep
	bne combat_elseblock739
combat_ConditionalTrueBlock738: ;Main true block ;keep 
	; LineNumber: 417
	; LineNumber: 419
	
; // Gobbo drops key
	lda x
	; Calling storevariable on generic assign expression
	sta levels_plot_x
	lda y
	; Calling storevariable on generic assign expression
	sta levels_plot_y
	lda #$4b
	; Calling storevariable on generic assign expression
	sta levels_plot_ch
	jsr levels_plot_buffer
	; LineNumber: 422
	
; // Reset player to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 423
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 424
	; Assigning a string : new_status
	lda #<combat_stringassignstr748
	sta new_status
	lda #>combat_stringassignstr748
	sta new_status+1
	jsr update_status
	; LineNumber: 425
	jmp combat_elsedoneblock740
combat_elseblock739
	; LineNumber: 427
	; LineNumber: 428
	; Assigning a string : new_status
	lda #<combat_stringassignstr751
	sta new_status
	lda #>combat_stringassignstr751
	sta new_status+1
	jsr update_status
	; LineNumber: 429
combat_elsedoneblock740
	; LineNumber: 430
	jmp combat_elsedoneblock700
combat_elseblock699
	; LineNumber: 432
	; LineNumber: 434
	; Test Inc dec D
	dec health
	; LineNumber: 437
	
; // Repel to position
	; 8 bit binop
	; Add/sub where right value is constant number
	; Right is PURE NUMERIC : Is word =0
	; 8 bit mul of power 2
	; 8 bit binop
	; Add/sub where right value is constant number
	lda oldx
	sec
	sbc x
	 ; end add / sub var with constant
	asl
	clc
	adc x
	 ; end add / sub var with constant
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 438
	; 8 bit binop
	; Add/sub where right value is constant number
	; Right is PURE NUMERIC : Is word =0
	; 8 bit mul of power 2
	; 8 bit binop
	; Add/sub where right value is constant number
	lda oldy
	sec
	sbc y
	 ; end add / sub var with constant
	asl
	clc
	adc y
	 ; end add / sub var with constant
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 442
	
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
	; LineNumber: 443
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp #$20;keep
	beq combat_elsedoneblock757
combat_ConditionalTrueBlock755: ;Main true block ;keep 
	; LineNumber: 444
	; LineNumber: 445
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 446
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 447
combat_elsedoneblock757
	; LineNumber: 449
	; Assigning a string : new_status
	lda #<combat_stringassignstr760
	sta new_status
	lda #>combat_stringassignstr760
	sta new_status+1
	jsr update_status
	; LineNumber: 451
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock763
	bcs combat_elsedoneblock765
combat_ConditionalTrueBlock763: ;Main true block ;keep 
	; LineNumber: 452
	; LineNumber: 453
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 454
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 455
combat_elsedoneblock765
	; LineNumber: 457
combat_elsedoneblock700
	; LineNumber: 459
	rts
	
; //@endif
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 465
check_collisions
	; LineNumber: 468
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext770
	; LineNumber: 472
	; LineNumber: 474
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr772
	sta new_status
	lda #>check_collisions_stringassignstr772
	sta new_status+1
	jsr update_status
	; LineNumber: 475
	jsr combat
	; LineNumber: 477
	jmp check_collisions_caseend769
check_collisions_casenext770
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext774
	; LineNumber: 480
	; LineNumber: 481
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr776
	sta new_status
	lda #>check_collisions_stringassignstr776
	sta new_status+1
	jsr update_status
	; LineNumber: 482
	jmp check_collisions_caseend769
check_collisions_casenext774
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext778
	; LineNumber: 484
	; LineNumber: 486
	jsr door
	; LineNumber: 487
	jmp check_collisions_caseend769
check_collisions_casenext778
	lda #$5d
	cmp charat ;keep
	bne check_collisions_casenext780
	; LineNumber: 489
	; LineNumber: 491
	
; // Opendoor
	jsr door
	; LineNumber: 492
	jmp check_collisions_caseend769
check_collisions_casenext780
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext782
	; LineNumber: 494
	; LineNumber: 496
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 497
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr784
	sta new_status
	lda #>check_collisions_stringassignstr784
	sta new_status+1
	jsr update_status
	; LineNumber: 498
	jmp check_collisions_caseend769
check_collisions_casenext782
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext786
	; LineNumber: 502
	; LineNumber: 503
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 504
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr788
	sta new_status
	lda #>check_collisions_stringassignstr788
	sta new_status+1
	jsr update_status
	; LineNumber: 506
	jmp check_collisions_caseend769
check_collisions_casenext786
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext790
	; LineNumber: 508
	; LineNumber: 511
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr792
	sta new_status
	lda #>check_collisions_stringassignstr792
	sta new_status+1
	jsr update_status
	; LineNumber: 512
	jsr combat
	; LineNumber: 513
	jmp check_collisions_caseend769
check_collisions_casenext790
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext794
	; LineNumber: 516
	; LineNumber: 517
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd796
	inc gold+1
check_collisions_WordAdd796
	; LineNumber: 518
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr797
	sta new_status
	lda #>check_collisions_stringassignstr797
	sta new_status+1
	jsr update_status
	; LineNumber: 520
	jmp check_collisions_caseend769
check_collisions_casenext794
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext799
	; LineNumber: 523
	; LineNumber: 525
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr801
	sta new_status
	lda #>check_collisions_stringassignstr801
	sta new_status+1
	jsr update_status
	; LineNumber: 526
	jsr combat
	; LineNumber: 528
	jmp check_collisions_caseend769
check_collisions_casenext799
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext803
	; LineNumber: 532
	; LineNumber: 534
	jmp check_collisions_caseend769
check_collisions_casenext803
	; LineNumber: 538
	; LineNumber: 541
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 542
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 547
	
; // Unknown
; //_A:=charat;
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr806
	sta new_status
	lda #>check_collisions_stringassignstr806
	sta new_status+1
	jsr update_status
	; LineNumber: 548
	lda #$f
	; Calling storevariable on generic assign expression
	sta txt__text_x
	lda #$13
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 549
	lda charat
	; Calling storevariable on generic assign expression
	sta txt__in_n
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__add_cr
	jsr txt_print_dec
	; LineNumber: 551
check_collisions_caseend769
	; LineNumber: 554
	rts
block1
	; LineNumber: 560
	
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 574
	
; // C64 has it's own special characters
	jsr txt_cursor_off
	; LineNumber: 575
	lda #$40
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 592
MainProgram_while808
MainProgram_loopstart812
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed904
	jmp MainProgram_ConditionalTrueBlock809
MainProgram_localfailed904
	jmp MainProgram_elsedoneblock811
MainProgram_ConditionalTrueBlock809: ;Main true block ;keep 
	; LineNumber: 592
	; LineNumber: 597
	
; // Borked, will need some work
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 601
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 604
	; Assigning a string : new_status
	lda #<MainProgram_stringassignstr906
	sta new_status
	lda #>MainProgram_stringassignstr906
	sta new_status+1
	jsr update_status
	; LineNumber: 605
	jsr display_text
	; LineNumber: 609
MainProgram_while908
MainProgram_loopstart912
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed954
	jmp MainProgram_ConditionalTrueBlock909
MainProgram_localfailed954
	jmp MainProgram_elsedoneblock911
MainProgram_ConditionalTrueBlock909: ;Main true block ;keep 
	; LineNumber: 610
	; LineNumber: 615
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 616
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 619
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 622
	lda #$8b
	cmp key_press ;keep
	bne MainProgram_casenext957
	; LineNumber: 624
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock962
MainProgram_ConditionalTrueBlock960: ;Main true block ;keep 
	; LineNumber: 624
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock962
	jmp MainProgram_caseend956
MainProgram_casenext957
	lda #$8a
	cmp key_press ;keep
	bne MainProgram_casenext965
	; LineNumber: 625
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock970
MainProgram_ConditionalTrueBlock968: ;Main true block ;keep 
	; LineNumber: 625
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock970
	jmp MainProgram_caseend956
MainProgram_casenext965
	lda #$88
	cmp key_press ;keep
	bne MainProgram_casenext973
	; LineNumber: 626
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock978
MainProgram_ConditionalTrueBlock976: ;Main true block ;keep 
	; LineNumber: 626
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock978
	jmp MainProgram_caseend956
MainProgram_casenext973
	lda #$89
	cmp key_press ;keep
	bne MainProgram_casenext981
	; LineNumber: 627
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock986
MainProgram_ConditionalTrueBlock984: ;Main true block ;keep 
	; LineNumber: 627
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock986
MainProgram_casenext981
MainProgram_caseend956
	; LineNumber: 635
	
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
	; LineNumber: 639
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock992
MainProgram_ConditionalTrueBlock990: ;Main true block ;keep 
	; LineNumber: 640
	; LineNumber: 643
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
	; LineNumber: 645
MainProgram_elsedoneblock992
	; LineNumber: 651
	
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
	; LineNumber: 655
	
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
	; LineNumber: 659
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 661
	jmp MainProgram_while908
MainProgram_elsedoneblock911
MainProgram_loopend913
	; LineNumber: 665
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 668
	jmp MainProgram_while808
MainProgram_elsedoneblock811
MainProgram_loopend813
	; LineNumber: 670
	; End of program
	; Ending memory block at $1100
show_start_screen_stringassignstr460		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr462		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr464		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr466		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr468		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr470		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr472		dc.b	"(C)2022"
	dc.b	0
show_start_screen_stringassignstr474		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr476		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr478		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr480		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr482		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr484		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr488		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr490		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr492		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr494		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr496		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr498		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr500		dc.b	"(C)2022"
	dc.b	0
show_start_screen_stringassignstr502		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr504		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr506		dc.b	"@ = YOU k = KEY"
	dc.b	0
show_start_screen_stringassignstr508		dc.b	"s = HEALTH c = DOOR"
	dc.b	0
show_start_screen_stringassignstr510		dc.b	"z = GEM x = ARTIFACT"
	dc.b	0
show_start_screen_stringassignstr512		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr514		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr522		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr525		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr528		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr531		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr533		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr535		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
display_text_stringassignstr538		dc.b	"                    "
	dc.b	0
door_stringassignstr552		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr555		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr562		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr565		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr572		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr575		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr590		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr601		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr608		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr612		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr618		dc.b	"YOU NEED A KEY!                    "
	dc.b	0
door_stringassignstr628		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr631		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr638		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr641		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr648		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr651		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr666		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr677		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr684		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr688		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr694		dc.b	"YOU NEED A KEY!                    "
	dc.b	0
combat_stringassignstr707		dc.b	"GOBBO DROPPED A KEY!             "
	dc.b	0
combat_stringassignstr710		dc.b	"YOU WON THIS FIGHT               "
	dc.b	0
combat_stringassignstr713		dc.b	"GOBBO DROPPED A KEY!             "
	dc.b	0
combat_stringassignstr716		dc.b	"YOU WON THIS FIGHT               "
	dc.b	0
combat_stringassignstr725		dc.b	"YOU LOST THIS FIGHT                  "
	dc.b	0
combat_stringassignstr742		dc.b	"GOBBO DROPPED A KEY!             "
	dc.b	0
combat_stringassignstr745		dc.b	"YOU WON THIS FIGHT               "
	dc.b	0
combat_stringassignstr748		dc.b	"GOBBO DROPPED A KEY!             "
	dc.b	0
combat_stringassignstr751		dc.b	"YOU WON THIS FIGHT               "
	dc.b	0
combat_stringassignstr760		dc.b	"YOU LOST THIS FIGHT                  "
	dc.b	0
check_collisions_stringassignstr772		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr776		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr784		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr788		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr792		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr797		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr801		dc.b	"RAT ATTACKS!"
	dc.b	0
check_collisions_stringassignstr806		dc.b	"EXISTING TILE:"
	dc.b	0
MainProgram_stringassignstr815		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
MainProgram_stringassignstr906		dc.b	"WELCOME ADVENTURER!"
	dc.b	0
EndBlock1100:
