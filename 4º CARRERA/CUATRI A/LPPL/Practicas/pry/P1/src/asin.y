/*****************************************************************************/
/**BISON                                         MIGUEL ÁNGEL NAVARRO ARENAS**/
/*****************************************************************************/
%{
#include <stdio.h>
#include <string.h>
#include "header.h"
%}


/******************        DECLARACIÓN TOKENS      ***************************/
/*****************************************************************************/
%token READ_ PRINT_ INT_ BOOL_ TRUE_ FALSE_ IF_ ELSE_ ELSEIF_ WHILE_ DO_
%token RETURN_ FOR_
/*****************************************************************************/
%token MAS_ MENOS_ POR_ DIV_ AND_ OR_ IGUAL_ DISTINTO_ MAYOR_ MENOR_ 
%token MAYORIGUAL_ MENORIGUAL_ NOT_ ASIG_ MAS2_ MENOS2_  
/*****************************************************************************/
%token APAR_ CPAR_ ACOR_ CCOR_ ALLAV_ CLLAV_ PUNTCOM_ COMA_ 
/*****************************************************************************/
%token CTE_ ID_ 
/*****************************************************************************/



/*****************************************************************************/
/*                                 ETDS                                      */
/*****************************************************************************/
%%
programa
        : listaDeclaraciones
        ;

/*****************************************************************************/

listaDeclaraciones
        : declaracion 
        | listaDeclaraciones declaracion
        ;

/*****************************************************************************/

declaracion
        : declaracionVariable
        | declaracionFuncion
        ;

/*****************************************************************************/

declaracionVariable
        : tipoSimple ID_ PUNTCOM_
        | tipoSimple ID_ ACOR_ CTE_ CCOR_ PUNTCOM_
        ;

/*****************************************************************************/

tipoSimple
        : INT_
        | BOOL_
        ;

/*****************************************************************************/

declaracionFuncion
        : cabeceraFuncion bloque
        ;

/*****************************************************************************/

cabeceraFuncion
        : tipoSimple ID_ APAR_ parametrosFormales CPAR_
        ;


/*****************************************************************************/

parametrosFormales
        : listaParametrosFormales 
        | 
        ;

/*****************************************************************************/

listaParametrosFormales
        : tipoSimple ID_
        | tipoSimple ID_ COMA_ listaParametrosFormales
        ;

/*****************************************************************************/

bloque
        : ALLAV_ declaracionVariableLocal listaInstrucciones RETURN_ expresion
          PUNTCOM_ CLLAV_
        ;

/*****************************************************************************/

declaracionVariableLocal
        : declaracionVariableLocal declaracionVariable
        | 
        ;

/*****************************************************************************/

listaInstrucciones
        : listaInstrucciones instruccion 
        | 
        ;

/*****************************************************************************/

instruccion
        : ALLAV_ listaInstrucciones CLLAV_ 
        | instruccionAsignacion
        | instruccionSeleccion
        | instruccionEntradaSalida
        | instruccionIteracion
        ;

/*****************************************************************************/

instruccionAsignacion
        : ID_ ASIG_ expresion PUNTCOM_
        | ID_ ACOR_ expresion CCOR_ ASIG_ expresion PUNTCOM_
        ;

/*****************************************************************************/

instruccionEntradaSalida
        : READ_ APAR_ ID_ CPAR_ PUNTCOM_
        | PRINT_ APAR_ expresion CPAR_ PUNTCOM_
        ;

/*****************************************************************************/

instruccionSeleccion
        :  IF_ APAR_ expresion CPAR_ instruccion ELSE_ instruccion
        ;

/*****************************************************************************/

instruccionIteracion
        : FOR_ APAR_ expresionOpcional PUNTCOM_ expresion PUNTCOM_
          expresionOpcional CPAR_ instruccion
        ;

/*****************************************************************************/

expresionOpcional
        : expresion
        | ID_ ASIG_ expresion
        | 
        ;

/*****************************************************************************/

expresion
        : expresionIgualdad
        | expresion operadorLogico expresionIgualdad
        ;

/*****************************************************************************/

expresionIgualdad
        : expresionRelacional
        | expresionIgualdad operadorIgualdad expresionRelacional
        ;

/*****************************************************************************/

expresionRelacional
        : expresionAditiva
        | expresionRelacional operadorRelacional expresionAditiva
        ;

/*****************************************************************************/

expresionAditiva
        : expresionMultiplicativa
        | expresionAditiva operadorAditivo expresionMultiplicativa
        ;

/*****************************************************************************/

expresionMultiplicativa
        : expresionUnaria
        | expresionMultiplicativa operadorMultiplicativo expresionUnaria
        ;

/*****************************************************************************/

expresionUnaria
        : expresionSufija
        | operadorUnario expresionUnaria
        | operadorIncremento ID_
        ;

/*****************************************************************************/

expresionSufija
        : APAR_ expresion CPAR_
        | ID_ operadorIncremento
        | ID_ ACOR_ expresion CCOR_ 
        | ID_ APAR_ parametrosActuales CPAR_ 
        | ID_ 
        | constante  
        ;

/*****************************************************************************/

parametrosActuales
        : listaParametrosActuales
        | 
        ;

/*****************************************************************************/

listaParametrosActuales
        : expresion
        | expresion COMA_ listaParametrosActuales
        ;

/*****************************************************************************/

constante
        : CTE_
        | TRUE_
        | FALSE_
        ;

/*****************************************************************************/

operadorLogico
        : AND_
        | OR_
        ;

/*****************************************************************************/

operadorIgualdad
        : IGUAL_
        | DISTINTO_
        ;

/*****************************************************************************/

operadorRelacional
        : MENOR_
        | MAYOR_
        | MENORIGUAL_
        | MAYORIGUAL_
        ;

/*****************************************************************************/

operadorAditivo
        : MAS_
        | MENOS_
        ;

/*****************************************************************************/

operadorMultiplicativo
        : POR_
        | DIV_
        ;

/*****************************************************************************/

operadorUnario
        : MAS_
        | MENOS_
        | NOT_
        ;

/*****************************************************************************/

operadorIncremento
        : MAS2_
        | MENOS2_
        ;
%%
/*****************************************************************************/