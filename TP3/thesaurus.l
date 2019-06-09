%{
#include <stdio.h>
%}

%option yylineno


%%

#.+              	{printf("reconheceu comentario\n");}

"%language" 		{printf("flex - reconheceu languages\n"); return LANGUAGES;}
"%baselang" 		{printf("flex - reconheceu baselang\n"); return BASELANG;}
"%inv" 				{printf("flex - reconheceu inv\n"); return INV;}

^"NT" 				{return NT;}  
^"BT" 				{return BT;}
^"SN" 				{return SN;}
^[A-Z][A-Z] 		{printf("flex - reconheceu traducao: %s\n", yytext); yylval.lang = strdup(yytext); return LANG;} 
[A-Z][A-Z]			{printf("flex - a imprimir duas maiusculas: %s\n", yytext); yylval.param = strdup(yytext); return PARAM;}
^[A-Za-z][a-z]+	    {printf("flex - reconheceu nome de conceito: %s\n", yytext); yylval.nome = strdup(yytext); return NOME;}
[A-Za-z][a-z]+ 		{printf("flex - reconheceu valor: %s\n",yytext); yylval.val = strdup(yytext); return VAL;}
[,\n]				{return yytext[0];}
[\s \t] 			{;}
%%

int yywrap() {
	return 1;
}
