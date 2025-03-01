%option nounput noinput

%{
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
			    TOKEN_COMMA, 
			    TOKEN_NEWLINE,
			    TOKEN_NUMBER,  
			    TOKEN_IDENT    
    			   }
    
#else            
  #include "yyparse.h"  
#endif
%}

%%
"union"     { printf("token union %s \n", yytext); return TOKEN_UNION; }
"inter"     { printf("token inter %s \n", yytext); return TOKEN_INTER; }
"comp"      { printf("token comp %s \n", yytext); return TOKEN_COMP; }
"diff"      { printf("token diff %s \n", yytext); return TOKEN_DIFF; }
"card"      { printf("token card %s \n", yytext); return TOKEN_CARD; }
":="        { printf("token assign %s \n", yytext); return TOKEN_ASSIGN; }
[a-zA-Z][a-zA-Z0-9]*    { printf("token ident %s \n", yytext); return TOKEN_IDENT; }
"{"         { printf("token lbrace %s \n", yytext); return TOKEN_LBRACE; }
"}"         { printf("token rbrace %s \n", yytext); return TOKEN_RBRACE; }
[1-9]|[1-5][0-9]|6[0-3] { 
    yylval.num = atoi(yytext); 
    return TOKEN_NUMBER; 
}
","         { return TOKEN_COMMA; }
[ \t]+     ;   /* Ignorer espaces et tabulations */
\n          { return TOKEN_NEWLINE; }
.           { return yytext[0]; }
%%

int yywrap(void) { return 1; }
#ifdef FLEXALONE 
int main(int argc, char *argv[]) { while (yylex()!=0); return 0; }
#endif

