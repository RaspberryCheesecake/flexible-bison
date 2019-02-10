%{
	#include <iostream>
	using namespace std;
	extern int yylex();
		
	int nCurrentLine = 0;
%}

%option noyywrap

%%

[\n]				{ nCurrentLine += 1; }
[0-9]+\[0-9]+		{ cout << "Found a floating point number: " << yytext << endl; }
M30					{ cout << "End of file! " << nCurrentLine << " lines in total." << endl; }

%%

int main(int, char**) {
	// lex through the input
	while(yylex());
}
