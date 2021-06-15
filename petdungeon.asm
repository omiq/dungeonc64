 processor 6502
	org $a000
	; Starting new memory block at $a000
StartBlocka000
dungeon64
	; LineNumber: 453
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
	; LineNumber: 17
txt_in_str	= $02
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
levels_temp_s	= $04
	; LineNumber: 8
levels_dest	= $08
	; LineNumber: 8
levels_ch_index	= $16
	; LineNumber: 10
levels_tiles_across	dc.b	0
	; LineNumber: 11
levels_detected_screen_width	dc.b	0
	; LineNumber: 14
levels_screen_buffer	dc.b	 
	org levels_screen_buffer+1000
	; LineNumber: 22
levels_tiles
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/Atari Tiles.bin"
	; LineNumber: 27
levels_level
	incbin "/Users/chris.garrett/GitHub/dungeonc64///levels/map.bin"
	; LineNumber: 28
levels_level_p	= $0B
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
new_status	= $0D
	; LineNumber: 60
p	= $10
	; LineNumber: 63
keys	dc.b	$00
	; LineNumber: 64
gold	dc.w	$00
	; LineNumber: 65
health	dc.b	$0c
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
	; ***********  Defining procedure : txt_DefineScreen
	;    Procedure type : User-defined procedure
	; LineNumber: 272
	; LineNumber: 271
txt_y	dc.b	0
txt_DefineScreen_block5
txt_DefineScreen
	; LineNumber: 274
	; Peek
	ldy $59 + $0;keep ; optimized, look out for bugs
	; Peek
	lda $58 + $0;keep
	; Calling storevariable on generic assign expression
	sta txt_temp_address_p
	sty txt_temp_address_p+1
	; LineNumber: 282
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_y
txt_DefineScreen_forloop6
	; LineNumber: 277
	; LineNumber: 278
	ldx #$28 ; optimized, look out for bugs
	lda #$0
txt_DefineScreen_fill15
	; integer assignment NodeVar
	ldy txt_temp_address_p+1 ; keep
	lda txt_temp_address_p,x
	dex
	bpl txt_DefineScreen_fill15
	; LineNumber: 279
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
	; LineNumber: 280
	lda txt_temp_address_p
	clc
	adc #$28
	sta txt_temp_address_p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc txt_DefineScreen_WordAdd16
	inc txt_temp_address_p+1
txt_DefineScreen_WordAdd16
	; LineNumber: 281
txt_DefineScreen_forloopcounter8
txt_DefineScreen_loopstart9
	; Compare is onpage
	; Test Inc dec D
	inc txt_y
	lda #$18
	cmp txt_y ;keep
	bcs txt_DefineScreen_forloop6
txt_DefineScreen_loopdone17: ;keep
txt_DefineScreen_forloopend7
txt_DefineScreen_loopend10
	; LineNumber: 283
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_move_to
	;    Procedure type : User-defined procedure
	; LineNumber: 288
	; LineNumber: 285
txt__text_x	dc.b	0
	; LineNumber: 285
txt__text_y	dc.b	0
txt_move_to_block18
txt_move_to
	; LineNumber: 289
	; Poke
	; Optimization: shift is zero
	lda txt__text_y
	sta $54
	; LineNumber: 290
	; Poke
	; Optimization: shift is zero
	lda txt__text_x
	sta $55
	; LineNumber: 291
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $56
	; LineNumber: 292
	rts
	
; // put cursor n home position 0,0
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_home
	;    Procedure type : User-defined procedure
	; LineNumber: 297
txt_cursor_home
	; LineNumber: 298
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt__text_x
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 299
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cls
	;    Procedure type : User-defined procedure
	; LineNumber: 302
txt_cls
	; LineNumber: 303
	
; //poke(^766,0,1); 
; //shows edit chars
	; Poke
	; Optimization: shift is zero
	lda #$0
	sta $52
	; LineNumber: 305
	
; // left margin to zero
	jsr txt_DefineScreen
	; LineNumber: 306
	jsr txt_cursor_home
	; LineNumber: 307
	rts
	
; // Put a character at current cursor location
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_put_ch
	;    Procedure type : User-defined procedure
	; LineNumber: 317
	; LineNumber: 316
txt_CH	dc.b	0
txt_put_ch_block21
txt_put_ch
	; LineNumber: 318
	; Assigning to register
	; Assigning register : _a
	lda txt_CH
	; LineNumber: 319
	jsr $f6a4
	; LineNumber: 320
	rts
	
; //poke(^764,0,255);
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_get_key
	;    Procedure type : User-defined procedure
	; LineNumber: 332
	; LineNumber: 331
txt_ink	dc.b	$00
txt_get_key_block22
txt_get_key
	; LineNumber: 333
	jsr $f6e2
	; LineNumber: 334
	; Assigning from register
	sta txt_ink
	; LineNumber: 335
	rts
	; LineNumber: 336
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_wait_key
	;    Procedure type : User-defined procedure
	; LineNumber: 340
txt_wait_key
	; LineNumber: 341
	jsr txt_get_key
	; LineNumber: 342
	rts
	
; //CURSOR_OFF
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_off
	;    Procedure type : User-defined procedure
	; LineNumber: 358
txt_cursor_off
	; LineNumber: 359
	; Poke
	; Optimization: shift is zero
	lda #$1
	sta $2f0
	; LineNumber: 360
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_cursor_return
	;    Procedure type : User-defined procedure
	; LineNumber: 382
txt_cursor_return
	; LineNumber: 384
	lda #$9b
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 385
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string
	;    Procedure type : User-defined procedure
	; LineNumber: 399
	; LineNumber: 398
txt_next_ch	dc.b	0
	; LineNumber: 396
	; LineNumber: 396
txt_print_string_block26
txt_print_string
	; LineNumber: 401
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_next_ch
	; LineNumber: 402
txt_print_string_while27
txt_print_string_loopstart31
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock30
txt_print_string_ConditionalTrueBlock28: ;Main true block ;keep 
	; LineNumber: 402
	; LineNumber: 404
	; Load pointer array
	ldy txt_next_ch
	lda (txt_in_str),y
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 405
	; Test Inc dec D
	inc txt_next_ch
	; LineNumber: 406
	jmp txt_print_string_while27
txt_print_string_elsedoneblock30
txt_print_string_loopend32
	; LineNumber: 408
	; Binary clause Simplified: NOTEQUALS
	lda txt_CRLF
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_print_string_elsedoneblock38
txt_print_string_ConditionalTrueBlock36: ;Main true block ;keep 
	; LineNumber: 409
	; LineNumber: 410
	jsr txt_cursor_return
	; LineNumber: 411
txt_print_string_elsedoneblock38
	; LineNumber: 412
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_str_len
	;    Procedure type : User-defined procedure
	; LineNumber: 554
	; LineNumber: 553
txt_str_len_block41
txt_str_len
	; LineNumber: 556
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 559
txt_str_len_while42
txt_str_len_loopstart46
	; Binary clause Simplified: NOTEQUALS
	; Load pointer array
	ldy txt_i
	lda (txt_in_str),y
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq txt_str_len_elsedoneblock45
txt_str_len_ConditionalTrueBlock43: ;Main true block ;keep 
	; LineNumber: 559
	; LineNumber: 561
	
; // get the Str_Len by counting until char is 0
	; Test Inc dec D
	inc txt_i
	; LineNumber: 562
	jmp txt_str_len_while42
txt_str_len_elsedoneblock45
txt_str_len_loopend47
	; LineNumber: 566
	; LineNumber: 567
	lda txt_i
	rts
	
; // Return
; // print X spaces
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_space
	;    Procedure type : User-defined procedure
	; LineNumber: 571
	; LineNumber: 570
txt_print_space_block50
txt_print_space
	; LineNumber: 573
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 578
	; Calling storevariable on generic assign expression
txt_print_space_forloop51
	; LineNumber: 575
	; LineNumber: 576
	lda #$20
	; Calling storevariable on generic assign expression
	sta txt_CH
	jsr txt_put_ch
	; LineNumber: 577
txt_print_space_forloopcounter53
txt_print_space_loopstart54
	; Compare is onpage
	; Test Inc dec D
	inc txt_i
	; integer assignment NodeVar
	ldy txt_max_digits+1 ; keep
	lda txt_max_digits
	cmp txt_i ;keep
	bne txt_print_space_forloop51
txt_print_space_loopdone58: ;keep
txt_print_space_forloopend52
txt_print_space_loopend55
	; LineNumber: 579
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : txt_print_string_centered
	;    Procedure type : User-defined procedure
	; LineNumber: 583
	; LineNumber: 582
	; LineNumber: 582
	; LineNumber: 582
txt__sc_w	dc.b	0
txt_print_string_centered_block59
txt_print_string_centered
	; LineNumber: 585
	lda #$0
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 586
	ldy #0   ; Force integer assignment, set y = 0 for values lower than 255
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 589
	
; // Get the length of the string
	jsr txt_str_len
	; Calling storevariable on generic assign expression
	sta txt_i
	; LineNumber: 592
	
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
	bcs txt_print_string_centered_skip61
	dey
txt_print_string_centered_skip61
txt_print_string_centered_int_shift_var62 = $54
	sta txt_print_string_centered_int_shift_var62
	sty txt_print_string_centered_int_shift_var62+1
		lsr txt_print_string_centered_int_shift_var62+1
	ror txt_print_string_centered_int_shift_var62+0

	lda txt_print_string_centered_int_shift_var62
	ldy txt_print_string_centered_int_shift_var62+1
	; Calling storevariable on generic assign expression
	sta txt_max_digits
	sty txt_max_digits+1
	; LineNumber: 595
	; Binary clause INTEGER: GREATER
	; Compare INTEGER with pure num / var optimization. GREATER. 
	lda txt_max_digits+1   ; compare high bytes
	cmp #$00 ;keep
	bcc txt_print_string_centered_elseblock65
	bne txt_print_string_centered_localsuccess69
	lda txt_max_digits
	cmp #$00 ;keep
	bcc txt_print_string_centered_elseblock65
	beq txt_print_string_centered_elseblock65
txt_print_string_centered_localsuccess69: ;keep
	; ; logical AND, second requirement
	; Binary clause Simplified: LESS
	lda txt_i
	; Compare with pure num / var optimization
	cmp #$28;keep
	bcs txt_print_string_centered_elseblock65
txt_print_string_centered_ConditionalTrueBlock64: ;Main true block ;keep 
	; LineNumber: 595
	; LineNumber: 599
	
; // Is it worth padding?
; // Add the padding
	jsr txt_print_space
	; LineNumber: 602
	
; // print the string
	jsr txt_print_string
	; LineNumber: 605
	jmp txt_print_string_centered_elsedoneblock66
txt_print_string_centered_elseblock65
	; LineNumber: 606
	; LineNumber: 608
	
; // print the string
	jsr txt_print_string
	; LineNumber: 609
txt_print_string_centered_elsedoneblock66
	; LineNumber: 613
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_tile
	;    Procedure type : User-defined procedure
	; LineNumber: 34
	; LineNumber: 33
	; LineNumber: 33
	; LineNumber: 33
levels_draw_tile_block72
levels_draw_tile
	; LineNumber: 37
	
; // Source
	; Generic 16 bit op
	lda #<levels_tiles
	ldy #>levels_tiles
levels_draw_tile_rightvarInteger_var75 = $54
	sta levels_draw_tile_rightvarInteger_var75
	sty levels_draw_tile_rightvarInteger_var75+1
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
	adc levels_draw_tile_rightvarInteger_var75
levels_draw_tile_wordAdd73
	sta levels_draw_tile_rightvarInteger_var75
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var75+1
	tay
	lda levels_draw_tile_rightvarInteger_var75
	sta levels_temp_s
	sty levels_temp_s+1
	; LineNumber: 40
	
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
levels_draw_tile_rightvarInteger_var78 = $54
	sta levels_draw_tile_rightvarInteger_var78
	sty levels_draw_tile_rightvarInteger_var78+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_draw_tile_rightvarInteger_var81 = $56
	sta levels_draw_tile_rightvarInteger_var81
	sty levels_draw_tile_rightvarInteger_var81+1
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
	adc levels_draw_tile_rightvarInteger_var81
levels_draw_tile_wordAdd79
	sta levels_draw_tile_rightvarInteger_var81
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var81+1
	tay
	lda levels_draw_tile_rightvarInteger_var81
	; Low bit binop:
	clc
	adc levels_draw_tile_rightvarInteger_var78
levels_draw_tile_wordAdd76
	sta levels_draw_tile_rightvarInteger_var78
	; High-bit binop
	tya
	adc levels_draw_tile_rightvarInteger_var78+1
	tay
	lda levels_draw_tile_rightvarInteger_var78
	sta levels_dest
	sty levels_dest+1
	; LineNumber: 41
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy82
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy82
	; LineNumber: 43
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd83
	inc levels_temp_s+1
levels_draw_tile_WordAdd83
	; LineNumber: 44
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd84
	inc levels_dest+1
levels_draw_tile_WordAdd84
	; LineNumber: 45
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy85
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy85
	; LineNumber: 47
	lda levels_dest
	clc
	adc levels_detected_screen_width
	sta levels_dest+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd86
	inc levels_dest+1
levels_draw_tile_WordAdd86
	; LineNumber: 48
	lda levels_temp_s
	clc
	adc #$03
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_draw_tile_WordAdd87
	inc levels_temp_s+1
levels_draw_tile_WordAdd87
	; LineNumber: 49
	; memcpyfast
	ldy #2
levels_draw_tile_memcpy88
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_draw_tile_memcpy88
	; LineNumber: 51
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_draw_level
	;    Procedure type : User-defined procedure
	; LineNumber: 59
levels_draw_level
	; LineNumber: 62
	
; // set to draw tiles
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_dest
	stx levels_dest+1
	; LineNumber: 63
	; Generic 16 bit op
	lda #<levels_level
	ldy #>levels_level
levels_draw_level_rightvarInteger_var92 = $54
	sta levels_draw_level_rightvarInteger_var92
	sty levels_draw_level_rightvarInteger_var92+1
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
	adc levels_draw_level_rightvarInteger_var92
levels_draw_level_wordAdd90
	sta levels_draw_level_rightvarInteger_var92
	; High-bit binop
	tya
	adc levels_draw_level_rightvarInteger_var92+1
	tay
	lda levels_draw_level_rightvarInteger_var92
	sta levels_level_p
	sty levels_level_p+1
	; LineNumber: 74
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_y
levels_draw_level_forloop93
	; LineNumber: 67
	; LineNumber: 72
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_t_x
levels_draw_level_forloop112
	; LineNumber: 69
	; LineNumber: 70
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
	; LineNumber: 71
	jsr levels_draw_tile
	; LineNumber: 72
levels_draw_level_forloopcounter114
levels_draw_level_loopstart115
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_x
	lda levels_tiles_across
	cmp levels_t_x ;keep
	bne levels_draw_level_forloop112
levels_draw_level_loopdone123: ;keep
levels_draw_level_forloopend113
levels_draw_level_loopend116
	; LineNumber: 73
levels_draw_level_forloopcounter95
levels_draw_level_loopstart96
	; Compare is onpage
	; Test Inc dec D
	inc levels_t_y
	lda #$6
	cmp levels_t_y ;keep
	bne levels_draw_level_forloop93
levels_draw_level_loopdone124: ;keep
levels_draw_level_forloopend94
levels_draw_level_loopend97
	; LineNumber: 76
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_refresh_screen
	;    Procedure type : User-defined procedure
	; LineNumber: 80
levels_refresh_screen
	; LineNumber: 82
	lda #<levels_screen_buffer
	ldx #>levels_screen_buffer
	sta levels_temp_s
	stx levels_temp_s+1
	; LineNumber: 91
	lda #$0
	; Calling storevariable on generic assign expression
	sta levels_r
levels_refresh_screen_forloop126
	; LineNumber: 87
	; LineNumber: 88
	
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
	; LineNumber: 89
	; memcpyfast
	ldy levels_detected_screen_width
	dey
levels_refresh_screen_memcpy135
	lda (levels_temp_s),y
	sta (levels_dest),y
	dey
	bpl levels_refresh_screen_memcpy135
	; LineNumber: 90
	lda levels_temp_s
	clc
	adc levels_detected_screen_width
	sta levels_temp_s+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc levels_refresh_screen_WordAdd136
	inc levels_temp_s+1
levels_refresh_screen_WordAdd136
	; LineNumber: 91
levels_refresh_screen_forloopcounter128
levels_refresh_screen_loopstart129
	; Compare is onpage
	; Test Inc dec D
	inc levels_r
	lda #$12
	cmp levels_r ;keep
	bne levels_refresh_screen_forloop126
levels_refresh_screen_loopdone137: ;keep
levels_refresh_screen_forloopend127
levels_refresh_screen_loopend130
	; LineNumber: 95
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_get_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 100
	; LineNumber: 99
levels_buf_x	dc.b	0
	; LineNumber: 99
levels_buf_y	dc.b	0
levels_get_buffer_block138
levels_get_buffer
	; LineNumber: 102
	; Generic 16 bit op
	ldy #0
	lda levels_buf_x
levels_get_buffer_rightvarInteger_var141 = $54
	sta levels_get_buffer_rightvarInteger_var141
	sty levels_get_buffer_rightvarInteger_var141+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_get_buffer_rightvarInteger_var144 = $56
	sta levels_get_buffer_rightvarInteger_var144
	sty levels_get_buffer_rightvarInteger_var144+1
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
	adc levels_get_buffer_rightvarInteger_var144
levels_get_buffer_wordAdd142
	sta levels_get_buffer_rightvarInteger_var144
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var144+1
	tay
	lda levels_get_buffer_rightvarInteger_var144
	; Low bit binop:
	clc
	adc levels_get_buffer_rightvarInteger_var141
levels_get_buffer_wordAdd139
	sta levels_get_buffer_rightvarInteger_var141
	; High-bit binop
	tya
	adc levels_get_buffer_rightvarInteger_var141+1
	tay
	lda levels_get_buffer_rightvarInteger_var141
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 104
	; LineNumber: 105
	; Load pointer array
	ldy #$0
	lda (levels_ch_index),y
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : levels_plot_buffer
	;    Procedure type : User-defined procedure
	; LineNumber: 110
	; LineNumber: 109
levels_plot_x	dc.b	0
	; LineNumber: 109
levels_plot_y	dc.b	0
	; LineNumber: 109
levels_plot_ch	dc.b	0
levels_plot_buffer_block145
levels_plot_buffer
	; LineNumber: 112
	; Generic 16 bit op
	ldy #0
	lda levels_plot_x
levels_plot_buffer_rightvarInteger_var148 = $54
	sta levels_plot_buffer_rightvarInteger_var148
	sty levels_plot_buffer_rightvarInteger_var148+1
	; Generic 16 bit op
	lda #<levels_screen_buffer
	ldy #>levels_screen_buffer
levels_plot_buffer_rightvarInteger_var151 = $56
	sta levels_plot_buffer_rightvarInteger_var151
	sty levels_plot_buffer_rightvarInteger_var151+1
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
	adc levels_plot_buffer_rightvarInteger_var151
levels_plot_buffer_wordAdd149
	sta levels_plot_buffer_rightvarInteger_var151
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var151+1
	tay
	lda levels_plot_buffer_rightvarInteger_var151
	; Low bit binop:
	clc
	adc levels_plot_buffer_rightvarInteger_var148
levels_plot_buffer_wordAdd146
	sta levels_plot_buffer_rightvarInteger_var148
	; High-bit binop
	tya
	adc levels_plot_buffer_rightvarInteger_var148+1
	tay
	lda levels_plot_buffer_rightvarInteger_var148
	sta levels_ch_index
	sty levels_ch_index+1
	; LineNumber: 113
	lda levels_plot_ch
	; Calling storevariable on generic assign expression
	; Storing to a pointer
	ldy #$0
	sta (levels_ch_index),y
	; LineNumber: 115
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
	lda #$20
	ldy #0
init_fill153
	sta (p),y
	iny
	cpy #$fa
	bne init_fill153
	; LineNumber: 89
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd154
	inc p+1
init_WordAdd154
	; LineNumber: 90
	lda #$20
	ldy #0
init_fill155
	sta (p),y
	iny
	cpy #$fa
	bne init_fill155
	; LineNumber: 92
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd156
	inc p+1
init_WordAdd156
	; LineNumber: 93
	lda #$20
	ldy #0
init_fill157
	sta (p),y
	iny
	cpy #$fa
	bne init_fill157
	; LineNumber: 95
	lda p
	clc
	adc #$fa
	sta p+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc init_WordAdd158
	inc p+1
init_WordAdd158
	; LineNumber: 96
	lda #$20
	ldy #0
init_fill159
	sta (p),y
	iny
	cpy #$fa
	bne init_fill159
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
	bne show_start_screen_localfailed184
	jmp show_start_screen_ConditionalTrueBlock162
show_start_screen_localfailed184
	jmp show_start_screen_elsedoneblock164
show_start_screen_ConditionalTrueBlock162: ;Main true block ;keep 
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
	lda #<show_start_screen_stringassignstr186
	sta txt_in_str
	lda #>show_start_screen_stringassignstr186
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
	lda #<show_start_screen_stringassignstr188
	sta txt_in_str
	lda #>show_start_screen_stringassignstr188
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
	lda #<show_start_screen_stringassignstr190
	sta txt_in_str
	lda #>show_start_screen_stringassignstr190
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
	lda #<show_start_screen_stringassignstr192
	sta txt_in_str
	lda #>show_start_screen_stringassignstr192
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
	lda #<show_start_screen_stringassignstr194
	sta txt_in_str
	lda #>show_start_screen_stringassignstr194
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
	lda #<show_start_screen_stringassignstr196
	sta txt_in_str
	lda #>show_start_screen_stringassignstr196
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
	lda #<show_start_screen_stringassignstr198
	sta txt_in_str
	lda #>show_start_screen_stringassignstr198
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
	lda #<show_start_screen_stringassignstr200
	sta txt_in_str
	lda #>show_start_screen_stringassignstr200
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
	lda #<show_start_screen_stringassignstr202
	sta txt_in_str
	lda #>show_start_screen_stringassignstr202
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 202
show_start_screen_elsedoneblock164
	; LineNumber: 209
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_start_screen_stringassignstr204
	sta txt_in_str
	lda #>show_start_screen_stringassignstr204
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
	beq show_end_screen_elseblock209
show_end_screen_ConditionalTrueBlock208: ;Main true block ;keep 
	; LineNumber: 226
	; LineNumber: 228
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr218
	sta txt_in_str
	lda #>show_end_screen_stringassignstr218
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 230
	jmp show_end_screen_elsedoneblock210
show_end_screen_elseblock209
	; LineNumber: 231
	; LineNumber: 232
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr221
	sta txt_in_str
	lda #>show_end_screen_stringassignstr221
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 233
show_end_screen_elsedoneblock210
	; LineNumber: 236
	
; // Wait for keypress
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr223
	sta txt_in_str
	lda #>show_end_screen_stringassignstr223
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 240
	; Assigning a string : txt_in_str
	lda #<show_end_screen_stringassignstr225
	sta txt_in_str
	lda #>show_end_screen_stringassignstr225
	sta txt_in_str+1
	lda #$1
	; Calling storevariable on generic assign expression
	sta txt_CRLF
	lda levels_detected_screen_width
	; Calling storevariable on generic assign expression
	sta txt__sc_w
	jsr txt_print_string_centered
	; LineNumber: 244
	jsr txt_wait_key
	; LineNumber: 247
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : update_status
	;    Procedure type : User-defined procedure
	; LineNumber: 297
	; LineNumber: 296
update_status_block227
update_status
	; LineNumber: 302
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : door
	;    Procedure type : User-defined procedure
	; LineNumber: 306
door
	; LineNumber: 309
	; Optimization: replacing a > N with a >= N+1
	; Binary clause Simplified: GREATEREQUAL
	lda keys
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc door_localfailed281
	jmp door_ConditionalTrueBlock230
door_localfailed281
	jmp door_elseblock231
door_ConditionalTrueBlock230: ;Main true block ;keep 
	; LineNumber: 310
	; LineNumber: 311
	
; // Check if have a key		
	; Test Inc dec D
	dec keys
	; LineNumber: 312
	; Assigning a string : new_status
	lda #<door_stringassignstr283
	sta new_status
	lda #>door_stringassignstr283
	sta new_status+1
	jsr update_status
	; LineNumber: 314
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock288
door_ConditionalTrueBlock286: ;Main true block ;keep 
	; LineNumber: 313
	; Assigning a string : new_status
	lda #<door_stringassignstr293
	sta new_status
	lda #>door_stringassignstr293
	sta new_status+1
	jsr update_status
door_elsedoneblock288
	; LineNumber: 315
	; Binary clause Simplified: EQUALS
	lda x
	; Compare with pure num / var optimization
	cmp #$1e;keep
	bne door_elsedoneblock298
door_ConditionalTrueBlock296: ;Main true block ;keep 
	; LineNumber: 314
	; Assigning a string : new_status
	lda #<door_stringassignstr303
	sta new_status
	lda #>door_stringassignstr303
	sta new_status+1
	jsr update_status
door_elsedoneblock298
	; LineNumber: 316
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$0;keep
	bne door_elsedoneblock308
door_ConditionalTrueBlock306: ;Main true block ;keep 
	; LineNumber: 315
	; Assigning a string : new_status
	lda #<door_stringassignstr313
	sta new_status
	lda #>door_stringassignstr313
	sta new_status+1
	jsr update_status
door_elsedoneblock308
	; LineNumber: 317
	; Binary clause Simplified: EQUALS
	lda y
	; Compare with pure num / var optimization
	cmp #$11;keep
	bne door_elsedoneblock318
door_ConditionalTrueBlock316: ;Main true block ;keep 
	; LineNumber: 318
	; LineNumber: 319
	; Assigning a string : new_status
	lda #<door_stringassignstr324
	sta new_status
	lda #>door_stringassignstr324
	sta new_status+1
	jsr update_status
	; LineNumber: 320
	lda levels_current_level
	clc
	adc #$01
	sta levels_current_level+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc door_WordAdd326
	inc levels_current_level+1
door_WordAdd326
	; LineNumber: 321
	; Test Inc dec D
	dec y
	; LineNumber: 322
	jsr levels_draw_level
	; LineNumber: 323
door_elsedoneblock318
	; LineNumber: 325
	jmp door_elsedoneblock232
door_elseblock231
	; LineNumber: 326
	; LineNumber: 327
	; Assigning a string : new_status
	lda #<door_stringassignstr328
	sta new_status
	lda #>door_stringassignstr328
	sta new_status+1
	jsr update_status
	; LineNumber: 330
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 331
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 332
door_elsedoneblock232
	; LineNumber: 334
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : combat
	;    Procedure type : User-defined procedure
	; LineNumber: 338
combat
	; LineNumber: 341
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
	bcc combat_elseblock333
combat_ConditionalTrueBlock332: ;Main true block ;keep 
	; LineNumber: 342
	; LineNumber: 343
	; Assigning a string : new_status
	lda #<combat_stringassignstr350
	sta new_status
	lda #>combat_stringassignstr350
	sta new_status+1
	jsr update_status
	; LineNumber: 344
	jmp combat_elsedoneblock334
combat_elseblock333
	; LineNumber: 346
	; LineNumber: 348
	; Test Inc dec D
	dec health
	; LineNumber: 351
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 352
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 354
	; Assigning a string : new_status
	lda #<combat_stringassignstr353
	sta new_status
	lda #>combat_stringassignstr353
	sta new_status+1
	jsr update_status
	; LineNumber: 356
	; Binary clause Simplified: LESSEQUAL
	lda health
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq combat_ConditionalTrueBlock356
	bcs combat_elsedoneblock358
combat_ConditionalTrueBlock356: ;Main true block ;keep 
	; LineNumber: 357
	; LineNumber: 358
	lda #$0
	; Calling storevariable on generic assign expression
	sta game_won
	; LineNumber: 359
	; Calling storevariable on generic assign expression
	sta game_running
	; LineNumber: 360
combat_elsedoneblock358
	; LineNumber: 362
combat_elsedoneblock334
	; LineNumber: 364
	rts
	; NodeProcedureDecl -1
	; ***********  Defining procedure : check_collisions
	;    Procedure type : User-defined procedure
	; LineNumber: 368
check_collisions
	; LineNumber: 371
	lda #$2a
	cmp charat ;keep
	bne check_collisions_casenext363
	; LineNumber: 375
	; LineNumber: 377
	
; // Gazer
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr365
	sta new_status
	lda #>check_collisions_stringassignstr365
	sta new_status+1
	jsr update_status
	; LineNumber: 378
	jsr combat
	; LineNumber: 380
	jmp check_collisions_caseend362
check_collisions_casenext363
	lda #$58
	cmp charat ;keep
	bne check_collisions_casenext367
	; LineNumber: 383
	; LineNumber: 384
	
; // Artifact
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr369
	sta new_status
	lda #>check_collisions_stringassignstr369
	sta new_status+1
	jsr update_status
	; LineNumber: 385
	jmp check_collisions_caseend362
check_collisions_casenext367
	lda #$43
	cmp charat ;keep
	bne check_collisions_casenext371
	; LineNumber: 386
	jsr door
	jmp check_collisions_caseend362
check_collisions_casenext371
	lda #$4b
	cmp charat ;keep
	bne check_collisions_casenext373
	; LineNumber: 389
	; LineNumber: 391
	
; // Key
	; Test Inc dec D
	inc keys
	; LineNumber: 392
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr375
	sta new_status
	lda #>check_collisions_stringassignstr375
	sta new_status+1
	jsr update_status
	; LineNumber: 393
	jmp check_collisions_caseend362
check_collisions_casenext373
	lda #$53
	cmp charat ;keep
	bne check_collisions_casenext377
	; LineNumber: 397
	; LineNumber: 398
	
; // Health potion
	; Test Inc dec D
	inc health
	; LineNumber: 399
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr379
	sta new_status
	lda #>check_collisions_stringassignstr379
	sta new_status+1
	jsr update_status
	; LineNumber: 401
	jmp check_collisions_caseend362
check_collisions_casenext377
	lda #$57
	cmp charat ;keep
	bne check_collisions_casenext381
	; LineNumber: 403
	; LineNumber: 406
	
; // Gobbo
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr383
	sta new_status
	lda #>check_collisions_stringassignstr383
	sta new_status+1
	jsr update_status
	; LineNumber: 407
	jsr combat
	; LineNumber: 408
	jmp check_collisions_caseend362
check_collisions_casenext381
	lda #$5a
	cmp charat ;keep
	bne check_collisions_casenext385
	; LineNumber: 411
	; LineNumber: 412
	
; // Jewell
	lda gold
	clc
	adc #$64
	sta gold+0
	; Optimization : A := A op 8 bit - var and bvar are the same - perform inc
	bcc check_collisions_WordAdd387
	inc gold+1
check_collisions_WordAdd387
	; LineNumber: 413
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr388
	sta new_status
	lda #>check_collisions_stringassignstr388
	sta new_status+1
	jsr update_status
	; LineNumber: 415
	jmp check_collisions_caseend362
check_collisions_casenext385
	lda #$5e
	cmp charat ;keep
	bne check_collisions_casenext390
	; LineNumber: 418
	; LineNumber: 420
	
; // Rat
	; Assigning a string : new_status
	lda #<check_collisions_stringassignstr392
	sta new_status
	lda #>check_collisions_stringassignstr392
	sta new_status+1
	jsr update_status
	; LineNumber: 421
	jsr combat
	; LineNumber: 423
	jmp check_collisions_caseend362
check_collisions_casenext390
	lda player_char
	cmp charat ;keep
	bne check_collisions_casenext394
	; LineNumber: 427
	; LineNumber: 429
	jmp check_collisions_caseend362
check_collisions_casenext394
	; LineNumber: 433
	; LineNumber: 436
	
; // Reset to backup position
	lda oldx
	; Calling storevariable on generic assign expression
	sta x
	; LineNumber: 437
	lda oldy
	; Calling storevariable on generic assign expression
	sta y
	; LineNumber: 446
check_collisions_caseend362
	; LineNumber: 449
	rts
block1
	; LineNumber: 455
	
; // Unknown
; // ********************************
	lda #$28
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 477
	
; // C64 has it's own special characters
; // Borked, will need some work
	lda #$1e
	; Calling storevariable on generic assign expression
	sta levels_detected_screen_width
	; LineNumber: 478
	jsr txt_cursor_off
	; LineNumber: 479
	lda #$20
	; Calling storevariable on generic assign expression
	sta player_char
	; LineNumber: 480
	lda #$0
	; Calling storevariable on generic assign expression
	sta space_char
	; LineNumber: 481
	; Calling storevariable on generic assign expression
	sta txt__text_x
	; Calling storevariable on generic assign expression
	sta txt__text_y
	jsr txt_move_to
	; LineNumber: 487
MainProgram_while397
MainProgram_loopstart401
	; Binary clause Simplified: NOTEQUALS
	lda #$1
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed515
	jmp MainProgram_ConditionalTrueBlock398
MainProgram_localfailed515
	jmp MainProgram_elsedoneblock400
MainProgram_ConditionalTrueBlock398: ;Main true block ;keep 
	; LineNumber: 487
	; LineNumber: 492
	
; // Infinite loop
; // Show start screen
; // *****************
	jsr show_start_screen
	; LineNumber: 496
	
; // Initial screen fill
; // and(re)set variables
	jsr init
	; LineNumber: 504
MainProgram_while517
MainProgram_loopstart521
	; Binary clause Simplified: NOTEQUALS
	lda game_running
	; Compare with pure num / var optimization
	cmp #$0;keep
	beq MainProgram_localfailed575
	jmp MainProgram_ConditionalTrueBlock518
MainProgram_localfailed575
	jmp MainProgram_elsedoneblock520
MainProgram_ConditionalTrueBlock518: ;Main true block ;keep 
	; LineNumber: 505
	; LineNumber: 510
	
; // Main loop
; // Backup the current position			
	lda x
	; Calling storevariable on generic assign expression
	sta oldx
	; LineNumber: 511
	lda y
	; Calling storevariable on generic assign expression
	sta oldy
	; LineNumber: 514
	
; // Get keyboard input
	jsr txt_get_key
	; Calling storevariable on generic assign expression
	sta key_press
	; LineNumber: 517
	lda #$1c
	cmp key_press ;keep
	bne MainProgram_casenext578
	; LineNumber: 519
	; Binary clause Simplified: GREATEREQUAL
	lda y
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock583
MainProgram_ConditionalTrueBlock581: ;Main true block ;keep 
	; LineNumber: 519
	
; // Check the pressed key
; // Cursor keys defined in unit		        
	; Test Inc dec D
	dec y
MainProgram_elsedoneblock583
	jmp MainProgram_caseend577
MainProgram_casenext578
	lda #$1d
	cmp key_press ;keep
	bne MainProgram_casenext586
	; LineNumber: 520
	; Binary clause Simplified: LESS
	lda y
	; Compare with pure num / var optimization
	cmp #$17;keep
	bcs MainProgram_elsedoneblock591
MainProgram_ConditionalTrueBlock589: ;Main true block ;keep 
	; LineNumber: 520
	; Test Inc dec D
	inc y
MainProgram_elsedoneblock591
	jmp MainProgram_caseend577
MainProgram_casenext586
	lda #$1e
	cmp key_press ;keep
	bne MainProgram_casenext594
	; LineNumber: 521
	; Binary clause Simplified: GREATEREQUAL
	lda x
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock599
MainProgram_ConditionalTrueBlock597: ;Main true block ;keep 
	; LineNumber: 521
	; Test Inc dec D
	dec x
MainProgram_elsedoneblock599
	jmp MainProgram_caseend577
MainProgram_casenext594
	lda #$1f
	cmp key_press ;keep
	bne MainProgram_casenext602
	; LineNumber: 522
	; Binary clause Simplified: LESS
	lda x
	; Compare with pure num / var optimization
	cmp #$27;keep
	bcs MainProgram_elsedoneblock607
MainProgram_ConditionalTrueBlock605: ;Main true block ;keep 
	; LineNumber: 522
	; Test Inc dec D
	inc x
MainProgram_elsedoneblock607
MainProgram_casenext602
MainProgram_caseend577
	; LineNumber: 530
	
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
	; LineNumber: 534
	; Binary clause Simplified: NOTEQUALS
	; Compare with pure num / var optimization
	cmp space_char;keep
	beq MainProgram_elsedoneblock613
MainProgram_ConditionalTrueBlock611: ;Main true block ;keep 
	; LineNumber: 535
	; LineNumber: 538
	; Binary clause Simplified: GREATEREQUAL
	lda charat
	; Compare with pure num / var optimization
	cmp #$1;keep
	bcc MainProgram_elsedoneblock625
MainProgram_ConditionalTrueBlock623: ;Main true block ;keep 
	; LineNumber: 537
	
; // $20 is space
; // Tile isn't empty so check what should happen
	jsr check_collisions
MainProgram_elsedoneblock625
	; LineNumber: 542
MainProgram_elsedoneblock613
	; LineNumber: 548
	
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
	; LineNumber: 552
	
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
	; LineNumber: 556
	
; // Update screen from the buffer
	jsr levels_refresh_screen
	; LineNumber: 558
	jmp MainProgram_while517
MainProgram_elsedoneblock520
MainProgram_loopend522
	; LineNumber: 562
	
; // Show end screen
	jsr show_end_screen
	; LineNumber: 565
	jmp MainProgram_while397
MainProgram_elsedoneblock400
MainProgram_loopend402
	; LineNumber: 567
	; End of program
	; Ending memory block
EndBlocka000
show_start_screen_stringassignstr166		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr168		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr170		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr172		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr174		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr176		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr178		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr180		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr182		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr186		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr188		dc.b	"DUNGEON OF COMMODORE"
	dc.b	0
show_start_screen_stringassignstr190		dc.b	"A DUNGEON CRAWL"
	dc.b	0
show_start_screen_stringassignstr192		dc.b	"FOR PET AND C64"
	dc.b	0
show_start_screen_stringassignstr194		dc.b	"dddddddddddddd"
	dc.b	0
show_start_screen_stringassignstr196		dc.b	"CHRIS GARRETT"
	dc.b	0
show_start_screen_stringassignstr198		dc.b	"BUILT WITH TRSE"
	dc.b	0
show_start_screen_stringassignstr200		dc.b	"eeeeeeeeeeeeeeeee"
	dc.b	0
show_start_screen_stringassignstr202		dc.b	"rrrrrrrrrrrrrrrrr"
	dc.b	0
show_start_screen_stringassignstr204		dc.b	"PRESS A KEY"
	dc.b	0
show_end_screen_stringassignstr212		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr215		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr218		dc.b	"YAY YOU WON!"
	dc.b	0
show_end_screen_stringassignstr221		dc.b	"EEK YOU DIED!"
	dc.b	0
show_end_screen_stringassignstr223		dc.b	" "
	dc.b	0
show_end_screen_stringassignstr225		dc.b	"PRESS A KEY TO CONTINUE"
	dc.b	0
door_stringassignstr234		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr241		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr244		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr251		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr254		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr261		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr264		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr271		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr275		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr279		dc.b	"YOU NEED A KEY!"
	dc.b	0
door_stringassignstr283		dc.b	"KEY USED!"
	dc.b	0
door_stringassignstr290		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr293		dc.b	"KEY USED! W"
	dc.b	0
door_stringassignstr300		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr303		dc.b	"KEY USED! E"
	dc.b	0
door_stringassignstr310		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr313		dc.b	"KEY USED! N"
	dc.b	0
door_stringassignstr320		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr324		dc.b	"KEY USED! S"
	dc.b	0
door_stringassignstr328		dc.b	"YOU NEED A KEY!"
	dc.b	0
combat_stringassignstr336		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr339		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
combat_stringassignstr350		dc.b	"YOU WON THIS FIGHT"
	dc.b	0
combat_stringassignstr353		dc.b	"YOU LOST THIS FIGHT"
	dc.b	0
check_collisions_stringassignstr365		dc.b	"GAZER ATTACKS!"
	dc.b	0
check_collisions_stringassignstr369		dc.b	"ARTIFACT!"
	dc.b	0
check_collisions_stringassignstr375		dc.b	"KEY ACQUIRED"
	dc.b	0
check_collisions_stringassignstr379		dc.b	"AHH THAT'S BETTER!"
	dc.b	0
check_collisions_stringassignstr383		dc.b	"GOBBO ATTACKS!"
	dc.b	0
check_collisions_stringassignstr388		dc.b	"KA-CHING!"
	dc.b	0
check_collisions_stringassignstr392		dc.b	"RAT ATTACKS!"
	dc.b	0
