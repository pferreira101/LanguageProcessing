%{
#include <stdio.h>
%}

%option yylineno
%x SCOPENOTE 

%%
	
#.+              								{printf("flex - reconheceu comentario\n");}
^#(.)*\n										{printf("flex - reconheceu comentario de início\n");}

"%language" 									{printf("flex - reconheceu languages\n"); return LANGUAGES;}
"%baselang" 									{printf("flex - reconheceu baselang\n"); return BASELANG;}
"%inv" 											{printf("flex - reconheceu inv\n"); return INV;}

^"NT" 											{return NT;}
^"NTP"											{return NTP;}
^"NTG"  										{return NTG;}
^"BT" 											{return BT;}
^"BTP"											{return BTP;}
^"BTG"											{return BTG;}
^"SN" 											{printf("flex - reconheceu SN\n"); BEGIN SCOPENOTE; return SN;}
^"RT"											{return RT;}
^[A-Z][A-Z] 									{printf("flex - reconheceu traducao: %s\n", yytext); yylval.lang = strdup(yytext); return LANG;} 
[A-Z][A-Z]([A-Z])?								{printf("flex - a imprimir duas maiusculas: %s\n", yytext); yylval.param = strdup(yytext); return PARAM;}
^([A-Za-z][a-z]+)(\ [A-Za-z][a-z]+)*	    	{printf("flex - reconheceu nome de conceito: %s\n", yytext); yylval.nome = strdup(yytext); return NOME;}
([A-Za-z][a-z]+)(\ [A-Za-z][a-z]+)* 			{printf("flex - reconheceu valor: %s\n",yytext); yylval.val = strdup(yytext); return VAL;}
[,\n]											{return yytext[0];}
[\s\t] 											{;}

<SCOPENOTE>{
[^\n#]+ 										{printf("flex SN - reconheceu valor: %s\n",yytext); yylval.val = strdup(yytext); BEGIN INITIAL; return VAL;}
#.+											{printf("flex SN - reconheceu comentario\n"); BEGIN INITIAL;}
}
%%


int yywrap() {
	return 1;
}
