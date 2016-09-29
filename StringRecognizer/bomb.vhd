library ieee;
use ieee.std_logic_1164.all;
library work;
use work.thepackage.all;

entity bomb is
	port (	X : in input_symbol;
		Yo : out output_symbol;
		clk,reset : in std_logic);
end entity bomb;

architecture Behave of bomb is
  signal current_state : fsm_state;
  begin 
	process (X, clk, current_state)
	  variable nstate : fsm_state;
	  variable vY : output_symbol;
	  begin
		nstate := current_state;      --set the default values
		vY := n;
		case current_state is 
		  when phi =>
			if (X=b) then
			  nstate := a;
			end if;
		  when a =>
			if (X=o) then
			  nstate := b;
			end if;
		  when b =>
			if (X=m) then
			  nstate := c;
			end if;
		  when c =>
			if (X=b) then
			  nstate := a;
			  vY := y;
			end if;
		  when d => 
			nstate := d;
		  when e =>
			nstate := e;
		  when f =>
			nstate := f;
		end case;
		
		if (reset = '1') then            --if reset put n to Yo else vY to Yo
		  Yo <= n;
		else
		  Yo <= vY;
		end if;
			if(clk'event and clk = '1') then
		     if(reset = '1') then
		       current_state <= phi;
		     else
		       current_state <= nstate;
		     end if;
	        end if;
	end process;

end Behave;
				
