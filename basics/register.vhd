library IEEE;
use IEEE.std_logic_1164.all;

-- Flipflop-based N-bit register

entity REGISTER_FD is
	generic (
		N: integer := 1
	);
	port (
		DIN:	in	std_logic_vector(N-1 downto 0);		-- Data in
		CLK:	in	std_logic;							-- Clock
		RESET:	in	std_logic;							-- Reset
		DOUT:	out	std_logic_vector(N-1 downto 0)		-- Data out
	);
end REGISTER_FD;

-- Architectures

architecture ASYNCHRONOUS of REGISTER_FD is
	component FLIPFLOP
		port (
			D:		in	std_logic;
			CK:		in	std_logic;
			RESET:	in	std_logic;
			Q:		out	std_logic
		);
	end component;

	begin
		REG_GEN_A : for i in 0 to N-1 generate
			ASYNC_REG : FLIPFLOP
				port map(DIN(i), CLK, RESET, DOUT(i));
		end generate;
end ASYNCHRONOUS;

