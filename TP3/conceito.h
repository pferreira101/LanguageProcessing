#ifndef __CONCEITO_H__
#define __CONCEITO_H__

#include <string.h>
#include <glib.h>
#include <stdio.h>
#include <gmodule.h>

typedef struct conceito* Conceito;



Conceito initConceito();
void addNarrow(Conceito c, GString* narrow);
void addBroader(Conceito c, GString* broader);
void setLinguagem(Conceito c, GString* ling);
void setScope(Conceito c, GString* scope);
void conceitoToHTML(Conceito c);