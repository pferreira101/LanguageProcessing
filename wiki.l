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
%x CURLY

%option stack

%%
"<page>"                        {BEGIN PAGE;}

<PAGE>"<title>"                 {printf("Tit: "); BEGIN TITLE;}
<PAGE>\<text[^>]+\>             {BEGIN TEXT; }
<PAGE>"</page>"                 {BEGIN INITIAL;}
<PAGE>.|\n {;}

<TITLE>"</title>"               {printf("\n"); BEGIN PAGE;}

<TEXT>"{{Info"[\/]?            {printf("Info: \n"); BEGIN INFOBOX; }
<TEXT>"''"|"'''"                {;}
<TEXT>"&quot;"                  {printf("\"");}
<TEXT>"</text>"                 {BEGIN PAGE;}
<TEXT>"[[Categoria:"            {BEGIN CATEGORY;} 
<TEXT>\n(.|\n)*/"[[Categoria:"  {printf("\n\nCategoria: ");} // Para descartar tudo apos primeiro paragrafo. so apanha a segunda categoria idkw

<CATEGORY>[0-9a-zA-Z ]*         {ECHO;} //  GUARDAR EM GARRAY PARA DEPOIS IMPRIMIR DIREITO;
<CATEGORY>\|[0-9a-zA-Z ]*       {;}
<CATEGORY>"]]"                  {printf("\n"); BEGIN TEXT; } 

<INFOBOX>" |"                   {;}
<INFOBOX>"''"                   {printf("\"");}
<INFOBOX>\}\}\n\n               {printf("\n"); BEGIN TEXT; } // FIXME: nem todos têm duas novas linhas

<PARENTHESES>[0-9a-zA-Z ]*\|    {;} 
<PARENTHESES>"]]"               {yy_pop_state(); }

<*>"[["                         {yy_push_state(PARENTHESES); }

(.|\n)                          {;}

%%


int yywrap(){
    return 1;
}


int main(){ 
    yylex();
    
    return 0;
}