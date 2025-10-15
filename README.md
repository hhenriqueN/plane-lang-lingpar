# PlaneLang — Linguagem de Missões de Voo
```ebnf
(* Programa principal *)
program         = { statement } ;

(* Declarações e instruções *)
statement       = takeoff_stmt
                | land_stmt
                | set_stmt
                | goto_stmt
                | wait_stmt
                | print_stmt
                | conditional
                | loop
                | ";" ;

(* Comandos básicos de voo *)
takeoff_stmt    = "takeoff" ";" ;
land_stmt       = "land" ";" ;
set_stmt        = "set" parameter "=" value ";" ;
goto_stmt       = "goto" identifier ";" ;
wait_stmt       = "wait" number "seconds" ";" ;
print_stmt      = "print" string ";" ;

(* Condicional *)
conditional     = "if" "(" condition ")" "{" { statement } "}"
                  [ "else" "{" { statement } "}" ] ;

(* Loop *)
loop            = "while" "(" condition ")" "{" { statement } "}" ;

(* Expressões e condições *)
condition       = identifier comparator value ;
comparator      = "==" | "!=" | "<" | ">" | "<=" | ">=" ;

parameter       = "speed" | "altitude" | "heading" ;

value           = number | identifier | string ;

(* Identificadores e valores *)
identifier      = letter { letter | digit | "_" } ;
number          = digit { digit } ;
string          = '"' { any_character - '"' } '"' ;

(* Tokens básicos *)
letter          = "A".."Z" | "a".."z" ;
digit           = "0".."9" ;

(* Comentários iniciam com // até o fim da linha *)

```

Recursos da PlaneLang
Comandos principais

takeoff; → decola o avião

land; → pousa o avião

set param = valor; → ajusta parâmetros do voo

parâmetros: speed, altitude, heading

exemplo: set speed = 250;

Controle de fluxo

Condicional:
```
if (altitude > 5000) {
    print "Altitude de cruzeiro atingida";
} else {
    print "Subindo...";
}

```

Loop:

```
while (altitude < 10000) {
    set altitude = altitude + 500;
    wait 5 seconds;
}

```
Funções da VM do avião:

takeoff()	Inicia o voo
land()	Finaliza o voo
set speed = X;	Ajusta a velocidade
set altitude = X;	Ajusta a altitude
set heading = X;	Ajusta o rumo/proa
goto WP1;	Direciona o avião para um waypoint nomeado
wait N seconds;	Simula passagem de tempo
print "texto";	Exibe informações no console

Exemplo de programa completo PlaneLang

```
set speed = 0;
set altitude = 0;

takeoff;

while (altitude < 5000) {
    set altitude = altitude + 500;
    set speed = speed + 50;
    wait 5 seconds;
    print "Subindo... Altitude: " + altitude;
}

if (speed > 300) {
    print "Reduzindo velocidade";
    set speed = speed - 50;
}

goto WP1;
print "Chegamos ao waypoint principal";

land;

```
