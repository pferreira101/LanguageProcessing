#include "documento.h"




Documento initDocumento(){
    Documento doc = malloc(sizeof(struct documento));

    doc->conceitos = g_hash_table_new_full(g_str_hash, g_str_equal, NULL, (GDestroyNotify)freeConceito);
	doc->baselang = NULL;
    doc->languages = g_array_new(FALSE, FALSE, sizeof(gchar*));
    doc->relacoes = g_array_new(FALSE, FALSE, sizeof(gchar*));

	g_array_set_clear_func(doc->languages, freeStr);
	g_array_set_clear_func(doc->relacoes, freeStr);

    return doc;
}


void freeDocumento(Documento doc){
    
    g_hash_table_destroy(doc->conceitos);
	g_free(doc->baselang);	
	g_array_free(doc->languages, TRUE);
	g_array_free(doc->relacoes, TRUE);
    
    free(doc);
}

gboolean printTraducao(gpointer key_pointer, gpointer value_ptr, gpointer file_ptr){
    gchar* lang = key_pointer;
    gchar* traducao = value_ptr;
    FILE* file = file_ptr;

    fprintf(file, "\t\t<li> %s - %s</li>\n", lang, traducao);
    return TRUE;
}

gboolean printConceito(gpointer key_pointer, gpointer conceito_ptr, gpointer token){
    Conceito c = (Conceito)conceito_ptr;
    
    Documento doc = ((Documento*)token)[0];

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

			// NT
			if(c->nt->len > 0){
				fprintf(file, "<h3>Narrower Terms</h3>\n");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->nt->len; i++){
                    gchar* nome = g_array_index(c->nt, gchar*, i);
                    if(g_hash_table_contains(doc->conceitos, nome)){
					    fprintf(file, "\t\t<li><a href=\"%s.html\">%s</a> </li>\n", nome, nome);
                    }
                    else{
                        fprintf(file, "\t\t<li>%s</li>\n", nome);   
                    }
				}
				fprintf(file, "\t</ul>\n");
			}

			// NTG
			if(c->ntg->len > 0){
				fprintf(file, "<h3>Narrower Terms Generic</h3>\n");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->ntg->len; i++){
                    gchar* nome = g_array_index(c->ntg, gchar*, i);
                    if(g_hash_table_contains(doc->conceitos, nome)){
					    fprintf(file, "\t\t<li><a href=\"%s.html\">%s</a> </li>\n", nome, nome);
                    }
                    else{
                        fprintf(file, "\t\t<li>%s</li>\n", nome);   
                    }
				}
				fprintf(file, "\t</ul>\n");
			}

			// NTP
			if(c->ntp->len > 0){
				fprintf(file, "<h3>Narrower Terms Partitive</h3>\n");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->ntp->len; i++){
                    gchar* nome = g_array_index(c->ntp, gchar*, i);
                    if(g_hash_table_contains(doc->conceitos, nome)){
					    fprintf(file, "\t\t<li><a href=\"%s.html\">%s</a> </li>\n", nome, nome);
                    }
                    else{
                        fprintf(file, "\t\t<li>%s</li>\n", nome);   
                    }
				}
				fprintf(file, "\t</ul>\n");
			}

            // BT
			if(c->bt->len > 0){
				fprintf(file, "<h3>Broader Terms</h3>\n");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->bt->len; i++){
                    gchar* nome = g_array_index(c->bt, gchar*, i);
                    if(g_hash_table_contains(doc->conceitos, nome)){
					    fprintf(file, "\t\t<li><a href=\"%s.html\">%s</a> </li>\n", nome, nome);
                    }
                    else{
                        fprintf(file, "\t\t<li>%s</li>\n", nome);   
                    }
				}
				fprintf(file, "\t</ul>\n");
			}

			// BTG
			if(c->btg->len > 0){
				fprintf(file, "<h3>Broader Terms Generic</h3>\n");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->btg->len; i++){
                    gchar* nome = g_array_index(c->btg, gchar*, i);
                    if(g_hash_table_contains(doc->conceitos, nome)){
					    fprintf(file, "\t\t<li><a href=\"%s.html\">%s</a> </li>\n", nome, nome);
                    }
                    else{
                        fprintf(file, "\t\t<li>%s</li>\n", nome);   
                    }
				}
				fprintf(file, "\t</ul>\n");
			}

			// BTP
			if(c->btp->len > 0){
				fprintf(file, "<h3>Broader Terms Partitive</h3>\n");
				fprintf(file, "\t<ul>\n");
				for(int i = 0; i < c->btp->len; i++){
                    gchar* nome = g_array_index(c->btp, gchar*, i);
                    if(g_hash_table_contains(doc->conceitos, nome)){
					    fprintf(file, "\t\t<li><a href=\"%s.html\">%s</a> </li>\n", nome, nome);
                    }
                    else{
                        fprintf(file, "\t\t<li>%s</li>\n", nome);   
                    }
				}
				fprintf(file, "\t</ul>\n");
			}

            // Related Concepts
            if(c->relatedConcepts->len > 0){
                fprintf(file, "<h3>Related Concepts</h3>\n");
                fprintf(file, "\t<ul>\n");
                for(int i = 0; i < c->relatedConcepts->len; i++){
                    gchar* nome = g_array_index(c->relatedConcepts, gchar*, i);
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

    // INDEX
    FILE* index = ((FILE**)token)[1];
    fprintf(index, "<li><a href=\"%s.html\">%s</a> </li>\n", c->nome, c->nome);

    return TRUE;
}


void docToHTML(Documento doc){

    FILE* index  = fopen("index.html", "w");	
    fprintf(index, "<!DOCTYPE html>\n<html>\n<head>\n\t<meta charset=\"utf-8\">\n\t<title>Index</title>\n</head>\n<body>\n<ul>\n<h1>Índice</h1>\n");

    void* token[2] = {doc, index};

    g_hash_table_foreach(doc->conceitos, (GHFunc)printConceito, token);

    fprintf(index, "</ul>\n</body>\n</html>");
    fclose(index);
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
			if(c->nt->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Narrower Terms\";\n", c->nome);

                for(int i = 0; i < c->nt->len; i++){
                    gchar* nome = g_array_index(c->nt, gchar*, i);
                    
                    fprintf(file, "\t\"Narrower Terms\" -- \"%s\";\n", nome);
                }
            }
			// NOME --> NTG --> termos
			if(c->ntg->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Narrower Terms General\";\n", c->nome);

                for(int i = 0; i < c->ntg->len; i++){
                    gchar* nome = g_array_index(c->ntg, gchar*, i);
                    
                    fprintf(file, "\t\"Narrower Terms General\" -- \"%s\";\n", nome);
                }
            }
			// NOME --> NTP --> termos
			if(c->ntp->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Narrower Terms Partitive\";\n", c->nome);

                for(int i = 0; i < c->ntp->len; i++){
                    gchar* nome = g_array_index(c->ntp, gchar*, i);
                    
                    fprintf(file, "\t\"Narrower Terms Partitive\" -- \"%s\";\n", nome);
                }
            }

            // NOME --> BT --> termos
			if(c->bt->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Broader Terms\";\n", c->nome);

                for(int i = 0; i < c->bt->len; i++){
                    gchar* nome = g_array_index(c->bt, gchar*, i);
                    
                    fprintf(file, "\t\"Broader Terms\" -- \"%s\";\n", nome);
                }
            }

			// NOME --> BTG --> termos
			if(c->btg->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Broader Terms Generic\";\n", c->nome);

                for(int i = 0; i < c->btg->len; i++){
                    gchar* nome = g_array_index(c->btg, gchar*, i);
                    
                    fprintf(file, "\t\"Broader Terms Generic\" -- \"%s\";\n", nome);
                }
            }

			// NOME --> BTP --> termos
			if(c->btp->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Broader Terms Partitive\";\n", c->nome);

                for(int i = 0; i < c->btp->len; i++){
                    gchar* nome = g_array_index(c->btp, gchar*, i);
                    
                    fprintf(file, "\t\"Broader Terms Partitive\" -- \"%s\";\n", nome);
                }
            }

			// NOME --> RT --> termos
			if(c->relatedConcepts->len > 0) {
                fprintf(file, "\t\"%s\" -- \"Related Terms\";\n", c->nome);

                for(int i = 0; i < c->relatedConcepts->len; i++){
                    gchar* nome = g_array_index(c->relatedConcepts, gchar*, i);
                    
                    fprintf(file, "\t\"Related Terms\" -- \"%s\";\n", nome);
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

void docToDOTGeral(Documento doc){
	FILE* file = fopen("geral.dot","w");
	if(file) {
		fprintf(file,"digraph { rankdir=\"LR\"; \n");

		void* token[1] = {file};
    	g_hash_table_foreach(doc->conceitos, (GHFunc)conceptToGraphGeral, token);
		
		fprintf(file, "}");
		fclose(file);
	}
}

gboolean conceptToGraphGeral(gpointer key_pointer, gpointer conceito_ptr, gpointer token){
    Conceito c = (Conceito)conceito_ptr;

	FILE* file = ((FILE**)token)[0];

	// NT e NTG
	if(c->nt->len > 0) {
    	for(int i = 0; i < c->nt->len; i++){
			gchar* nome = g_array_index(c->nt, gchar*, i);        
           	fprintf(file, "\t\"%s\" -> \"%s\" [label=\"can be\"];\n", c->nome,nome);
        }
    }
	if(c->ntg->len > 0) {
    	for(int i = 0; i < c->ntg->len; i++){
			gchar* nome = g_array_index(c->ntg, gchar*, i);        
           	fprintf(file, "\t\"%s\" -> \"%s\" [label=\"can be\"];\n", c->nome,nome);
        }
    }
	// NTP
	if(c->ntp->len > 0) {
    	for(int i = 0; i < c->ntp->len; i++){
			gchar* nome = g_array_index(c->ntp, gchar*, i);        
           	fprintf(file, "\t\"%s\" -> \"%s\" [label=\"has\"];\n", c->nome,nome);
        }
    }
	// BT e BTG
	if(c->bt->len > 0) {
    	for(int i = 0; i < c->bt->len; i++){
			gchar* nome = g_array_index(c->bt, gchar*, i);        
           	fprintf(file, "\t\"%s\" -> \"%s\" [label=\"is a\"];\n", c->nome,nome);
        }
    }
	if(c->btg->len > 0) {
    	for(int i = 0; i < c->btg->len; i++){
			gchar* nome = g_array_index(c->btg, gchar*, i);        
           	fprintf(file, "\t\"%s\" -> \"%s\" [label=\"is a\"];\n", c->nome,nome);
        }
    }
	// BTP
	if(c->btp->len > 0) {
    	for(int i = 0; i < c->btp->len; i++){
			gchar* nome = g_array_index(c->btp, gchar*, i);        
           	fprintf(file, "\t\"%s\" -> \"%s\" [label=\"is part of\"];\n", c->nome,nome);
        }
    }

	// RT
	if(c->relatedConcepts->len > 0) {
    	for(int i = 0; i < c->relatedConcepts->len; i++){
			gchar* nome = g_array_index(c->relatedConcepts, gchar*, i);        
           	fprintf(file, "\t\"%s\" -> \"%s\" [label=\"related to\"];\n", c->nome,nome);
        }
    }

}


void addConceito(Documento doc, Conceito c){
    printf("DOC: a adicionar conceito: %s\n",c->nome );
    g_hash_table_insert(doc->conceitos, c->nome, c);     
}

void setBaselang(Documento doc, gchar* bl){
   	doc->baselang = g_strdup(bl);
}

void addLanguage(Documento doc, gchar* lang){
    gchar* _lang = g_strdup(lang);
    g_array_append_val(doc->languages, _lang);
}

void addRelacao(Documento doc, gchar* ref){
    gchar* _ref = g_strdup(ref);
    g_array_append_val(doc->relacoes, _ref);
}




