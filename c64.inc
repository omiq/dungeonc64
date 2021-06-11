

	// Custom characterset

	zeronine: array[80] of byte = (
	056,068,130,130,130,068,056,000,
	048,080,144,016,016,016,254,000,
	124,130,002,124,128,130,254,000,
	254,132,008,028,130,130,124,000,
	012,024,040,074,254,010,028,000,
	254,130,252,002,130,130,124,000,
	124,130,128,252,130,130,124,000,
	254,132,008,008,016,016,056,000,
	124,130,130,124,130,130,124,000,
	124,130,130,130,124,004,120,000
	);
	
	custom: array[4*8] of byte = (
	,000,126,000,060,000,024,000,000 // rem character 60
	,239,138,012,000,254,170,128,000 // rem character 61
	,000,000,024,000,060,000,126,000 // rem character 62
	,000,060,126,254,122,126,254,126 // rem door char
	);
		
		
	alpha: array[27*8] of byte = (
		
	 092,087,233,089,057,030,020,054 // rem character 0
	,016,040,040,068,124,068,238,000 // rem character 1
	,252,066,066,124,066,066,252,000 // rem character 2
	,056,068,130,128,130,068,056,000 // rem character 3
	,252,066,066,066,066,066,252,000 // rem character 4
	,254,066,072,120,072,066,254,000 // rem character 5
	,254,066,072,120,072,064,224,000 // rem character 6
	,060,066,128,142,130,066,060,000 // rem character 7
	,238,068,124,068,068,068,238,000 // rem character 8
	,254,016,016,016,016,016,254,000 // rem character 9
	,124,016,016,016,144,144,096,000 // rem character 10
	,238,068,072,112,072,068,238,000 // rem character 11
	,224,064,064,064,066,066,254,000 // rem character 12
	,238,084,084,084,068,068,238,000 // rem character 13
	,238,100,084,084,076,076,228,000 // rem character 14
	,056,068,130,130,130,068,056,000 // rem character 15
	,252,066,066,066,124,064,224,000 // rem character 16
	,056,068,130,130,146,076,058,000 // rem character 17
	,252,066,066,066,124,072,238,000 // rem character 18
	,124,130,128,124,002,130,124,000 // rem character 19
	,254,146,016,016,016,016,056,000 // rem character 20
	,238,068,068,068,068,068,056,000 // rem character 21
	,238,068,068,040,040,040,016,000 // rem character 22
	,238,068,068,084,084,108,068,000 // rem character 23
	,238,068,040,016,040,068,238,000 // rem character 24
	,238,068,040,040,016,016,056,000 // rem character 25
	,254,132,008,016,032,066,254,000 // rem character 26
	);


	procedure c64_chars();
	var
		dest,temp_s:pointer;
	begin
		// Set to use the new characterset
		CopyCharsetFromRom(^$3000);
		SetCharsetLocation(^$3000); 
	
		// Destination address
		dest:=$3000;
		temp_s:=#alpha;
		MemCpy(temp_s, 0, dest,27*8);
	 		
		// Copy selected 0-9 bytes
		dest:=$3000+(48*8);	
		temp_s:=#zeronine;
		MemCpyFast(temp_s, 0, dest,10*8);
	
		// Copy char 48 bytes
		dest:=$3000+(44*8);	
		temp_s:=#custom[0];
		MemCpyFast(temp_s, 0, dest,8);
	
		// Copy remaining 4 custom char bytes
		dest:=$3000+(60*8);	
		temp_s:=#custom[0];
		MemCpyFast(temp_s, 0, dest,8*3);
		dest:=$3000+(35*8);
		temp_s:=#custom[8*3];
		MemCpyFast(temp_s, 0, dest,8);
		
		// Clear screen,
		txt::cls();
	
		// Black screen
		poke(^53280,0,0);
		poke(^53281,0,0);
		
		// Forecolour to white for now
		ClearScreen(1,^$D800);
		
		// Ensure no flashing cursor
		txt::cursor_off();
	
	end;
	