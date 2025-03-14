%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdint.h>
    
    #include "ensemble.h" 
    
    #define MAX_VARS 26 
        
    Ensemble symbol_table[MAX_VARS] = {0};  
    
    extern int yylex();
    extern char *yytext;
    void printSet(Ensemble e);  

    void printError(const char *message);

    int yyerror(const char *message) { 
        fprintf(stderr, "erreur : %s\n", message);
        return 0;
    }
    
    %}
    
    %union {
        int num;     
    	char* id;  
        Ensemble set;
    }
    
    %define parse.error verbose
    

    %token TOKEN_IDENT TOKEN_NEWLINE TOKEN_ASSIGN TOKEN_LBRACE TOKEN_COMMA TOKEN_RBRACE TOKEN_LPARANT TOKEN_RPARANT
    %token TOKEN_UNION TOKEN_INTER TOKEN_COMP TOKEN_DIFF TOKEN_CARD
    
    %type <set> ensemble expression
    %type <num> liste_nombres
    %type <id> TOKEN_IDENT
    %token <num> TOKEN_NUMBER
    
    %right TOKEN_ASSIGN     
    %left TOKEN_UNION       
    %left TOKEN_INTER     
    %left TOKEN_COMP       
    %left TOKEN_DIFF     


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
			int index = $1 ? $1[0] - 'A' : -1; 
			if (index < 0 || index >= MAX_VARS) {
				printf("Identificateur d'ensemble invalide %s (%d) !\n", $1 ? $1 : "NULL", index);
				yyerrok; 
		        yyclearin;
			}
			symbol_table[index] = $3; 
			printf("%s = ", $1 ? $1 : "NULL"); 
			printSet($3);
			if ($1) free($1); 
		}
        | TOKEN_IDENT TOKEN_ASSIGN TOKEN_CARD { 
		    printError("Erreur : Impossible d'affecter une valeur numérique à un ensemble.");
		    yyerrok; 
		    yyclearin;
		}
		| TOKEN_CARD ensemble { 
			int cardinality = 0;
			Ensemble tmp = $2;
			while (tmp) {
				cardinality += tmp & 1;
				tmp >>= 1;
			}
			printf("Cardinalité = %d\n", cardinality);
		}
        ;
    
ensemble:
    TOKEN_LBRACE liste_nombres TOKEN_RBRACE { 
        $$ = $2;
    }
    | TOKEN_IDENT { 
        int index = $1[0] - 'A'; 
        if (index < 0 || index >= MAX_VARS) {
            printError("Variable inconnue !");
            yyerrok; 
		    yyclearin;
        }
        $$ = symbol_table[index]; 
        if ($1) free($1);  
    }
    | ensemble TOKEN_UNION ensemble { 
        $$ = $1 | $3; 
        printf("Union détectée.\n");
    }
    | ensemble TOKEN_INTER ensemble { 
        $$ = $1 & $3;  
        printf("Intersection détectée.\n");
    }
    | ensemble TOKEN_COMP ensemble { 
        $$ = $1 ^ $3;  
        printf("Complémentaire détecté.\n");
    }
    | ensemble TOKEN_DIFF ensemble { 
        $$ = $1 & ~$3;  
        printf("Différence détectée.\n");
    }
    | TOKEN_LPARANT ensemble TOKEN_RPARANT { 
        $$ = $2;
        printf("Parenthèses respectées, application des priorités.\n");
    }
    ;

    
    liste_nombres:
        TOKEN_NUMBER { 
            $$ = 1ULL << ($1 - 1);
        }
        | liste_nombres TOKEN_COMMA TOKEN_NUMBER { 
            $$ = $1 | (1ULL << ($3 - 1));
        }
        | TOKEN_CARD TOKEN_IDENT {
		int index = $2[0] - 'A';
		if (index < 0 || index >= MAX_VARS || symbol_table[index] == 0) {
		    printError("Erreur : Utilisation de card sur un ensemble non défini.");
		    yyerrok; 
		    yyclearin;
		} else {
		    int cardinality = 0;
		    Ensemble tmp = symbol_table[index];
		    while (tmp) {
		        cardinality += tmp & 1;
		        tmp >>= 1;
		    }
		    $$ = 1ULL << (cardinality - 1);
		}
	    }
		| liste_nombres TOKEN_COMMA TOKEN_CARD TOKEN_IDENT {
		    int index = $4[0] - 'A';
		    if (index < 0 || index >= MAX_VARS || symbol_table[index] == 0) {
		        printError("Erreur : Utilisation de card sur un ensemble non défini.");
		        yyerrok; 
		    	yyclearin;
		    } else {
		        int cardinality = 0;
		        Ensemble tmp = symbol_table[index];
		        while (tmp) {
		            cardinality += tmp & 1;
		            tmp >>= 1;
		        }
		        $$ = $1 | (1ULL << (cardinality - 1));
		    }
		}
		;
        
    
    %%
    
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
        printf("}\n\n\n");
    }
   
