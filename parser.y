%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "vm.h"

extern int yylex();
extern int yylineno;
extern FILE *yyin;
void yyerror(const char *s);

int parse_errors = 0;
VMState vm;
%}

%union {
    int num;
    char *str;
    void *cond;
}

%token <num> NUMBER
%token <str> ID
%token <str> STRING_LITERAL

%token TAKEOFF LAND SET GOTO WAIT SECONDS PRINT
%token IF ELSE WHILE
%token SPEED_PARAM ALTITUDE_PARAM HEADING_PARAM
%token EQ NEQ GT LT GE LE

%type <cond> Condition
%type <str> Comparable Comparator Parameter
%type <num> Value

%%

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
    | ';'
    ;

TakeoffStmt:
      TAKEOFF ';' { vm_execute_takeoff(&vm); }
    ;

LandStmt:
      LAND ';' { vm_execute_land(&vm); }
    ;

SetStmt:
      SET Parameter '=' Value ';' {
        if (strcmp($2, "speed") == 0) vm_execute_set_speed(&vm,$4);
        else if (strcmp($2, "altitude") == 0) vm_execute_set_altitude(&vm,$4);
        else if (strcmp($2, "heading") == 0) vm_execute_set_heading(&vm,$4);
      }
    ;

GotoStmt:
      GOTO ID ';' {
        int x=0,y=0;
        sscanf($2,"%d,%d",&x,&y);
        vm_execute_goto(&vm,x,y);
      }
    ;

WaitStmt:
      WAIT NUMBER SECONDS ';' { printf("Waiting %d seconds\n",$2); }
    ;

PrintStmt:
      PRINT STRING_LITERAL ';' { printf("%s\n",$2); vm_execute_print(&vm); }
    ;

Conditional:
      IF '(' Condition ')' '{' Program '}' OptElse
    ;

OptElse:
      /* vazio */
    | ELSE '{' Program '}'
    ;

Loop:
      WHILE '(' Condition ')' '{' Program '}' {
        while(vm_compare(&vm, ((Cond*)$3)->param, ((Cond*)$3)->op, ((Cond*)$3)->value)) {
            yyparse();
        }
      }
    ;

Condition:
      Comparable Comparator Value {
        Cond *c = malloc(sizeof(*c));
        c->param = $1;
        c->op = $2;
        c->value = $3;
        $$ = (void*)c;
      }
    ;

Comparable:
    ID { $$ = $1; }
    | Parameter { $$ = $1; }
    ;

Comparator:
      EQ { $$="=="; }
    | NEQ { $$="!="; }
    | LT { $$="<"; }
    | GT { $$=">"; }
    | LE { $$="<="; }
    | GE { $$=">="; }
    ;

Parameter:
      SPEED_PARAM { $$ = strdup("speed"); }
    | ALTITUDE_PARAM { $$ = strdup("altitude"); }
    | HEADING_PARAM { $$ = strdup("heading"); }
    ;

Value:
      NUMBER { $$=$1; }
    | ID { $$=0; }
    | STRING_LITERAL { $$=0; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr,"Erro sintático linha %d: %s\n",yylineno,s);
    parse_errors=1;
}

int main(int argc,char **argv){
    if(argc>1){
        FILE *f=fopen(argv[1],"r");
        if(!f){perror("fopen");return 1;}
        yyin=f;
    }
    if(yyin==NULL) yyin=stdin;
    vm_init(&vm);
    parse_errors=0;
    yyparse();
    if(parse_errors==0){
        printf("\nPrograma válido (análise + execução OK).\n");
        return 0;
    } else {
        printf("\nPrograma inválido.\n");
        return 2;
    }
}
