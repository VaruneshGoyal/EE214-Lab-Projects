entity mux21 is
	port(a,b,s : in bit;
		o : out bit);
end entity;
architecture one of mux21 is
begin
	o<=(a and (not s)) or (b and s);
end one;	
