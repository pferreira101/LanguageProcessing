#include "documento.h"



Documento initDocumento(){
    Documento doc = malloc(sizeof(struct documento));

    doc->conceitos = g_hash_table_new_full(g_str_hash, g_str_equal, (GDestroyNotify)free, (GDestroyNotify)freeConceito); // definir freeConceito

    return doc;
}

void freeDocumento(Documento doc){
    
    g_hash_table_destroy(doc->conceitos);
    
    free(doc);
}

gboolean printTraducao(gpointer key_pointer, gpointer value_ptr, gpointer file_ptr){
    gchar* lang = key_pointer;
    gchar* traducao = value_ptr;
    FILE* file = file_ptr;

    fprintf(file, "\t\t<li> %s - %s</li>\n", lang, traducao);
    return TRUE;
}

gboolean printConceito(gpointer key_pointer, gpointer conceito_ptr, gpointer doc_ptr){
    Conceito c = (Conceito)conceito_ptr;
    Documento doc = (Documento)doc_ptr;
    printf("a imprimir conceito\n");
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
				fprintf(file, "<h3>Narrows</h3>\n");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->narrows->len; i++){
                    gchar* nome = g_array_index(c->narrows, gchar*, i);
                    if(g_hash_table_contains(doc->conceitos, nome)){
					    fprintf(file, "\t\t<li><a href=\"%s.html\">%s</a> </li>\n", nome, nome);
                    }
                    else{
                        fprintf(file, "\t\t<li>%s</li>\n", nome);   
                    }
				}
				fprintf(file, "\t</ul>\n");
			}

            // Broaders
			if(c->broaders->len > 0){
				fprintf(file, "<h3>Broaders</h3>\n");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->broaders->len; i++){
                    gchar* nome = g_array_index(c->broaders, gchar*, i);
                    if(g_hash_table_contains(doc->conceitos, nome)){
					    fprintf(file, "\t\t<li><a href=\"%s.html\">%s</a> </li>\n", nome, nome);
                    }
                    else{
                        fprintf(file, "\t\t<li>%s</li>\n", nome);   
                    }
				}
				fprintf(file, "\t</ul>\n");
			}

            // Scope
            if(c->scope != NULL){
                fprintf(file, "<h4>Scope: </h4> ");
                fputs(c->scope, file);
                fprintf(file, "\n");
            }

            if(g_hash_table_size(c->traducoes) > 0){
                fprintf(file, "<h4> Traduções </h4>\n\t <ul>\n");
                g_hash_table_foreach(c->traducoes, (GHFunc) printTraducao, file);
                fprintf(file, "\t</ul>");
            }

			// HTML STUFF CLOSE
			fprintf(file, "</body>\n</html>");

			fclose(file);
		}	
	}

	g_free(filename);

    return TRUE;
}


void docToHTML(Documento doc){
    g_hash_table_foreach(doc->conceitos, (GHFunc)printConceito, doc);
}


gboolean printTraducaoGraph(gpointer key_pointer, gpointer value_ptr, gpointer file_ptr){
    gchar* lang = key_pointer;
    gchar* traducao = value_ptr;
    FILE* file = file_ptr;

    fprintf(file, "\"Traduções\" -- \" %s - %s\";", lang, traducao);
    return TRUE;
}


gboolean printConceitoGraph(gpointer key_pointer, gpointer conceito_ptr, gpointer ptr){
    Conceito c = (Conceito)conceito_ptr;
    
    char* dot = ".dot";
	gchar* filename = NULL;

	if(c->nome != NULL) {
		filename = g_strconcat(c->nome, dot, NULL);

		FILE* file = fopen(filename, "w");	
	
		if(file){
			
			// INIT
			fprintf(file, "graph { rankdir=\"LR\"; \n");


            // Traduções
            if(g_hash_table_size(c->traducoes) > 0){
                fprintf(file, "\t\"%s\" -- \"Traduções\";\n", c->nome);
                
                g_hash_table_foreach(c->traducoes, (GHFunc) printTraducaoGraph, file);
            }

            // NOME --> NT --> termos
			if(c->narrows->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Narrow Terms\";\n", c->nome);

                for(int i = 0; i < c->narrows->len; i++){
                    gchar* nome = g_array_index(c->narrows, gchar*, i);
                    
                    fprintf(file, "\t\"Narrow Terms\" -- \"%s\";\n", nome);
                }
            }

            // NOME --> BT --> termos
			if(c->broaders->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Broader Terms\";\n", c->nome);

                for(int i = 0; i < c->broaders->len; i++){
                    gchar* nome = g_array_index(c->broaders, gchar*, i);
                    
                    fprintf(file, "\t\"Broader Terms\" -- \"%s\";\n", nome);
                }
            }

			// CLOSE
			fprintf(file, "}");

			fclose(file);
		}	
	}

	g_free(filename);
    return TRUE;
}

void docToDOT(Documento doc){
    g_hash_table_foreach(doc->conceitos, (GHFunc)printConceitoGraph, NULL);
}


void addConceito(Documento doc, Conceito c){
    printf("DOC: a adicionar conceito: %s\n",c->nome );
    g_hash_table_insert(doc->conceitos, c->nome, c);     
}
