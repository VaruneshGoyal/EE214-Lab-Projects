library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

entity Testbench is

end entity;


architecture Behave of Testbench is
  signal input : std_logic_vector(4 downto 0);
  signal output : std_logic;
  signal reset: std_logic := '0';
  signal clk: std_logic := '0';

component StringRecognizer is
		port (X : in std_logic_vector(4 downto 0); W: out std_logic;
			clk, rreset: in std_logic);
	end component StringRecognizer;

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

  dut: StringRecognizer port map(X => input , W => output, clk => clk, rreset => reset);

  process
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";
    variable input_bv: bit_vector (4 downto 0);
    variable expected_output: bit;

    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
	
    variable clk_bit: bit;
    variable reset_bit: bit;

    begin 

        while not endfile(INFILE) loop 

          -- clock = '0', inputs should be changed here.
          LINE_COUNT := LINE_COUNT + 1;
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, clk_bit);
	  read (INPUT_LINE, reset_bit);
          read (INPUT_LINE, input_bv);
          read (INPUT_LINE, expected_output);

          clk <= to_std_logic(clk_bit);
	  input <= to_std_logic_vector(input_bv);
	  reset <= to_std_logic(reset_bit);

	  wait for 20 ns;

	  -- check Mealy machine output and 
          -- compare with expected.
          if (not (output = to_std_logic(expected_output))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 

	  if(endfile(INFILE)) then
		exit;
	  end if;

	  -- clk = '1', inputs should not change here.
          LINE_COUNT := LINE_COUNT + 1;
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, clk_bit);
	  read (INPUT_LINE, reset_bit);
          read (INPUT_LINE, input_bv);
          read (INPUT_LINE, expected_output);
          clk <= to_std_logic(clk_bit);
	  input <= to_std_logic_vector(input_bv);
	  reset <= to_std_logic(reset_bit);

	  wait for 20 ns;
	  
        end loop;
    
	assert (err_flag) report "SUCCESS, all tests passed." severity note;
    	assert (not err_flag) report "FAILURE, some tests failed." severity error;
	
	wait;
  end process;
  
end Behave;
