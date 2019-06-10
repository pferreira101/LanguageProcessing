CFLAGS=$(shell pkg-config --cflags glib-2.0)
LFLAGS=$(shell pkg-config --libs glib-2.0)
CC=gcc


make: thesaurus.l thesaurus.y
	flex thesaurus.l
	yacc -d -v thesaurus.y
	$(CC) $(CFLAGS) -o thesaurus y.tab.c documento.c conceito.c $(LFLAGS)

.SILENT:prolog_clean
prolog_clean: output.pl 
			sort -u output.pl > output_cleaned.pl
			rm output.pl

.SILENT:teste
teste: conceito.c conceito.h documento.c documento.h main.c
	$(CC) $(CFLAGS) -g -o teste documento.c conceito.c main.c $(LFLAGS)

.PHONY:clean
.SILENT:clean
clean: 
	-rm y.output
	-rm y.tab.*
	-rm lex.yy.c
	-rm *.html
	-rm thesaurus
	-rm teste
	-rm *.dot