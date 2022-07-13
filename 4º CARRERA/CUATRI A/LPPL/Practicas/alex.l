/*****************************************************************************/
/**  Ejemplo de FLEX: S E M - 1                       <jbenedi@dsic.upv.es> **/
/**  V. 20                                                                  **/
/*****************************************************************************/
%{
#include <stdio.h>
#include <string.h>
#include "header.h"

#define  retornar(x) {if (verbosidad) ECHO; return(x);}

%}
/*----------------------------------------------------------------------
  Dado que las funciones "input()" y "unput(c)" son costosas y no las
  utilizaremos, evitaremos que se generen automaticamente sus rutinas
  correspondientes desactivandolas mediante las siguientes opciones:
----------------------------------------------------------------------*/
%option noinput
%option nounput
/*----------------------------------------------------------------------
  Para mantener el numero de linea actual en la variable global yylineno
----------------------------------------------------------------------*/
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
                    yyerror("Error [%d]: %s\n", yylineno, yytext);
                  }
                }

%%
int verbosidad = FALSE;

/*****************************************************************************/
void yyerror(const char *msg){
/*  Tratamiento de errores.                                                  */
  fprintf(stderr, "\nError en la linea %d: %s\n", yylineno, msg);
}

/*****************************************************************************/
int main(int argc, char **argv) {
	int i, n=1 ;

	for (i=1; i<argc; ++i)
      if (strcmp(argv[i], "-v")==0) { verbosidad = TRUE; n++; }
	if (argc == n+1)
      if ((yyin = fopen (argv[n], "r")) == NULL)
      	fprintf (stderr, "El fichero '%s' no es valido\n", argv[n]) ;
      else yylex ();
	else fprintf (stderr, "Uso: cmc [-v] fichero\n");

	return (0);
}

/*****************************************************************************/
