%option nounput noinput

%{
#include "lexer.h"
%}

%%
[a-z]*    echo("ANY"); return(ANY);

        echonl();    return(yytext[0]);
.         echo("UNK"); return(UNK);
%%

int yywrap (void) { return 1; }

#ifdef FLEXALONE
int main(int argc, char *argv[]) {
    while (yylex() != 0);
    return 0;
}
#endif
