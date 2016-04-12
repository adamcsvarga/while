%{

#include <stdio.h>
#include <string.h>

#define MAX_PROGRAM_LENGTH 2000
#define MAX_NESTING_LEVEL 8

typedef struct {
    int ident;
    char* value;
}
    locStruct;
    
locStruct locList[MAX_PROGRAM_LENGTH];
int identLevel = 0;
int lineNo = 0;
char tmpContent[80];

char leftHand[30], rightHand[50], tmpBool[30];
int tmpLineNo[MAX_NESTING_LEVEL];
int added = 0;

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
%token tok_COMMENT

%%

program     :                   { /* Starting with empty program */ }
            | program statement { /* Adding new line of code to local array */ 
                                    if(added == 0) {
                                        locList[lineNo].ident = identLevel;
                                        locList[lineNo].value = strdup(tmpContent);
                                        /*printf("%i, %i, %s\n", lineNo, identLevel, tmpContent);*/
                                        lineNo++;
                                    }
                                    
                                    added = 0;
                                }
            ;

statement   : assignment    { }
            | while         { }
            | if            { }
            | print         { }
            | tok_COMMENT   { }
            ;

assignment  : tok_VAR tok_ASSIGN right_hand tok_SEP { /* Assigning to var */
                                                      strcpy(tmpContent, $1);
                                                      strcat(tmpContent, " = ");
                                                      strcat(tmpContent, rightHand);   
                                                    }
            ;
            
right_hand  : tok_EMPTY                                      { /* Assigning empty string */ 
                                                                strcpy(rightHand, "\"\"");
                                                             } 
            | tok_CONS tok_SYMBOL tok_OPAR tok_VAR tok_CPAR  { /* Assigning var with concatenated symbol */
                                                                strcpy(rightHand, "\"");
                                                                strcat(rightHand, $2);
                                                                strcat(rightHand, "\" + ");
                                                                strcat(rightHand, $4);   
                                                             }
            | tok_CDR tok_OPAR tok_VAR tok_CPAR              { /* Assigning trimmed var */
                                                                strcpy(rightHand, $3);
                                                                strcat(rightHand, "[1:] if len(");
                                                                strcat(rightHand, $3);
                                                                strcat(rightHand, ") > 1 else \"\"");                                                            
                                                             }
            ;
            
while       : tok_WHILE bool tok_LOOP program tok_END tok_LOOP tok_SEP  { /* While loop */
                                                            strcpy(tmpContent, "while ");
                                                            strcat(tmpContent, tmpBool);
                                                            identLevel--;
                                                            locList[tmpLineNo[identLevel]].ident = identLevel;
                                                            locList[tmpLineNo[identLevel]].value = strdup(tmpContent);
                                                            added = 1;
                                                        }
            ;

bool        : tok_CAR tok_SYMBOL tok_QMARK tok_OPAR tok_VAR tok_CPAR    {/* Check first char of var */
                                                                            tmpLineNo[identLevel] = lineNo;
                                                                            strcpy(tmpBool, $5);
                                                                            strcat(tmpBool, "[0] == ");
                                                                            strcat(tmpBool, "\"");
                                                                            strcat(tmpBool, $2);
                                                                            strcat(tmpBool, "\":");
                                                                            identLevel++;
                                                                            lineNo++;                                                                        
                                                                        }
            | tok_NONEM tok_QMARK tok_OPAR tok_VAR tok_CPAR             {/* Check if var is empty */
                                                                            tmpLineNo[identLevel] = lineNo;
                                                                            strcpy(tmpBool, $4);
                                                                            strcat(tmpBool, " != \"\":");
                                                                            identLevel++;
                                                                            lineNo++;
                                                                        }
            ;

if          : tok_IF bool tok_THEN program tok_END tok_IF tok_SEP {/* If branch */
                                                        strcpy(tmpContent, "if ");
                                                        strcat(tmpContent, tmpBool);
                                                        identLevel--;
                                                        locList[tmpLineNo[identLevel]].ident = identLevel;
                                                        locList[tmpLineNo[identLevel]].value = strdup(tmpContent);
                                                        added = 1;
                                                    }
            ;
            
print       : tok_VAR tok_SEP   { /* Print  var */
                                    strcpy(tmpContent, "print(");
                                    strcat(tmpContent, $1);
                                    strcat(tmpContent, ")");
                                }
            ;
%%

void emitCode(FILE *fout) {
    int i;
    for(i = 0; i < lineNo; i++) {
        int j;
        for(j = 0; j < locList[i].ident; j++) {
            fprintf(fout, "    ");
        }
        fprintf(fout, "%s\n", locList[i].value);
    }
    
}

int yyerror(char *errMessage) {
    printf("Trouble: %s\n", errMessage);
} 

main() {
    FILE *fout;
    yyparse();
    
    fout = fopen("while.py","w");
    emitCode(fout);
}
