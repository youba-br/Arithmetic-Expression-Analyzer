%code requires {
#include <math.h>



typedef struct {
    double vals[50];
    int count;
} arglist;
}







%{
#include <stdio.h>
#include <stdlib.h>


int yylex(void);
void yyerror(const char *s);


%}

%union {
    double dval;
    arglist alist;
}

%token <dval> INT FLOAT
%token SOMME PRODUIT MOYENNE VARIANCE ECART_TYPE

%type <dval> E T F
%type <alist> args

%left '+' '-'
%left '*' '/'

%%

input
    : E { printf("Result = %f\n", $1); }
    ;

E
    : E '+' T { $$ = $1 + $3; }
    | E '-' T { $$ = $1 - $3; }
    | T       { $$ = $1; }
    ;

T
    : T '*' F { $$ = $1 * $3; }
    | T '/' F {
                  if ($3 == 0) {
                      printf("Error: division by zero\n");
                      exit(1);
                  }
                  $$ = $1 / $3;
              }
    | F       { $$ = $1; }
    ;

F
    : INT     { $$ = $1; }
    | FLOAT   { $$ = $1; }
    | '(' E ')' { $$ = $2; }

    | SOMME '(' args ')' {
          double s = 0;
          for (int i = 0; i < $3.count; i++) s += $3.vals[i];
          $$ = s;
      }

    | PRODUIT '(' args ')' {
          double p = 1;
          for (int i = 0; i < $3.count; i++) p *= $3.vals[i];
          $$ = p;
      }

    | MOYENNE '(' args ')' {
          double s = 0;
          for (int i = 0; i < $3.count; i++) s += $3.vals[i];
          $$ = s / $3.count;
      }

    | VARIANCE '(' args ')' {
          double mean = 0, var = 0;
          for (int i = 0; i < $3.count; i++) mean += $3.vals[i];
          mean /= $3.count;
          for (int i = 0; i < $3.count; i++)
              var += pow($3.vals[i] - mean, 2);
          $$ = var / $3.count;
      }

    | ECART_TYPE '(' args ')' {
          double mean = 0, var = 0;
          for (int i = 0; i < $3.count; i++) mean += $3.vals[i];
          mean /= $3.count;
          for (int i = 0; i < $3.count; i++)
              var += pow($3.vals[i] - mean, 2);
          $$ = sqrt(var / $3.count);
      }
    ;

args
    : E {
          $$.vals[0] = $1;
          $$.count = 1;
      }
    | args ',' E {
          $$.vals[$1.count] = $3;
          $$.count = $1.count + 1;
      }
    ;

%%

void yyerror(const char *s) {
    printf("Syntax error\n");
}

int main(void) {
}
    yyparse();
    return 0;
}
