#ifndef __DOCUMENTO_H__
#define __DOCUMENTO_H__

#include "conceito.h"
#include <glib.h>
#include <stdio.h>
#include <gmodule.h>


typedef struct documento* Documento;

struct documento {
    GHashTable* conceitos;

};


Documento initDocumento();
gboolean printConceito(gpointer key_pointer, gpointer conceito_pointer, gpointer info);
void docToHTML(Documento doc);
void addConceito(Documento doc, Conceito c);


#endif