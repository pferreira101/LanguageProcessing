CFLAGS=$(shell pkg-config --cflags glib-2.0)
LFLAGS=$(shell pkg-config --libs glib-2.0)
CC=gcc

program: wiki.l
	flex wiki.l
	$(CC) $(CFLAGS)  -o wiki lex.yy.c structPage.c $(LFLAGS)

test: wiki
	head -$(LINES) wiki_sample_page.xml | ./wiki 	

clean:
	rm lex.yy.c
	rm wiki
	rm *.html






