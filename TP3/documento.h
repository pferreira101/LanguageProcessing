#ifndef __DOCUMENTO_H__
#define __DOCUMENTO_H__

#include "conceito.h"
#include <glib.h>
#include <stdio.h>
#include <gmodule.h>


typedef struct documento* Documento;

struct documento {
    gchar* baselang;
    GArray* languages;
    GArray* inv;
    GHashTable* conceitos;

};


Documento initDocumento();
void freeDocumento(Documento doc);
gboolean printConceito(gpointer key_pointer, gpointer conceito_pointer, gpointer info);
void docToHTML(Documento doc);
gboolean printConceitoGraph(gpointer key_pointer, gpointer conceito_ptr, gpointer doc_ptr);
void docToDOT(Documento doc);
void addConceito(Documento doc, Conceito c);
void setBaselang(Documento doc, gchar* bl);
void addLanguage(Documento doc, gchar* lang);
void addInv(Documento doc, gchar* ref);


#endif
