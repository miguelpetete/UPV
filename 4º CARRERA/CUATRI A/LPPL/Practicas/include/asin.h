/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_ASIN_H_INCLUDED
# define YY_YY_ASIN_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INT_ = 258,
    BOOL_ = 259,
    WHILE_ = 260,
    FOR_ = 261,
    IF_ = 262,
    ELSE_ = 263,
    TRUE_ = 264,
    FALSE_ = 265,
    PRINT_ = 266,
    READ_ = 267,
    RETURN_ = 268,
    ALLAVE_ = 269,
    CLLAVE_ = 270,
    ACORCH_ = 271,
    CCORCH_ = 272,
    APAREN_ = 273,
    CPAREN_ = 274,
    PTOCOMA_ = 275,
    PTO_ = 276,
    CMA_ = 277,
    MAS_ = 278,
    MENOS_ = 279,
    POR_ = 280,
    DIV_ = 281,
    AND_ = 282,
    OR_ = 283,
    SUMASIG_ = 284,
    RESASIG_ = 285,
    MULASIG_ = 286,
    DIVASIG_ = 287,
    IGU_ = 288,
    NOIGU_ = 289,
    MAYIGU_ = 290,
    MENIGU_ = 291,
    INC_ = 292,
    DEC_ = 293,
    MAY_ = 294,
    MEN_ = 295,
    ASIG_ = 296,
    NOT_ = 297,
    MOD_ = 298,
    CTE_ = 299,
    ID_ = 300
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_ASIN_H_INCLUDED  */
