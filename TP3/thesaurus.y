%{
#include <stdio.h>
int yyerror(char *s);
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
%token lang>LAN
%token <val>VAL


%%

Documento : Metadados '\n\n' Conceitos
	  ;


Metadados : Metadado
	  | Metadados '\n' Metadado
	  ;

Metadado : Diretiva ' ' Parametros
	 ;

Diretiva : BASELANG
         | LANGUAGES
	 | INV
         ;

Parametros : Parametro
	   | Parametros ' ' Parametro
	   ;

Parametro : PARAM
          ;

Conceitos : Conceito
	  | Conceitos '\n' Conceito
	  ;

Conceito : NOME '\n' Dados
	 ;

Dados : Dado
      | Dados '\n' Dado
      ;

Dado : Tipo ' ' VAL
     ;

Tipo : NT
     | BT
     | SN
     | LAN
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
