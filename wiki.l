%{
    #include <stdio.h>
    #include <string.h>

%}

%x PAGE
%x TITLE
%x TEXT
%x INFOBOX
%x PARENTHESES
%x CATEGORY

%%
"<page>"          {printf("INICIO PAGE\n"); BEGIN PAGE;}

<PAGE>"<title>"         {printf("Tit: "); BEGIN TITLE;}
<PAGE>\<text[^>]+\>     {printf("INICIO TEXT\n"); BEGIN TEXT;}
<PAGE>"</page>"    {printf("FIM PAGE\n"); BEGIN INITIAL;}
<PAGE>.|\n {;}

<TITLE>"</title>" {printf("\n"); BEGIN PAGE;}

<TEXT>\{\{Info[\/]?         {printf("Info: "); BEGIN INFOBOX;}
<TEXT>"''"|"'''"       {;}
<TEXT>"[["          {BEGIN PARENTHESES;}
<TEXT>"</text>"    {printf("FIM TEXT\n"); BEGIN PAGE;}

<INFOBOX>"|" {;}
<INFOBOX>\}\}\n\n {printf("INICIO TEXT\n"); BEGIN TEXT;} // FIXME: não funciona direito para todos

<PARENTHESES>"]]" {BEGIN TEXT;}

(.|\n)           {;}
%%


int yywrap(){
    return 1;
}


int main(){ 
    yylex();
    
    return 0;
}