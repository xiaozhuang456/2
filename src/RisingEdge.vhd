Library IEEE;
use IEEE.std_logic_1164.all;

Entity RisingEdge is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	XIN : in std_logic;
	XOUT : out std_logic
	);
end RisingEdge;

Architecture Behavioral of RisingEdge is
signal Qp, Qn : std_logic_vector(2 downto 0);
begin
	Combinational : process(Qp, XIN)
	begin
		Qn(0) <= XIN;
		Qn(1) <= Qp(0);
		Qn(2) <= Qp(1);
		XOUT <= Qp(0) AND Qp(1) AND NOT(Qp(2));
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= "111";
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
end Behavioral;