#ifndef __STRUCTPAGE_H__
#define __STRUCTPAGE_H__


typedef struct page* Page;


Page initPage();
void setPageTitle(Page p, char* title);
void setPageAbstract(Page p, char* abst);
void addInfoLine(Page p, char* infoLine);
void addCategoria(Page p, char* cat);
void freePage (Page p);
void printPage(Page p);
char* replace_char(char* str, char find, char replace);
void pageToHTML(Page p);

#endif