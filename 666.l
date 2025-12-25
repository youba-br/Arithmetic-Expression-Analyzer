%{
#include "666.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

DIGIT   [0-9]
INT     {DIGIT}+
FLOAT   {DIGIT}+"."{DIGIT}+

%%

{FLOAT}    { yylval.fval = atof(yytext); return FLOAT; }
{INT}      { yylval.ival = atoi(yytext); return INT; }

"+"        { return '+'; }
"-"        { return '-'; }
"*"        { return '*'; }
"/"        { return '/'; }
"("        { return '('; }
")"        { return ')'; }

[ \t\n]+   ;

.          {
              printf("Lexical error: invalid character '%s'\n", yytext);
              exit(1);
            }

%%

int yywrap(void) {
    return 1;
}
