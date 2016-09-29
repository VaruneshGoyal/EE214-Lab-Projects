entity leftShift8 is
	port (x0, x1,x2,x3,x4,x5,x6,x7,a0,a1,a2,a3,a4,a5,a6,a7: in bit;
		y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
end entity;
architecture one of leftShift8 is
begin
	y0<= x0 and a0;
	y1<= (x1 and a0) or (x0 and a1);
	y2<= (x2 and a0) or (x1 and a1) or (x0 and a2);
	y3<= (x3 and a0) or (x2 and a1) or (x1 and a2) or (x0 and a3);
	y4<= (x4 and a0) or (x3 and a1) or (x2 and a2) or (x1 and a3) or (x0 and a4);
	y5<= (x5 and a0) or (x4 and a1) or (x3 and a2) or (x2 and a3) or (x1 and a4) or (x0 and a5);
	y6<= (x6 and a0) or (x5 and a1) or (x4 and a2) or (x3 and a3) or (x2 and a4) or (x1 and a5) or (x0 and a6);
	y7<= (x7 and a0) or (x6 and a1) or (x5 and a2) or (x4 and a3) or (x3 and a4) or (x2 and a5) or (x1 and a6) or (x0 and a7); 
end one;
