Library IEEE;
use IEEE.std_logic_1164.all;

Entity DHT11 is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STR : in std_logic;
	DIN : in std_logic;
	DOUT : out std_logic;
	HUM : out std_logic_vector(15 downto 0);
	TEM : out std_logic_vector(15 downto 0);
	CHK : out std_logic_vector(7 downto 0)
	);
end DHT11;

Architecture Structural of DHT11 is
Component Latch is port(
	RST : in std_logic;
	CLK : in std_logic;
	SET : in std_logic;
	CLR : in std_logic;
	QOUT : out std_logic);
end Component;
Component Timer is generic(Ticks : integer := 10);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	EOT : out std_logic);
end Component;
Component RisingEdge is port(
	RST : in std_logic;
	CLK : in std_logic;
	XIN : in std_logic;
	XOUT : out std_logic);
end Component;
Component Deserializer is generic(busWidth : integer := 8);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SHF : in std_logic;
	BIN : in std_logic;
	DOUT : out std_logic_vector(busWidth - 1 downto 0));
end Component;
signal ENO, EOT, RED, SYN, ENI : std_logic;
signal DREC : std_logic_vector(40 downto 0);
begin
	DOUT <= '0' when ENO = '1' else 'Z';
	U01 : Latch port map(RST, CLK, STR, EOT, ENO);
	U02 : Timer generic map(2000000) port map(ENO, CLK, EOT);
	
	HUM <= DREC(40 downto 25);
	TEM <= DREC(24 downto 9);
	CHK <= DREC(8 downto 1);
	
	U03 : RisingEdge port map(RST, CLK, DIN, RED);
	U04 : Latch port map(RST, CLK, RED, SYN, ENI);
	U05 : Timer generic map(5000) port map(ENI, CLK, SYN);
	U06 : Deserializer generic map(41) port map(RST, CLK, SYN, DIN, DREC);
end Structural;