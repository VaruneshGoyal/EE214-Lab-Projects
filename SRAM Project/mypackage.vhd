library ieee;
use ieee.std_logic_1164.all;

package mypackage is	

	component dataregister is
		generic (data_width:integer);
		port (Din: in std_logic_vector(data_width-1 downto 0);
		      Dout: out std_logic_vector(data_width-1 downto 0);
		      clk, enable: in std_logic);
	end component dataregister;

	component Adder16 is 
   	port (A, B: in std_logic_vector(15 downto 0); ---------------asuming a > b  -------------
   			 RESULT: out std_logic_vector(15 downto 0));
	end component Adder16;

	component Adder13 is 
   	port (A, B: in std_logic_vector(12 downto 0); ---------------asuming a > b  -------------
   			 RESULT: out std_logic_vector(12 downto 0));
	end component Adder13;

	component ADCC is
		port ( Data : in std_logic_vector(7 downto 0);
			notCS, notWR, notRD : out std_logic;
			INTR : in std_logic;
			adc_run:in std_logic;
			adc_output_ready : out std_logic;
			Dout : out std_logic_vector(7 downto 0);
			clk, reset : in std_logic );
	end component ADCC;

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

	component CCU is
		port (adc_run : out std_logic;
			adc_output_ready : in std_logic;
			adc_data : in std_logic_vector(7 downto 0);
			mc_start, mc_write : out std_logic;
			mc_address : out std_logic_vector(12 downto 0);
			mc_write_data : out std_logic_vector(7 downto 0);
			mc_done : in std_logic;
			mc_read_data : in std_logic_vector(7 downto 0);
			clk, reset : in std_logic;
	
			Data_to_DAC : out std_logic_vector(7 downto 0);		
			display, capture : in std_logic			);
	end component CCU;

	component toplevel is
		port (Data_ADC : in std_logic_vector(7 downto 0);
			notCSadc, notWRadc, notRDadc : out std_logic;
			INTR : in std_logic;
			address : out std_logic_vector(12 downto 0);
			Data_SMCC : inout std_logic_vector(7	downto 0);
			notOE, notWE, notCS : out std_logic;
			Data_DAC : out 	std_logic_vector(7 downto 0);
			display, capture : in std_logic;
			clk, reset : in std_logic );
	end component toplevel;

end mypackage;

