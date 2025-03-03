#include <stdio.h>
#include "../include/lexer.h"
#include "../include/parser.h"
//#include "semantic.h"
//#include "exec.h"

int main() {
    yyparse();
    return 0;
}
