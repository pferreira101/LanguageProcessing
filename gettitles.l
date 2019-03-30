%{
    #include <stdio.h>
    #include <string.h>
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
"<page>"                        {BEGIN PAGE; flag=0; ignore_page=0; in_pretty_mode=0;}

<PAGE>{
	"<title>Predefinição"		{ignore_page=1;}
	"<title>MediaWiki:"			{ignore_page=1;}
	"<title>Wikipédia:"			{ignore_page=1;}
	"<title>"                 	{BEGIN TITLE;}
	\<text[^>]+\>#(?i:redire) {ignore_page = 1;}
	\<text[^>]+\>"{| class="	{ignore_page = 1;}
	\<text[^>]+\>"{{"[Dd]esam	{ignore_page = 1;}
	"</page>"                 	{BEGIN INITIAL; 									
									if(!ignore_page){
										if(processed_pages < max_pages) processed_pages++;
                                 		else return 0;			
									}
									//printf("=================#==================#=================\n"); 
									//printPage(p); 
									//printf("=================#==================#=================\n");
								}
	.|\n 					   	{;}
}

<TITLE>(.+?)/"</title>"         { printf("%s\n",yytext); BEGIN PAGE;}

.|\n 						{;}
%%
int yywrap(){
    return 1;
}

int main(int argc, char* argv[]){

    yylex();


    return 0;
}