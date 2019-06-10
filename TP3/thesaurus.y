%{
#include <stdio.h>
#include "documento.h"
#include "conceito.h"

int yylex();
void yyerror(char *s);
int checkLanguage(Documento d, char* lang);
int checkRelacoes(Documento d, char* rel);

Documento doc;
Conceito c;


%}

%union{
	char* param;
	char* nome;
	char* lang;
	char* val;
}
%token BASELANG LANGUAGES INV NT NTP NTG BT BTP BTG SN RT
%token <param>PARAM
%token <nome>NOME
%token <lang>LANG
%token <val>VAL
%type <param> Parametros 
%type <val>ValoresNT
%type <val>ValoresBT

%%

Documento : Metadados '\n''\n' Conceitos		{return 1;}
	      ;

Metadados : Metadado
	  	  | Metadados '\n' Metadado
	      ;

Metadado : BASELANG PARAM 	    				{printf("YACC - Reconheceu baselang: %s\n",$2); setBaselang(doc,$2);}
	 	 | LANGUAGES Parametros	    			{printf("YACC -Languages são: %s\n",$2);}
	 	 | INV PARAM PARAM 	        			{printf("YACC - reconheceu inversa: %s inversa de %s\n",$2,$3); addRelacao(doc,$2); addRelacao(doc,$3);}
	 	 ;

Parametros : PARAM 								{ addLanguage(doc,$1);}
	   	   | Parametros PARAM   				{ addLanguage(doc,$2);}
	   	   ;

Conceitos : Conceito							{;}
	  	  | Conceito '\n' Conceitos				{;}
	  	  ;

Conceito : NOME '\n' Dados              	{printf("YACC - reconheceu conceito: %s\n", $1); setNome(c,$1); addConceito(doc, c); c = initConceito();}
	 	 ;						

Dados : Dado '\n'
      | Dado '\n' Dados
      ;

Dado : NT ValoresNT 	              		{if(!checkRelacoes(doc,"NT")) return 0; }
	 | NTP ValoresNTP						{if(!checkRelacoes(doc,"NTP")) return 0; }
	 | NTG ValoresNTG						{if(!checkRelacoes(doc,"NTG")) return 0; }
     | BT ValoresBT 						{if(!checkRelacoes(doc,"BT")) return 0; }
     | BTP ValoresBTP						{if(!checkRelacoes(doc,"BTP")) return 0; }
     | BTG ValoresBTG						{if(!checkRelacoes(doc,"BTG")) return 0; }
     | RT ValoresRT							{;}
     | SN VAL  								{printf("YACC - reconheceu SN: %s\n",$2); setScope(c,$2);}
     | LANG VAL   							{if(!checkLanguage(doc,$1)) return 0; printf("YACC - reconheceu traducao %s\n",$2); addTraducao(c,$1,$2);}
     ;	

ValoresNT : VAL 							{addNT(c,$1);}
          | VAL ',' ValoresNT				{addNT(c,$1);}
          ;
          
ValoresNTP : VAL 							{addNTP(c,$1);}
           | VAL ',' ValoresNTP				{addNTP(c,$1);}
           ;

ValoresNTG : VAL 							{addNTG(c,$1);}
           | VAL ',' ValoresNTG				{addNTG(c,$1);}
           ;

ValoresBT : VAL 							{addBT(c,$1);}
          | VAL ',' ValoresBT				{addBT(c,$1);}
          ;

ValoresBTP : VAL 							{addBTP(c,$1);}
           | VAL ',' ValoresBTP				{addBTP(c,$1);}
           ;     

ValoresBTG : VAL 							{addBTG(c,$1);}
           | VAL ',' ValoresBTG				{addBTG(c,$1);}
           ;                         

ValoresRT : VAL 							{printf("YACC - adicionou RT na 1 clausula: %s\n",$1); addRelated(c,$1);}
          | VAL ',' ValoresRT				{printf("YACC - adicionou RT na 2 clausula: %s\n",$1); addRelated(c,$1);}
          ;    

%%
#include "lex.yy.c"

void yyerror(char *s){
   fprintf(stderr,"%d: %s (%s)\n",yylineno,s,yytext);
}

int checkLanguage(Documento d, char* lang){
	for(int i=0;i<(d->languages)->len;i++){
		if(strcmp(g_array_index(d->languages,char*,i),lang)==0){
			return 1;
		}
	}
	yyerror("Language not defined");
	return 0;
}

int checkRelacoes(Documento d, char* rel){
	for(int i=0;i<(d->relacoes)->len;i++){
		if(strcmp(g_array_index(d->relacoes,char*,i),rel)==0){
			return 1;
		}
	}
	yyerror("Relathionship not defined");
	return 0;
}

int main(int argc, char const *argv[])
{
	doc = initDocumento();
	c = initConceito();

	printf("A iniciar processamento\n");
	int ok = yyparse();
	if(ok){
		printf("Processamento terminado com sucesso. Estrutura preenchida\n");
		docToHTML(doc); printf("HTMLs gerados\n");
		docToDOT(doc); printf("DOCs gerados\n");
		docToDOTGeral(doc); printf("DOC Geral gerado\n");
	}
	else printf("Processamento abortado\n");


	freeDocumento(doc);
	return 0;
}
