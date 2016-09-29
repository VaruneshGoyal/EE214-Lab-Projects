entity rightShift8 is
	port (x7,x6,x5,x4,x3,x2,x1,x0,a0,a1,a2,a3,a4,a5,a6,a7: in bit;
		y7,y6,y5,y4,y3,y2,y1,y0 : out bit);
end entity;
architecture one of rightShift8 is
begin
	y7<= x7 and a0;
	y6<= (x6 and a0) or (x7 and a1);
	y5<= (x5 and a0) or (x6 and a1) or (x7 and a2);
	y4<= (x4 and a0) or (x5 and a1) or (x6 and a2) or (x7 and a3);
	y3<= (x3 and a0) or (x4 and a1) or (x5 and a2) or (x6 and a3) or (x7 and a4);
	y2<= (x2 and a0) or (x3 and a1) or (x4 and a2) or (x5 and a3) or (x6 and a4) or (x7 and a5);
	y1<= (x1 and a0) or (x2 and a1) or (x3 and a2) or (x4 and a3) or (x5 and a4) or (x6 and a5) or (x7 and a6);
	y0<= (x0 and a0) or (x1 and a1) or (x2 and a2) or (x3 and a3) or (x4 and a4) or (x5 and a5) or (x6 and a6) or (x7 and a7); 
end one;
