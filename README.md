# plane-lang-lingpar
```ebnf
(* Programa principal *)
program         = { statement } ;

(* Declarações e instruções *)
statement       = variable_declaration
                | assignment
                | conditional
                | loop
                | function_call
                | print_statement
                | ";" ;

(* Variáveis *)
variable_declaration = "var" identifier "=" expression ";" ;
assignment           = identifier "=" expression ";" ;

(* Condicional *)
conditional     = "if" "(" condition ")" "{" { statement } "}"
                  [ "else" "{" { statement } "}" ] ;

(* Loop *)
loop            = "while" "(" condition ")" "{" { statement } "}" ;

(* Expressões e condições *)
expression      = number
                | string
                | identifier
                | expression operator expression
                | function_call ;

condition       = expression comparator expression ;

operator        = "+" | "-" | "*" | "/" ;
comparator      = "==" | "!=" | "<" | ">" | "<=" | ">=" ;

(* Funções e comandos específicos do avião *)
function_call   = ( "takeOff" | "land" | "accelerate" | "decelerate"
                  | "turnLeft" | "turnRight" | "status" )
                  "(" [ arguments ] ")" ";" ;

arguments       = expression { "," expression } ;

(* Print para debug *)
print_statement = "print" "(" expression ")" ";" ;

(* Identificadores e valores *)
identifier      = letter { letter | digit | "_" } ;
number          = digit { digit } ;
string          = '"' { any_character - '"' } '"' ;

(* Tokens básicos *)
letter          = "A".."Z" | "a".."z" ;
digit           = "0".."9" ;
```

🛫 Recursos da PlaneLang
Variáveis: var speed = 0;

Atribuição: speed = speed + 10;

Condicional:

```
if (speed > 200) {
    print("Velocidade alta");
}
```

Loop:

```
while (altitude < 10000) {
    accelerate(100);
}
```
Funções da VM do avião:

- takeOff();

- land();

- accelerate(value);

- decelerate(value);

- turnLeft(degrees);

- turnRight(degrees);

- status(); → retorna valores de sensores (velocidade, altitude etc.)

Print para debug:

- print("Altitude atual: " + altitude);

🧪 Exemplo de programa em PlaneLang

```
var speed = 0;
var altitude = 0;

takeOff();

while (altitude < 10000) {
    accelerate(50);
    altitude = altitude + 500;
    print("Subindo: " + altitude);
}

if (speed > 300) {
    decelerate(50);
} else {
    accelerate(20);
}

turnLeft(90);
status();
land();
```
