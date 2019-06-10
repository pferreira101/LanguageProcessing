%{
#include <stdio.h>
%}

%option yylineno
%x SCOPENOTE VALUES

%%

#.+              								{;}


"%language" 									{ return LANGUAGES;}
"%baselang" 									{ return BASELANG;}
"%inv" 											{ return INV;}

^"NT" 											{ BEGIN VALUES; return NT;}
^"NTP"											{ BEGIN VALUES; return NTP;}
^"NTG"  										{ BEGIN VALUES; return NTG;}
^"BT" 											{ BEGIN VALUES; return BT;}
^"BTP"											{ BEGIN VALUES; return BTP;}
^"BTG"											{ BEGIN VALUES; return BTG;}
^"SN" 											{ BEGIN SCOPENOTE; return SN;}
^"RT"											{ return RT;}
^[A-Z][A-Z] 									{ yylval.lang = strdup(yytext); return LANG;} 
[A-Z][A-Z]([A-Z])?								{ yylval.param = strdup(yytext); return PARAM;}
^([A-Za-z][a-z]+)(\ [A-Za-z][a-z]+)*	    	{ yylval.nome = strdup(yytext); return NOME;}
([A-Za-z][a-z]+)(\ [A-Za-z][a-z]+)* 			{ yylval.val = strdup(yytext); return VAL;}
[,\n]											{ return yytext[0];}
[\s\t] 											{ ;}

<VALUES>{
#.+              								{;}
,												{ return yytext[0];}
([A-Za-z][a-z]+)(\ [A-Za-z][a-z]+)* 			{ yylval.val = strdup(yytext); return VAL;}
\n/[^\t]										{ BEGIN INITIAL; return '\n';}	 
}


<SCOPENOTE>{
[^\n#]+ 										{ yylval.val = strdup(yytext); return VAL;}
#.+												{ ;}
\n/[^\t]										{ BEGIN INITIAL; return '\n';}	
\n\t 											{;}
}
%%


int yywrap() {
	return 1;
}
