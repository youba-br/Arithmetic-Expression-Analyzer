%{
#include "999.tab.h"
#include <stdlib.h>
%}

DIGIT   [0-9]
INTNUM  {DIGIT}+
FLOATNUM {DIGIT}+"."{DIGIT}+

%%

"somme"       { return SOMME; }
"produit"     { return PRODUIT; }
"moyenne"     { return MOYENNE; }
"variance"    { return VARIANCE; }
"ecart_type"  { return ECART_TYPE; }

{FLOATNUM}    { yylval.dval = atof(yytext); return FLOAT; }
{INTNUM}      { yylval.dval = atof(yytext); return INT; }

"+"           return '+';
"-"           return '-';
"*"           return '*';
"/"           return '/';
"("           return '(';
")"           return ')';
","           return ',';

[ \t\n]+      ;
.             { printf("Lexical error: %s\n", yytext); }

%%

int yywrap(void) { return 1; }
