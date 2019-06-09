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
};



Conceito initConceito();
void freeConceito(void* str);
void addNarrow(Conceito c, gchar* narrow);
void addBroader(Conceito c, gchar* broader);
void setNome(Conceito c, gchar* nome);
void setLinguagem(Conceito c, gchar* ling);
void setLinguagem(Conceito c, gchar* ling);
void setScope(Conceito c, gchar* scope);
void conceitoToHTML(Conceito c);


#endif