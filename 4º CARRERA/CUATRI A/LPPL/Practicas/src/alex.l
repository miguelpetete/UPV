/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          2019-2020 <jbenedi@dsic.upv.es> **/
/*****************************************************************************/
%{
#include <stdio.h>
#include <string.h>
#include "header.h"
#include "asin.h"

#define  retornar(x) {if (verbosidad) ECHO; return(x);}
%}
/*-----------------------------------------------------------------------------
  Estas opciones evitan "warnings" innecesarios y permiten obtener el
  numero de linea actual en la variable global "yylineno".
-----------------------------------------------------------------------------*/
%option noinput
%option nounput
%option yylineno

delimitador     [ \t\n]+
identificador   [_a-zA-Z][_a-zA-Z0-9]*
numero          [0-9]+("."[0-9]*)?|[0-9]*"."[0-9]+
comentario      \/\/.*\n

%%


{delimitador}  {if (verbosidad) ECHO ; }
{comentario}   {if (verbosidad){  ECHO;  }}
"int"          {retornar (INT_);}
"return"       {retornar (RETURN_); }
"bool"         {retornar (BOOL_) ;}
"while"        {retornar (WHILE_) ;}
"for"          {retornar (FOR_) ;}
"if"           {retornar (IF_) ;}
"else"         {retornar (ELSE_) ;}
"true"         {retornar (TRUE_) ;}
"false"        {retornar (FALSE_) ;}
"print"        {retornar (PRINT_) ;}
"read"         {retornar (READ_) ;}
"struct"       {retornar (FALSE_) ;}

"{"            { retornar(ALLAVE_); fprintf(stdout,"%3d.- ",yylineno); }
"}"            { retornar(CLLAVE_); }
"["            { retornar(ACORCH_); }
"]"            { retornar(CCORCH_); }
"("            { retornar(APAREN_);  }
")"            { retornar(CPAREN_);   }
";"            { retornar(PTOCOMA_); }
"."            { retornar(PTO_); }
","            { retornar(CMA_); }

"+"		 		     { retornar (MAS_) ; }
"-"            { retornar (MENOS_) ; }
"*"            { retornar (POR_) ; }
"/"            { retornar (DIV_) ; }

"&&"		       { retornar(AND_); }
"||"		       { retornar(OR_); }
"+="		       { retornar(SUMASIG_); }
"-="		       { retornar(RESASIG_); }
"*="		       { retornar(MULASIG_); }
"/="		       { retornar(DIVASIG_); }
"=="		       { retornar(IGU_); }
"!="		       { retornar(NOIGU_); }
">="		       { retornar(MAYIGU_); }
"<="		       { retornar(MENIGU_); }
"++"		       { retornar(INC_); }
"--"		       { retornar(DEC_); }
">"		         { retornar(MAY_); }
"<"		         { retornar(MEN_); }
"="		         { retornar(ASIG_); }
"!"		         { retornar(NOT_); }
"%"		         { retornar(MOD_); }

{numero}            {yylval.cent = atoi(yytext); retornar (CTE_); }
{identificador}     {yylval.ident = strdup(yytext); retornar (ID_); }
.		                { yyerror("Caracter desconocido") ;}

%%
