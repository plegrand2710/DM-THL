#ifndef LEXER_H
#define LEXER_H

#include <stdio.h>

/* Définition des tokens */
#ifdef FLEXALONE
enum Return_Token_Values { ANY=1000, UNK };
#endif

/* Prototypes */
void echo(char *lex_cat);
void echonl();

#endif /* LEXER_H */
