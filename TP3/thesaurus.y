%{
#include <stdio.h>
int yylex();
void yyerror(char *s);
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
%type <val>Valores

%%

Documento : Metadados '\n''\n' Conceitos
	  	  ;

Metadados : Metadado
	  	  | Metadados '\n' Metadado
	      ;

Metadado : BASELANG PARAM 	    			{printf("YACC - Reconheceu baselang: %s\n",$2);}
	     | LANGUAGES Parametros	    		{printf("Languages são: %s\n",$2);}
	     | INV PARAM PARAM 	        		{printf("YACC - reconheceu inversa: %s inversa de %s\n",$2,$3);}
	     ;

Parametros : PARAM 						
	   	   | Parametros PARAM   		
	       ;

Conceitos : Conceito
	      | Conceitos '\n' Conceito
	      ;

Conceito : NOME '\n' Dados                  		{printf("YACC - reconheceu conceito: %s\n", $1);}
	     ;

Dados : Dado '\n'
      | Dado '\n' Dados
      ;

Dado : NT Valores 	              					{printf("reconheceu NT %s\n",$2);}    						
     | BT Valores 									{printf("reconheceu BT %s\n",$2);}
     | SN VAL  										{printf("reconheceu SN %s\n",$2);}
     | LANG VAL   									{printf("reconheceu traducao %s\n",$2);}

Valores : VAL 
        | VAL ',' Valores							{printf("VALORES: reconheceu %s  e %s\n",$1,$3);}
        ;


%%
#include "lex.yy.c"

void yyerror(char *s){
   fprintf(stderr,"%d: %s (%s)\n",yylineno,s,yytext);
} 

int main(int argc, char const *argv[])
{
	printf("A iniciar processamento\n");
	yyparse();
	return 0;
}
