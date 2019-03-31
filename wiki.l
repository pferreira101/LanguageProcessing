%{
    #include <stdio.h>
    #include <string.h>
    #include <glib.h>
    #include "structPage.h"
    #include <time.h>

    Page p;

    int pos;
    int top_state;
    int ignore_page;
    int in_pretty_mode;
    int num_pelicas;
    int head_removed= 0;
    int debug_mode = 0;
    int ignore_cont_p = 0;
    int ignore_cont_c = 0;
    int curl_reclvl = 0;
    char next;
	char* categoria = "";
	int max_pages = 2147483647;
	int processed_pages = 0;
	int all_flag = 0;
	int total_categoria = 0;
	char* link_to;
	int ident_lvl=0;
	void addToTopContext(char* txt);
	void outprettyMode(int num_pel_in, int num_pel_out);
%}

%x PAGE TITLE TEXT INFOBOX PARENTHESES CATEGORY CURLY BUILDLIST
%x ABSTRACT INFOLINES  DELETEREF DELETETAG PBPE HREF GETLISTLINE


sepCatg ("|")
parentOpen ("[["|"{{")
parentClose ("]]"|"}}")

%option stack

%%
"<page>"                        		{BEGIN PAGE; p=initPage(); ignore_page=0; in_pretty_mode=0;}

<PAGE>{
	"<title>Predefinição"				{ ignore_page = 1;}
	"<title>MediaWiki:"					{ ignore_page = 1;}
	"<title>Wikipédia:"					{ ignore_page = 1;}
	\<text[^>]+\>"{| class="			{ ignore_page = 1;}
	\<text[^>]+\>"{{"[Dd]esam			{ ignore_page = 1;}
	\<text[^>]+\>/[A-Z]					{ if(!ignore_page) BEGIN ABSTRACT;}
	\<text[^>]+\>/[^A-Z]        		{ if(!ignore_page) BEGIN INFOBOX;}
	"<title>"                 			{ BEGIN TITLE;}
	"</page>"                 			{ BEGIN INITIAL; 									
										  if(!ignore_page){
											if(debug_mode) printf("%s\n",getTitulo(p));
											processed_pages++;
										  }
										  if(processed_pages >= max_pages) return 0;
										  if(all_flag) pageToHTML(p); 
										  else if(checkCategoria(p, categoria)){
											  total_categoria++;
											  pageToHTML(p);
										  }
										  freePage(p); 
										}		
	.|\n   	 					   		{;}
}

<TITLE>(.+?)/"</title>"         		{ setPageTitle(p, yytext); BEGIN PAGE;} 

<TEXT>{
	"[[Categoria:"            			{ BEGIN CATEGORY;} 
	"</text>"                 			{ BEGIN PAGE;}
	.|\n 								{ ;}
}

<CATEGORY>{	
	[^|\]<]+/[\]|<]					{ addCategoria(p, yytext);} // apanhar texto todo até à | ou ]] (algumas catgorias nao tem | terminam logo com ]]!!!!!!!)
	[\]|]              	    		{ BEGIN TEXT;} // detetar fim de categoria (depois da | nao importa)
	\<								{ BEGIN TEXT; unput('<');} // se nao fechar os [[]]
}
	
<INFOBOX>{
	&lt;div(.+?)\/div&gt;										{;}
	#(?i:redire)												{ ignore_page=1; BEGIN PAGE;}
	"{{"(?i:info)\n												{ BEGIN INFOLINES; top_state = INFOLINES;}
	"{{"(?i:info)[ /][^}\n|]+/[\n|}]							{ setPageInfoBCatg(p, yytext+7); BEGIN INFOLINES; top_state = INFOLINES;}
	"{{"[^iI][^{}]*"}}"\n										{;}
	"[["(.+?)"]]"\n 											{;}
	"{{"														{ yy_push_state(CURLY); top_state = INFOBOX;} //elimina restantes casos,nao vai escrever para lado nenhum
	"{{"PBPE[^|]*\|												{ BEGIN ABSTRACT; // begin abs para depois ao fazer popstack ir para abs
																  yy_push_state(PBPE); 
																  top_state=ABSTRACT;}
	"{{PU-"[A-Z0-9]{4}\|[^}]+"}}"								{ 	yytext[yyleng-2]='\0';
																	addChunkAbstract(p,yytext+10);
																	top_state = ABSTRACT; 
																	BEGIN ABSTRACT;
																}
    &lt;!--														{ yy_push_state(DELETETAG);} // sem isto estraga paginas como a de 1946
	[A-Z'=]							 							{ unput(yytext[yyleng-1]); BEGIN ABSTRACT; top_state = ABSTRACT;} // volta a por carater do resumo no input
}

<INFOLINES>{
	\ ?\|[^'|&\[\n}{]*/[\n'&{|\[}]	    {	if(yytext[0]==' ') pos = 2; 
											else pos=1; 
											addInfoLine(p, yytext+pos);
										}	
	[^\[|'&}{\n]+/[{\n\[|'&}] 			{ addInfoLineChunk(p, yytext);} // curls tao aqui por causa de detetar o fim sem ser no inicio de frase, assim nao os apanha
	&lt;br[ /]*&gt;						{ addInfoLineChunk(p, "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");}
	"}}"		         				{ BEGIN INFOBOX;}
	.	 								{ ;}
}	

<ABSTRACT>{
	[^\*=\['\n{&]+/[\*=\['\n{&]		{ addChunkAbstract(p, yytext);}
	(\n\n|\n=)   				{ BEGIN TEXT;}
	\[							{ addChunkAbstract(p,yytext);} // precaver de [...] que aparecem em algumas paginas
	\{							{ addChunkAbstract(p,yytext);}
	\n 							{ addChunkAbstract(p,"<br>");}
	"[[Categoria:"				{ BEGIN CATEGORY;} // paginas que começam logo categoria sem duplo \n
	^\*							{ unput('*'); yy_push_state(BUILDLIST);}
	\=							{ addChunkAbstract(p,"=");} // para nao afetar a formatacao
	==(.+?)==/\n 				{ yytext[yyleng-2]='\0';
								  addChunkAbstract(p,"<h4>"); 
								  addChunkAbstract(p,yytext+2);
								  addChunkAbstract(p,"</h4>");
								}							
}



<PARENTHESES>{
	[^|\]\[]+    			{ if(!(ignore_cont_p+ignore_cont_c)) addToTopContext(yytext);}
	[^|\]\[]*\|				{;}		
	"]]"/\n					{ if(ignore_cont_p) ignore_cont_p--;
							  else addToTopContext(" ");//apenas para embelezar
							  yy_pop_state(); 
							}  
	"]]"               		{ yy_pop_state(); if(ignore_cont_p) ignore_cont_p--;} 
	"[["					{ if(ignore_cont_p) ignore_cont_p++; yy_push_state(PARENTHESES);}// se estiver a ignorar aumenta nivel
}


<CURLY>{ 
	[Nn]ota\ de\ [Rr]odapé\ ?\|			{ ignore_cont_c++;	}		
	formatnum:[0-9]*"}}" 				{ yytext[yyleng-2]='\0'; 
										  addToTopContext(yytext+10); 
										  yy_pop_state();
										}
	PAGENAME\}\}						{ addToTopContext(getTitulo(p));yy_pop_state();}
	PBPE[^|]*\|							{ BEGIN PBPE; }
	"PU-"[A-Z0-9]{4}\|[^}]+"}}"			{ 	yytext[yyleng-2]='\0';
												addToTopContext(yytext+8);
												yy_pop_state(); 
										}
	[^{\['|}]+/[{\['|}]					{ next=input(); 
										  if((next!='|' || head_removed==1)&&!ignore_cont_c)
										  	addToTopContext(yytext);
										  if(next!='|')unput(next);
										  head_removed=1;
										}
	"[["								{ yy_push_state(PARENTHESES);}									
	"}}"								{ head_removed=0;  yy_pop_state();
										  if(ignore_cont_c) 
										  	ignore_cont_c--; //diminui nivel da variavel para depois ser 0 nas chavetas que fecham a primeira abertura 
										 
										} 
	"{{"								{ head_removed=0; 
										  if(ignore_cont_c) 
										  	ignore_cont_c++; //aumenta nivel para ao retomar e terminar meter ignore a 0
										  yy_push_state(CURLY);
										} 
	(.|\n)								{ if(!ignore_cont_c) addToTopContext(yytext);}//adicona | que separam os curls
}




<ABSTRACT,INFOLINES>{
	\[http[^ \]]+\ 						{ asprintf(&link_to,"<a href=\"%s\">",yytext+1);
										  addToTopContext(link_to); free(link_to);
										  yy_push_state(HREF);
										} 
	\[mailto:[^ \]\n]+\ 					{ asprintf(&link_to,"<a href=\"%s\">",yytext+1);
										  addToTopContext(link_to); free(link_to);
										  yy_push_state(HREF);
										} 		
}

<INFOLINES,ABSTRACT,CURLY>{
	"[[":?(?i:ficheiro):				{ ignore_cont_p++; yy_push_state(PARENTHESES);}
	"[[":?(?i:imagem):					{ ignore_cont_p++; yy_push_state(PARENTHESES);}
	"[["       							{ yy_push_state(PARENTHESES);}
	&lt;[Rr]ef							{ yy_push_state(DELETEREF);}
	&lt;ref[^/]*\/&gt;					{;}
	&lt;								{ addToTopContext("<");}
	&gt;								{ addToTopContext(">");}
	"{{"								{ yy_push_state(CURLY);}
	&quot;								{ addToTopContext("''");}
	&lt;!--								{ yy_push_state(DELETETAG);}
	&amp;								{;}
	&amp;nbsp;							{;}
	&lt;[/]?center&gt;					{;}
}



<ABSTRACT,INFOLINES,PBPE,CURLY>{
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


<BUILDLIST>{
	^\*{1,}							{ if(ident_lvl<yyleng) //iniciar nova lista aninhada
									 	addToTopContext("<ul>");
									  if(ident_lvl>yyleng) //terminar lista aninhada	
									  	addToTopContext("</ul>");
									  ident_lvl=yyleng;
									  addToTopContext("<li>");
									  BEGIN GETLISTLINE;	
									} 
	^[^*]							{ addToTopContext("</ul>"); 
									  yy_pop_state(); 
									  ident_lvl=0; // reset
									  unput(yytext[0]); //unput para nao estragar nada
									}								
}

<GETLISTLINE>{
	[^{\['\n]+						{ addToTopContext(yytext);}
	\n 								{ addToTopContext("</li>"); BEGIN BUILDLIST;}
	['{\[]							{ addToTopContext(yytext);}	
	"[["							{ yy_push_state(PARENTHESES);}
	"{{"							{ yy_push_state(CURLY);}
}

<DELETEREF>{
	[^&<]+/[&<]						{ ;}
	&lt;\/ref&gt;               	{ yy_pop_state();}
	\</\/text\>						{ ignore_page=1; unput('<'); BEGIN TEXT;}//se isto acontecer, ref nao foi fechado
	.|\n 							{ ;}							// entao nao se processa pagina
}


<DELETETAG>{
	[^-]+/-							{ ;}
	--&gt;							{ yy_pop_state();}
}

<PBPE>{
	[^}'&]+/[&'}]					{ addToTopContext(yytext);}
	"}}"							{ yy_pop_state();}
}


<HREF>[^\]]+\]						{ yytext[yyleng-1]='\0'; asprintf(&link_to,"%s</a>",yytext);
									  addToTopContext(link_to); free(link_to);
									  yy_pop_state();
									}


<*>(.|\n)                          { ;}

%%

void outprettyMode(int num_pel_in, int num_pel_out){
	int dif = num_pel_out-num_pel_in;

	if(num_pel_in==2) addToTopContext("</i>");
	if(num_pel_in==3) addToTopContext("</b>");
	if(num_pel_in==5) addToTopContext("</i></b>");

	for(int i=0;i<dif;i++){
		unput('\'');
	}

	in_pretty_mode=0;
}

void addToTopContext(char* txt){

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
	
	if(strcmp("-a", argv[1]) == 0 ) all_flag = 1;
	categoria = argv[1];

	if(argc>2) if(strcmp("-d",argv[2]) == 0) debug_mode=1;
    
	if((argc == 3 && debug_mode==0) || argc == 4) max_pages = atoi(argv[argc-1]);
    
    if(!debug_mode) printf("_________ A INICIAR PROCESSAMENTO _________\n\n");

    clock_t begin = clock();
    yylex();
    clock_t end = clock();
    
    double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;

    if(!debug_mode){
		if(all_flag == 0) printf(" - Páginas da categoria: %d\n", total_categoria);
		printf(" - Páginas processadas: %d\n"
		   	   " - Tempo gasto: %f segundos\n"
			   "\n_________  FIM DE PROCESSAMENTO ___________\n",
				processed_pages, time_spent);

	}

    return 0;
}