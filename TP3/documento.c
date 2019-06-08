#include "documento.h"
#include "conceito.h"

struct documento {
    GHashTable* conceitos;

};


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