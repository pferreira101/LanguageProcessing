CFLAGS=$(shell pkg-config --cflags glib-2.0)
LFLAGS=$(shell pkg-config --libs glib-2.0)
CC=gcc


make: thesaurus.l thesaurus.y
	flex thesaurus.l
	yacc -d -v thesaurus.y
	gcc -o thesaurus y.tab.c

.SILENT:teste
teste: conceito.c conceito.h documento.c documento.h main.c
	$(CC) $(CFLAGS)  -o teste documento.c conceito.c main.c $(LFLAGS)

.PHONY:clean
.SILENT:clean
clean: 
	-rm y.output
	-rm y.tab.*
	-rm lex.yy.c
	-rm *.html
	-rm thesaurus
	-rm teste