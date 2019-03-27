%{
    #include <stdio.h>
    #include <string.h>
    #include <glib.h>
    #include "structPage.h"
    Page p;
    int pos;

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
	(.+?)/{sepCatg}				{addCategoria(p, yytext);} // apanhar texto todo até à | ou ]] (algumas catgorias nao tem | terminam logo com ]]!!!!!!!)
	"|"(.+?)/"]]"	       		{;} // eliminar texto depois da | até final da categoria
	"]]"                  		{BEGIN TEXT;} // detetar fim de categoria
}

<INFOBOX>{
	"{{"(?i:info)\/				           		{BEGIN INFOLINES;}
	({parentOpen}(.+?){parentClose}\n)*			{;}//estas sao para ignorar
	^[A-Z'{]								 	{unput(yytext[yyleng-1]); printf("a comecar abstract"); BEGIN ABSTRACT;} // volta a por carater do resumo no input
}

<INFOLINES>{
	^\ ?\|[^\[\n]*(\n)	        {if(yytext[0]==' ') pos=2; else pos=1; addInfoLine(p, yytext+pos);}	
	^\ ?\|[^\[\n]*	            {if(yytext[0]==' ') pos=2; else pos=1; addInfoLine(p, yytext+pos);}
	\][^\]\[\n]*[\n\[] 			{if(yytext[yyleng-1]=='[') {unput('[');yytext[yyleng-1]='\0';}addInfoLine(p, yytext+1);}
	^"}}"		         		{BEGIN INFOBOX;}
}	

<ABSTRACT>.+\n   				{ setPageAbstract(p, yytext); BEGIN TEXT;}

<PARENTHESES>{
	[^|\]]+    					{addInfoLine(p, yytext);}
	[^|\]]*\|					{;}		  
	"]]"               			{unput(']'); yy_pop_state();}
	\|							{;}
}


<TEXT,ABSTRACT>{quotes}         {;}
<INFOLINES>"[["        {yy_push_state(PARENTHESES);}



(.|\n)                          {;}

%%


int yywrap(){
    return 1;
}


int main(){ 
    yylex();
    return 0;
}