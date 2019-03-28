#ifndef __STRUCTPAGE_H__
#define __STRUCTPAGE_H__

#include <string.h>
#include <glib.h>
#include <stdio.h>
#include <gmodule.h>

typedef struct page* Page;


Page initPage();
void setPageTitle(Page p, gchar* title);
void setPageAbstract(Page p, gchar* abst);
void setPageInfoBCatg(Page p, gchar* tipo);
void addInfoLine(Page p, gchar* infoLine);
void addInfoLineChunk(Page p, gchar* info);
void addCategoria(Page p, char* cat);
void addChunkAbstract(Page p, gchar* abst);
int checkCategoria(Page p, char* cat);
void freePage (Page p);
void printPage(Page p);
char* replace_char(char* str, char find, char replace);
void pageToHTML(Page p);

#endif