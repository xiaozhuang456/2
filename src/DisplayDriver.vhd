Library IEEE;
use IEEE.std_logic_1164.all;

Entity DisplayDriver is
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	DIG1 : in std_logic_vector(3 downto 0);
	DIG2 : in std_logic_vector(3 downto 0);
	DIG3 : in std_logic_vector(3 downto 0);
	DIG4 : in std_logic_vector(3 downto 0);
	SEG  : out std_logic_vector(7 downto 0);
	ANO  : out std_logic_vector(3 downto 0)
	);
end DisplayDriver;

Architecture Structural of DisplayDriver is
Component Timer is generic(Ticks : integer := 10);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	EOT : out std_logic);
end Component;
Component Counter is generic(busWidth : integer := 8);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	INC : in std_logic;
	CNT : out std_logic_vector(busWidth - 1 downto 0));
end Component;
Component AnodeDecoder is port(
	ADDR : in std_logic_vector(1 downto 0);
	DATA : out std_logic_vector(3 downto 0));
end Component;
Component Multiplexer4To1 is generic(busWidth : integer := 8);
	port(
	XIN1 : in std_logic_vector(busWidth - 1 downto 0);
	XIN2 : in std_logic_vector(busWidth - 1 downto 0);
	XIN3 : in std_logic_vector(busWidth - 1 downto 0);
	XIN4 : in std_logic_vector(busWidth - 1 downto 0);
	SEL  : in std_logic_vector(1 downto 0);
	XOUT : out std_logic_vector(busWidth - 1 downto 0));
end Component;
Component SN74LS47 is port(
	XIN : in std_logic_vector(3 downto 0);
	SEG : out std_logic_vector(7 downto 0));
end Component;
signal SYN : std_logic;
signal SEL : std_logic_vector(1 downto 0);
signal NIB : std_logic_vector(3 downto 0);
begin
	U01 : Timer generic map(250000) port map(RST, CLK, SYN);
	U02 : Counter generic map(2) port map(RST, CLK, SYN, SEL);
	U03 : AnodeDecoder port map(SEL, ANO);
	U04 : Multiplexer4To1 generic map(4) port map(DIG1, DIG2, DIG3, DIG4, SEL, NIB);
	U05 : SN74LS47 port map(NIB, SEG);
end Structural;