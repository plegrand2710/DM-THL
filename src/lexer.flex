%option nounput noinput

%{
#include "../include/lexer.h"
YYSTYPE yylval;

void printError(const char *msg) {
    fprintf(stderr, "Erreur lexicale : %s\n", msg);
}
%}

%%
[ \t\r]+    ;  // Ignore les espaces et tabulations
"#".*       ;  // Ignore les commentaires commençant par #

"union"     { printf("TOKEN_UNION\n"); return TOKEN_UNION; }
"inter"     { printf("TOKEN_INTER\n"); return TOKEN_INTER; }
"comp"      { printf("TOKEN_COMP\n"); return TOKEN_COMP; }
"-"         { printf("TOKEN_DIFF\n"); return TOKEN_DIFF; }
"card"      { printf("TOKEN_CARD\n"); return TOKEN_CARD; }

":="        { printf("TOKEN_ASSIGN\n"); return TOKEN_ASSIGN; }

"{"         { printf("TOKEN_LBRACE\n"); return TOKEN_LBRACE; }
"}"         { printf("TOKEN_RBRACE\n"); return TOKEN_RBRACE; }
","         { printf("TOKEN_COMMA\n"); return TOKEN_COMMA; }
"\n"        { printf("TOKEN_NEWLINE\n"); return TOKEN_NEWLINE; }

[a-zA-Z] { printf("TOKEN_IDENT: %s\n", yytext); yylval.ident[0] = yytext[0]; yylval.ident[1] = '\0'; return TOKEN_IDENT; }

[1-9]      { printf("TOKEN_NUMBER: %s\n", yytext); yylval.num = atoi(yytext); return TOKEN_NUMBER; }
[1-5][0-9] { printf("TOKEN_NUMBER: %s\n", yytext); yylval.num = atoi(yytext); return TOKEN_NUMBER; }
6[0-3]     { printf("TOKEN_NUMBER: %s\n", yytext); yylval.num = atoi(yytext); return TOKEN_NUMBER; }

. { printError(yytext); return TOKEN_UNKNOWN; }
%%

int yywrap (void) { return 1; }

#ifdef FLEXALONE
int main(int argc, char *argv[]) {
    while (yylex() != 0);
    return 0;
}
#endif
