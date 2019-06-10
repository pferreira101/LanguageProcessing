#ifndef __CONCEITO_H__
#define __CONCEITO_H__

#include <string.h>
#include <glib.h>
#include <stdio.h>
#include <gmodule.h>



typedef struct conceito* Conceito;

struct conceito {
    gchar* nome;
    gchar* linguagem;
    GArray* narrows;
    GArray* broaders;
    gchar* scope;
    GHashTable* traducoes;
};



Conceito initConceito();
void freeStr(void* str);
void freeConceito(Conceito c);
void addNarrow(Conceito c, gchar* narrow);
void addBroader(Conceito c, gchar* broader);
void addTraducao(Conceito c, gchar* lang, gchar* traducao);
void setNome(Conceito c, gchar* nome);
void setLinguagem(Conceito c, gchar* ling);
void setScope(Conceito c, gchar* scope);


#endif
