#include "structPage.h"

struct page{
	char* titulo;
	char* resumo;
	char* infoB_catg;
	GArray* info;
	GArray* categorias;
};

Page initPage(){
	Page p = malloc(sizeof(struct page));
	p->titulo = NULL;
	p->resumo = NULL;
	p->infoB_catg = NULL;
	p->info = g_array_new(FALSE, FALSE, sizeof(char *));
	p->categorias = g_array_new(FALSE, FALSE, sizeof(char *));
	return p;
}

void setPageInfoBCatg(Page p, gchar* tipo){
	p->infoB_catg = g_strdup(tipo);
}

void setPageTitle(Page p, gchar* title){
	p->titulo = g_strdup(title);
}

void setPageAbstract(Page p, gchar* abst){
	p->resumo = g_strdup(abst);
}

void addChunkAbstract(Page p, gchar* abst){
	gchar* newText = g_strdup(abst);
	if(p->resumo)
		p->resumo = g_strconcat(p->resumo,newText,NULL);
	else
		p->resumo = newText;
}


void addInfoLine(Page p, gchar* info){
	gchar* newInfo = g_strdup(info);
	g_array_append_val(p->info, newInfo);	
}


void addInfoLineChunk(Page p, gchar* info){
	gchar* newInfo = g_strdup(info);
	if(p->info->len>0){
		int last = p->info->len-1;
		const gchar * lline = g_array_index(p->info, char*, last);
		char* catLineInfo = g_strconcat(lline,newInfo,NULL); // adicona resto da informacao à linha que se encontra incompleta
		g_array_remove_index(p->info, last);
		g_array_append_val(p->info, catLineInfo);						
	}
	else
		g_array_append_val(p->info, newInfo);	
}

void addCategoria(Page p, gchar* cat){
	char* newCat = strdup(cat);
	g_array_append_val(p->categorias, newCat);
}

int checkCategoria(Page p, gchar* cat) {
	for(int i=0;i<(p->categorias)->len;i++)
		if(strcmp(cat,g_array_index(p->categorias,char*,i))==0) return 1;
	return 0;
}

void freePage(Page p){
	free(p->titulo);
	free(p->resumo);
	free(p->infoB_catg);
	g_array_free(p->info, TRUE);
	g_array_free(p->categorias, TRUE);
	free(p);	
}

void printPage(Page p){
	printf("Titulo: %s\n", p->titulo );
	//printf("Tipo infobox: %s\n",p->infoB_catg );
	//printf("Resumo: \n\t%s\n", p->resumo );
	/*printf("Info:\n");
	for(int i=0; i < p->info->len; i++){
		char * line = g_array_index (p->info, char*, i);
		printf("\t%s\n",line);
	}
	*/
	/*
	printf("Categorias:\n");
	for(int i=0; i < p->categorias->len; i++){
		char * cat = g_array_index (p->categorias, char*, i);
		printf("\t%s\n",cat);
	}
	*/
	
}


char* replace_char(char* str, char find, char replace){
    char *current_pos = strchr(str,find);
    while (current_pos){
        *current_pos = replace;
        current_pos = strchr(current_pos,find);
    }
    return str;
}

void pageToHTML(Page p){
	
	char* filename = malloc(strlen(p->titulo) + 6); 
	filename = strdup(p->titulo); strcat(filename, ".html");

	FILE* file = fopen(filename, "w");

	// HTML STUFF
	fprintf(file, "<!DOCTYPE html>\n<html>\n<head>\n\t<meta charset=\"utf-8\">\n\t<title>");
	
	fputs(p->titulo, file);

	fprintf(file, "</title>\n</head>\n<body>\n");

	// Título
	fprintf(file, "<h1>");
	fputs(p->titulo, file);
	fprintf(file, "</h1>\n");

	// Info
	if(p->info->len > 0){
		fprintf(file, "<h3>Info</h3>\n\t<ul>\n");
		if(p->infoB_catg) fputs(p->infoB_catg, file);
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
	

	// Wikipedia Link
	char* wikipedia = "pt.wikipedia.org/wiki/";
	char* link = malloc(strlen(wikipedia)+strlen(p->titulo)+1);
	strcat(link, wikipedia); strcat(link, p->titulo);
	link = replace_char(link, ' ', '_');

	fprintf(file, "<a href=\"http://%s\">Visitar página Wikipédia</a>", link);

	// HTML STUFF CLOSE
	fprintf(file, "</body>\n</html>");

	fclose(file);
}
