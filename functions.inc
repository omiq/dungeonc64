	procedure show_start_screen();
	begin

		txt::cls();
		if (game_running=false) then 
		begin	
			txt::print_string("DUNGEON CRAWL GAME FOR COMMODORES",true);
		end;

		txt::wait_key();


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


	procedure door();
	begin

		// Check if have a key		
		if(keys>0) then 
		begin
			dec(keys);
			txt::print_string("KEY USED!                ",true);
		end
		else
		begin
			
			txt::print_string("YOU NEED A KEY!          ",true);
			
			// Reset to backup position
			x:=oldx;
			y:=oldy;	
		end;
		
	end;		

	
	procedure check_collisions();
	begin
		
		txt::move_to(0,21);
		case charat of	

			$0B: // Key
				begin 
					inc(keys);
					txt::print_string("KEY!              ",true);
			 	end;

			$58: // Artifact
				begin
					txt::print_string("ARTIFACT!         ",true);
				end;

			$5D: door();
			$43: door();
		

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
				txt::print_string("EXISTING TILE:       ", false);
				txt::move_to(15,21);
				txt::print_dec(charat, false);
			
		end;
			
		
	end;