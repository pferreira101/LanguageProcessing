%{

%}

%x LANGUAGES BASELANG INV
%x CONCEITOS CONCEITO
%x LANG NT BT SN
%x COMENTARIO

%%

"#" {yy_push_state(COMENTARIO)}

"%language" {return LANGUAGES; BEGIN LANGUAGES}
"%baselang" {return BASELANG; BEGIN BASELANG}
"%inv" {return INV; BEGIN INV}

"\n\n\n" {BEGIN CONCEITOS;}


<LANGUAGES,BASELANG,INV>{

[^\s\n]* {yylval.param = strdup(yytext); return PARAM;} // \s = ' ' = whitespace

\n {yy_pop_state()}

}


<CONCEITOS>{

"\n\n" {BEGIN CONCEITO}

}

<CONCEITO>{

"\n\n" {BEGIN CONCEITO} // posso fazer isto ou volto pra CONCEITOS?? mas dps ia ter \n\n a dobrar

[^\s\n]* {yylval.nome = strdup(yytext); return NOME}

"NT" {return NT; BEGIN NT}  // narrow term
"BT" {return BT; BEGIN BT}  // broader term
"SN" {return SN; BEGIN SN}  // scope note
[A-Z][A-Z] {yylval.lang = strdup(yytext); return LAN; BEGIN LANG}  // language translation 

}

<NT,BT,SN,LANG>{

[^\s\n]* {yylval.val = strdup(yytext); return VAL} // valor 
\n {yy_pop_state()}

}

<COMENTARIO>{

"\n" {yy_pop_state()}

}


%%

int yywrap() {
	return 1;
}
