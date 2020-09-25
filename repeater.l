%{
#include "y.tab.h"
#include <string.h>
int yylex();
void yyerror(char* s);
%}

%%

"repeat"        {return REPEAT;}
"print"         {return PRINT;}
"sum"           {return SUM;}
\{              {return LEFTCURLY;}
\}              {return RIGHTCURLY;}
=               {return EQ;}
,               {return COMMA;}
[1-9][0-9]*     {yylval.num = atoi(yytext); return NUMBER;}
\"[a-zA-Z]*\"   {yylval.str = strdup(yytext); return STRING;}
[a-zA-Z]+       {yylval.id = strdup(yytext); return ID;}
[ \t\n]         ;
.               {yyerror("Pifiaste un caracter.");}

%%

int yywrap(void){
    return 1;
}