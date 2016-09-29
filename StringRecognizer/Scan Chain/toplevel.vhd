library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

library work;
	use work.thepackage.all;

entity toplevel is
  port 
  (
	 TDI : in std_logic; -- Test Data In
	 TDO : out std_logic; -- Test Data Out
	 TMS : in std_logic; -- TAP controller signal
	 TCLK : in std_logic; -- Test clock
	 TRST : in std_logic -- Test reset
  );
end entity;

architecture operation of toplevel is
	  -- declare Scan-chain component.
	  component Scan_Chain is
	    generic (
	    in_pins : integer; -- Number of input pins
	    out_pins : integer -- Number of output pins
	  );
	  port (
	         TDI : in std_logic; -- Test Data In
	         TDO : out std_logic; -- Test Data Out
	         TMS : in std_logic; -- TAP controller signal
	         TCLK : in std_logic; -- Test clock
	         TRST : in std_logic; -- Test reset
	         dut_in : out std_logic_vector(in_pins-1 downto 0); -- Input for the DUT
	         dut_out : in std_logic_vector(out_pins-1 downto 0) -- Output from the DUT
	       );
	  end component;
  -- declare I/O signals to DUT component
	signal letter : std_logic_vector(4 downto 0);
	signal clk, reset : std_logic;
	signal W : std_logic;

  -- declare signals to Scan-chain component.
  	signal scan_chain_parll_in : std_logic_vector(6 downto 0);
  	signal scan_chain_parll_out : std_logic_vector(0 downto 0);

 begin 
 	scan_instantiate : Scan_chain 
 		generic map (in_pins => 7, out_pins => 1)
 		port map 
 		(
			TDI => TDI,
           		TDO => TDO,
            		TMS => TMS,
            		TCLK => TCLK,
            		TRST => TRST,
            		dut_in => scan_chain_parll_in,
            		dut_out => scan_chain_parll_out
 		);
	
	dut : StringRecognizer port map (X => letter, clk => clk, rreset => reset, W => W);

  -- connections between DUT and Scan_Chain
  	letter <= scan_chain_parll_in(4 downto 0);
  	clk <= scan_chain_parll_in(6);
  	reset <= scan_chain_parll_in(5);
  	scan_chain_parll_out(0) <= W;
end operation;






