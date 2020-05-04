Library IEEE;
use IEEE.std_logic_1164.all;

Entity Deserializer is
	generic(busWidth : integer := 8);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SHF : in std_logic;
	BIN : in std_logic;
	DOUT : out std_logic_vector(busWidth - 1 downto 0)
	);
end Deserializer;

Architecture Behavioral of Deserializer is
signal Qp, Qn : std_logic_vector(busWidth - 1 downto 0);
begin
	Combinational : process(Qp, SHF, BIN)
	begin
		if SHF = '1' then
			Qn <= Qp(busWidth - 2 downto 0) & BIN;
		else
			Qn <= Qp;
		end if;
		DOUT <= Qp;
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
end Behavioral;