library work;
use work.ee214.all;
entity eightBitAdder is
	port (a0,a1,a2,a3,a4,a5,a6,a7, 
		b0,b1,b2,b3,b4,b5,b6,b7, cin: in bit;
		y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
end entity;
architecture basic of eightBitAdder is 
	signal c1,c2,c3,c4,c5,c6,c7,random : bit;
begin
	
	
 	add0 : bitAdder port map ( x=> a0, y=> b0, cin=> cin, s=> y0, cout=>c1); 
	add1 : bitAdder port map ( x=> a1, y=> b1, cin=> c1, s=> y1, cout=>c2);
	add2 : bitAdder port map ( x=> a2, y=> b2, cin=> c2, s=> y2, cout=>c3);
	add3 : bitAdder port map ( x=> a3, y=> b3, cin=> c3, s=> y3, cout=>c4);
	add4 : bitAdder port map ( x=> a4, y=> b4, cin=> c4, s=> y4, cout=>c5);
	add5 : bitAdder port map ( x=> a5, y=> b5, cin=> c5, s=> y5, cout=>c6);
	add6 : bitAdder port map ( x=> a6, y=> b6, cin=> c6, s=> y6, cout=>c7);
	add7 : bitAdder port map ( x=> a7, y=> b7, cin=> c7, s=> y7, cout=>random);
	
end basic;
