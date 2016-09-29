#include <iostream>
using namespace std;

#define input_pins 7
#define output_pins 1
string mask="F";
string x,y;

char dec_to_hex(int a){
	if(a==0) return '0';
	else if(a==1) return '1';
	else if(a==2) return '2';
	else if(a==3) return '3';
	else if(a==4) return '4';
	else if(a==5) return '5';
	else if(a==6) return '6';
	else if(a==7) return '7';
	else if(a==8) return '8';
	else if(a==9) return '9';
	else if(a==10) return 'A';
	else if(a==11) return 'B';
	else if(a==12) return 'C';
	else if(a==13) return 'D';
	else if(a==14) return 'E';
	else if(a==15) return 'F';
	return 0;
}

string binstr_to_hex(string binstr){
	string x;
	while((binstr.length()%4)!=0) binstr.insert(0,1,'0');
	int num=0;
	int k;
	for(int i=0; i<binstr.length(); i++){
		if(binstr[i]=='0') k = 0;
		else k = 1;

		if(i%4==3){
			num+=k;
			x.push_back(dec_to_hex(num));
			num=0;
		}
		else if(i%4==2){
			num+=k*2;
		}
		else if(i%4==1){
			num+=k*4;
		}
		else if(i%4==0){
			num+=k*8;
		}
	}
	return x;
}

int count=1;

int main(){
	while(cin>>x){
		cin>>y;
		cout<<"# @t"<<count++<<endl;
		cout<<"SDR "<<input_pins<<" TDI(";
			cout<<binstr_to_hex(x);
		cout<<") "<<output_pins<<" TDO(";
			cout<<binstr_to_hex(y);
		cout<<") MASK("<<mask<<")";
		cout<<endl;
		cout<<"RUNTEST 1 MSEC"<<endl;
	}

	return 0;
}
