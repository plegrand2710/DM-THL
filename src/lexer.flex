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
":="        { return TOKEN_ASSIGN; }
[a-zA-Z]   { return TOKEN_IDENT; }
"{"         { return TOKEN_LBRACE; }
"}"         { return TOKEN_RBRACE; }
[1-9]|[1-5][0-9]|6[0-3] { 
    printf("TOKEN_NUMBER: %s\n", yytext); 
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

