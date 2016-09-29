entity Demux38 is
	port(x0, x1,x2 : in bit;
		y0,y1,y2,y3,y4,y5,y6,y7 : out bit);
end entity;
architecture one of Demux38 is
begin
	y0 <= (not x0) 	and (not x1) 	and (not x2);
	y1 <= (x0) 	and (not x1) 	and (not x2);
	y2 <= (not x0) 	and (x1) 	and (not x2);
	y3 <= (x0) 	and (x1) 	and (not x2);
	y4 <= (not x0) 	and (not x1) 	and (x2);
	y5 <= (x0) 	and (not x1) 	and (x2);
	y6 <= (not x0) 	and (x1) 	and (x2);
	y7 <= (x0) 	and (x1) 	and (x2);
end one;
