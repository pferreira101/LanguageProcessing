#include "conceito.h"



Conceito initConceito(){
    Conceito c = malloc(sizeof(struct conceito));

    c->nome = NULL;
    c->nt = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->bt = g_array_new(FALSE, FALSE, sizeof(gchar*));
	c->ntg = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->btg = g_array_new(FALSE, FALSE, sizeof(gchar*));
	c->ntp = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->btp = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->relatedConcepts = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->scope = NULL;
	c->traducoes = g_hash_table_new_full(g_str_hash, g_str_equal, (GDestroyNotify)g_free, (GDestroyNotify)g_free);

    g_array_set_clear_func(c->nt, freeStr);
	g_array_set_clear_func(c->bt, freeStr);
	g_array_set_clear_func(c->ntg, freeStr);
	g_array_set_clear_func(c->btg, freeStr);
	g_array_set_clear_func(c->ntp, freeStr);
	g_array_set_clear_func(c->btp, freeStr);

    return c;
}


void freeStr(void* str){
	char** to_free = (char**)str;
	g_free(*to_free);
}


void freeConceito(Conceito c){ // mudar

	g_free(c->nome);
	g_array_free(c->nt, TRUE);
	g_array_free(c->bt, TRUE);
	g_array_free(c->ntg, TRUE);
	g_array_free(c->btg, TRUE);
	g_array_free(c->ntp, TRUE);
	g_array_free(c->btp, TRUE);
    g_array_free(c->relatedConcepts, TRUE);
	if(c->scope != NULL) g_free(c->scope);
	g_hash_table_destroy(c->traducoes);

	free(c);
}



void addNT(Conceito c, gchar* narrow){
    gchar* _narrow = g_strdup(narrow);
    g_array_append_val(c->nt, _narrow);
}


void addBT(Conceito c, gchar* broader){
    gchar* _broader = g_strdup(broader);
    g_array_append_val(c->bt, _broader);
}

void addNTG(Conceito c, gchar* narrow){
    gchar* _narrow = g_strdup(narrow);
    g_array_append_val(c->ntg, _narrow);
}


void addBTG(Conceito c, gchar* broader){
    gchar* _broader = g_strdup(broader);
    g_array_append_val(c->btg, _broader);
}

void addNTP(Conceito c, gchar* narrow){
    gchar* _narrow = g_strdup(narrow);
    g_array_append_val(c->ntp, _narrow);
}


void addBTP(Conceito c, gchar* broader){
    gchar* _broader = g_strdup(broader);
    g_array_append_val(c->btp, _broader);
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


