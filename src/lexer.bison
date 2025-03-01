%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int yylex(void);

extern char *yytext;
%}


%right TOKEN_UNION
%right TOKEN_INTER
%right TOKEN_COMP
%right TOKEN_DIFF
%right TOKEN_CARD

%token TOKEN_IDENT
%token TOKEN_NEWLINE
%token TOKEN_ASSIGN
%token TOKEN_LBRACE
%token TOKEN_COMMA
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
        printf("❌ Erreur ignorée, passage à la ligne suivante.\n"); 
        yyerrok; // Réinitialise l'état d'erreur
    }
    ;


expression:
    TOKEN_IDENT TOKEN_ASSIGN ensemble { printf("Expression d'assignation correcte.\n"); }
    | error TOKEN_NEWLINE { 
        printf("❌ Erreur détectée dans une expression, passage à la ligne suivante.\n"); 
        yyerrok;  // Réinitialisation de l'état d'erreur pour continuer
    }
    ;


ensemble:
    TOKEN_LBRACE liste_nombres TOKEN_RBRACE { printf("Ensemble détecté.\n"); }
    | ensemble TOKEN_UNION ensemble { printf("Union détectée.\n"); }
    | ensemble TOKEN_INTER ensemble { printf("Intersection détectée.\n"); }
    | ensemble TOKEN_COMP ensemble { printf("Composition détectée.\n"); }
    | ensemble TOKEN_DIFF ensemble { printf("Différence détectée.\n"); }
    | TOKEN_CARD ensemble { printf("Cardinalité détectée.\n"); }
    | TOKEN_DIFF ensemble { printf("Différence détectée.\n"); }
    | error TOKEN_NEWLINE { 
        printf("❌ Erreur détectée dans un ensemble, passage à la ligne suivante.\n"); 
        yyerrok;
    }
    ;


    
liste_nombres:
     TOKEN_NUMBER { printf("Nombre unique: %d\n", $1); }
    | liste_nombres TOKEN_COMMA TOKEN_NUMBER { printf("Ajout du nombre: %d\n", $3); }
    | liste_nombres TOKEN_COMMA TOKEN_IDENT { 
    printf("❌ Erreur: Identifiant '%s' trouvé dans un ensemble au lieu d'un nombre.\n", yytext); 
    yyerrok; 
}
    | liste_nombres TOKEN_COMMA error { 
        printf("❌ Erreur: Nombre manquant après une virgule.\n"); 
        yyerrok; 
    }
    ;



%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}



