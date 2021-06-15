

	
	procedure init();
	var
		
	begin
		
		// Initialise start position
		x:=5;
		y:=5;	


		// Clean the screen buffer		
		p:=#levels::screen_buffer;
		fill(p,space_char,250);
		
		p:=p+250;
		fill(p,space_char,250);
		
		p:=p+250;
		fill(p,space_char,250);
		
		p:=p+250;
		fill(p,space_char,250);
		
		// Initialise player inventory
		keys:=0;
		
		levels::tiles_across:=10;
		
		
	@ifdef BBCM

		p:=#levels::screen_buffer;
		fori i:= 0 to 18 do
		begin
			levels::b_tab[i]:=p;
			p:=p+40;			
		end;	

	@endif	
		

	@ifdef VIC20
		levels::tiles_across:=7;
	@endif	
		// Clear screen,
		txt::cls();

		game_won:=false;
		game_running:=true;

		// Draw current level
		levels::current_level:=0;
		levels::draw_level();
		
		// Draw the player
		levels::plot_buffer(x,y, player_char);
		
		// Update the screen from the buffer
		levels::refresh_screen();
	end;
	
	@ifdef C64
		procedure c64_chars();
		var
			dest,temp_s:pointer;
		begin
			
			// Set to use the new characterset
			setbank(vic_bank1);
			setcharsetlocation($6000);
			
			// Force the screen address
			txt::temp_address_p:=$4400;
			
			// Tells basic routines where screen memory is located
			poke(^648,0,68);
		
			// Clear screen,
			txt::cls();
		
			// Black screen
			poke(^53280,0,0);
			poke(^53281,0,0);
			
			
			// Ensure no flashing cursor
			txt::cursor_off();
		
		end;
	@endif
	
	@ifdef VIC20
		procedure vic20_chars();
		var
	
		begin
			// Force the screen address
			txt::temp_address_p:=$1000;
			poke(^36879,0,8);
			
			// Clear screen,
			txt::cls();
	
			
		end;
	@endif






	procedure show_start_screen();
	begin

		txt::cls();
		if (game_running=false) then 
		begin
			//                         01234567890123456789012
			// Text colour to green:
				txt::put_ch(30);	
			txt::put_ch(13);
			txt::print_string_centered("dddddddddddddd", true, levels::detected_screen_width);	
			txt::put_ch(13);	
			txt::print_string_centered("DUNGEON OF COMMODORE", true, levels::detected_screen_width);				
			txt::print_string_centered("A DUNGEON CRAWL", true, levels::detected_screen_width);
			txt::print_string_centered("FOR PET AND C64", true, levels::detected_screen_width);	
			txt::put_ch(13);		
			txt::print_string_centered("dddddddddddddd", true, levels::detected_screen_width);	
			txt::put_ch(13);
			txt::print_string_centered("CHRIS GARRETT", true, levels::detected_screen_width);		
				//txt::print_string_centered("(C)2021", true, levels::detected_screen_width);	
			txt::put_ch(13);
			txt::print_string_centered("BUILT WITH TRSE", true, levels::detected_screen_width);
			txt::put_ch(13);		
			txt::print_string_centered("eeeeeeeeeeeeeeeee", true, levels::detected_screen_width);	
				//txt::print_string_centered("@ = YOU k = KEY", true, levels::detected_screen_width);
				//txt::print_string_centered("s = HEALTH c = DOOR", true, levels::detected_screen_width);
				//txt::print_string_centered("z = GEM x = ARTIFACT", true, levels::detected_screen_width);	
			txt::print_string_centered("rrrrrrrrrrrrrrrrr", true, levels::detected_screen_width);	
		end;

		// Wait for keypress
		@ifndef ATARI800
			txt::put_ch(13);
			txt::put_ch(18);
		@endif
		txt::print_string_centered("PRESS A KEY", false, levels::detected_screen_width);
		txt::print_space(txt::max_digits);
		@ifndef ATARI800
			txt::put_ch(13);
			txt::put_ch(146);
		@endif
		txt::wait_key();


	end;



	procedure show_end_screen();
	begin

		txt::cls();
		if (game_won) then 
		begin	
			txt::print_string_centered("YAY YOU WON!", true, levels::detected_screen_width);
		end
		else
		begin
			txt::print_string_centered("EEK YOU DIED!", true, levels::detected_screen_width);
		end;

		// Wait for keypress
		txt::print_string_centered(" ", true, levels::detected_screen_width);
		@ifndef ATARI800	 
			txt::put_ch(18); 
		@endif
		txt::print_string_centered("PRESS A KEY TO CONTINUE", true, levels::detected_screen_width);
		@ifndef 
			ATARI800	txt::put_ch(146); 
		@endif
		txt::wait_key();


	end;


@ifndef ATARI800		
	procedure display_text();
	begin

		txt::put_ch(18);
		txt::move_to(0,19);
		txt::print_string("                    ", false);
		txt::move_to(0,19);
		txt::print_string(the_status, false);
		txt::put_ch(146);
		
		txt::move_to(5,20);
		txt::put_ch(203);
		txt::put_ch(32);	
		txt::print_dec(keys, false);
				
		txt::move_to(15,20);
		txt::put_ch(122);
		txt::put_ch(32);	
		txt::print_dec(gold, false);
		

		txt::move_to(5,21);
		txt::put_ch(18);
		txt::put_ch(211);
		txt::put_ch(146);
		txt::put_ch(32);	
		txt::print_dec(health, false);
	
		
		txt::move_to(15,21);
		txt::put_ch(118);
		txt::put_ch(32);	
		txt::print_dec(attack, false);
		
		
		txt::move_to(5,22);
		txt::put_ch(18);
		txt::put_ch(214);
		txt::put_ch(146);
		txt::put_ch(32);		
		txt::print_dec(defense, false);
		
	end;


	procedure update_status(new_status: global pointer);
	begin
			the_status:=new_status;
			display_text();

	end;


	procedure door();
	begin

		// Check if have a key		
		if(keys>0) then 
		begin
			dec(keys);
			update_status("KEY USED!");
			
			if(x=0) then update_status("KEY USED! W");
			if(x=30) then update_status("KEY USED! E");
			if(y=0) then update_status("KEY USED! N");
			if(y=17) then 
			begin
				update_status("KEY USED! S");
				inc(levels::current_level);
				dec(y);
				levels::draw_level();
			end;
		end
		else
		begin
			update_status("YOU NEED A KEY!");
			
			// Reset to backup position
			x:=oldx;
			y:=oldy;	
		end;
		
	end;		


	procedure combat();
	begin
	
		
		if((random()/12)>10) then
		begin
			update_status("YOU WON THIS FIGHT");
		end		
		else
		begin
			
			dec(health);
	
			// Reset to backup position
			x:=oldx;
			y:=oldy;		
			
			update_status("YOU LOST THIS FIGHT");
			
			if(health<=0) then 
			begin
				game_won:=false;
				game_running:=false;
			end;
			
		end;
			
	end;

	
@endif
	
	procedure check_collisions();
	begin
		

		case charat of	


			42: // Gazer
				begin
					
					update_status("GAZER ATTACKS!"); 
					combat();
	
				end;

			$58: // Artifact
				begin
					update_status("ARTIFACT!");
				end;

			$43:
				begin  
					door();
				end;

			75: // Key
				begin 
					inc(keys);
					update_status("KEY ACQUIRED");
			 	end;
			 				
			
			83: // Health potion
				begin
					health:=health+1;
					update_status("AHH THAT'S BETTER!");

				end;	
				
			87: // Gobbo
				begin				
					
					update_status("GOBBO ATTACKS!");
					combat();
				end;			
		
			90: // Jewell
				begin
					gold:=gold+100;
					update_status("KA-CHING!");

				end;		
		
			94: // Rat
				begin
					
					update_status("RAT ATTACKS!"); 
					combat();
	
				end;
		

		 	player_char: 
		 		begin

		 		end;

		 
		else
		begin
			
				// Reset to backup position
				x:=oldx;
				y:=oldy;		
				
			
				// Unknown
				_A:=charat;
				update_status("EXISTING TILE:");
				txt::move_to(15,19);
				txt::print_dec(charat, false);
			
		end;
			
		
	end;
