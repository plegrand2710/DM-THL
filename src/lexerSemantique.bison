%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdint.h>
    
    #define MAX_VARS 26  // Stockage des ensembles de A à Z
    
    typedef uint64_t Ensemble;  // Un ensemble est représenté par un uint64_t (64 bits)
    Ensemble symbol_table[MAX_VARS] = {0};  // Table des symboles
    
    void printError(const char *message); 
    void printSet(Ensemble e);  // Fonction pour afficher un ensemble
    
    %}
    
    %union {
        int num;     
        char id;
        Ensemble set;
    }
    
    /* Déclaration des tokens */
    %token TOKEN_IDENT TOKEN_NEWLINE TOKEN_ASSIGN TOKEN_LBRACE TOKEN_COMMA TOKEN_RBRACE
    %token TOKEN_UNION TOKEN_INTER TOKEN_COMP TOKEN_DIFF TOKEN_CARD TOKEN_NUMBER
    
    %type <set> ensemble expression
    %type <num> liste_nombres
    %type <id> TOKEN_IDENT
    %token <num> TOKEN_NUMBER
    
    %%
    
    input:
        /* vide */
        | input expression TOKEN_NEWLINE
        | input error TOKEN_NEWLINE { 
            printError("Erreur ignorée, passage à la ligne suivante."); 
            yyerrok; 
            yyclearin;
        }
        ;
    
    expression:
        TOKEN_IDENT TOKEN_ASSIGN ensemble { 
            symbol_table[$1 - 'A'] = $3; 
            printf("%c = ", $1); 
            printSet($3);
        }
        | TOKEN_IDENT TOKEN_ASSIGN TOKEN_CARD ensemble { 
            printError("Erreur : Impossible d'affecter une valeur numérique à un ensemble.");
            YYABORT;
        }
        | TOKEN_CARD ensemble { 
            printf("Cardinalité = %d\n", __builtin_popcountll($2));
        }
        | ensemble TOKEN_UNION ensemble { 
            $$ = $1 | $3;
        }
        | ensemble TOKEN_INTER ensemble { 
            $$ = $1 & $3;
        }
        | ensemble TOKEN_COMP ensemble { 
            $$ = $1 ^ $3;
        }
        | ensemble TOKEN_DIFF ensemble { 
            $$ = $1 & ~$3;
        }
        ;
    
    ensemble:
        TOKEN_LBRACE liste_nombres TOKEN_RBRACE { 
            $$ = $2;
        }
        | TOKEN_IDENT { 
            $$ = symbol_table[$1 - 'A']; 
        }
        ;
    
    liste_nombres:
        TOKEN_NUMBER { 
            $$ = 1ULL << ($1 - 1);  // Active le bit correspondant à $1
        }
        | liste_nombres TOKEN_COMMA TOKEN_NUMBER { 
            $$ = $1 | (1ULL << ($3 - 1));
        }
        ;
    
    %%
    
    void printError(const char *message) {
        fprintf(stderr, "❌ %s\n", message);
    }
    
    void printSet(Ensemble e) {
        printf("{");
        int first = 1;
        for (int i = 1; i <= 63; i++) {
            if (e & (1ULL << (i - 1))) {
                if (!first) printf(", ");
                printf("%d", i);
                first = 0;
            }
        }
        printf("}\n");
    }
    
    int main(void) { return yyparse(); }