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

void setPageTitle(Page p, gchar* title){
	p->titulo = g_strdup(title);
}

void setPageAbstract(Page p, gchar* abst){
	p->resumo = g_strdup(abst);
}


void addInfoLine(Page p, char* info){
	gchar* newInfo = g_strdup(info);
	if(p->info->len>0){
		int last = p->info->len-1;
		const gchar * lline = g_array_index(p->info, char*, last);
		int l_len = strlen(lline);

		if(lline[l_len-1]=='\n')
			g_array_append_val(p->info, newInfo); // insere novo registo se ja tiver a linha preenchida
		else{
			char* catLineInfo = g_strconcat(lline,newInfo,NULL); // adicona resto da informacao à linha que se encontra incompleta
			g_array_remove_index(p->info, last);
			g_array_append_val(p->info, catLineInfo);			
		} 	
	}
	else
		g_array_append_val(p->info, newInfo);	
}

void addCategoria(Page p, char* cat){
	char* newCat = strdup(cat);
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
	/*printf("Info:\n");
	for(int i=0; i < p->info->len; i++){
		char * line = g_array_index (p->info, char*, i);
		printf("\t%s\n",line);
	}
	printf("Categorias:\n");
	for(int i=0; i < p->categorias->len; i++){
		char * cat = g_array_index (p->categorias, char*, i);
		printf("\t%s\n",cat);
	}
	*/
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
