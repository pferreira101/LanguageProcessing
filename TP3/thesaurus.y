%{
#include <stdio.h>
int yyerror(char *s);
%}

%union (char* str)
%token BASELANG ACCEPTLANGS <str>value

%%

Documento : Metadados '\n\n' Conceitos
		  ;


Metadados : Metadado
		  | Metadados '\n' Metadado
		  ;

Metadado : Diretiva ' ' Parametros
		 ;

Diretiva : BASELANG
         | ACCEPTLANGS
         ;

Parametros : Parametro
		   | Parametros ' ' Parametro
		   ;

Paramentro : value
           ;

Conceitos : Conceito
		  | Conceios '\n' Conceito
		  ;

Conceito : Nome '\n' Dados
		 ;

Nome : value
     ;

Dados : Dado
      | Dados '\n' Dado
      ;

Dado : value 
     ;


%%

int yyerror(char *s){
	printf("ERRO: %s \n", s);
	return 0;
}

int main(int argc, char const *argv[])
{
	yyparse();
	return 0;
}
