#include "conceito.h"

struct conceito {
    GString* nome;
    GString* linguagem;
    GArray* narrows;
    GArray* broaders;
    GString* scope;
};



void freeArray(void* str){
	char** to_free = (char**)str;
	g_free(*to_free);
}


Conceito initConceito(){
    Conceito c = malloc(sizeof(struct conceito));

    c->nome = g_string_new("");
    c->linguagem = g_string_new("");
    c->narrows = g_array_new(FALSE, FALSE, sizeof(struct conceito));
    c->broaders = g_array_new(FALSE, FALSE, sizeof(struct conceito));
    c->scope = g_string_new("");

    g_array_set_clear_func(c->narrows, freeArray);
	g_array_set_clear_func(c->broaders, freeArray);

    return c;
}


void addNarrow(Conceito c, GString* narrow){
    g_array_append_val(c->narrows, narrow);
}

void addBroader(Conceito c, GString* broader){
    g_array_append_val(c->broaders, broader);
}

void setLinguagem(Conceito c, GString* ling){
    c->linguagem = g_strdup(ling);
}

void setScope(Conceito c, GString* scope){
    c->scope = g_strdup(scope);
}

void conceitoToHTML(Conceito c){
    
}