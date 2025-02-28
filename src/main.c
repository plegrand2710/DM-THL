#include <stdio.h>
#include "../include/lexer.h"
#include "../include/parser.h"
//#include "semantic.h"
//#include "exec.h"

int main() {
    printf("Interpréteur d'Expressions Ensemblistes\n");
    yyparse();
    return 0;
}
