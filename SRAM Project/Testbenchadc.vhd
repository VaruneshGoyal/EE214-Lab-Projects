library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

entity Testbench is

end entity;


architecture Behave of Testbench is
  signal input : std_logic_vector(7 downto 0);
  signal output : std_logic_vector(7 downto 0);
  signal reset: std_logic := '0';
  signal clk: std_logic := '1';
  signal notCS, notWR, notRD, INTR, adc_run, adc_output_ready : std_logic;
  
component ADCC is
	port ( Data : in std_logic_vector(7 downto 0);
		notCS, notWR, notRD : out std_logic;
		INTR : in std_logic;
		adc_run:in std_logic;
		adc_output_ready : out std_logic;
		Dout : out std_logic_vector(7 downto 0);
		clk, reset : in std_logic );
end component ADCC;

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

begin
----------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------------------------
  dut: ADCC port map(Data => input,
		notCS => notCS, notWR => notWR, notRD => notRD,
		INTR => INTR,
		adc_run=>adc_run,
		adc_output_ready => adc_output_ready,
		Dout => output,
		clk=>clk, reset=> reset);
clk <= not clk after 10 ns;
  process
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILEADCC.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";
    variable input_bv: bit_vector (7 downto 0);
    variable expected_output:bit_vector (7 downto 0);

    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
	


    begin 

        while not endfile(INFILE) loop
	
	INTR <= '1';

          -- clock = '0', inputs should be changed here.
          LINE_COUNT := LINE_COUNT + 1;
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, input_bv);
          read (INPUT_LINE, expected_output);

	  input <= to_std_logic_vector(input_bv);
	  adc_run <= '1';
	  wait for 20 ns;
	  --adc_run <= '0';

	  wait for 300 us;
	  INTR <= '0';

	  while (adc_output_ready = '0') loop
		wait for 20 ns;
	  end loop;

	  INTR <= '1';
	  --wait for 700 us;
	  -- check Mealy machine output and 
          -- compare with expected.
          if (not (output = to_std_logic_vector(expected_output))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
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
