%{
    #include <stdio.h>
    #include <string.h>
    #include "structPage.h"
    Page p;
    int ignore_page;

%}

%x PAGE TITLE 

%%
"<page>"                        {BEGIN PAGE; p=initPage(); ignore_page=0; }

<PAGE>{
	"<title>Predefinição"		{ignore_page = 1;}
	"<title>MediaWiki:"			{ignore_page = 1;}
	"<title>Wikipédia:"			{ignore_page = 1;}
	\<text[^>]+\>#(?i:redire) 	{ignore_page = 1;}
	\<text[^>]+\>"{| class="	{ignore_page = 1;}
	\<text[^>]+\>"{{"[Dd]esam	{ignore_page = 1;}
	"<title>"                 	{BEGIN TITLE;}
	"</page>"                 	{ BEGIN INITIAL; 									
								  if(!ignore_page){
									printf("%s\n",getTitulo(p));
								  }
								  freePage(p);
								}
	.|\n 					   	{;}
}

<TITLE>(.+?)/"</title>"         { setPageTitle(p,yytext); BEGIN PAGE;}

.|\n 						{;}
%%
int yywrap(){
    return 1;
}

int main(int argc, char* argv[]){

    yylex();


    return 0;
}