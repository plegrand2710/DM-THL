#ifndef LEXER_H
#define LEXER_H

#include <stdio.h>
#include <stdlib.h>

enum Token {
    TOKEN_ANY = 256, 
    TOKEN_UNKNOWN,
    TOKEN_ASSIGN,  // :=
    TOKEN_UNION,   // union
    TOKEN_INTER,   // inter
    TOKEN_COMP,    // comp
    TOKEN_DIFF,    // -
    TOKEN_CARD,    // card
    TOKEN_LBRACE,  // {
    TOKEN_RBRACE,  // }
    TOKEN_COMMA,   // ,
    TOKEN_NEWLINE, // \n
    TOKEN_NUMBER,  // 1-63
    TOKEN_IDENT    // A-Z ou a-z
};

typedef union {
    int num;       
    char ident[64];
} YYSTYPE;

extern YYSTYPE yylval;

int yylex(void);

#endif // LEXER_H
