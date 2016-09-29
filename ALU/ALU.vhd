library work;
use work.ee214.all;
entity ALU is
	port (a0,a1,a2,a3,a4,a5,a6,a7, 
		b0,b1,b2,b3,b4,b5,b6,b7, in0, in1: in bit;
		y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
end entity;
architecture basic of ALU is 
	signal ad0,ad1,ad2,ad3,ad4,ad5,ad6,ad7,add_cin,o1,o2,o0,o3,o4,o5,o6,o7,for_shift,
		lsh0,lsh1,lsh2,lsh3,lsh4,lsh5,lsh6,lsh7,
		rsh0,rsh1,rsh2,rsh3,rsh4,rsh5,rsh6,rsh7,
		sh0,sh1,sh2,sh3,sh4,sh5,sh6,sh7,
		h0,h1,h2,h3,h4,h5,h6,h7,
		s0,s1,s2,s3,s4,s5,s6,s7 : bit;
begin
		--first to decide whether to add or subtract...deciding the initial cin
		add_cin <= (not in1) and in0;
		--now to change input to adder dependhing on cin...(takes 2s complement if required)
		xb0 : XOR1 port map (a=>b0, b=>add_cin, c=>ad0);
		xb1 : XOR1 port map (a=>b1, b=>add_cin, c=>ad1);
		xb2 : XOR1 port map (a=>b2, b=>add_cin, c=>ad2);
		xb3 : XOR1 port map (a=>b3, b=>add_cin, c=>ad3);
		xb4 : XOR1 port map (a=>b4, b=>add_cin, c=>ad4);
		xb5 : XOR1 port map (a=>b5, b=>add_cin, c=>ad5);
		xb6 : XOR1 port map (a=>b6, b=>add_cin, c=>ad6);
		xb7 : XOR1 port map (a=>b7, b=>add_cin, c=>ad7);

 		add : eightBitAdder port map (a0=>a0, a1=>a1,
					a2=>a2, a3=>a3,
					a4=>a4, a5=>a5,
					a6=>a6, a7=>a7,
					b0=>ad0, b1=>ad1,
					b2=>ad2, b3=>ad3,
					b4=>ad4, b5=>ad5,
					b6=>ad6, b7=>ad7,
					cin=>add_cin,
					y0=>o0, y1=>o1,
					y2=>o2, y3=>o3,
					y4=>o4, y5=>o5,
					y6=>o6, y7=>o7);
		--this completes both addition and subtraction 

 	
		--first use the demux
		demux : Demux38 port map(x0=>b0, x1=>b1, x2=>b2, 
					y0=>sh0, y1=>sh1, y2=>sh2, y3=>sh3, y4=>sh4, y5=>sh5, y6=>sh6, y7=>sh7);
		for_shift <= b3 or b4 or b5 or b6 or b7;
	
		
			--now for left shift...xis are input, ais are demux input, yis are output
			lefts : leftShift8 port map (x0=>a0, x1=>a1, x3=>a3, x2=>a2,x4=>a4,x5=>a5,x6=>a6, x7=>a7,
					a0=>sh0, a1=>sh1, a3=>sh3, a2=>sh2,a4=>sh4,a5=>sh5,a6=>sh6, a7=>sh7,
					y0=>lsh0,y1=>lsh1,y2=>lsh2,y3=>lsh3,y4=>lsh4,y5=>lsh5,y6=>lsh6,y7=>lsh7);
		
			--now for right shift
			rights : rightShift8 port map (x0=>a0, x1=>a1, x3=>a3, x2=>a2,x4=>a4,x5=>a5,x6=>a6, x7=>a7,
					a0=>sh0, a1=>sh1, a3=>sh3, a2=>sh2,a4=>sh4,a5=>sh5,a6=>sh6, a7=>sh7,
					y0=>rsh0,y1=>rsh1,y2=>rsh2,y3=>rsh3,y4=>rsh4,y5=>rsh5,y6=>rsh6,y7=>rsh7);
		
		mux1: mux168 port map (a0=>rsh0, a1=>rsh1, a3=>rsh3, a2=>rsh2,a4=>rsh4,a5=>rsh5,a6=>rsh6, a7=>rsh7,
					b0=>lsh0, b1=>lsh1, b3=>lsh3, b2=>lsh2,b4=>lsh4,b5=>lsh5,b6=>lsh6, b7=>lsh7,
					y0=>h0,y1=>h1,y2=>h2,y3=>h3,y4=>h4,y5=>h5,y6=>h6,y7=>h7,
					s=>in0);

		
		--if b>=8, output is zero always...
		s0<=(not for_shift) and h0;
		s1<=(not for_shift) and h1;
		s2<=(not for_shift) and h2;
		s3<=(not for_shift) and h3;
		s4<=(not for_shift) and h4;
		s5<=(not for_shift) and h5;
		s6<=(not for_shift) and h6;
		s7<=(not for_shift) and h7;

	finalmux: mux168 port map (a0=>o0, a1=>o1, a3=>o3, a2=>o2,a4=>o4,a5=>o5,a6=>o6, a7=>o7,
					b0=>s0, b1=>s1, b3=>s3, b2=>s2,b4=>s4,b5=>s5,b6=>s6, b7=>s7,
					y0=>y0,y1=>y1,y2=>y2,y3=>y3,y4=>y4,y5=>y5,y6=>y6,y7=>y7,
					s=>in1);	


	
end basic;
