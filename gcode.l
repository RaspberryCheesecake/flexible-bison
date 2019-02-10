%{
	#include <iostream>
	using namespace std;
	extern int yylex();
		
	int nCurrentLine = 0;
	const char* fname = "Example.gcode";
%}

%option noyywrap

%%

[\n]				{ nCurrentLine += 1; }
[0-9]+\[0-9]+		{ cout << "Found a floating point number: " << yytext << endl; }
M30					{ cout << "End of file! " << nCurrentLine << " lines in total." << endl; }

%%

int main(int, char**) {
	// Instead of targeting STDIN, open a file handler to a file
	FILE* myfile = fopen(fname, "r");
	// make sure file is valid
	if (!myfile) {
		cout << "Woops, can't open file " << fname << endl;
		return(-1);
	}
	
	// All is well, set input to be from the file
	yyin = myfile;
	
	// lex through the input
	while(yylex());
}
