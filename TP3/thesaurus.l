%{
#include <stdio.h>
%}

%option yylineno
%x SCOPENOTE VALUES

%%

#.+              								{printf("flex - reconheceu comentario\n");}


"%language" 									{printf("flex - reconheceu languages\n"); return LANGUAGES;}
"%baselang" 									{printf("flex - reconheceu baselang\n"); return BASELANG;}
"%inv" 											{printf("flex - reconheceu inv\n"); return INV;}

^"NT" 											{ BEGIN VALUES; return NT;}
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
[,\n]											{printf("a retornar \\n %d\n",yylineno);return yytext[0];}
[\s\t] 											{;}

<VALUES>{
#.+              								{printf("flex 333- reconheceu comentario\n");}
,												{return yytext[0];}
([A-Za-z][a-z]+)(\ [A-Za-z][a-z]+)* 			{printf("flex - reconheceu valor: %s\n",yytext); yylval.val = strdup(yytext); return VAL;}
\n/[^\t]										{printf("reconheceu istoo\n"); BEGIN INITIAL; return '\n';}	 
}


<SCOPENOTE>{
[^\n#]+ 										{printf("flex SN - reconheceu valor: %s\n",yytext); yylval.val = strdup(yytext); return VAL;}
#.+												{printf("flex SN - reconheceu comentario %d\n",yylineno);}
\n/[^\t]										{printf("reconheceu istoo %d\n",yylineno); BEGIN INITIAL; return '\n';}	
\n\t 											{;}
}
%%


int yywrap() {
	return 1;
}
