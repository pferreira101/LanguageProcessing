#include "documento.h"



Documento initDocumento(){
    Documento doc = malloc(sizeof(struct documento));

    doc->conceitos = g_hash_table_new_full(g_str_hash, g_str_equal, (GDestroyNotify)free, (GDestroyNotify)freeConceito); // definir freeConceito

    return doc;
}




gboolean printConceito(gpointer key_pointer, gpointer conceito_pointer, gpointer info){
    Conceito c = (Conceito)conceito_pointer;
    
    conceitoToHTML(c);

    // fazer free do conceito? ou fazer free de tudo na hash?
}

void docToHTML(Documento doc){
    g_hash_table_foreach(doc->conceitos, (GHFunc)printConceito, NULL);
}


void addConceito(Documento doc, Conceito c){
    g_hash_table_insert(doc->conceitos, c->nome, c);

    // Narrows: adiciona c como broader / cria e adiciona
    for(int i = 0; i < c->narrows->len; i++){
        gchar* nome = g_array_index(c->narrows, gchar*, i);
        if(g_hash_table_contains(doc->conceitos, nome)){
            Conceito narrow = g_hash_table_lookup(doc->conceitos, nome);
            addBroader(narrow, c->nome);
        }
        else{
            Conceito novo = initConceito();
            setNome(novo, nome);
            addBroader(novo, c->nome);
            g_hash_table_insert(doc->conceitos, novo->nome, novo);
        }
    }

    // Broaders: adiciona c como narrow / cria e adiciona
    for(int i = 0; i < c->broaders->len; i++){
        gchar* nome = g_array_index(c->broaders, gchar*, i);
        if(g_hash_table_contains(doc->conceitos, nome)){
            Conceito broader = g_hash_table_lookup(doc->conceitos, nome);
            addNarrow(broader, c->nome);
        }
        else{
            Conceito novo = initConceito();
            setNome(novo, nome);
            addNarrow(novo, c->nome);
            g_hash_table_insert(doc->conceitos, novo->nome, novo);
        }
    }
}
