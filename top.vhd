
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
generic(
c_clkfreq		:integer :=100_000_000;
c_baudrate		:integer :=115_200
);
port(
clk				:in std_logic;
rx_i			:in std_logic;
led_o			:out std_logic_vector(7 downto 0)
);
end top;


architecture Behavioral of top is



component uart_rx_src is
generic(
c_clkfreq			:integer :=100_000_000;
c_baudrate			:integer :=115_200
);
port(
clk				: in std_logic;
rx_i			: in std_logic;
dout_o			: out std_logic_vector (7 downto 0);
rx_done_tick_o	: out std_logic
);
end component uart_rx_src;

signal ledshift				:std_logic_vector(15 downto 0):= (others=>'0');
signal led					:std_logic_vector(7 downto 0):= (others=>'0');
signal rx_done_tick			:std_logic :='0';


begin

i_uart_rx: uart_rx_src
generic map(
c_clkfreq			=> c_clkfreq,
c_baudrate			=> c_baudrate
)
port map(
clk				=> clk,
rx_i			=> rx_i,
dout_o			=> led,
rx_done_tick_o	=> rx_done_tick
);

P_MAIN: process (clk) begin
if(rising_edge(clk)) then
	
	if(rx_done_tick <='1') then
		ledshift(15 downto 8) <= ledshift(7 downto 0);
		ledshift(7 downto 0) <= led;
	
	end if;

end if;
end process;

led_o <= led;

end Behavioral;
