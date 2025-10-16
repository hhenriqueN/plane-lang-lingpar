%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern FILE *yyin;
void yyerror(const char *s);

int parse_errors = 0;
%}

%union {
    int num;
    char *str;
}

/* Tokens de literais */
%token <num> NUMBER
%token <str> ID
%token <str> STRING_LITERAL

/* Tokens de comandos */
%token TAKEOFF LAND SET GOTO WAIT SECONDS PRINT

/* Tokens de controle de fluxo */
%token IF ELSE WHILE

/* Tokens de parâmetros */
%token SPEED_PARAM ALTITUDE_PARAM HEADING_PARAM

/* Tokens de comparadores */
%token EQ NEQ GT LT GE LE

/* Tokens de caracteres simples: ';', '=', '(', ')', '{', '}' */

%%

/* GRAMÁTICA */

Program:
      /* vazio */
    | Program Statement
    ;

Statement:
      TakeoffStmt
    | LandStmt
    | SetStmt
    | GotoStmt
    | WaitStmt
    | PrintStmt
    | Conditional
    | Loop
    | ';' /* Permite ponto e vírgula solto ou declarações vazias */
    ;

/* Comandos básicos de voo */
TakeoffStmt:
      TAKEOFF ';'
    ;

LandStmt:
      LAND ';'
    ;

SetStmt:
      SET Parameter '=' Value ';' /* set parameter = value ; */
    ;

GotoStmt:
      GOTO ID ';' /* goto identifier ; */
    ;

WaitStmt:
      WAIT NUMBER SECONDS ';' /* wait number seconds ; */
    ;

PrintStmt:
      PRINT STRING_LITERAL ';' /* print string ; */
    ;

/* Condicional */
Conditional:
      IF '(' Condition ')' '{' Program '}' OptElse
    ;

OptElse:
      /* vazio */
    | ELSE '{' Program '}'
    ;

/* Loop */
Loop:
      WHILE '(' Condition ')' '{' Program '}'
    ;

/* Expressões e condições */

Condition:
      Comparable Comparator Value
    ;

Comparable:
    ID
    | Parameter
    ;

Comparator:
      EQ
    | NEQ
    | LT
    | GT
    | LE
    | GE
    ;

Parameter:
      SPEED_PARAM
    | ALTITUDE_PARAM
    | HEADING_PARAM
    ;

Value:
      NUMBER
    | ID
    | STRING_LITERAL
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático na linha %d: %s\n", yylineno, s);
    parse_errors = 1;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror("fopen"); return 1; }
        yyin = f;
    }
    
    // Configura o yyin para stdin se nenhum arquivo for fornecido
    if (yyin == NULL) {
        yyin = stdin;
    }

    parse_errors = 0;
    yyparse();
    if (parse_errors == 0) {
        printf("\nPrograma valido (analise lexica + sintatica OK).\n");
        return 0;
    } else {
        printf("\nPrograma invalido (erros sintaticos encontrados).\n");
        return 2;
    }
}
