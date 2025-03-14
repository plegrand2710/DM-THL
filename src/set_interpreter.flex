%option nounput noinput

%{
#include "../include/proto-color.h"
#include "ensemble.h"
#ifdef FLEXALONE 
YYSTYPE yylval;
  enum Return_Token_Values {TOKEN_ANY = 1000, 
			    TOKEN_UNKNOWN,
			    TOKEN_ASSIGN,  
			    TOKEN_UNION,  
			    TOKEN_INTER,
			    TOKEN_COMP,  
			    TOKEN_DIFF,  
			    TOKEN_CARD,   
			    TOKEN_LBRACE,  
			    TOKEN_RBRACE, 
			    TOKEN_LPARANT,  
			    TOKEN_RPARANT, 
			    TOKEN_COMMA, 
			    TOKEN_NEWLINE,
			    TOKEN_NUMBER,  
			    TOKEN_IDENT    
    			   }
    
#else            
  #include "yyparse.h"  
#endif

void printError(const char *msg) {
    fprintf(stderr, RED("Erreur lexicale : %s\n"), msg);
}
%}

%%
"union"     { /*printf("TOKEN_UNION %s \n", yytext);*/ return TOKEN_UNION; }
"inter"     { /*printf("TOKEN_INTER %s \n", yytext);*/ return TOKEN_INTER; }
"comp"      { /*printf("TOKEN_COMP %s \n", yytext);*/ return TOKEN_COMP; }
"-"      { /*printf("TOKEN_DIFF %s \n", yytext);*/ return TOKEN_DIFF; }
"card"      { /*printf("TOKEN_CARD %s \n", yytext);*/ return TOKEN_CARD; }
":="        { /*printf("TOKEN_ASSIGN %s \n", yytext);*/ return TOKEN_ASSIGN; }
[a-zA-Z][a-zA-Z0-9]* { 
    yylval.id = strdup(yytext); 
    /*printf("TOKEN_IDENT %s \n", yytext);*/
    return TOKEN_IDENT; 
}

"{"         { /*printf("TOKEN_LBRACE %s \n", yytext);*/ return TOKEN_LBRACE; }
"}"         { /*printf("TOKEN_RBRACE %s \n", yytext);*/ return TOKEN_RBRACE; }
"("         { /*printf("TOKEN_LPARANT %s \n", yytext);*/ return TOKEN_LPARANT; }
")"         { /*printf("TOKEN_RPARANT %s \n", yytext);*/ return TOKEN_RPARANT; }
[1-9]|[1-5][0-9]|6[0-3] { 
    /*printf("TOKEN_NUMBER %s \n", yytext);*/
    yylval.num = atoi(yytext); 
    return TOKEN_NUMBER; 
}
","         { /*printf("TOKEN_COMMA %s \n", yytext);*/ return TOKEN_COMMA; }
[ \t]+     ;   
\n          { /*printf("TOKEN_NEWLINE %s \n", yytext);*/ return TOKEN_NEWLINE; }
.           { printError(yytext); return yytext[0]; }
%%

int yywrap(void) { return 1; }
#ifdef FLEXALONE 
int main(int argc, char *argv[]) { while (yylex()!=0); return 0; }
#endif

