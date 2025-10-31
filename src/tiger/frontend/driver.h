#ifndef TIGER_FONTEND_DRIVER_H
#define TIGER_FONTEND_DRIVER_H

#include <memory>
#include "tiger/errormsg/errormsg.h"
#include "tiger/absyn/absyn.h"
#include "parser.hh"

class TigerFrontendDriver;

#define YY_DECL \
  yy::parser::symbol_type yylex(TigerFrontendDriver& drv)

YY_DECL;

#ifdef YY_NULL
#undef YY_NULL
#endif
#define YY_NULL yy::parser::make_YYEOF(loc)

/**
 * A simple shim class that combines the scanner and parser, and record global
 * information.
 *
 * Each @c TigerFrontendDriver is bound to a file when constructed.
 *
 */
class TigerFrontendDriver {
public:
  using syntax_error = yy::parser::syntax_error;
  /// The structure that contains (only) the @c token_kind_type enumeration
  using Token = yy::parser::token;
  /// Symbol kinds.
  using SKind = yy::parser::symbol_kind;

  TigerFrontendDriver(std::string_view f, err::ErrorMsg &errmsg) : file(new std::string{f}), parse_result(nullptr), errormsg(errmsg) { }

  /**
   * Auxiliary methods for initializing/cleanup states before and after @c yylex
   * scans the input file.
   *
   * Should be defined in @ref scanner.lex so some symbols from flex can be
   * found.
   */
  void scan_begin();
  /**
   * @sa ::scan_begin
   */
  void scan_end();

  /**
   * Use @c yylex to scan the next token.
   *
   * @return the next token
   */
  yy::parser::symbol_type lex() {
    return yylex(*this);
  }

  /**
   * Parse the whole file.
   *
   * @return status code. 0 on success, 1 otherwise
   */
  int parse() {
    this->scan_begin();
    yy::parser parse(*this);
    int res = parse();
    this->scan_end();
    return res;
  }

  /// The location of the current token. Used by the scanner.
  yy::location location;
  /// The scanned/parsed file. "-" refers to standard input.
  const std::string *file; // FIXME: memory leak
  /// The root of the whole AST.
  absyn::AbsynTree *parse_result;

  err::ErrorMsg& errormsg;
};

#endif
