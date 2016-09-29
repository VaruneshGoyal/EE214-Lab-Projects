library ieee;
use ieee.std_logic_1164.all;

package thepackage is
	type fsm_state is ( phi, a, b, c, d, e, f);     --for bomb we go only upto state d, for gun till c etc. 
	type input_symbol is (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,space);
	type output_symbol is (n,y);

	component bomb is
		port (	X : in input_symbol;
			Yo : out output_symbol;
			clk,reset : in std_logic);
	end component bomb;

	component knife is
		port (	X : in input_symbol;
			Yo : out output_symbol;
			clk,reset : in std_logic);
	end component knife;

	component gun is
		port (	X : in input_symbol;
			Yo : out output_symbol;
			clk,reset : in std_logic);
	end component gun;

	component terror is
		port (	X : in input_symbol;
			Yo : out output_symbol;
			clk,reset : in std_logic);
	end component terror;

	component StringRecognizer is
		port (X : in std_logic_vector(4 downto 0); W: out std_logic;
			clk, rreset: in std_logic);
	end component StringRecognizer;

	function BV_To_Input_Symbol(XY: std_logic_vector)  return input_symbol;
	function BV_To_Output_Symbol(X: std_logic_vector)  return output_symbol;
	function Output_Symbol_To_BV(K: output_symbol) return std_logic;

end thepackage;

package body thepackage is
	function BV_To_Input_Symbol(XY: std_logic_vector)  return input_symbol  is
		variable ret_var: input_symbol;
		begin
     		if ( XY = "00001" )  then
			ret_var := a;
    		elsif (XY = "00010") then
			ret_var := b;
    		elsif (XY = "00011") then
			ret_var := c;
    		elsif (XY = "00100") then
			ret_var := d;
    		elsif (XY = "00101") then
			ret_var := e;
    		elsif (XY = "00110") then
			ret_var := f;
    		elsif (XY = "00111") then
			ret_var := g;
    		elsif (XY = "01000") then
			ret_var := h;
    		elsif (XY = "01001") then
			ret_var := i;
    		elsif (XY = "01010") then
			ret_var := j;
    		elsif (XY = "01011") then
			ret_var := k;
    		elsif (XY = "01100") then
			ret_var := l;
    		elsif (XY = "01101") then
			ret_var := m;
    		elsif (XY = "01110") then
			ret_var := n;
    		elsif (XY = "01111") then
			ret_var := o;
    		elsif (XY = "10000") then
			ret_var := p;
    		elsif (XY = "10001") then
			ret_var := q;
    		elsif (XY = "10010") then
			ret_var := r;
    		elsif (XY = "10011") then
			ret_var := s;
    		elsif (XY = "10100") then
			ret_var := t;
    		elsif (XY = "10101") then
			ret_var := u;
    		elsif (XY = "10110") then
			ret_var := v;
    		elsif (XY = "10111") then
			ret_var := w;
    		elsif (XY = "11000") then
			ret_var := x;
    		elsif (XY = "11001") then
			ret_var := y;
    		elsif (XY = "11010") then
			ret_var := z;
    		elsif (XY = "11011") then
			ret_var := space;
    		else
    		    ret_var := space;
    		end if;
    		return(ret_var);
  	end BV_To_Input_Symbol;

	function BV_To_Output_Symbol(X: std_logic_vector)  return output_symbol  is
		variable ret_var: output_symbol;
		begin
			if (X = "0") then
			  ret_var := n;
			else
        		  ret_var := y;
			end if;
		return(ret_var);
  	end BV_To_Output_Symbol;

	function Output_Symbol_To_BV(K: output_symbol) return std_logic is
		begin
			if(K = n) then
				return('0');
			else
				return('1');
			end if;
	end Output_Symbol_To_BV;

end package body;












