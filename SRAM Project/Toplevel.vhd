library ieee;
use ieee.std_logic_1164.all;
library work;
use work.mypackage.all;

entity toplevel is
	port (Data_ADC : in std_logic_vector(7 downto 0);
		notCSadc, notWRadc, notRDadc : out std_logic;
		INTR : in std_logic;
		address : out std_logic_vector(12 downto 0);
		Data_SMCC : inout std_logic_vector(7	downto 0);
		notOE, notWE, notCS : out std_logic;
		Data_DAC : out 	std_logic_vector(7 downto 0);
		Data_LED : out 	std_logic_vector(7 downto 0);
		display, capture : in std_logic;
		clk, reset : in std_logic );
end entity;

architecture behave of toplevel is
	signal adc_run, adc_output_ready : std_logic;
	signal CCU_adcdata : std_logic_vector(7 downto 0);
	
	signal mc_start, mc_write, mc_done : std_logic;
	signal mc_address : std_logic_vector(12 downto 0);
	signal mc_write_data, mc_read_data : std_logic_vector(7 downto 0);
	signal LED_data : std_logic_vector(7 downto 0);
begin
	adc : ADCC port map (Data => Data_ADC,
				notCS => notCSadc, notWR=> notWRadc, notRD => notRDadc,
				INTR=> INTR,
				adc_run => adc_run,
				adc_output_ready => adc_output_ready,
				Dout => CCU_adcdata,
				clk=>clk, reset=>reset);

	sram : SMCC port map (mc_start => mc_start, mc_write=>mc_write,
				mc_address => mc_address,
				mc_write_data => mc_write_data,
				mc_done => mc_done,
				mc_read_data => mc_read_data,
				clk=>clk, reset=>reset,
				address => address,
				Data => Data_SMCC,
				notOE =>notOE, notWE=>notWE, notCS=>notCS );

	dut : CCU port map (adc_run => adc_run,
				adc_output_ready => adc_output_ready,
				adc_data => CCU_adcdata,
				mc_start => mc_start, mc_write => mc_write,
				mc_address => mc_address,
				mc_write_data => mc_write_data,
				mc_done => mc_done,
				mc_read_data => mc_read_data,
				clk=>clk, reset=> reset,
				Data_to_DAC => LED_data,	
				display => display, capture => capture	);
				
	Data_LED <= LED_data;
	Data_DAC <= LED_data;

end behave;
