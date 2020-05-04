Library IEEE;
use IEEE.std_logic_1164.all;

Entity Thermometer is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	DIO : inout std_logic;
	SEG : out std_logic_vector(7 downto 0);
	ANO : out std_logic_vector(3 downto 0)
	);
end Thermometer;

Architecture Structural of Thermometer is
Component Timer is generic(Ticks : integer := 10);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	EOT : out std_logic);
end Component;
Component DHT11 is port(
	RST : in std_logic;
	CLK : in std_logic;
	STR : in std_logic;
	DIN : in std_logic;
    DOUT : out std_logic;
	HUM : out std_logic_vector(15 downto 0);
	TEM : out std_logic_vector(15 downto 0);
	CHK : out std_logic_vector(7 downto 0) );
end Component;
Component BinaryToDecimal is port(
	RST : in std_logic;
	CLK : in std_logic;
	STR : in std_logic;
	DIN : in std_logic_vector(7 downto 0);
	ONE : out std_logic_vector(3 downto 0);
	TEN : out std_logic_vector(3 downto 0);
	HUN : out std_logic_vector(3 downto 0);
	THO : out std_logic_vector(3 downto 0));
end Component;
Component DisplayDriver is port(
	RST  : in std_logic;
	CLK  : in std_logic;
	DIG1 : in std_logic_vector(3 downto 0);
	DIG2 : in std_logic_vector(3 downto 0);
	DIG3 : in std_logic_vector(3 downto 0);
	DIG4 : in std_logic_vector(3 downto 0);
	SEG  : out std_logic_vector(7 downto 0);
	ANO  : out std_logic_vector(3 downto 0));
end Component;
signal STR : std_logic;
signal TEM : std_logic_vector(15 downto 0);
signal ONE, TEN, HUN, THO : std_logic_vector(3 downto 0);
begin
	U01 : Timer generic map(150000000) port map(RST, CLK, STR);
	U02 : DHT11 port map(RST, CLK, STR, DIO, DIO, OPEN, TEM, OPEN);
	U03 : BinaryToDecimal port map(RST, CLK, STR, TEM(15 downto 8), ONE, TEN, HUN, THO);
	U04 : DisplayDriver port map(RST, CLK, ONE, TEN, HUN, THO, SEG, ANO);
end Structural;