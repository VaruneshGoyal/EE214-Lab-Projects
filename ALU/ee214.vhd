library std;
use std.standard.all;

package ee214 is
	component bitAdder is
		port (x, y, cin : in bit;
			s, cout : out bit);
	end component bitAdder;
	component eightBitAdder is
		port (a0,a1,a2,a3,a4,a5,a6,a7, 
			b0,b1,b2,b3,b4,b5,b6,b7, cin: in bit;
			y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
	end component eightBitAdder;
	component XOR1 is
		port (a, b: in bit;
			c : out bit);
	end component XOR1;
	component Demux38 is
	port(x0, x1,x2 : in bit;
		y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
	end component Demux38;
	component rightShift8 is
		port (x7,x6,x5,x4,x3,x2,x1,x0,a0,a1,a2,a3,a4,a5,a6,a7: in bit;
			y7,y6,y5,y4,y3,y2,y1,y0 : out bit);
	end component;
	component leftShift8 is
		port (x0, x1,x2,x3,x4,x5,x6,x7,a0,a1,a2,a3,a4,a5,a6,a7: in bit;
			y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
	end component;
	component mux21 is
		port(a,b,s : in bit;
		o : out bit);
	end component mux21;
	component mux168 is
		port (a0,a1,a2,a3,a4,a5,a6,a7, 
		b0,b1,b2,b3,b4,b5,b6,b7, s: in bit;
		y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
	end component;
end ee214;
