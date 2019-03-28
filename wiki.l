%{
    #include <stdio.h>
    #include <string.h>
    #include <glib.h>
    #include "structPage.h"
    Page p;
    int pos;
    int top_state;

%}

%x PAGE TITLE TEXT INFOBOX PARENTHESES CATEGORY CURLY ABSTRACT INFOLINES

quotes ("''"|"'''")
sepCatg ("|")
parentOpen ("[["|"{{")
parentClose ("]]"|"}}")

%option stack

%%
"<page>"                        {BEGIN PAGE; p=initPage();}

<PAGE>{
	"<title>"                 	{BEGIN TITLE;}
	\<text[^>]+\>/[A-Z]			{BEGIN ABSTRACT;}
	\<text[^>]+\>/[^A-Z]        {BEGIN INFOBOX;}
	"</page>"                 	{BEGIN INITIAL;	pageToHTML(p);    printf("=================#==================#=================\n"); printPage(p);}
	.|\n 					   	{;}
}

<TITLE>(.+?)/"</title>"         {setPageTitle(p, yytext); BEGIN PAGE;}

<TEXT>{
	"[[Categoria:"            	{BEGIN CATEGORY;} 
	"</text>"                 	{BEGIN PAGE;}
	.|\n 						{;}
}

<CATEGORY>{	
	[^|\]]+/[\]|]				{addCategoria(p, yytext);} // apanhar texto todo até à | ou ]] (algumas catgorias nao tem | terminam logo com ]]!!!!!!!)
	[\]|]                  		{BEGIN TEXT;} // detetar fim de categoria (depois da | nao importa)
}

<INFOBOX>{
	"{{"(?i:info)\n								{BEGIN INFOLINES; printf("nao tem tema de infobox\n");}
	"{{"(?i:info)[ /][^}\n|]+/[\n|}]			{setPageInfoBCatg(p, yytext+7);BEGIN INFOLINES;}
	^[A-Z'{]								 	{unput(yytext[yyleng-1]); printf("a comecar abstract"); BEGIN ABSTRACT;} // volta a por carater do resumo no input
}

<INFOLINES>{
	\ ?\|[^|\[\n}]*/[\n|\[}]	    {if(yytext[0]==' ') pos=2; else pos=1; addInfoLine(p, yytext+pos);}	
	[^\[|}\n]+/[\n\[|}] 			{addInfoLineChunk(p, yytext);} // curls tao aqui por causa de detetar o fim sem ser no inicio de frase, assim nao os apanha
	"}}"		         			{BEGIN INFOBOX;}
}	


<ABSTRACT>[^\[\n]*/[\[\n]			{ addChunkAbstract(p, yytext);}
<ABSTRACT>(\n\n|\n=)   		{ BEGIN TEXT;}

<PARENTHESES>{
	[^|\]]+    					{if(top_state==INFOLINES)
									addInfoLineChunk(p, yytext);
								 if(top_state==ABSTRACT)
									addChunkAbstract(p, yytext);
									printf("a adicionar %s\n",yytext);
								}
	[^|\]]*\|					{;}		  
	"]]"               			{yy_pop_state();printf("a sair de parentesis\n");}
}


<TEXT,ABSTRACT>{quotes}         {;}
<INFOLINES,ABSTRACT>"[["        {yy_push_state(PARENTHESES);printf("a entrar em modo parentesis\n"); top_state=yy_top_state();}



(.|\n)                          {;}


%%


int yywrap(){
    return 1;
}


int main(){ 
    yylex();
    return 0;
}