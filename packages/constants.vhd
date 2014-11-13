package CONSTANTS is
	constant WORD_SIZE :		integer := 32;

	-- WRF
	constant wrfNumBit :				integer	:= 32;	-- numBit;
	constant wrfNumWindows :			integer := 8;	-- numWindows;
	constant wrfNumRegsPerWin :			integer := 8;	-- numRegsPerWin;
	constant wrfLogNumWindows :			integer := 3;	-- numWindows;
	constant wrfLogNumRegsPerWin :		integer := 3;	-- LOG(numRegsPerWin)
end CONSTANTS;
