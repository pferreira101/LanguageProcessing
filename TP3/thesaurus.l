%{

%}

%x LANGUAGE BASELANG INV
%x CONCEITOS CONCEITO
%x LANG NT BT SN
%x COMENTARIO

%%

"#" {yy_push_state(COMENTARIO)}

"%language" {BEGIN LANGUAGE}
"%baselang" {BEGIN BASELANG}
"%inv" {BEGIN INV}

"\n\n\n" {BEGIN CONCEITOS}


<LANGUAGE,BASELANG,INV>{

.*/\n {return yytext} // separar aqui as linguas ou passar logo todas?
\n {yy_pop_state()}

}


<CONCEITOS>{

"\n\n" {BEGIN CONCEITO}

}

<CONCEITO>{

"\n\n" {BEGIN CONCEITO} // posso fazer isto ou volto pra CONCEITOS?? mas dps ia ter \n\n a dobrar

.*/\n {return value;} // passar yytext? termo na baselang

"NT" {BEGIN NT}  // narrow term
"BT" {BEGIN BT}  // broader term
"SN" {BEGIN SN}  // scope note
[A-Z][A-Z] {BEGIN LANG}  // termo na lingua 

}

<NT,BT,SN>{

.*/\n {return yytext} // separar aqui as linguas ou passar logo todas?
\n {yy_pop_state()}

}

<COMENTARIO>{

"\n" {yy_pop_state()}

}


%%

int yywrap() {
	return 1;
}
