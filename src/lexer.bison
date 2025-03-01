%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int yylex(void);
%}

%token TOKEN_IDENT
%token TOKEN_NEWLINE
%token TOKEN_ASSIGN

%%

input:
      /* vide */
    | input expression TOKEN_NEWLINE
    ;

expression:
    TOKEN_IDENT { printf("Expression syntaxiquement correcte.\n"); }
  | TOKEN_IDENT TOKEN_ASSIGN { printf("Assignment expression syntaxiquement correcte.\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}


