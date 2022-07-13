/*****************************************************************************/
/** ANALIZADOR SINTACTICO                                           GRUPO 9 **/
/** Autores: Álvaro Rodríguez Sánchez
/**          Vladyslav
/**          Lugman
/**          Miguel
/**
/*****************************************************************************/

%{
#include <stdio.h>
#include <string.h>
#include "header.h"
%}

%union{
    char *ident; //NOMBRE DEL IDENTIFICADOR
    int cent;    //VALOR DE LA CTE NUMERICA ENTERA
    EXP exp;     //TIPO PARA LAS EXPRESIONES
}

%token <cent> INT_
%token <ident> ID_

%token BOOL_ WHILE_ FOR_ IF_ ELSE_ TRUE_ FALSE_ PRINT_ READ_ RETURN_
%token ALLAVE_  CLLAVE_ ACORCH_  CCORCH_ APAREN_ CPAREN_ PTOCOMA_ PTO_ CMA_
%token MAS_ MENOS_ POR_ DIV_
%token AND_ OR_ SUMASIG_ RESASIG_ MULASIG_ DIVASIG_ IGU_ NOIGU_ MAYIGU_ MENIGU_ INC_ DEC_  MAY_ MEN_ ASIG_ NOT_ MOD_
%token CTE_

%type <exp> programa listaDeclaraciones declaracion instruccion expresion
%type <exp> expresionIgualdad expresionAditiva expresionRelacional expresionAditiva expresionOpcional
%type <exp> expresionMultiplicativa expresionUnaria expresionSufija constante

%type <cent> tipoSimple operadorAditivo operadorIgualdad operadorIncremento
%type <cent> operadorLogico operadorMultiplicativo operadorRelacional operadorUnario
%%

0programa                        :{
                                    dvar = 0;
                                    niv = 0;
                                    }
                                | listaDeclaraciones {
                                        /*  vacio   */
                                    }
                                ;

1listaDeclaraciones              : declaracion {
                                        /*  vacio   */
                                    }
                                | listaDeclaraciones declaracion{
                                        /*  vacio   */
                                    }
                                ;

2declaracion                     : declaracionVariable{
                                        if(!insTdS($1.n,1,$1.t,n,desp,-1)){
                                            yyerror("identificador ya existente : utilice otro nombre");
                                        } else{
                                            dvar += $1.talla;
                                        }
                                    }
                                | declaracionFuncion
                                ;

3declaracionVariable             : tipoSimple ID_ PTOCOMA_{
                                        if(insTdS($2,VARIABLE,$1,niv,vdar,-1)){
                                            dvar += TALLA_TIPO_SIMPLE;
                                        }else{
                                            yyerror("La variable ya ha sido declarada");
                                        }
                                    }
                                | tipoSimple ID_ ACORCH_ CTE_ CCORCH_ PTOCOMA_{
                                        int numelem = $4;
                                        if($4 <= 0){
                                            yyerror("Talla no apropiada para array");
                                            numelem = 0;
                                        }
                                        int refe = insTdA($1, numelem);
                                        if(instTdS($2,VARIABLE,T_ARRAY,niv,dvar,refe)){
                                            dvar += numelem * TALLA_TIPO_SIMPLE;
                                        }else{
                                            yyerror("Identificador repetido")
                                        }
                                    }
                                ;

4tipoSimple                      : INT_ {$$.t = $1.t;}
                                | BOOL_{$$.t = $1.t;}
                                ;

5declaracionFuncion              : cabeceraFuncion bloque {
                                        /*  vacio   */
                                    }
                                ;

6cabeceraFuncion                 : tipoSimple ID_ APAREN_ parametrosFormales CPAREN_{
                                       insTdS($2)
                                    }
                                ;

7parametrosFormales              : /* vacio */{
                                        $$.t = T_VACIO;
                                        dvar += 0;
                                    }
                                | listaParametrosFormales{
                                        $$.t = $1.t;
                                        dvar += TALLA_SEGENLACES;
                                    }
                                ;

8listaParametrosFormales         : tipoSimple ID_
                                    {
                                        $$.n = $2.n;
                                        $$.t = $2.t;
                                    }
                                | tipoSimple ID_ CMA_ listaParametrosFormales
                                    {
                                        if( obtTdS($2.n, $2.t)  && ($2.t = tvector($2.nel )) && ($4.t = tentero)){
                                            $$.t = T_ERROR;
                                            yerror("Error de tipos en la 'instruccion de lista de parametros'");
                                        }else{
                                            $$.t = $2.tel;
                                        }
                                    }
                                ;

9bloque                          : {
                                    niv++;
                                    cargaContexto(niv);
                                    //D.aux = dvar; dvar = 0;
                                    }
                                : ALLAVE_ declaracionVariableLocal listaInstrucciones RETURN_ expresion PTOCOMA_ CLLAVE_{
                                    niv--;
                                    descargaContexto(niv);
                                    //dvar = D.aux;
                                }
                                ;

10declaracionVariableLocal        : /* vacio */ { }
                                | declaracionVariableLocal declaracionVariable{
                                        if(insTdS($2,VARIABLE,$2,n,dvar,-1)){
                                          dvar += TALLA_TIPO_SIMPLE;
                                        }
                                    }
                                ;

11listaInstrucciones             : /* vacio */
                                 | listaInstrucciones instruccion
                                ;

12instruccion                     : ALLAVE_ listaInstrucciones CLLAVE_
                                | instruccionAsignacion
                                | instruccionSeleccion
                                | instruccionEntradaSalida
                                | instruccionIteracion
                                ;

13instruccionAsignacion           : ID_ ASIG_ expresion PTOCOMA_
                                    {
                                        SIMB simb = obtTdS($1);
                                        if(simb.t == T_ERROR)
                                            yyerror("Objeto no declarado");
                                        else if (! ((simb.t == $3.t == T_ENTERO) ||
                                                (simb.t == $3.t == T_LOGICO)))
                                            yerror("Error de tipos en la 'instruccion de asignacion'");
                                    }
                                | ID_ ACORCH_ expresion CCORCH_ ASIG_ expresion PTOCOMA_
                                    {
                                        SIMB simb = obtTdS($1);
                                        if(simb.t == T_ERROR)
                                            yyerror("Objeto no declarado");
                                        else if (! ((simb.t == $3.t == T_ENTERO) ||
                                                (simb.t == $3.t == T_LOGICO)))
                                            yerror("Error de tipos en la 'instruccion de asignacion'");
                                    }
                                ;

14instruccionEntradaSalida        : READ_ APAREN_ ID_ CPAREN_ PTOCOMA_{

                                    }
                                | PRINT_ APAREN_ expresion CPAREN_ PTOCOMA_{

                                    }
                                ;

15instruccionSeleccion            : IF_ APAREN_ expresion CPAREN_ instruccion ELSE_ instruccion
                                ;

16instruccionIteracion            : FOR_ APAREN_ expresionOpcional PTOCOMA_ expresion PTOCOMA_ expresionOpcional CPAREN_ instruccion
                                    {
                                        int numelem = $7;
                                        if($7 <= 0){
                                            yyerror("Talla no apropiada para array");
                                            numelem = 0;
                                        }
                                        if($3.t != T_ENTERO || $5.t != T_ENTERO || $7.t != T_ENTERO){
                                            yyerror("El iterador tiene que ser un entero");
                                        }
                                        $$ = $7 + 1;
                                    }
                                ;

17expresionOpcional               : /* vacı́o */
                                | expresion
                                | ID_ ASIG_ expresion
                                ;

18expresion                       : expresionIgualdad
                                | expresion operadorLogico expresionIgualdad
                                ;

19expresionIgualdad               : expresionRelacional
                                | expresionIgualdad operadorIgualdad expresionRelacional
                                ;

20expresionRelacional             : expresionAditiva
                                | expresionRelacional operadorRelacional expresionAditiva
                                ;

21expresionAditiva                : expresionMultiplicativa   { $$ = $1; }
                                | expresionAditiva operadorAditivo expresionMultiplicativa
                                    {
                                        $$.tipo = T ERROR;
                                        if ($1.tipo == $3.tipo == T_ENTERO) $$.tipo = T_ENTERO;
                                        else yyerror("Error de tipos en la ‘expresi´on aditiva’");
                                        $$.d = creaVarTemp();
                                        emite($2, crArgPos(niv, $1.d), crArgPos(niv, $3.d), crArgPos(niv, $$.d));
                                    }
                                ;

22expresionMultiplicativa         : expresionUnaria
                                | expresionMultiplicativa operadorMultiplicativo expresionUnaria
                                ;

23expresionUnaria                 : expresionSufija
                                | operadorUnario expresionUnaria
                                | operadorIncremento ID_
                                ;

24expresionSufija                 : APAREN_ expresion CPAREN_{
                                        $$.t = $2.t;
                                    }
                                | ID_ operadorIncremento{
                                        $$.t = T_ERROR;
                                        SIMB simb = obtTdS($1)
                                        if(simb.t == T_ERROR){
                                            yyerror("identificador no declarado.");
                                        }else if(simb.t != T_ENTERO){
                                            yyerror("identificador no valido, unicamente valido con tipo int");
                                        }else{
                                            $$.t = simb.t;
                                        }
                                    }
                                | ID_ ACORCH_ expresion CCORCH_{
                                        $$.t = T_ERROR;
                                        SIMB simb = obtTdS($1)
                                        if(simb.t == T_ERROR){
                                            yyerror("identificador no declarado.");
                                        }else if(simb.t != T_ERROR){
                                            if($3.t != T_ENTERO){
                                                yyerror("expresion no valida : se espera tipo int");
                                            }
                                            if(simb.t != T_ARRAY){
                                                yyerror("identificador no valido : se espera tipo array");
                                            }
                                            if($3.t == T_ENTERO && simb.t == T_ARRAY){
                                                    $$.t = simb.t;
                                            }
                                        }
                                    }
                                | ID_ APAREN_ parametrosActuales CPAREN_{
                                        $$.t = T_ERROR;
                                        SIMB simb = obtTdS($1);
                                        if(simb.t != T_FUNCION){
                                            yyerror("inconsistendia de tipos : identificador y parametros actuales no son del mismo tipo");
                                        }else if(simb.t != $3){
                                            yyerror("identificador no valido : no corresponde con el tipo de parametros actuales");
                                        }else{
                                            $$.t = simb.t;
                                        }
                                    }
                                | ID_ {
                                        $$.t = T_ERROR;
                                        SIMB simb = obtTdS($1);
                                        if (simb.t == T_ERROR) {
                                         yyerror("identificador no declarado : declarelo antes de utilizarlo");
                                        } else {
                                            $$.t = simb.t;
                                }
                                | constante{
                                        $$.t = $1.t;
                                    }
                                ;

25parametrosActuales              : /* vacı́o */{
                                    $$.t = T_VACIO;
                                }
                                | listaParametrosActuales{
                                    $$.t = $1.t;
                                }
                                ;

26listaParametrosActuales         : expresion
                                | expresion CMA_ listaParametrosActuales
                                ;


27constante                       : CTE_    {$$ = $1}
                                | TRUE_   {$$.t = T_LOGICO}
                                | FALSE_  {$$.t = T_LOGICO}
                                ;

28operadorLogico                  :AND_     {
                                    if( $1.t == $2.t){
                                        if($1.n == $2.n){
                                            $$.n = TRUE_;
                                        }else {
                                            $$.n = FALSE_;
                                        }
                                    }else{
                                        yyerror("identificador de dipos diferentes : tienen que ser del mismo tipo");
                                    }
                                }
                                |OR_        {
                                    if( $1.t == $2.t){
                                        if( ($1.t == T_VACIO && $2.t != T_VACIO) || ($1.t == T_VACIO && $2.t != T_VACIO) ){
                                            $$.t = $2.t;
                                        }else if($1.t != T_VACIO && $2.t == T_VACIO){
                                            $$.t = $1.t;
                                        else {
                                            $$.t = T_VACIO;
                                        }
                                    }else{
                                        yyerror("identificador de dipos diferentes : tienen que ser del mismo tipo");
                                    }
                                }
                                ;

29operadorIgualdad                :IGU_     { $$ = $EIGUAL; }
                                |NOIGU_   { $$ = $EDIST;  }
                                ;

30operadorRelacional              : MAY_
                                | MEN_
                                | MAYIGU_
                                | MENIGU_
                                ;

31operadorAditivo                 : MAS_      { $$ = ESUM; }
                                | MENOS_    { $$ = EDIF; }
                                ;

operadorMultiplicativo          : POR_      { $$ = EMULT; }
                                | DIV_      { $$ = EDIVI; }
                                ;

operadorUnario                  : MAS_      { $$ = ESUM; }
                                | MENOS_    { $$ = EDIF; }
                                | NOT_
                                ;

operadorIncremento              : INC_
                                | DEC_
                                ;

%%
