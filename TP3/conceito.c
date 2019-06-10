#include "conceito.h"



Conceito initConceito(){
    Conceito c = malloc(sizeof(struct conceito));

    c->nome = NULL;
    c->narrows = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->broaders = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->relatedConcepts = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->scope = NULL;
	c->traducoes = g_hash_table_new_full(g_str_hash, g_str_equal, (GDestroyNotify)g_free, (GDestroyNotify)g_free);

    g_array_set_clear_func(c->narrows, freeStr);
	g_array_set_clear_func(c->broaders, freeStr);

    return c;
}


void freeStr(void* str){
	char** to_free = (char**)str;
	g_free(*to_free);
}


void freeConceito(Conceito c){ // mudar

	g_free(c->nome);
	g_array_free(c->narrows, TRUE);
	g_array_free(c->broaders, TRUE);
    g_array_free(c->relatedConcepts, TRUE);
	if(c->scope != NULL) g_free(c->scope);
	g_hash_table_destroy(c->traducoes);

	free(c);
}



void addNarrow(Conceito c, gchar* narrow){
    gchar* _narrow = g_strdup(narrow);
    g_array_append_val(c->narrows, _narrow);
}


void addBroader(Conceito c, gchar* broader){
    gchar* _broader = g_strdup(broader);
    g_array_append_val(c->broaders, _broader);
}

void addRelated(Conceito c, gchar* related){
    gchar* _related = g_strdup(related);
    g_array_append_val(c->relatedConcepts, _related);
}


void addTraducao(Conceito c, gchar* lang, gchar* traducao){
    gchar* _lang = g_strdup(lang);
    gchar* _traducao = g_strdup(traducao);
	g_hash_table_insert(c->traducoes, _lang, _traducao);
}


void setNome(Conceito c, gchar* nome){
    c->nome = g_strdup(nome);
}


void setScope(Conceito c, gchar* scope){
    c->scope = g_strdup(scope);
}


