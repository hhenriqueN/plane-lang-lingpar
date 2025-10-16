# Makefile para PlaneLang (Flex + Bison)

FL_LIB := $(shell test -f /opt/homebrew/opt/flex/lib/libfl.a && echo /opt/homebrew/opt/flex/lib/libfl.a || echo -lfl)

EXECUTABLE := planelang

.PHONY: all $(EXECUTABLE) lexer parser clean run

all: $(EXECUTABLE)

$(EXECUTABLE): parser.tab.c lex.yy.c
	gcc -o $(EXECUTABLE) parser.tab.c lex.yy.c 

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

lexer: lex.yy.c
	@echo "Lexer gerado: lex.yy.c"

parser: parser.tab.c
	@echo "Parser gerado: parser.tab.c parser.tab.h"

run: $(EXECUTABLE)
	@if [ -f a.planelang ]; then \
	  echo "--- Executando com a.planelang ---"; \
	  ./$(EXECUTABLE) a.planelang; \
	else \
	  echo "Arquivo a.planelang não encontrado."; \
	  echo "Crie um arquivo de teste com código PlaneLang e rode 'make run' novamente."; \
	  echo "Exemplo de código de teste:"; \
	  echo "takeoff;"; \
	  echo "set speed = 10;"; \
	  echo "if (altitude == 500) { land; } else { wait 5 seconds; }"; \
	fi

clean:
	rm -f $(EXECUTABLE) parser.tab.c parser.tab.h lex.yy.c
