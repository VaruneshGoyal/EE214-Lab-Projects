entity XOR1 is
	port(a,b : in bit;
		c: out bit);
end entity;
architecture one of XOR1 is
begin
	c<= ((not a) and b) or ((not b) and a);
end one;
