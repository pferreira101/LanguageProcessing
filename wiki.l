%{
    #include <stdio.h>
    #include <string.h>

%}

%x PAGE
%x TITLE
%x TEXT
%x INFOBOX
%x CATEGORY

%%
"<page>"          {printf("INICIO PAGE\n"); BEGIN PAGE;}

<PAGE>"<title>"         {printf("Tit: "); BEGIN TITLE;}
<PAGE>\<text[^>]+\>     {printf("INICIO TEXT\n"); BEGIN TEXT;}
<PAGE>"</page>"    {printf("FIM PAGE\n"); BEGIN INITIAL;}
<PAGE>.|\n {;}

<TITLE>"</title>" {printf("\n"); BEGIN PAGE;}

<TEXT>"{{INFO/"         {printf("Info: "); BEGIN INFOBOX;}
<TEXT>"</text>"    {printf("FIM TEXT\n"); BEGIN PAGE;}

<INFOBOX>"}}" {BEGIN PAGE;}

(.|\n)           {;}
%%


int yywrap(){
    return 1;
}


int main(){ 
    yylex();
    
    return 0;
}