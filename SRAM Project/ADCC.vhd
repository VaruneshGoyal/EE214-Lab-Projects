library ieee;
use ieee.std_logic_1164.all;
--library ieee;
--use ieee.std_logic_arith.all;
library work;
use work.mypackage.all;

entity ADCC is
	port ( Data : in std_logic_vector(7 downto 0);
		notCS, notWR, notRD : out std_logic;
		INTR : in std_logic;
		adc_run:in std_logic;
		adc_output_ready : out std_logic;
		Dout : out std_logic_vector(7 downto 0);
		clk, reset : in std_logic );
end entity;

architecture behave of ADCC is
	type FsmState is (phi, WR, doing, RD, waiting);
	signal fsm_state : FsmState := phi;
	signal count : std_logic_vector(15 downto 0);
	signal ccount, ccountin : std_logic_vector(15 downto 0);
	signal reading : std_logic;
	signal regin, regout : std_logic_vector(7 downto 0);
	constant C15 : std_logic_vector(15 downto 0) := "0000000000000001";
	signal x, T, INTR_stable : std_logic;
begin
	reg1 : dataregister generic map (data_width => 8)
						port map (Din => regin, Dout => regout, enable => reading, clk => clk);
	reg2 : dataregister generic map (data_width => 16)
						port map (Din => ccountin, Dout => count, enable => '1' , clk => clk);
	regin <= Data when (reading = '1') else regout;	
	
	process(clk)
    	begin
       		if(clk'event and (clk  = '1')) then
           		if(reset = '0') then
               			INTR_stable <= INTR;
           		end if;
       		end if;
    	end process;

	notRD <= not reading;
	Dout <= regout;
		
	add : Adder16 port map(A => count, B => C15, RESULT => ccount);
	ccountin <= C15 when (x = '1') else ccount;
	--x <= adc_run or reset;
	x <= T or reset;
	process(fsm_state, adc_run, clk, reset)
      	variable next_state: FsmState;
	variable notCS_var, notWR_var, RD_var, adc_output_ready_var, T_var : std_logic;
   	begin
       	-- defaults
		--ccount := count + C15;
	        next_state := fsm_state;
		notWR_var := '1';
		RD_var := '0';
		adc_output_ready_var := '0';
		T_var := '0';
	        case fsm_state is 
	          when phi =>
	                if(adc_run = '1') then
	                	next_state := WR;
				notCS_var := '0';
				T_var := '1';
				--ccount := (others => '0');
			else 
				next_state := phi;
	        	end if;
		  when WR =>
			if(count(5) = '1') then
				next_state := doing;
			else 
				notWR_var := '0';
				next_state := WR;
			end if;
		  when doing =>
			if(INTR_stable = '1') then
				next_state := doing;
			else
				next_state := RD;
				RD_var := '1';
			end if;
		  when RD =>
			if(count(14) = '1') then
				next_state := waiting;
				RD_var := '0';
			else 
				RD_var := '1';
				next_state := RD;		
			end if;
		  when waiting =>
			if(count = "1100001101010000") then
				next_state := phi;
				adc_output_ready_var := '1';
			else 
				next_state := waiting;
			end if;
	     end case;

		reading <= RD_var;
		notCS <= notCS_var;
		notWR <= notWR_var;
		T <= T_var;
		adc_output_ready <= adc_output_ready_var;
		
	     if(clk'event and (clk = '1')) then
		if(reset = '1') then
             		fsm_state <= phi;
			--ccount <= (others => '0');
        	else
        	     	fsm_state <= next_state;
			--count <= ccount;
        	end if;
     	     end if;
	   end process;
	
end behave;





