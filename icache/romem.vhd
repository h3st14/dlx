library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.cachepkg.all;

-- Instruction memory for DLX
-- Memory filled by a process which reads from a file
-- file name is "test.asm.mem"
entity ROMEM is
	generic (
		ENTRIES		: integer := 48;
		WORD_SIZE	: integer := 32
	);
	port (
		CLK					: in std_logic;
		RST					: in std_logic;
		ADDRESS				: in std_logic_vector(WORD_SIZE - 1 downto 0);
		ENABLE				: in std_logic;
		DATA_READY			: out std_logic;
		DATA				: out std_logic_vector(2*WORD_SIZE - 1 downto 0)
	);
end ROMEM;

architecture Behavioral of ROMEM is
	type RAM is array (0 to ENTRIES-1) of integer;
	signal Memory : RAM;
	signal valid : std_logic;
	signal idout : std_logic_vector(2*WORD_SIZE-1 downto 0);

begin

	-- purpose: This process is in charge of filling the Instruction RAM with the firmware
	FILL_MEM_P: process (RST)
		file mem_fp: text;
		variable file_line : line;
		variable index : integer := 0;
		variable tmp_data_u : std_logic_vector(WORD_SIZE-1 downto 0);
	begin  -- process FILL_MEM_P
		if (Rst = '1') then
			file_open(
				mem_fp,
				"/home/gandalf/Documents/Universita/Postgrad/Modules/Microelectronic/dlx/icache/hex.txt",
				READ_MODE
			);

			while (not endfile(mem_fp)) loop
				readline(mem_fp,file_line);
				hread(file_line,tmp_data_u);
				Memory(index) <= conv_integer(unsigned(tmp_data_u));
				index := index + 1;
			end loop;
		end if;
	end process FILL_MEM_P;

	-- IRAM
	manager : process
	begin
		wait until clk'event and clk = '1';
		valid <= '0';

		if rst = '1' then
			valid <= '0';
		elsif ENABLE = '1' then

			-- Simulate access + read time
			wait until clk'event and clk = '1';
			wait until clk'event and clk = '1';

			-- I gots the data ready!
			valid <= '1';
			idout <=
				conv_std_logic_vector(Memory(conv_integer(unsigned(ADDRESS))+1),WORD_SIZE) &
				conv_std_logic_vector(Memory(conv_integer(unsigned(ADDRESS))),WORD_SIZE
			);
		end if;
	end process;

	DATA_READY <= valid;
	DATA <= idout when valid = '1' else (others => 'Z');
end Behavioral;
