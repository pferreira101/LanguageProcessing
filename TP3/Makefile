CFLAGS=$(shell pkg-config --cflags glib-2.0)
LFLAGS=$(shell pkg-config --libs glib-2.0)
CC=gcc

.SILENT:teste
teste: conceito.c conceito.h documento.c documento.h main.c
	$(CC) $(CFLAGS) -g -o teste conceito.c documento.c main.c $(LFLAGS)