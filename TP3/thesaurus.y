%{
#include <stdio.h>
#include "documento.h"
#include "conceito.h"

int yylex();
void yyerror(char *s);
void checkLanguage(Documento d, char* lang);

Documento doc;
Conceito c;

%}

%union{
	char* param;
	char* nome;
	char* lang;
	char* val;
}
%token BASELANG LANGUAGES INV NT BT SN 
%token <param>PARAM
%token <nome>NOME
%token <lang>LANG
%token <val>VAL
%type <param> Parametros 
%type <val>ValoresNT
%type <val>ValoresBT

%%

Documento : Metadados '\n''\n' Conceitos		{docToHTML(doc);docToDOT(doc);}
	      ;

Metadados : Metadado
	  	  | Metadados '\n' Metadado
	      ;

Metadado : BASELANG PARAM 	    				{printf("YACC - Reconheceu baselang: %s\n",$2); setBaselang(doc,$2);}
	 	 | LANGUAGES Parametros	    			{printf("YACC -Languages são: %s\n",$2);}
	 	 | INV PARAM PARAM 	        			{printf("YACC - reconheceu inversa: %s inversa de %s\n",$2,$3); addInv(doc,$2); addInv(doc,$3);}
	 	 ;

Parametros : PARAM 								{ addLanguage(doc,$1);}
	   	   | Parametros PARAM   				{ addLanguage(doc,$2);}
	   	   ;

Conceitos : Conceito							{;}
	  	  | Conceito '\n' Conceitos				{;}
	  	  ;

Conceito : NOME '\n' Dados              {printf("YACC - reconheceu conceito: %s\n", $1); setNome(c,$1); addConceito(doc, c); c = initConceito();}
	 	 ;						

Dados : Dado '\n'
      | Dado '\n' Dados
      ;

Dado : NT ValoresNT 	              		{printf("YACC - reconheceu NT %s\n",$2);} 	
     | BT ValoresBT 						{printf("YACC - reconheceu BT %s\n",$2);}
     | SN VAL  								{printf("YACC - reconheceu SN %s\n",$2); setScope(c,$2);}
     | LANG VAL   							{checkLanguage(doc,$1); printf("YACC - reconheceu traducao %s\n",$2); addTraducao(c,$1,$2);}
     ;	

ValoresNT : VAL 							{addNarrow(c,$1);}
          | VAL ',' ValoresNT				{printf("YACC - VALORES: reconheceu %s  e %s\n",$1,$3); addNarrow(c,$1);}
          ;
          
ValoresBT : VAL 							{addBroader(c,$1);}
          | VAL ',' ValoresBT				{printf("YACC - VALORES: reconheceu %s  e %s\n",$1,$3); addBroader(c,$1);}
          ;


%%
#include "lex.yy.c"

void yyerror(char *s){
   fprintf(stderr,"%d: %s (%s)\n",yylineno,s,yytext);
}

void checkLanguage(Documento d, char* lang){
	for(int i=0;i<(d->languages)->len;i++){
		if(strcmp(g_array_index(d->languages,char*,i),lang)==0){
			return ;
		}
	}
	yyerror("Language not defined");
}

int main(int argc, char const *argv[])
{
	doc = initDocumento();
	c = initConceito();

	printf("A iniciar processamento\n");
	yyparse();
	printf("Processamento terminado. Estrutura preenchida\n");


	freeDocumento(doc);
	return 0;
}
