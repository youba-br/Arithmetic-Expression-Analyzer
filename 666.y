%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}
%union {
    int ival;
    float fval;
}

%token <ival> INT
%token <fval> FLOAT

%type <fval> E T F

%left '+' '-'
%left '*' '/'

%%

input:
      E { printf("this expression is correct\n"); }
    ;

E:
      E '+' T { $$ = $1 + $3; }
    | E '-' T { $$ = $1 - $3; }
    | T       { $$ = $1; }
    ;

T:
      T '*' F { $$ = $1 * $3; }
    | T '/' F {
                  if ($3 == 0) {
                      printf("Error: division by zero\n");
                      exit(1);
                  }
                  $$ = $1 / $3;
              }
    | F       { $$ = $1; }
    ;

F:
      INT     { $$ = $1; }
    | FLOAT   { $$ = $1; }
    | '(' E ')' { $$ = $2; }
    ;
%%
void yyerror(const char *s) {
    printf("Syntax error: %s\n", s);
}

int main(void) {
    printf("Enter an arithmetic expression:\n");
    yyparse();
    return 0;
}
