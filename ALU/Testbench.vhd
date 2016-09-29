library std;
-- for writing and reading from files.
use std.textio.all;

entity Testbench is
end entity;
architecture Behave of Testbench is
  	signal a0,a1,a2,a3,a4,a5,a6,a7, b0,b1,b2,b3,b4,b5,b6,b7, in0, in1 : bit := '0'; 
	signal y : bit_vector (7 downto 0);
	signal error_flag : bit := '0';
  	component ALU
    		port (a0,a1,a2,a3,a4,a5,a6,a7, 
			b0,b1,b2,b3,b4,b5,b6,b7, in0, in1: in bit;
			y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
  	end component;
	function bitvec_to_str ( x : bit_vector ) return String is
		variable L : line ;
		variable W : String (1 to x ' length ) :=( others => ' ') ;
		begin
			write (L , x ) ;
			W ( L . all ' range ) := L . all ;
			Deallocate ( L ) ;
		return W ;
	end bitvec_to_str ;
begin
	process
	file f : text open read_mode is "outputs.txt" ;
	file g : text open write_mode is "error_log.txt" ;
	variable a : bit_vector (7 downto 0) ;
	variable b : bit_vector (7 downto 0) ;
	variable op_code : bit_vector (1 downto 0) ;
	variable L : line ;
	--variable to_check : string;
	variable expected_output : bit_vector (7 downto 0);

	begin
		while not endfile(f) loop
			readline(f,L);
			read(L,a);
			read(L,b);
			read(L,op_code);
			read(L,expected_output);
			a7 <= a(7);
			a6 <= a(6);
			a5 <= a(5);
			a4 <= a(4);
			a3 <= a(3);
			a2 <= a(2);
			a1 <= a(1);
			a0 <= a(0);
			b7 <= b(7);
			b6 <= b(6);
			b5 <= b(5);
			b4 <= b(4);
			b3 <= b(3);
			b2 <= b(2);
			b1 <= b(1);
			b0 <= b(0);
			in0 <= op_code(0);
			in1 <= op_code(1);

			wait for 10 ns ;
			--this is for the computation of the output by the circuit
			
			--to_check = bitvec_to_str(y);

			if(not (y = expected_output)) then
				write(g,bitvec_to_str(a));
				write(g,bitvec_to_str(b));
				write(g,bitvec_to_str(op_code));
				write(g,bitvec_to_str(y));
				write(g,bitvec_to_str(expected_output));
				write(g,"\n");
				error_flag <= '1';
			end if;

			assert (y = expected_output)
				report "Error"
				severity error;
			
		end loop ;

		assert (error_flag = '0') report "Test completed. Errors present. See error_log.txt"
			severity error;
		assert (error_flag = '1') report "Test completed. Successful!!!"
			severity note;
		wait ;
	end process ;
	dut : ALU port map (a7 => a7,
			a6 => a6,
			a5 => a5,
			a4 => a4,
			a3 => a3,
			a2 => a2,
			a1 => a1,
			a0 => a0,
			b7 => b7,
			b6 => b6,
			b5 => b5,
			b4 => b4,
			b3 => b3,
			b2 => b2,
			b1 => b1,
			b0 => b0,
			in0 => in0,
			in1 => in1,
			y7 => y(7),
			y6 => y(6),
			y5 => y(5),
			y4 => y(4),
			y3 => y(3),
			y2 => y(2),
			y1 => y(1),
			y0 => y(0));
			
end Behave ;
