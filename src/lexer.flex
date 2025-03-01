%option nounput noinput

%{
#ifdef FLEXALONE 
  enum Return_Token_Values { TOKEN_IDENT = 1000, TOKEN_NEWLINE = '\n', TOKEN_ASSIGN = 2000 };
#else            
  #include "yyparse.h"  
#endif
%}

%%
":="        { return TOKEN_ASSIGN; }
[a-zA-Z]   { return TOKEN_IDENT; }
[ \t]+     ;   /* Ignorer espaces et tabulations */
\n          { return TOKEN_NEWLINE; }
.           { return yytext[0]; }
%%

int yywrap(void) { return 1; }
#ifdef FLEXALONE 
int main(int argc, char *argv[]) { while (yylex()!=0); return 0; }
#endif

