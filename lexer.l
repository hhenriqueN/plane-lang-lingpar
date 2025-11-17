%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "vm.h"
#include "parser.tab.h"

// Função auxiliar para remover as aspas de um literal de string.
char *strip_quotes(char *text) {
    size_t len = strlen(text);
    if (len >= 2 && text[0] == '"' && text[len - 1] == '"') {
        char *content = strdup(text + 1);
        content[len - 2] = '\0';
        return content;
    }
    return strdup(text);
}
%}

%%
[ \t\r\n]+ { /* Ignora whitespaces */ }
"//".* { /* Ignora comentarios */ }

"takeoff" { return TAKEOFF; }
"land" { return LAND; }
"set" { return SET; }
"goto" { return GOTO; }
"wait" { return WAIT; }
"seconds" { return SECONDS; }
"print" { return PRINT; }

"if" { return IF; }
"else" { return ELSE; }
"while" { return WHILE; }

"speed" { return SPEED_PARAM; }
"altitude" { return ALTITUDE_PARAM; }
"heading" { return HEADING_PARAM; }

"==" { return EQ; }
"!=" { return NEQ; }
"<=" { return LE; }
">=" { return GE; }
"<" { return GT; }
">" { return LT; }

";" { return ';'; }
"=" { return '='; }
"(" { return '('; }
")" { return ')'; }
"{" { return '{'; }
"}" { return '}'; }

[0-9]+ { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9_]* {yylval.str = strdup(yytext); return ID; }
\"[^\"]*\" {yylval.str = strip_quotes(yytext); return STRING_LITERAL; }
. {fprintf(stderr, "Linha %d: caractere desconhecido: '%s'\n", yylineno, yytext); }
%%