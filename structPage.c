#include "structPage.h"

struct page{
	char* titulo;
	GString* resumo;
	char* infoB_catg;
	GArray* info;
	GArray* categorias;
};

void freeFunc(void* str){
	char** to_free = (char**)str;
	g_free(*to_free);
}

Page initPage(){
	Page p = malloc(sizeof(struct page));
	p->titulo = NULL;
	p->resumo = g_string_new("");
	p->infoB_catg = NULL;
	p->info = g_array_new(FALSE, FALSE, sizeof(char *));
	p->categorias = g_array_new(FALSE, FALSE, sizeof(char *));

	g_array_set_clear_func(p->info, freeFunc);
	g_array_set_clear_func(p->categorias, freeFunc);

	return p;
}



void setPageInfoBCatg(Page p, gchar* tipo){
	if(p->infoB_catg == NULL) 
		p->infoB_catg = g_strdup(tipo);

	//free(tipo);
}

void setPageTitle(Page p, gchar* title){
	p->titulo = g_strdup(title);

	//free(title);
}



void addChunkAbstract(Page p, gchar* abst){
	//printf("PAGE:adding text to abs:PAGE\n%s\n",abst);
	g_string_append(p->resumo, abst);
	//printf("SO FAR________\n%s\n", p->resumo->str);	
	
}


void addInfoLine(Page p, gchar* info){
	gchar* newInfo = g_strdup(info);
	g_array_append_val(p->info, newInfo);	

	//free(info);
}


void addInfoLineChunk(Page p, gchar* info){
	//gchar* newInfo = g_strdup(info);
	if(p->info->len>0){
		int last = p->info->len-1;
		gchar* lline = g_array_index(p->info, char*, last);
		char* catLineInfo = g_strconcat(lline, info, NULL); // adicona resto da informacao à linha que se encontra incompleta	
		g_array_remove_index(p->info, last);
		//g_free(lline);
		g_array_append_val(p->info, catLineInfo);						
	}
	else{
		gchar* newInfo = g_strdup(info);
		g_array_append_val(p->info, newInfo);
	}
	//free(info);	
}

void addCategoria(Page p, gchar* cat){
	char* newCat = g_strdup(cat);
	g_array_append_val(p->categorias, newCat);

	//free(cat);
}

int checkCategoria(Page p, gchar* cat) {
	for(int i=0;i<(p->categorias)->len;i++)
		if(strcmp(cat,g_array_index(p->categorias,char*,i))==0) return 1;
	return 0;
}

void freePage(Page p){
	g_free(p->titulo);
	g_free(p->infoB_catg);
	g_string_free(p->resumo,TRUE);
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
	char* html = ".html";
	char* wikipedia = "pt.wikipedia.org/wiki/";
	gchar* filename = NULL;
	gchar* link = NULL;

	if(p->titulo != NULL) {
		filename = g_strconcat(p->titulo, html, NULL);

		FILE* file = fopen(filename, "w");
	
	
		if(file){
			
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
			fputs(p->resumo->str, file);
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
			link = g_strconcat(wikipedia, p->titulo, NULL); //strcat(link, p->titulo);
			link = replace_char(link, ' ', '_');

			fprintf(file, "<a href=\"http://%s\">Visitar página Wikipédia</a>", link);

			// HTML STUFF CLOSE
			fprintf(file, "</body>\n</html>");

			

			fclose(file);
		}	
	}

	g_free(filename);
	g_free(link);
	
}
