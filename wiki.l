%{
    #include <stdio.h>
    #include <string.h>
    #include <glib.h>
    #include "structPage.h"
    Page p;
    int pos;
    int top_state;
    int ignore_page;

	char* categoria = "";
	int max_pages = 2147483647;
	int processed_pages = 0;
	int all_flag = 0;

%}

%x PAGE TITLE TEXT INFOBOX PARENTHESES CATEGORY CURLY ABSTRACT INFOLINES

sepCatg ("|")
parentOpen ("[["|"{{")
parentClose ("]]"|"}}")

%option stack

%%
"<page>"                        {BEGIN PAGE; p=initPage(); ignore_page=0;}

<PAGE>{
	"<title>"                 	{BEGIN TITLE;}
	\<text[^>]+\>/[A-Z]			{BEGIN ABSTRACT;}
	\<text[^>]+\>/[^A-Z]        {BEGIN INFOBOX;}
	\<text[^>]+\>/"{| class="	{ignore_page = 1;}
	"</page>"                 	{BEGIN INITIAL; 									
									if(!ignore_page){
										if(processed_pages < max_pages) processed_pages++;
                                 		else return 0;
										if(all_flag || checkCategoria(p, categoria)) pageToHTML(p); 
									}
									printf("=================#==================#=================\n"); 
									printPage(p); 
									freePage(p); 
									printf("=================#==================#=================\n");
								}
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
	#(?i:redire)												{ignore_page=1; BEGIN PAGE;}
	"{{"(?i:info)\n												{BEGIN INFOLINES; /*printf("nao tem tema de infobox\n");*/}
	"{{"(?i:info)[ /][^}\n|]+/[\n|}]							{/*printf("a adicionar cat %s\n", yytext);*/setPageInfoBCatg(p, yytext+7);BEGIN INFOLINES;}
	"{{"[^iI][^{}]*"}}"\n  										{/*printf("a eliminar1: %s ###\n",yytext)*/;}//eliminar o que nao interessa
	"[["[^\[\]]*"]]"\n 											{/*printf("a eliminar2: %s ###\n",yytext)*/;}//eliminar o que nao interessa
	"{{"														{yy_push_state(CURLY); top_state=yy_top_state();}
	[A-Z()'']							 						{ECHO; unput(yytext[yyleng-1]); /*printf("a comecar abstract\n");*/ BEGIN ABSTRACT;} // volta a por carater do resumo no input
}

<INFOLINES>{
	\ ?\|[^|&\[\n}{]*/[\n&{|\[}]	    {if(yytext[0]==' ') pos=2; else pos=1; addInfoLine(p, yytext+pos);}	
	[^\[|&}{\n]+/[{\n\[|&}] 			{addInfoLineChunk(p, yytext);} // curls tao aqui por causa de detetar o fim sem ser no inicio de frase, assim nao os apanha
	"}}"		         				{/*printf("a sair de infolines\n");*/BEGIN INFOBOX;}
}	

<ABSTRACT>[^\[\n{&]+/[\[\n{&]		{/*printf("apanha isto");*/ addChunkAbstract(p, yytext);}
<ABSTRACT>(\n\n|\n=)   				{/*printf("este");*/ BEGIN TEXT;}
<ABSTRACT>\[						{/*printf("este2");*/ addChunkAbstract(p,yytext);}//precaver de [...] que aparecem em algumas paginas


<PARENTHESES>{
	[^|\]]+    					{if(top_state==INFOLINES)
									addInfoLineChunk(p, yytext);
								 if(top_state==ABSTRACT)
									addChunkAbstract(p, yytext);
								}
	[^|\]]*\|					{;}		  
	"]]"               			{yy_pop_state();}
}

<CURLY>{
	[A-Za-z]+/[}]				{if(top_state==INFOLINES)
									addInfoLineChunk(p, yytext);
								 if(top_state==ABSTRACT)
									addChunkAbstract(p, yytext);
								}
	"}}"						{yy_pop_state();}

}


<INFOLINES,ABSTRACT>{
	"[["       							{yy_push_state(PARENTHESES); top_state=yy_top_state();}
	&lt;ref(.+?)&gt;(.+?)&lt;\/ref&gt; 	{/*printf("apanhou REF %s\n",yytext)*/;}
	&lt;br&gt;							{;}
	"{{"								{yy_push_state(CURLY); top_state=yy_top_state();}		
}



(.|\n)                          {;}


%%


int yywrap(){
    return 1;
}

int main(int argc, char* argv[]){
	if(argc < 2) {
		printf("Por favor, insira os argumentos corretos.\n");
		return -1;
	} 
	
	if(strcmp("-a", argv[1]) == 0) all_flag = 1;
	
	categoria = argv[1];
	printf("%s\n",categoria);

    
	if(argc == 3) max_pages = atoi(argv[2]);
    yylex();

	printf("\n\n %d\n --- FIM DE PROCESSAMENTO --- \n", processed_pages);

    return 0;
}