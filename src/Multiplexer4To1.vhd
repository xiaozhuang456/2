Library IEEE;
use IEEE.std_logic_1164.all;

Entity Multiplexer4To1 is
	generic(busWidth : integer := 8);
	port(
	XIN1 : in std_logic_vector(busWidth - 1 downto 0);
	XIN2 : in std_logic_vector(busWidth - 1 downto 0);
	XIN3 : in std_logic_vector(busWidth - 1 downto 0);
	XIN4 : in std_logic_vector(busWidth - 1 downto 0);
	SEL  : in std_logic_vector(1 downto 0);
	XOUT : out std_logic_vector(busWidth - 1 downto 0)
	);
end Multiplexer4To1;

Architecture DataPath of Multiplexer4To1 is
begin
	With SEL Select XOUT <=
	XIN2 when "01",
	XIN3 when "10",
	XIN4 when "11",
	XIN1 when others;
end DataPath;