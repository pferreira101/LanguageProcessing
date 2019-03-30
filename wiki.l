%{
    #include <stdio.h>
    #include <string.h>
    #include <glib.h>
    #include "structPage.h"
    Page p;
    int pos;
    int top_state;
    int ignore_page;
    int in_pretty_mode;
    int num_pelicas;
    int flag;

	char* categoria = "";
	int max_pages = 2147483647;
	int processed_pages = 0;
	int all_flag = 0;
	void addToTopContext(char* txt);
	void outprettyMode(int num_pel_in, int num_pel_out);
%}

%x PAGE TITLE TEXT INFOBOX PARENTHESES CATEGORY CURLY ABSTRACT INFOLINES SMALLTEXT QUOT DELETEREF
%x PRETTY PCATCHTXTI PCATCHTXTB PCATCHTXTIB	

sepCatg ("|")
parentOpen ("[["|"{{")
parentClose ("]]"|"}}")

%option stack

%%
"<page>"                        {BEGIN PAGE; flag=0;p=initPage(); ignore_page=0; in_pretty_mode=0;}

<PAGE>{
	"<title>Predefinição"		{ignore_page=1;}
	"<title>MediaWiki:"			{ignore_page=1;}
	"<title>Wikipédia:"			{ignore_page=1;}
	"<title>"                 	{BEGIN TITLE;}
	\<text[^>]+\>/[A-Z]			{if(!ignore_page)BEGIN ABSTRACT;}
	\<text[^>]+\>/[^A-Z]        {if(!ignore_page)BEGIN INFOBOX;}
	\<text[^>]+\>"{| class="	{ignore_page = 1;}
	\<text[^>]+\>"{{"[Dd]esam	{ignore_page = 1;}
	"</page>"                 	{BEGIN INITIAL; 									
									if(!ignore_page){
										if(processed_pages < max_pages) processed_pages++;
                                 		else return 0;
										if(all_flag || checkCategoria(p, categoria)) pageToHTML(p); 
									}
									//printf("=================#==================#=================\n"); 
									//printPage(p); 
									freePage(p); 
									//printf("=================#==================#=================\n");
								}
	.|\n 					   	{;}
}

<TITLE>(.+?)/"</title>"         {setPageTitle(p, yytext);printf("%s\n",yytext); BEGIN PAGE;}

<TEXT>{
	"[[Categoria:"            	{BEGIN CATEGORY;} 
	"</text>"                 	{BEGIN PAGE;}
	.|\n 						{;}
}

<CATEGORY>{	
	[^|\]<]+/[\]|<]					{addCategoria(p, yytext);} // apanhar texto todo até à | ou ]] (algumas catgorias nao tem | terminam logo com ]]!!!!!!!)
	[\]|]              	    		{BEGIN TEXT;} // detetar fim de categoria (depois da | nao importa)
	\<								{BEGIN TEXT; unput('<');}//se nao fechar os [[]]
}
	
<INFOBOX>{
	#(?i:redire)												{ignore_page=1; BEGIN PAGE;}
	"{{"(?i:info)\n												{BEGIN INFOLINES; top_state=INFOLINES;}
	"{{"(?i:info)[ /][^}\n|]+/[\n|}]							{setPageInfoBCatg(p, yytext+7);BEGIN INFOLINES;top_state=INFOLINES;}
	"{{"[^iI][^{}]*"}}"\n										{/*printf("a eliminar1: %s ###\n",yytext)*/;}//eliminar o que nao interessa
	"[["(.+?)"]]"\n 											{/*printf("a eliminar2: %s ###\n",yytext)*/;}//eliminar o que nao interessa
	"{{"														{/*printf("a comecar\n")*/;flag=1;yy_push_state(CURLY); top_state=INFOBOX;} //elimina restantes casos,nao vai escrever para lado nenhum
	"{{PBPE|"[^}]+"}}"											{yytext[yyleng-2]='\0';addChunkAbstract(p,yytext+7);top_state=ABSTRACT; BEGIN ABSTRACT;}
	"{{PU-"[A-Z0-9]{4}\|[^}]+"}}"								{yytext[yyleng-2]='\0';addChunkAbstract(p,yytext+10);top_state=ABSTRACT; BEGIN ABSTRACT;}
	[A-Z']							 							{/*printf("a comecar abstract %s\n",yytext);*/unput(yytext[yyleng-1]);  BEGIN ABSTRACT;top_state=ABSTRACT;} // volta a por carater do resumo no input
}

<INFOLINES>{
	\ ?\|[^'|&\[\n}{]*/[\n'&{|\[}]	    {if(yytext[0]==' ') pos=2; else pos=1; addInfoLine(p, yytext+pos);}	
	[^\[|'&}{\n]+/[{\n\[|'&}] 			{addInfoLineChunk(p, yytext);} // curls tao aqui por causa de detetar o fim sem ser no inicio de frase, assim nao os apanha
	&lt;br[ /]*&gt;						{addInfoLineChunk(p, "<br>______");}
	"}}"		         				{/*printf("a sair de infolines\n");*/BEGIN INFOBOX;}
	.|\n 								{;}
}	

<ABSTRACT>{
	[^\['\n{&]+/[\['\n{&]		{/*printf("apanha isto");*/ addChunkAbstract(p, yytext);}
	(\n\n|\n=)   				{/*printf("este");*/ BEGIN TEXT;}
	\[							{/*printf("este2");*/ addChunkAbstract(p,yytext);}//precaver de [...] que aparecem em algumas paginas
	\{							{addChunkAbstract(p,yytext);}
	\n 							{addToTopContext("<br>");}
	"[[Categoria:"				{BEGIN CATEGORY;} //paginas que começam logo categoria sem duplo \n

}

<PARENTHESES>{
	[^|\]]+    					{addToTopContext(yytext);}
	[^|\]]*\|					{;}		  
	"]]"               			{yy_pop_state();}
}

<CURLY>{
	[^{}]+/[{}]				{addToTopContext(yytext);}
	"}}"					{yy_pop_state();if(flag) flag=0;}
	"{{"					{yy_push_state(CURLY);}
	(.|\n)					{addToTopContext(yytext);}
}


<INFOLINES,ABSTRACT>{
	"[["       							{yy_push_state(PARENTHESES);}
	&lt;[Rr]ef							{yy_push_state(DELETEREF);}
	&lt;ref[^/]*\/&gt;					{;}
	&lt;[/]?small&gt;					{;}
	"{{"								{yy_push_state(CURLY);}
	&quot;								{addToTopContext("''");}
	&lt;!--(.+?)--&gt;					{;}	
	&amp;								{;}
	&amp;nbsp;							{;}
	&lt;math&gt;						{addToTopContext("<MATH>");}
	&lt;\/math&gt;						{addToTopContext("</MATH>");}
}



<DELETEREF>{
	[^&<]+/[&<]						{;}
	&lt;\/ref&gt;               	{yy_pop_state();}
	\</\/text\>						{ignore_page=1; unput('<'); BEGIN TEXT;}//se isto acontecer, ref nao foi fechado
	.|\n 							{;}							// entao nao se processa pagina
}




<ABSTRACT,INFOLINES>{
	''							{	if(in_pretty_mode==0){
										in_pretty_mode=1; addToTopContext("<i>"); num_pelicas=2;
									}
									else outprettyMode(num_pelicas, 2);
								}
	'''							{	if(in_pretty_mode==0){
										in_pretty_mode=1; addToTopContext("<b>"); num_pelicas=3;
									}
									else outprettyMode(num_pelicas, 3);
								}
	'''''						{	if(in_pretty_mode==0){
										in_pretty_mode=1; addToTopContext("<i><b>"); num_pelicas=5;
									}
									else outprettyMode(num_pelicas, 5);

								}
}



<*>(.|\n)                          {;}

%%

void outprettyMode(int num_pel_in, int num_pel_out){
	int dif = num_pel_out-num_pel_in;

	if(num_pel_in==2)addToTopContext("</i>");
	if(num_pel_in==3)addToTopContext("</b>");
	if(num_pel_in==5)addToTopContext("</i></b>");

	for(int i=0;i<dif;i++){
		unput('\'');
	}

	in_pretty_mode=0;
}

void addToTopContext(char* txt){
	//if(flag){printf("%s\n",txt);}
	if(top_state==INFOLINES)
		addInfoLineChunk(p, txt);
	if(top_state==ABSTRACT)
		addChunkAbstract(p, txt);
}

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
	//printf("%s\n",categoria);

    
	if(argc == 3) max_pages = atoi(argv[2]);
    yylex();

	printf("\n\n %d\n --- FIM DE PROCESSAMENTO --- \n", processed_pages);

    return 0;
}