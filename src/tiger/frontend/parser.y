 /* TODO: Is this version appropriate? */
%require "3.8.2"
%language "c++"

 /* Generate parser.hh and location.hh */
%header

%define api.token.raw

/**
 * Request that symbols be handled as a whole (type, value, and possibly
 * location) in the scanner.
 */
%define api.token.constructor
/**
 * Use std::variant (type-safe union) to record semantic values.
 */
%define api.value.type variant

%code requires {
  #include "tiger/symbol/symbol.h"
  #include "tiger/absyn/absyn.h"
  class TigerFrontendDriver;
}

%param { TigerFrontendDriver& drv }
%locations

/* define YYDEBUG, so the symbol name can be read */
%define parse.trace

%code {
#include "tiger/frontend/driver.h"
#define GET_POS(loc) (loc)
}

 /* semantic values */

 /* terminals */
%token <sym::Symbol*> ID
%token <std::string> STRING
%token <int> INT

%token
  COMMA
  COLON
  LPAREN
  RPAREN
  LBRACK
  RBRACK
  LBRACE
  RBRACE
  DOT

%token
  ARRAY
  IF
  THEN
  WHILE
  FOR
  TO
  LET
  IN
  END
  BREAK
  NIL
  VAR

%left SEMICOLON
%nonassoc DO
%nonassoc LOWER
%nonassoc TYPE
%nonassoc FUNCTION
%nonassoc OF
%nonassoc LOW
%nonassoc ELSE
%right ASSIGN

%left OR
%left AND

%nonassoc EQ
%nonassoc NEQ
%nonassoc GT
%nonassoc LT
%nonassoc GE
%nonassoc LE

%left PLUS MINUS

%left TIMES DIVIDE

%left UMINUS

 /* nonterminals */
%nterm <absyn::Exp*> exp expseq
%nterm <absyn::ExpList*> actuals nonemptyactuals sequencing sequencing_exps
%nterm <absyn::Var*> lvalue one oneormore
%nterm <absyn::DecList*> decs decs_nonempty
%nterm <absyn::Dec*> decs_nonempty_s vardec
%nterm <absyn::EFieldList*> rec rec_nonempty
%nterm <absyn::EField*> rec_one
%nterm <absyn::NameAndTyList*> tydec
%nterm <absyn::NameAndTy*> tydec_one
%nterm <absyn::FieldList*> tyfields tyfields_nonempty
%nterm <absyn::Field*> tyfield
%nterm <absyn::Ty*> ty
%nterm <absyn::FunDecList*> fundec
%nterm <absyn::FunDec*> fundec_one
%nterm <absyn::AbsynTree*> program

%start program


 /*
  * Put your codes here (lab3).
  */

%%
program: exp { drv.parse_result = new absyn::AbsynTree($1); }

exp: NIL  { $$ = new absyn::NilExp(@$); }

%%
 /* User-supplied error report interface */
void yy::parser::error (const location_type& l, const std::string& m)
{
  drv.errormsg.Error(l, m);
}
