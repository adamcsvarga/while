%{
#include "compile.h"
%}

/* States */ 

%s comment

%%

<INITIAL>[ \t\n]             	{ };

<INITIAL>"x0"                	{ yylval.str = strdup(yytext); return tok_VAR;}
<INITIAL>x[123456789][0-9]*  	{ yylval.str = strdup(yytext); return tok_VAR;}


<INITIAL>"€"                 	{ return tok_EMPTY;}
<INITIAL>":="                	{ return tok_ASSIGN;}
<INITIAL>";"                 	{ return tok_SEP;}

<INITIAL>"if"                	{ return tok_IF;}
<INITIAL>"then"              	{ return tok_THEN;}
<INITIAL>"while"             	{ return tok_WHILE;}
<INITIAL>"loop"              	{ return tok_LOOP;}
<INITIAL>"end"               	{ return tok_END;}

<INITIAL>"("                 	{ return tok_OPAR;}
<INITIAL>")"                 	{ return tok_CPAR;}
<INITIAL>"\?"                	{ return tok_QMARK;}

<INITIAL>"cons_"             	{ return tok_CONS;}
<INITIAL>"cdr"               	{ return tok_CDR;}
<INITIAL>"car_"              	{ return tok_CAR;}
<INITIAL>"nonem"             	{ return tok_NONEM;}

<INITIAL>"#"                    { BEGIN(comment);}
<comment>[^\n]*					{ return tok_COMMENT;}
<comment>[\n]					{ BEGIN(INITIAL);}

<INITIAL>[^ \t\n;€:=\(\)\?_#]+  { yylval.str = strdup(yytext); return tok_SYMBOL;}

<INITIAL>.                   	{ return tok_ERR;}

%%

yywrap() {
    return 1;
}

