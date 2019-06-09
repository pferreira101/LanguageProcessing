#include "conceito.h"




Conceito initConceito(){
    Conceito c = malloc(sizeof(struct conceito));

    c->nome = NULL;
    c->linguagem = NULL;
    c->narrows = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->broaders = g_array_new(FALSE, FALSE, sizeof(gchar*));
    c->scope = NULL;
	c->traducoes = g_hash_table_new_full(g_str_hash, g_str_equal, (GDestroyNotify)g_free, (GDestroyNotify)g_free);

    g_array_set_clear_func(c->narrows, (GDestroyNotify)g_free);
	g_array_set_clear_func(c->broaders, (GDestroyNotify)g_free);

    return c;
}

void freeConceito(Conceito c){ // mudar

	g_free(c->nome);
	g_free(c->linguagem);	
	g_array_free(c->narrows, TRUE);
	g_array_free(c->broaders, TRUE);
	if(c->scope != NULL) g_free(c->scope);
	g_hash_table_destroy(c->traducoes);

	free(c);
}



void addNarrow(Conceito c, gchar* narrow){
    g_array_append_val(c->narrows, narrow);
}


void addBroader(Conceito c, gchar* broader){
    g_array_append_val(c->broaders, broader);
}

void addTraducao(Conceito c, gchar* lang, gchar* traducao){
	g_hash_table_insert(c->traducoes, lang, traducao);
}


void setNome(Conceito c, gchar* nome){
    c->nome = g_strdup(nome);
}


void setLinguagem(Conceito c, gchar* ling){
    c->linguagem = g_strdup(ling);
}


void setScope(Conceito c, gchar* scope){
    c->scope = g_strdup(scope);
}


