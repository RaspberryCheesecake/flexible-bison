%{
	#include <iostream>
	using namespace std;
	
	// Declare stuff Bison needs to know about
	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	
	const char* fname = "Example.gcode";
	
	void yyerror(const char *s);
%}

// This is Bison! Bison works by asking Flex to get the next token for it
// That returns as an object of type `yystype`
// Initially, by default, `yystype` is just a typedef of 'int'
// But tokens could be any arbitrary data type, so we have to
// override yystype's default typedef to be a C union instead. Unions
// can hold all of the types of tokens flex could return, which means
// we can return ints, floats, strings, etc. Bison does this with:
%union {
	int ival;
	float fval;
	char * sval;
}

// Define token types I will use (CAPS convention)
// and associate them with a field of the union above
%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING

// Define the constant string tokens
%token END

%%
// Here's where the grammar lives

gcode:
	body end {
		cout << "Done parsing file!"<< endl;
	}

body:
	FLOAT {
		cout << "Found float: " << $1 << endl;
	}
	| STRING {
		cout << "Found string: " << $1 << endl;
		free($1);  // string needs to be free'd
	}
	| INT {
		cout << "Found int: " << $1 << endl;
	}

end:
	END {
		cout << "Reached end" << endl;
	}
	

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
	
	// parse through the input
	yyparse();
	
}

void yyerror(const char *s) {
	cout << "Eek, parse error! Message: " << s << endl;
	// Might as well halt now
	exit(-1);
}
