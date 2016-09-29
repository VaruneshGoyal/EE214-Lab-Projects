library work;
use work.ee214.all;
entity mux168 is
	port (a0,a1,a2,a3,a4,a5,a6,a7, 
		b0,b1,b2,b3,b4,b5,b6,b7, s: in bit;
		y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
end entity;
architecture one of mux168 is
begin
	bit0 : mux21 port map ( a=> a0, b=> b0, s=>s, o=>y0); 
	bit1 : mux21 port map ( a=> a1, b=> b1, s=>s, o=>y1); 
	bit2 : mux21 port map ( a=> a2, b=> b2, s=>s, o=>y2); 
	bit3 : mux21 port map ( a=> a3, b=> b3, s=>s, o=>y3); 
	bit4 : mux21 port map ( a=> a4, b=> b4, s=>s, o=>y4); 
	bit5 : mux21 port map ( a=> a5, b=> b5, s=>s, o=>y5); 
	bit6 : mux21 port map ( a=> a6, b=> b6, s=>s, o=>y6); 
	bit7 : mux21 port map ( a=> a7, b=> b7, s=>s, o=>y7); 
end one;	
