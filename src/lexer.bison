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
%token TOKEN_LBRACE
%token TOKEN_COMMA
%token TOKEN_RBRACE

%union { 
    int num;     
    char* id;    
}

%type <num> liste_nombres
%token <num> TOKEN_NUMBER


%%

input:
      /* vide */
    | input expression TOKEN_NEWLINE
    ;

expression:
    TOKEN_IDENT { printf("Expression syntaxiquement correcte.\n"); }
    | TOKEN_IDENT TOKEN_ASSIGN { printf("Assignment expression syntaxiquement correcte.\n"); }
    | TOKEN_IDENT TOKEN_ASSIGN TOKEN_LBRACE { printf("Assignment accolade expression syntaxiquement correcte.\n"); }
    | TOKEN_IDENT TOKEN_ASSIGN TOKEN_LBRACE liste_nombres TOKEN_RBRACE{ printf("Assignment accolade liste de valeurs accolade syntaxiquement correcte.\n"); }
    ;

liste_nombres:
    TOKEN_NUMBER { printf("Nombre unique: %d\n", $1); }
    | liste_nombres TOKEN_COMMA TOKEN_NUMBER { printf("Ajout du nombre: %d\n", $3); }
    ;


%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}


