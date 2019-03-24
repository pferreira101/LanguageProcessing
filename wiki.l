%{
    #include <stdio.h>
    #include <string.h>
    #include <glib.h>
    #include "structPage.h"
    Page p;

%}

%x PAGE TITLE TEXT INFOBOX PARENTHESES CATEGORY CURLY ABSTRACT

quotes ("''"|"'''")
sepCatg ("|")

%option stack

%%
"<page>"                        {BEGIN PAGE; p=initPage();}

<PAGE>{
	"<title>"                 	{BEGIN TITLE;}
	\<text[^>]+\>             	{BEGIN TEXT;}
	"</page>"                 	{BEGIN INITIAL;}
	.|\n 					   	{;}
}

<TITLE>(.+?)/"</title>"         {setPageTitle(p, yytext); BEGIN PAGE;}

<TEXT>{
	"{{Info"[\/]?             	{BEGIN INFOBOX;}
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
	" |"(.+)	                {addInfoLine(p, yytext+2);}
	^"}}"		         		{BEGIN ABSTRACT;}
}

<ABSTRACT>.+\n   				{ECHO; setPageAbstract(p, yytext); BEGIN TEXT;}

<PARENTHESES>{
	[0-9a-zA-Z ]*\|    			{;} 
	"]]"               			{yy_pop_state();}
}


<TEXT,ABSTRACT>{quotes}         {;}
<ABSTRACT,INFOBOX>"[["          {yy_push_state(PARENTHESES);}



(.|\n)                          {;}

%%


int yywrap(){
    return 1;
}


int main(){ 
    yylex();
    printf("=================#==================#=================\n"); printPage(p);
	pageToHTML(p);
    return 0;
}