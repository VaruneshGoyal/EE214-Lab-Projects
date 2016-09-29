library ieee;
use ieee.std_logic_1164.all;
library work;
use work.mypackage.all;

entity CCU is
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
		display, capture : in std_logic		);
end entity;

architecture behave of CCU is
	signal address : std_logic_vector(12 downto 0) := (others => '0');
	signal aaaddress : std_logic_vector(12 downto 0);
	signal address_in : std_logic_vector(12 downto 0) := (others => '0');
	constant C12 : std_logic_vector(12 downto 0) := "0000000000001";
	signal addEnable, DACEnable : std_logic := '0';
--	type fsm1 is (phi, adc_run_high);

begin
	addressreg : dataregister generic map (data_width => 13)
				port map (Din => address_in, Dout => address, enable => addEnable , clk => clk);
	addEnable <= (mc_done and display) or (adc_output_ready and capture); 			--assumption : same wraparound sequence for both read and write
	add : Adder13 port map(A => address, B => C12, RESULT => aaaddress);
	address_in <= C12 when (reset = '1') else aaaddress;

	mc_address <= address;

	Dataadcreg : dataregister generic map (data_width => 8)
			 	port map (Din => adc_data, Dout => mc_write_data, enable => adc_output_ready, clk => clk);

	Datadacreg : dataregister generic map (data_width => 8)
			 	port map (Din => mc_read_data, Dout => Data_to_DAC, enable => DACEnable, clk => clk);
	DACEnable <= mc_done and display and (not capture);

	adc_run <= capture;
	mc_start <= adc_output_ready or capture;
	mc_write <= '1' when (adc_output_ready='1') else '0';
	
	
--	process(clk, reset, display, capture, mc_done, adc_output_ready)
--		
--	begin
--	
--	end process;

end behave;



architecture fsm of CCU is
	signal address : std_logic_vector(12 downto 0) := (others => '0');
	signal aaaddress : std_logic_vector(12 downto 0);
	signal address_in : std_logic_vector(12 downto 0) := (others => '0');
	constant C12 : std_logic_vector(12 downto 0) := "0000000000001";
	signal addEnable, DACEnable : std_logic := '0';
	signal displayf : std_logic;
--	type fsm1 is (phi, adc_run_high);

begin
	displayf <= display and (not capture);
	addressreg : dataregister generic map (data_width => 13)
				port map (Din => address_in, Dout => address, enable => addEnable , clk => clk);
	addEnable <= (mc_done and display and (not capture)) or (adc_output_ready and capture); --assumption: same wraparound sequence for both read and write
	--add : Adder13 port map(A => address, B => C12, RESULT => aaaddress);
	--address_in <= C12 when (reset = '1') else aaaddress;
	add : Adder13 port map(A => address, B => C12, RESULT => address_in);

	mc_address <= address;

	Dataadcreg : dataregister generic map (data_width => 8)
			 	port map (Din => adc_data, Dout => mc_write_data, enable => adc_output_ready, clk => clk);

	Datadacreg : dataregister generic map (data_width => 8)
			 	port map (Din => mc_read_data, Dout => Data_to_DAC, enable => DACEnable, clk => clk);
	DACEnable <= mc_done and display and (not capture);
	--DACEnable <= mc_done and (not capture);

	adc_run <= capture;
	mc_start <= displayf or adc_output_ready;
	mc_write <= '1' when (adc_output_ready='1') else '0';
	
--	process(clk, reset, display, capture, mc_done, adc_output_ready)
--		
--	begin
--	
--	end process;

end fsm;












