#include "conceito.h"



void freeConceito(void* str){ // mudar
	char** to_free = (char**)str;
	g_free(*to_free);
}


Conceito initConceito(){
    Conceito c = malloc(sizeof(struct conceito));

    c->nome = NULL;
    c->linguagem = NULL;
    c->narrows = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->broaders = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->scope = NULL;

    g_array_set_clear_func(c->narrows, freeConceito);
	g_array_set_clear_func(c->broaders, freeConceito);

    return c;
}


void addNarrow(Conceito c, gchar* narrow){
    g_array_append_val(c->narrows, narrow);
}


void addBroader(Conceito c, gchar* broader){
    g_array_append_val(c->broaders, broader);
}


void setNome(Conceito c, gchar* nome){
    c->nome = g_strdup(nome);
}


void setLinguagem(Conceito c, gchar* ling){
    c->linguagem = g_strdup(ling);
}


void setScope(Conceito c, gchar* scope){
    c->scope = g_strdup(scope);
}


void conceitoToHTML(Conceito c){
    char* html = ".html";
	gchar* filename = NULL;

	if(c->nome != NULL) {
		filename = g_strconcat(c->nome, html, NULL);

		FILE* file = fopen(filename, "w");	
	
		if(file){
			
			// HTML STUFF
			fprintf(file, "<!DOCTYPE html>\n<html>\n<head>\n\t<meta charset=\"utf-8\">\n\t<title>");

			fputs(c->nome, file);

			fprintf(file, "</title>\n</head>\n<body>\n");

			// Título
			fprintf(file, "<h1>");
			fputs(c->nome, file);
			fprintf(file, "</h1>\n");

            // Linguagem
            fprintf(file, "<h3>Linguagem: ");
			fputs(c->linguagem, file);
			fprintf(file, "</h3>\n");

			// Narrows
			if(c->narrows->len > 0){
				fprintf(file, "<h3>Narrows</h3>\n\t");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->narrows->len; i++){
					fprintf(file, "\t\t<li>%s%s", g_array_index(c->narrows, const char*, i), "</li>\n");
				}
				fprintf(file, "\t</ul>\n");
			}

            // Broaders
			if(c->broaders->len > 0){
				fprintf(file, "<h3>Broaders</h3>\n\t");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->broaders->len; i++){
					fprintf(file, "\t\t<li>%s%s", g_array_index(c->broaders, const char*, i), "</li>\n");
				}
				fprintf(file, "\t</ul>\n");
			}

            // Scope
            if(c->scope != NULL){
                fprintf(file, "<h4>Scope: <p>");
                fputs(c->scope, file);
                fprintf(file, "</p></h4>\n");
            }

			// HTML STUFF CLOSE
			fprintf(file, "</body>\n</html>");

			fclose(file);
		}	
	}

	g_free(filename);
}