#ifndef __CONCEITO_H__
#define __CONCEITO_H__

#include <string.h>
#include <glib.h>
#include <ctype.h>
#include <stdio.h>
#include <gmodule.h>



typedef struct conceito* Conceito;

struct conceito {
    gchar* nome;
    GArray* nt;
    GArray* bt;
	GArray* ntg;
    GArray* btg;
	GArray* ntp;
    GArray* btp;
    GArray* relatedConcepts;
    GString* scope;
    GHashTable* traducoes;
};



Conceito initConceito();
void addScopeChunk(Conceito c, gchar* scope_chunk);
void freeStr(void* str);
void freeConceito(Conceito c);
void addNT(Conceito c, gchar* narrow);
void addBT(Conceito c, gchar* broader);
void addNTG(Conceito c, gchar* narrow);
void addBTG(Conceito c, gchar* broader);
void addNTP(Conceito c, gchar* narrow);
void addBTP(Conceito c, gchar* broader);
void addRelated(Conceito c, gchar* related);
void addTraducao(Conceito c, gchar* lang, gchar* traducao);
void setNome(Conceito c, gchar* nome);


#endif
