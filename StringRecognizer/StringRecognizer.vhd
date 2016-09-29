library ieee;
use ieee.std_logic_1164.all;
library work;
use work.thepackage.all;

entity StringRecognizer is
	port (X : in std_logic_vector(4 downto 0); W: out std_logic;
		clk, rreset: in std_logic);
end entity StringRecognizer;

architecture Behave of StringRecognizer is
	signal abstractin : input_symbol;
	signal ay1, ay2, ay3, ay4 : output_symbol;
	signal y1, y2, y3, y4 : std_logic;
begin
	abstractin <= BV_To_Input_Symbol(X);

	fsm_bomb : bomb port map(X=>abstractin, Yo=>ay1, clk=>clk, reset=> rreset);
	fsm_gun : gun port map(X=>abstractin, Yo=>ay2, clk=>clk, reset=> rreset);
	fsm_knife : knife port map(X=>abstractin, Yo=>ay3, clk=>clk, reset=> rreset);
	fsm_terror : terror port map(X=>abstractin, Yo=>ay4, clk=>clk, reset=> rreset);

	y1 <= Output_Symbol_To_BV(ay1);
	y2 <= Output_Symbol_To_BV(ay2);
	y3 <= Output_Symbol_To_BV(ay3);
	y4 <= Output_Symbol_To_BV(ay4);

	W <= y1 or y2 or y3 or y4;
	
end Behave;
