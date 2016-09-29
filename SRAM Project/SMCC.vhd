
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.mypackage.all;

entity SMCC is
	port (mc_start, mc_write : in std_logic;
		mc_address : in std_logic_vector(12 downto 0);
		mc_write_data : in std_logic_vector(7 downto 0);
		mc_done : out std_logic;
		mc_read_data : out std_logic_vector(7 downto 0);
		clk, reset : in std_logic;
		address : out std_logic_vector(12 downto 0);
		Data : inout std_logic_vector(7	downto 0);
		notOE, notWE, notCS : out std_logic		 );
end entity;

architecture behave of SMCC is
	type FsmState is (phi, write, write2, read, done);
	signal fsm_state : FsmState;
	signal T0, T1, T2, T3 : std_logic;
	signal x1, x : std_logic;

	signal count : std_logic_vector(15 downto 0);
	signal ccount, ccountin : std_logic_vector(15 downto 0);
	constant C15 : std_logic_vector(15 downto 0) := "0000000000000001";
	constant high_Z : std_logic_vector(7 downto 0) := "ZZZZZZZZ";
	
	signal data_to_write : std_logic_vector(7 downto 0);
	
begin 

	readData : dataregister generic map (data_width => 8)
			 	port map (Din => Data, Dout => mc_read_data, enable => T2, clk => clk);
	
	writeData : dataregister generic map (data_width => 8)
			 	port map (Din => mc_write_data, Dout => data_to_write, enable => T3, clk => clk);

	addressReg : dataregister generic map (data_width => 13)
			 	port map (Din => mc_address, Dout => address, enable => x1, clk => clk);
	x1 <= T0 or T1;

	reg2 : dataregister generic map (data_width => 16)
				port map (Din => ccountin, Dout => count, enable => '1' , clk => clk);
	add : Adder16 port map(A => count, B => C15, RESULT => ccount);
	ccountin <= C15 when (x = '1') else ccount;
	x <= T0 or T1 or reset;

	Data <= data_to_write when (T3 = '1') else high_Z;
	

	process(fsm_state, clk, reset, mc_start)
	variable next_state : FsmState;
	variable T0_var, T1_var, T2_var, T3_var : std_logic;
	variable notCS_var, notWE_var, notOE_var, mc_done_var : std_logic;
	begin
		mc_done_var := '0';
		T0_var := '0';
		T1_var := '0';
		T2_var := '0';
		T3_var := '0';
		notCS_var := '1'; notWE_var := '1'; notOE_var := '1';
	   case fsm_state is
		when phi =>
			if(mc_start = '1') then
				if(mc_write = '1') then
					next_state := write;
					T0_var := '1';
				else
					next_state := read;
					T1_var := '1';
				end if;
			else
				next_state := phi;
			end if;
		when write =>
			notCS_var := '0';
			notWE_var := '0';
			if(count(3) = '1') then
				next_state := write2;
				T3_var := '1';
			else next_state := write;
			end if;
		when write2 =>
			notCS_var := '0';
			notWE_var := '0';
			T3_var := '1';
			if(count(4) = '1') then
				notCS_var := '1';
				notWE_var := '1';
				next_state := done;
			else
				next_state := write2;
			end  if;
		when read =>
			notCS_var := '0';
			notOE_var := '0';
			if(count(3) = '1') then
				T2_var := '1';
				next_state := done;
			else
				next_state := read;
			end if;
		when done =>
			if(count = "1100001101000000") then
				mc_done_var := '1';
				next_state := phi;
			else 
				next_state := done;
			end if;
	   end case;

	T0 <= T0_var; T1 <= T1_var; T2 <= T2_var; T3 <= T3_var;
	mc_done <= mc_done_var;
	notCS <= notCS_var; notWE <= notWE_var; notOE <= notOE_var;	

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
