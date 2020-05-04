Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity BinaryToDecimal is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STR : in std_logic;
	DIN : in std_logic_vector(7 downto 0);
	ONE : out std_logic_vector(3 downto 0);
	TEN : out std_logic_vector(3 downto 0);
	HUN : out std_logic_vector(3 downto 0);
	THO : out std_logic_vector(3 downto 0)
	);
end BinaryToDecimal;

Architecture Structural of BinaryToDecimal is
Component Latch is port(
	RST : in std_logic;
	CLK : in std_logic;
	SET : in std_logic;
	CLR : in std_logic;
	QOUT : out std_logic);
end Component;
Component Counter is generic(busWidth : integer := 8);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	INC : in std_logic;
	CNT : out std_logic_vector(busWidth - 1 downto 0));
end Component;
Component DecimalCounter is port(
	RST : in std_logic;
	CLK : in std_logic;
	ENI : in std_logic;
	ONE : out std_logic_vector(3 downto 0);
	TEN : out std_logic_vector(3 downto 0);
	HUN : out std_logic_vector(3 downto 0);
	THO : out std_logic_vector(3 downto 0));
end Component;
signal ENA, EOC, RSS, GTE, INC : std_logic;
signal CNT : std_logic_vector(7 downto 0);
begin
	RSS <= RST AND NOT(STR); 
	INC <= GTE AND ENA;
	EOC <= NOT(GTE); 
	GTE <= '1' when unsigned(DIN) > unsigned(CNT) else '0';
	
	U01 : Latch port map(RST, CLK, STR, EOC, ENA);
	U02 : Counter generic map(8) port map(ENA, CLK, '1', CNT);
	U03 : DecimalCounter port map(RSS, CLK, INC, ONE, TEN, HUN, THO);	
end Structural;