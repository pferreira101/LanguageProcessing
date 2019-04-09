CFLAGS=$(shell pkg-config --cflags glib-2.0)
LFLAGS=$(shell pkg-config --libs glib-2.0)
CC=gcc

.SILENT:mk_wiki
mk_wiki: mk_wiki.l structPage.c structPage.h
	flex -o mk_wiki.c mk_wiki.l 
	$(CC) $(CFLAGS)  -o mk_wiki mk_wiki.c structPage.c $(LFLAGS)

.SILENT:gettitles
gettitles: gettitles.l structPage.c structPage.h
	flex -o gettitles.c gettitles.l
	$(CC) $(CFLAGS) -o gettitles gettitles.c structPage.c $(LFLAGS)

.SILENT:test
.PHONY:test
test: mk_wiki gettitles
	./mk_wiki -a -d < testes/1milionlines.xml | sort > processed.txt
	./gettitles < testes/1milionlines.xml | sort > titles.txt
	comm -2 -3 titles.txt processed.txt > missing.txt
	echo "Número de páginas em falta:"
	cat missing.txt | wc -l

.PHONY:clean
.SILENT:clean
clean: 
	-rm mk_wiki.c
	-rm mk_wiki
	-rm *.html
	-rm gettitles.c
	-rm gettitles
	-rm missing.txt
	-rm processed.txt
	-rm titles.txt
	






