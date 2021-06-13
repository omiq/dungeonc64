

	
	procedure init();
	begin
		
		// Initialise start position
		x:=5;
		y:=5;	
		
		// Initialise player inventory
		keys:=0;
		
		// Clear screen,
		txt::cls();

		game_won:=false;
		game_running:=true;

		// Draw current level
		levels::current_level:=1;
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


	procedure show_start_screen();
	begin

		txt::cls();
		if (game_running=false) then 
		begin
			// Text colour to green:
			txt::put_ch(30);	
			txt::print_string("DUNGEON CRAWL GAME FOR COMMODORES",true);
		end;

		//txt::wait_key();


	end;



	procedure show_end_screen();
	begin

		txt::cls();
		if (game_won) then 
		begin	
			txt::print_string("YAY YOU WON!",true);
		end
		else
		begin
			txt::print_string("EEK YOU DIED!",true);
		end;

		txt::wait_key();


	end;
	
	procedure display_text();
	begin
	
		txt::put_ch(18);
		txt::move_to(0,21);
		txt::print_string("                    ", false);
		txt::move_to(0,21);
		txt::print_string(the_status, false);
		txt::put_ch(146);
		
		txt::move_to(25,22);
		txt::put_ch(75);
		txt::put_ch(32);	
		txt::print_dec(keys, false);
		
		txt::move_to(25,23);
		txt::put_ch(122);
		txt::put_ch(32);	
		txt::print_dec(gold, false);
		
		
		txt::move_to(33,21);
		txt::put_ch(18);
		txt::put_ch(211);
		txt::put_ch(146);
		txt::put_ch(32);	
		txt::print_dec(health, false);
	
		
		txt::move_to(33,22);
		txt::put_ch(118);
		txt::put_ch(32);	
		txt::print_dec(attack, false);
		
		
		txt::move_to(33,23);
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
		end
		else
		begin
			update_status("YOU NEED A KEY!");
			
			// Reset to backup position
			x:=oldx;
			y:=oldy;	
		end;
		
	end;		

	
	procedure check_collisions();
	begin
		

		case charat of	

			$0B: // Key
				begin 
					inc(keys);
					update_status("KEY ACQUIRED");
			 	end;

			$58: // Artifact
				begin
					update_status("ARTIFACT!");
				end;

			$5D: door();
			$43: door();
			
			90: // Jewell
				begin
					gold:=gold+100;
					update_status("KA-CHING!");

				end;		

			
			83: // Health potion
				begin
					health:=health+1;
					update_status("AHH THAT'S BETTER!");

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
				txt::move_to(15,21);
				txt::print_dec(charat, false);
			
		end;
			
		
	end;