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


void pageToHTML(Page p){

	char* filename = strdup(p->titulo); strcat(filename, ".html"); // nao devia alocar espaço para o ".html" ?? funciona assim tho

	FILE* file = fopen(filename, "w");

	// HTML STUFF
	fprintf(file, "<!DOCTYPE html>\n<html>\n<head>\n\t<meta charset=\"utf-8\">\n\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n\t<title>");
	
	fputs(p->titulo, file);

	fprintf(file, "</title>\n\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n</head>\n<body>\n");

	// Título
	fprintf(file, "<h1>");
	fputs(p->titulo, file);
	fprintf(file, "</h1>\n");

	// Info
	if(p->info->len > 0){
		fprintf(file, "<h3>Info</h3>\n\t<ul>\n");
		for(int i = 0; i<p->info->len; i++){
			fprintf(file, "\t\t<li>%s%s", g_array_index(p->info, const char*, i), "</li>\n");
		}
		fprintf(file, "\t</ul>\n");
	}

	// Resumo
	fprintf(file, "<h3>Resumo</h3>\n<p>");
	fputs(p->resumo, file);
	fprintf(file, "</p>\n");

	// Categorias	
	if(p->categorias->len > 0){
		fprintf(file, "<h3>Categorias</h3>\n\t<ul>\n");
		for(int i = 0; i<p->categorias->len; i++){
			fprintf(file, "\t\t<li>%s%s", g_array_index(p->categorias, const char*, i), "</li>\n");
		}
		fprintf(file, "\t</ul>\n");
	}
	

	// HTML STUFF CLOSE
	fprintf(file, "</body>\n</html>");

	fclose(file);
}
