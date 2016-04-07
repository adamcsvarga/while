%{
#include "compile.h"
%}

%%

[ \t\n]             {};

"x0"                {yylval.str = strdup(yytext); return tok_VAR;}
x[123456789][0-9]*  {yylval.str = strdup(yytext); return tok_VAR;}


"€"                 {return tok_EMPTY;}
":="                {return tok_ASSIGN;}
";"                 {return tok_SEP;}

"if"                {return tok_IF;}
"then"              {return tok_THEN;}
"while"             {return tok_WHILE;}
"loop"              {return tok_LOOP;}
"end"               {return tok_END;}

"("                 {return tok_OPAR;}
")"                 {return tok_CPAR;}
"\?"                {return tok_QMARK;}

"cons_"             {return tok_CONS;}
"cdr"               {return tok_CDR;}
"car_"              {return tok_CAR;}
"nonem"             {return tok_NONEM;}

[^x]                  {yylval.str = strdup(yytext); return tok_SYMBOL;}

.                   {return tok_ERR;}

%%

yywrap() {
    return 1;
}

