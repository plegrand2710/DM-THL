%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../include/proto-color.h"

extern int yylex(); 
extern char *yytext;

void printError(const char *message); 
int yyerror (char const *message) { 
  fprintf(stderr, BLUE("❌ <%s>\n"), message);
  return 0;
}
%}

%error-verbose

%right TOKEN_ASSIGN
%left TOKEN_UNION
%left TOKEN_INTER
%left TOKEN_COMP
%left TOKEN_DIFF
%right TOKEN_CARD

%token TOKEN_IDENT
%token TOKEN_NEWLINE
%token TOKEN_ASSIGN
%token TOKEN_LBRACE
%token TOKEN_COMMA
%token TOKEN_RPARANT
%token TOKEN_LPARANT
%token TOKEN_RBRACE
%token TOKEN_UNION 
%token TOKEN_INTER
%token TOKEN_COMP 
%token TOKEN_DIFF 
%token TOKEN_CARD

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
    | input error TOKEN_NEWLINE { 
        printf(REV("❌ Erreur ignorée, passage à la ligne suivante.\n")); 
        yyerrok; 
        yyclearin;
    }
    ;

expression:
    TOKEN_IDENT TOKEN_ASSIGN ensemble { 
        printf(GREEN("Expression d'assignation correcte.\n\n")); 
    }
    ;

ensemble:
    TOKEN_LBRACE liste_nombres TOKEN_RBRACE { 
        printf("Ensemble détecté.\n"); 
    }
    | ensemble TOKEN_UNION ensemble { 
        printf("Union détectée.\n"); 
    }
    | ensemble TOKEN_INTER ensemble { 
        printf("Intersection détectée.\n"); 
    }
    | ensemble TOKEN_COMP ensemble { 
        printf("Composition détectée.\n"); 
    }
    | ensemble TOKEN_DIFF ensemble { 
        printf("Différence détectée.\n"); 
    }
    | TOKEN_CARD ensemble { 
        printf("Cardinalité détectée.\n"); 
    }
    | TOKEN_LPARANT ensemble TOKEN_RPARANT { 
        printf("Parenthèses détectées.\n");
    }
    ;

liste_nombres:
    TOKEN_NUMBER { 
        printf("Nombre unique: %d\n", $1); 
    }
    | liste_nombres TOKEN_COMMA TOKEN_NUMBER { 
        printf("Ajout du nombre: %d\n", $3); 
    }
    ;

%%

