%{
#include <stdio.h>
#include <stdlib.h>
#include "../include/proto-color.h"

void yyerror(const char *s);
int yylex(void);
%}

%token TOKEN_NUMBER TOKEN_IDENT
%token TOKEN_UNION TOKEN_INTER TOKEN_COMP TOKEN_DIFF TOKEN_CARD
%token TOKEN_ASSIGN TOKEN_LBRACE TOKEN_RBRACE TOKEN_COMMA TOKEN_NEWLINE

%left TOKEN_UNION TOKEN_INTER TOKEN_DIFF
%right TOKEN_COMP TOKEN_CARD


%%

input:
     line
    | input line
    ;

line:
    expression TOKEN_NEWLINE { printf(GREEN("Expression syntaxiquement correcte.\n")); }
    | set_expr TOKEN_NEWLINE { printf(GREEN("Expression syntaxiquement correcte.\n")); }
    | error TOKEN_NEWLINE { yyerror("Erreur syntaxique"); yyerrok; }
    ;

    
expression:
    TOKEN_IDENT TOKEN_ASSIGN set_expr
    ;


set_expr:
    TOKEN_LBRACE set_elements TOKEN_RBRACE
    | set_expr TOKEN_UNION set_expr
    | set_expr TOKEN_INTER set_expr
    | set_expr TOKEN_DIFF set_expr
    | TOKEN_COMP set_expr
    | TOKEN_CARD set_expr
    | TOKEN_IDENT
    | '(' set_expr ')'  
    ;


set_elements:
    TOKEN_NUMBER
    | set_elements TOKEN_COMMA TOKEN_NUMBER
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur : %s \n", s);
}



