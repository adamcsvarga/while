%{

#include <stdio.h>

%}

%union{
    char *str;
}

%token <str> tok_VAR 
%token tok_ASSIGN 
%token tok_EMPTY 
%token tok_SEP 
%token tok_IF 
%token tok_THEN 
%token tok_WHILE 
%token tok_LOOP 
%token tok_END
%token tok_OPAR 
%token tok_CPAR 
%token tok_QMARK 
%token tok_CONS 
%token tok_CDR 
%token tok_CAR 
%token tok_NONEM 
%token <str> tok_SYMBOL 
%token tok_ERR

%%

program     :                   {printf("Starting with an empty program!\n");}
            | program statement {printf("Adding a statement!\n");}
            ;

statement   : assignment    {printf("Assignment done!\n");}
            | while         {printf("While loop done!\n");}
            | if            {printf("If statement done!\n");}
            | print         {printf("Variable printed!\n");}
            ;

assignment  : tok_VAR tok_ASSIGN right_hand tok_SEP {printf("Assigning to %s...\n", $1);}
            ;
            
right_hand  : tok_EMPTY                                      {printf("assigning empty string.\n");} 
            | tok_CONS tok_SYMBOL tok_OPAR tok_VAR tok_CPAR  {printf("assigning %s with concatenated %s.\n", $4, $2);}
            | tok_CDR tok_OPAR tok_VAR tok_CPAR              {printf("assigning trimmed %s.\n", $3);}
            ;
            
while       : tok_WHILE bool tok_LOOP program tok_END   {printf("starting while-loop.\n");}
            ;

bool        : tok_CAR tok_SYMBOL tok_QMARK tok_OPAR tok_VAR tok_CPAR    {printf("checking first char of %s.\n", $5);}
            | tok_NONEM tok_QMARK tok_OPAR tok_VAR tok_CPAR             {printf("checking if %s is empty.\n", $4);}
            ;

if          : tok_IF bool tok_THEN program tok_END  {printf("starting if-branch.\n");}
            ;
            
print       : tok_VAR tok_SEP   {printf("Printing %s.\n", $1);}
            ;
%%

int yyerror(char *errMessage) {
    printf("Trouble: %s\n", errMessage);
} 

main() {
    yyparse();
}
