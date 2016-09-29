library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

entity Testbenchsmcc is

end entity;


architecture Behave of Testbenchsmcc is
  
	component SMCC is
		port (mc_start, mc_write : in std_logic;
			mc_address : in std_logic_vector(12 downto 0);
			mc_write_data : in std_logic_vector(7 downto 0);
			mc_done : out std_logic;
			mc_read_data : out std_logic_vector(7 downto 0);
			clk, reset : in std_logic;
			address : out std_logic_vector(12 downto 0);
			Data : inout std_logic_vector(7	downto 0);
			notOE, notWE, notCS : out std_logic		 );
	end component SMCC;

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  	begin  
          ret_val := lx;
      return(ret_val);
  end to_string;

  function to_std_logic (x: bit) return std_logic is
  begin
	if(x = '1') then return ('1');
	else return('0'); end if;
  end to_std_logic;

  function to_std_logic_vector (x: bit_vector) return std_logic_vector is
	variable y : std_logic_vector((x'length-1) downto 0);
	begin
	for k in 0 to (x'length-1) loop
		if(x(k)='1') then y(k) := '1';
		else y(k) := '0';
		end if;
	end loop;
	return y;
  end to_std_logic_vector;

  signal mc_write_data, mc_read_data, Data : std_logic_vector(7 downto 0);
  signal mc_address, address: std_logic_vector(12 downto 0);
  signal reset: std_logic := '0';
  signal clk: std_logic := '0';
  signal notCS, notWE, notOE, mc_done, mc_start, mc_write : std_logic;
  

----------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------------------------
begin

  dut: SMCC port map(mc_start => mc_start, mc_write => mc_write,
			mc_address => mc_address,
			mc_write_data => mc_write_data,
			mc_done => mc_done,
			mc_read_data => mc_read_data,
			clk => clk, reset => reset,
			address => address,
			Data => Data,
			notOE => notOE, notWE => notWE, notCS => notCS);

clk <= not clk after 10 ns;

  process
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILESMCC.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";
    variable address_bv: bit_vector (12 downto 0);
--    variable expected_output:bit_vector (7 downto 0);
--    variable address_output : bit_vector (12 downto 0);
    variable input_bv  :bit_vector (7 downto 0);
    variable start_b : bit_vector (0 downto 0);
--    variable mc_start, notOE, notWE, notCS : bit;

    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
	


    begin 
	--mc_address <= to_std_logic_vector(address_bv);
	--mc_start <= to_std_logic(start_b(0));
        while not endfile(INFILE) loop

          -- clock = '0', inputs should be changed here.
          LINE_COUNT := LINE_COUNT + 1;
	  readLine (INFILE, INPUT_LINE);
	  read (INPUT_LINE, start_b);
          read (INPUT_LINE, address_bv);
	  read (INPUT_LINE, input_bv);
	  
	  if(start_b(0) = '0') then
		mc_start <= '1';
		mc_address <= to_std_logic_vector(address_bv);
		mc_write <= '0';
		wait for 20 ns;
		while (notCS = '1') loop
			wait for 1 ns;
		end loop;
		--mc_start <= '0';		
		
		if (not (address = to_std_logic_vector(address_bv))) then
        		write(OUTPUT_LINE,to_string("ERROR: line "));
           		write(OUTPUT_LINE, LINE_COUNT);
	                writeline(OUTFILE, OUTPUT_LINE);
           		err_flag := true;
          	end if; 
		
		if (notWE = '0') then
			err_flag := true;
			write(OUTPUT_LINE, LINE_COUNT);
		end if;

		while (notOE = '1') loop
			wait for 1 ns;
		end loop;

		wait for 50 ns;

		Data <= to_std_logic_vector(input_bv);

		while (mc_done = '0') loop
			wait for 10 ns;
		end loop;
		
		if (not (mc_read_data = to_std_logic_vector(input_bv))) then
        		write(OUTPUT_LINE,to_string("ERROR: line "));
           		write(OUTPUT_LINE, LINE_COUNT);
	                writeline(OUTFILE, OUTPUT_LINE);
           		err_flag := true;
          	end if; 
	
	else 
		mc_start <= '1';
		mc_address <= to_std_logic_vector(address_bv);
		mc_write <= '1';
		wait for 20 ns;
		while (notCS = '1') loop
			wait for 1 ns;
		end loop;
		--mc_start <= '0';

		if (not (address = to_std_logic_vector(address_bv))) then
        		write(OUTPUT_LINE,to_string("ERROR: line "));
           		write(OUTPUT_LINE, LINE_COUNT);
	                writeline(OUTFILE, OUTPUT_LINE);
           		err_flag := true;
          	end if; 

		while (notWE = '1') loop
			wait for 1 ns;
		end loop;
		
		Data <= "ZZZZZZZZ";

		wait for 50 ns;

		mc_write_data <= to_std_logic_vector(input_bv);

		while (notWE = '0') loop
			wait for 1 ns;
		end loop;
		
		if (not (Data = to_std_logic_vector(input_bv))) then
        		write(OUTPUT_LINE,to_string("ERROR: line "));
           		write(OUTPUT_LINE, LINE_COUNT);
	                writeline(OUTFILE, OUTPUT_LINE);
           		err_flag := true;
          	end if; 
			  
		while (mc_done = '0') loop
			wait for 10 ns;
		end loop;
	end if;

	if(endfile(INFILE)) then
		exit;
	end if;

        end loop;
    
	assert (err_flag) report "SUCCESS, all tests passed." severity note;
    	assert (not err_flag) report "FAILURE, some tests failed." severity error;
	
	wait;
  end process;
  
end Behave;
