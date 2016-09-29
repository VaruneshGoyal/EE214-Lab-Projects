import string
f = open("outputs.txt",'w')
string=""
for i in range(256):
	for j in range(256):
		string=""
		string+='{:08b}'.format(i) + " " + '{:08b}'.format(j) + " " +"00"+ " " + '{:08b}'.format((i+j)%256) +"\n"
		f.write(string)

for i in range(256):
	for j in range(256):
		string=""
		string+='{:08b}'.format(i) + " " + '{:08b}'.format(j) + " " +"01"+ " " + '{:08b}'.format((i-j)%256) +"\n"
		f.write(string)

for i in range(256):
	for j in range(256):
		string=""
		string+='{:08b}'.format(i) + " " + '{:08b}'.format(j) + " " +"10"+ " " + '{:08b}'.format((i>>j)%256) +"\n"
		f.write(string)

for i in range(256):
	for j in range(256):
		string=""
		string+='{:08b}'.format(i) + " " + '{:08b}'.format(j) + " " +"11"+ " " + '{:08b}'.format((i<<j)%256) +"\n"
		f.write(string)
