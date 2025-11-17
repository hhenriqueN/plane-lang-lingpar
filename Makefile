# Try common Homebrew flex static lib locations; if none found, leave empty
# (lex.yy.c here doesn't require libfl when using noyywrap and modern flex)
FL_LIB := $(shell \
	test -f /opt/homebrew/opt/flex/lib/libfl.a && echo /opt/homebrew/opt/flex/lib/libfl.a || \
	test -f /usr/local/opt/flex/lib/libfl.a && echo /usr/local/opt/flex/lib/libfl.a || \
	echo )
EXECUTABLE := planelang

.PHONY: all lexer parser clean run

all: $(EXECUTABLE)

$(EXECUTABLE): parser.tab.c lex.yy.c vm.c
	gcc -o $(EXECUTABLE) parser.tab.c lex.yy.c vm.c $(FL_LIB)

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

lexer: lex.yy.c
	@echo "Lexer gerado: lex.yy.c"

parser: parser.tab.c
	@echo "Parser gerado: parser.tab.c parser.tab.h"

run: $(EXECUTABLE)
	@if [ -f test.pln ]; then \
	  echo "--- Executando com test.pln ---"; \
	  ./$(EXECUTABLE) test.pln; \
	else \
	  echo "Arquivo test.pln não encontrado."; \
	  echo "Crie um arquivo de teste com código PlaneLang."; \
	  echo "Exemplo:"; \
	  echo "takeoff;"; \
	  echo "set speed = 10;"; \
	  echo "if (altitude == 500) { land; } else { wait 5 seconds; }"; \
	fi

clean:
	rm -f $(EXECUTABLE) parser.tab.c parser.tab.h lex.yy.c
