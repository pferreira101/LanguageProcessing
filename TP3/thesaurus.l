%{

%}

%option stack
%x LLANGUAGES LBASELANG LINV
%x LCONCEITOS LCONCEITO
%x LLANG LNT LBT LSN
%x LCOMENTARIO

%%

"#" {yy_push_state(LCOMENTARIO);}

"%language" {return LANGUAGES; BEGIN LANGUAGES;}
"%baselang" {return BASELANG; BEGIN BASELANG;}
"%inv" {return INV; BEGIN INV;}

"\n\n\n" {BEGIN LCONCEITOS;}


<LLANGUAGES,LBASELANG,LINV>{

[^\s\n]* {yylval.param = strdup(yytext); return PARAM;} // \s = ' ' = whitespace

\n {yy_pop_state();}

}


<LCONCEITOS>{

"\n\n" {BEGIN LCONCEITO;}

}

<LCONCEITO>{

"\n\n" {BEGIN LCONCEITO;} // posso fazer isto ou volto pra CONCEITOS?? mas dps ia ter \n\n a dobrar

.+\n {yylval.nome = strdup(yytext); return NOME;}

<<<<<<< HEAD
"NT" {return NT; BEGIN LNT;}  // narrow term
"BT" {return BT; BEGIN LBT;}  // broader term
"SN" {return SN; BEGIN LSN;}  // scope note
[A-Z][A-Z] {yylval.lang = strdup(yytext); return LAN; BEGIN LLANG;}  // termo na lingua 

}

<LNT,LBT,LSN>{

[^\s\n]* {yylval.val = strdup(yytext); return VAL;}
\n {yy_pop_state();}

}

<LCOMENTARIO>{

"\n" {yy_pop_state();}

}


%%

int yywrap() {
	return 1;
}
