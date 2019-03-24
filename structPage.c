#include "structPage.h"
#include <string.h>
#include <glib.h>
#include <stdio.h>
struct page{
	char* titulo;
	char* resumo;
	GArray* info;
	GArray* categorias;
};

Page initPage(){
	Page p = malloc(sizeof(struct page));
	p->titulo = NULL;
	p->resumo = NULL;
	p->info = g_array_new(FALSE, FALSE, sizeof(char *));
	p->categorias = g_array_new(FALSE, FALSE, sizeof(char *));
	return p;
}

void setPageTitle(Page p, char* title){
	p->titulo = strdup(title);
}

void setPageAbstract(Page p, char* abst){
	p->resumo = strdup(abst);
}

void addInfoLine(Page p, char* infoLine){
	char* newLine = strdup(infoLine);
	printf("+++++++++++++++a inserir info: %s\n",newLine );
	g_array_append_val(p->info, newLine);
}

void addCategoria(Page p, char* cat){
	char* newCat = strdup(cat);
	printf("+++++++++++++++a inserir cat: %s\n",newCat );
	g_array_append_val(p->categorias, newCat);
}

void freePage(Page p){
	free(p->titulo);
	free(p->resumo);
	g_array_free(p->info, TRUE);
	g_array_free(p->categorias, TRUE);
	free(p);	
}

void printPage(Page p){
	printf("Titulo: %s\n", p->titulo );
	printf("Resumo: \n\t%s\n", p->resumo );
	printf("Info:\n");
	for(int i=0; i < p->info->len; i++){
		char * line = g_array_index (p->info, char*, i);
		printf("\t%s\n",line);
	}
	printf("Categorias:\n");
	for(int i=0; i < p->categorias->len; i++){
		char * cat = g_array_index (p->categorias, char*, i);
		printf("\t%s\n",cat);
	}
}
