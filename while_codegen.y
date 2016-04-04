%{

#include <stdio.h>
#include <string.h>

typedef struct {
    int index;
    char* value;
}
    locStruct;
    
locStruct locList[50];

char* lhVar[30];

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

program     :                   { }
            | program statement { }
            ;

statement   : assignment    { }
            | while         { }
            | if            { }
            | print         { }
            ;

assignment  : tok_VAR tok_ASSIGN right_hand tok_SEP {
                                                        strcpy(lhVar, $1);
                                                        char* id[30];
                                                        strcpy(id, lhVar);
                                                        int k = find(lhVar);
                                                        id++;
                                                        int indexInLoc = atoi(id);
                                                        locList[k].index = indexInLoc;
                                                     }
            ;
            
right_hand  : tok_EMPTY                                      {
                                                                int k = find(lhVar);
                                                                strcpy(locList[k].value, $1);
                                                             } 
            | tok_CONS tok_SYMBOL tok_OPAR tok_VAR tok_CPAR  {
                                                                int k = find(lhVar);
                                                                char* rh_value[80];
                                                                strcpy(rh_value, locList[k].value);
                                                                strcat($2)
                                                                
                                                             }
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
