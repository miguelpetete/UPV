/*****************************************************************************/
/**FLEX                                          MIGUEL ÁNGEL NAVARRO ARENAS**/
/*****************************************************************************/
%{
#include <stdio.h>
#include <string.h>
#include "header.h"
#include "asin.h"

#define  retornar(x) {if (verbosidad) ECHO; return(x);}

%}


%option noinput
%option nounput
%option yylineno

delimitador     [ \t\v\f]+
comentario      \/\/.*\n
letra           [a-zA-Z]
num            [0-9]
numero          {num}+(\.{num}*)?|{num}*\.{num}+
identificador   {letra}({letra}|{num}|"_")*

%%

{delimitador}   {if (verbosidad) ECHO ; }
{comentario}    {if(verbosidad){ ECHO ; fprintf(stdout, "%3d.- ", yylineno)}}
"\n"            {if(verbosidad){ ECHO ; fprintf(stdout, "%3d.- ", yylineno)}}


"read"          { retornar (READ_) ;}
"print"         { retornar (PRINT_) ;}
"int"           { retornar (INT_) ;}
"bool"          { retornar (BOOL_) ;}
"true"          { retornar (TRUE_) ;}
"false"         { retornar (FALSE_) ;}
"if"            { retornar (IF_) ;}
"else"          { retornar (ELSE_) ;}
"elseif"        { retornar (ELSEIF_) ;}
"while"         { retornar (WHILE_) ;}
"do"            { retornar (DO_) ;}
"return"        { retornar (RETURN_) ;}
"for"           { retornar (FOR_) ;}


"+"             { retornar (MAS_) ; }
"-"             { retornar (MENOS_) ; }
"*"             { retornar (POR_) ; }
"/"             { retornar (DIV_) ; }
"&&"            { retornar (AND_) ;}
"||"            { retornar (OR_) ;}
"=="            { retornar (IGUAL_) ;}
"!="            { retornar (DISTINTO_) ;}
">"             { retornar (MAYOR_) ;}
"<"             { retornar (MENOR_) ;}
">="            { retornar (MAYORIGUAL_) ;}
"<="            { retornar (MENORIGUAL_) ;}
"!"             { retornar (NOT_) ;}
"="             { retornar (ASIG_) ;}
"++"            { retornar (MAS2_) ;}
"--"            { retornar (MENOS2_) ;}

"("             { retornar (APAR_) ; }
")"             { retornar (CPAR_) ; }
"["             { retornar (ACOR_) ;}
"]"             { retornar (CCOR_) ;}
"{"             { retornar (ALLAV_) ;}
"}"             { retornar (CLLAV_) ;}
";"             { retornar (PUNTCOM_) ;}
","             { retornar (COMA_) ;}


{numero}        { retornar (CTE_) ; }
{identificador} { retornar (ID_) ;}
.		            { if(verbosidad){
                    {fprint(stdout,"<"); ECHO; fprintf(stdout,">"); }
                    yyerror("Error [%d]: %s\n", yylineno, yytext);
                  }
                }

%%
/*****************************************************************************/