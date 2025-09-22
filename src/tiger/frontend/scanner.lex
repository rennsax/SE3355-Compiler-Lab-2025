/* -*- mode: c++; -*- */
%{

#include "parser.hh"
#include "tiger/frontend/driver.h"

static char string_buf[1024];
static char *string_buf_ptr;
static int comment_level = 0;

using location_type = yy::parser::location_type;
%}

 /* disable useless options so we don't need `-lfl` when compiling */
%option noyywrap nounput noinput batch

%{
  yy::parser::symbol_type make_ID(std::string_view, const location_type&);
  yy::parser::symbol_type make_INT(const std::string &, const location_type&);
%}

 /* You can add lex definitions here. */
digit [0-9]
id [a-zA-Z][0-9a-zA-Z_]*

%x COMMENT STR

%{
// Code run each time a pattern is matched.
#define YY_USER_ACTION  loc.columns(yyleng);
#define ERROR(message) throw yy::parser::syntax_error(loc, message)
%}

%%
%{
  // Code run each time yylex is called.
  // A handy shortcut to the location held by the driver.
  yy::location& loc = drv.location;
  // Set begin to end.
  loc.step();
%}

 /**
  * All token names that you might use:
  *   ID
  *   STRING
  *   INT
  *   COMMA
  *   COLON
  *   LPAREN
  *   RPAREN
  *   LBRACK
  *   RBRACK
  *   LBRACE
  *   RBRACE
  *   DOT
  *   ARRAY
  *   IF
  *   THEN
  *   WHILE
  *   FOR
  *   TO
  *   LET
  *   IN
  *   END
  *   BREAK
  *   NIL
  *   VAR
  *   SEMICOLON
  *   DO
  *   LOWER
  *   TYPE
  *   FUNCTION
  *   OF
  *   LOW
  *   ELSE
  *   ASSIGN
  *   OR
  *   AND
  *   EQ
  *   NEQ
  *   GT
  *   LT
  *   GE
  *   LE
  *   PLUS
  *   MINUS
  *   TIMES
  *   DIVIDE
  *   UMINUS
  */

 /* TODO: add your rules here (lab2). */

 /* reserved words */
"array"     return yy::parser::make_ARRAY(loc);

 /*
  * skip white space chars.
  * space, tabs and LF
  */
[ \t]+ { loc.step(); }
\n+ { loc.lines(yyleng); loc.step(); }

. { ERROR("illegal token"); }

 /* End of TODO */

%%

yy::parser::symbol_type make_ID(std::string_view s, const location_type &loc) {
  return yy::parser::make_ID(sym::Symbol::UniqueSymbol(s), loc);
}

yy::parser::symbol_type make_INT(const std::string &s, const location_type &loc)
{
  try {
    int n = std::stoi(s);
    return yy::parser::make_INT(n, loc);
  } catch (std::out_of_range const& ex) {
    ERROR("integer is out of range: " + s);
  }
}

void TigerFrontendDriver::scan_begin() {
  if (file.empty() || file == "-") {
    yyin = stdin;
  } else if (!(yyin = fopen(file.c_str(), "r"))) {
    std::cerr << "cannot open " << file << ": " << strerror(errno) << std::endl;
    exit(EXIT_FAILURE);
  }
  location.initialize(&file);
}

void TigerFrontendDriver::scan_end() {
  fclose(yyin);
}
