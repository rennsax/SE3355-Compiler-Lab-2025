#ifndef TIGER_ABSYN_ABSYN_H_
#define TIGER_ABSYN_ABSYN_H_

#include <cstdio>
#include <list>
#include <string>

#include "location.hh" // yy::location
#include "tiger/symbol/symbol.h"

#ifndef TIGER_NO_BACKEND
/**
 * Forward Declarations
 */
namespace tr {
class Exp;
class ValAndTy;
} // namespace tr
#endif

namespace absyn {

class Var;
class Exp;
class Dec;
class Ty;

class ExpList;
class FieldList;
class FunDecList;
class NameAndTyList;
class DecList;
class EFieldList;

enum Oper {
  AND_OP,
  OR_OP,
  PLUS_OP,
  MINUS_OP,
  TIMES_OP,
  DIVIDE_OP,
  EQ_OP,
  NEQ_OP,
  LT_OP,
  LE_OP,
  GT_OP,
  GE_OP,
  ABSYN_OPER_COUNT,
};

using location_t = yy::location;
using position_t = yy::position;
}

#ifndef TIGER_NO_BACKEND
#include "tiger/errormsg/errormsg.h" // Should be included after absyn::location_t is declared.
#include "tiger/env/env.h"
#include "tiger/semant/types.h"
#include "tiger/escape/escape.h"
#endif

namespace absyn {

/**
 * Abstract syntax tree root
 */
class AbsynTree {
public:
  AbsynTree() = delete;
  explicit AbsynTree(absyn::Exp *root);
  AbsynTree(const AbsynTree &absyn_tree) = delete;
  AbsynTree(AbsynTree &&absyn_tree) = delete;
  AbsynTree &operator=(const AbsynTree &absyn_tree) = delete;
  AbsynTree &operator=(AbsynTree &&absyn_tree) = delete;
  ~AbsynTree();

  void Print(FILE *out) const;
#ifndef TIGER_NO_BACKEND
  void SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv,
                  err::ErrorMsg *errormsg) const;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level, err::ErrorMsg *errormsg) const;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env);
#endif
#endif

private:
  absyn::Exp *root_;
};

/**
 * Variables
 */

class Var {
public:
  location_t loc_;
  virtual ~Var() = default;
  virtual void Print(FILE *out, int d) const = 0;
#ifndef TIGER_NO_BACKEND
  virtual type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv,
                               int labelcount,
                               err::ErrorMsg *errormsg) const = 0;
#ifdef TIGER_LAB5
  virtual tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                                  tr::Level *level,
                                  err::ErrorMsg *errormsg) const = 0;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  virtual void Traverse(esc::EscEnvPtr env, int depth) = 0;
#endif
#endif

protected:
  explicit Var(location_t loc) : loc_(loc) {}
};

class SimpleVar : public Var {
public:
  sym::Symbol *sym_;
  SimpleVar(location_t loc, sym::Symbol *sym) : Var(loc), sym_(sym) {}
  ~SimpleVar() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class FieldVar : public Var {
public:
  Var *var_;
  sym::Symbol *sym_;

  FieldVar(location_t loc, Var *var, sym::Symbol *sym)
      : Var(loc), var_(var), sym_(sym) {}
  ~FieldVar() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class SubscriptVar : public Var {
public:
  Var *var_;
  Exp *subscript_;

  SubscriptVar(location_t loc, Var *var, Exp *exp)
      : Var(loc), var_(var), subscript_(exp) {}
  ~SubscriptVar() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

/**
 * Expressions
 */

class Exp {
public:
  location_t loc_;
  virtual ~Exp() = default;
  virtual void Print(FILE *out, int d) const = 0;
#ifndef TIGER_NO_BACKEND
  virtual type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv,
                               int labelcount,
                               err::ErrorMsg *errormsg) const = 0;
#ifdef TIGER_LAB5
  virtual tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                                  tr::Level *level,
                                  err::ErrorMsg *errormsg) const = 0;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  virtual void Traverse(esc::EscEnvPtr env, int depth) = 0;
#endif
#endif

protected:
  explicit Exp(location_t loc) : loc_(loc) {}
};

class VarExp : public Exp {
public:
  Var *var_;

  VarExp(location_t loc, Var *var) : Exp(loc), var_(var) {}
  ~VarExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class NilExp : public Exp {
public:
  explicit NilExp(location_t loc) : Exp(loc) {}
  ~NilExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class IntExp : public Exp {
public:
  int val_;

  IntExp(location_t loc, int val) : Exp(loc), val_(val) {}
  ~IntExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class StringExp : public Exp {
public:
  std::string str_;

  StringExp(location_t loc, const std::string &str) : Exp(loc), str_(str) {}
  ~StringExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class CallExp : public Exp {
public:
  sym::Symbol *func_;
  ExpList *args_;

  CallExp(location_t loc, sym::Symbol *func, ExpList *args)
      : Exp(loc), func_(func), args_(args) {
    assert(args);
  }
  ~CallExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class OpExp : public Exp {
public:
  Oper oper_;
  Exp *left_, *right_;

  OpExp(location_t loc, Oper oper, Exp *left, Exp *right)
      : Exp(loc), oper_(oper), left_(left), right_(right) {}
  ~OpExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class RecordExp : public Exp {
public:
  sym::Symbol *typ_;
  EFieldList *fields_;

  RecordExp(location_t loc, sym::Symbol *typ, EFieldList *fields)
      : Exp(loc), typ_(typ), fields_(fields) {}
  ~RecordExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class SeqExp : public Exp {
public:
  ExpList *seq_;

  SeqExp(location_t loc, ExpList *seq) : Exp(loc), seq_(seq) {}
  ~SeqExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class AssignExp : public Exp {
public:
  Var *var_;
  Exp *exp_;

  AssignExp(location_t loc, Var *var, Exp *exp) : Exp(loc), var_(var), exp_(exp) {}
  ~AssignExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class IfExp : public Exp {
public:
  Exp *test_, *then_, *elsee_;

  IfExp(location_t loc, Exp *test, Exp *then, Exp *elsee)
      : Exp(loc), test_(test), then_(then), elsee_(elsee) {}
  ~IfExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class WhileExp : public Exp {
public:
  Exp *test_, *body_;

  WhileExp(location_t loc, Exp *test, Exp *body)
      : Exp(loc), test_(test), body_(body) {}
  ~WhileExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class ForExp : public Exp {
public:
  sym::Symbol *var_;
  Exp *lo_, *hi_, *body_;
  bool escape_;

  ForExp(location_t loc, sym::Symbol *var, Exp *lo, Exp *hi, Exp *body)
      : Exp(loc), var_(var), lo_(lo), hi_(hi), body_(body), escape_(true) {}
  ~ForExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class BreakExp : public Exp {
public:
  explicit BreakExp(location_t loc) : Exp(loc) {}
  ~BreakExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class LetExp : public Exp {
public:
  DecList *decs_;
  Exp *body_;

  LetExp(location_t loc, DecList *decs, Exp *body)
      : Exp(loc), decs_(decs), body_(body) {}
  ~LetExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class ArrayExp : public Exp {
public:
  sym::Symbol *typ_;
  Exp *size_, *init_;

  ArrayExp(location_t loc, sym::Symbol *typ, Exp *size, Exp *init)
      : Exp(loc), typ_(typ), size_(size), init_(init) {}
  ~ArrayExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class VoidExp : public Exp {
public:
  explicit VoidExp(location_t loc) : Exp(loc) {}
  ~VoidExp() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  tr::ValAndTy *Translate(env::VEnvPtr venv, env::TEnvPtr tenv,
                          tr::Level *level,
                          err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

/**
 * Declarations
 */

class Dec {
public:
  location_t loc_;
  virtual ~Dec() = default;
  virtual void Print(FILE *out, int d) const = 0;
#ifndef TIGER_NO_BACKEND
  virtual void SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                          err::ErrorMsg *errormsg) const = 0;
#ifdef TIGER_LAB5
  virtual void Translate(env::VEnvPtr venv, env::TEnvPtr tenv, tr::Level *level,
                         err::ErrorMsg *errormsg) const = 0;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  virtual void Traverse(esc::EscEnvPtr env, int depth) = 0;
#endif
#endif

protected:
  explicit Dec(location_t loc) : loc_(loc) {}
};

class FunctionDec : public Dec {
public:
  FunDecList *functions_;

  FunctionDec(location_t loc, FunDecList *functions)
      : Dec(loc), functions_(functions) {}
  ~FunctionDec() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  void SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                  err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  void Translate(env::VEnvPtr venv, env::TEnvPtr tenv, tr::Level *level,

                 err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class VarDec : public Dec {
public:
  sym::Symbol *var_;
  sym::Symbol *typ_;
  Exp *init_;
  bool escape_;

  VarDec(location_t loc, sym::Symbol *var, sym::Symbol *typ, Exp *init)
      : Dec(loc), var_(var), typ_(typ), init_(init), escape_(true) {}
  ~VarDec() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  void SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                  err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  void Translate(env::VEnvPtr venv, env::TEnvPtr tenv, tr::Level *level,

                 err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

class TypeDec : public Dec {
public:
  NameAndTyList *types_;

  TypeDec(location_t loc, NameAndTyList *types) : Dec(loc), types_(types) {}
  ~TypeDec() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  void SemAnalyze(env::VEnvPtr venv, env::TEnvPtr tenv, int labelcount,
                  err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  void Translate(env::VEnvPtr venv, env::TEnvPtr tenv, tr::Level *level,

                 err::ErrorMsg *errormsg) const override;
#endif
#if defined(TIGER_LAB5) || defined(TIGER_LAB5_1)
  void Traverse(esc::EscEnvPtr env, int depth) override;
#endif
#endif
};

/**
 * Types
 */

class Ty {
public:
  location_t loc_;
  virtual ~Ty() = default;
  virtual void Print(FILE *out, int d) const = 0;
#ifndef TIGER_NO_BACKEND
  virtual type::Ty *SemAnalyze(env::TEnvPtr tenv,
                               err::ErrorMsg *errormsg) const = 0;
#ifdef TIGER_LAB5
  virtual type::Ty *Translate(env::TEnvPtr tenv,
                              err::ErrorMsg *errormsg) const = 0;
#endif
#endif

protected:
  explicit Ty(location_t loc) : loc_(loc) {}
};

class NameTy : public Ty {
public:
  sym::Symbol *name_;

  NameTy(location_t loc, sym::Symbol *name) : Ty(loc), name_(name) {}
  ~NameTy() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::TEnvPtr tenv,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  type::Ty *Translate(env::TEnvPtr tenv,
                      err::ErrorMsg *errormsg) const override;
#endif
#endif
};

class RecordTy : public Ty {
public:
  FieldList *record_;

  RecordTy(location_t loc, FieldList *record) : Ty(loc), record_(record) {}
  ~RecordTy() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::TEnvPtr tenv,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  type::Ty *Translate(env::TEnvPtr tenv,
                      err::ErrorMsg *errormsg) const override;
#endif
#endif
};

class ArrayTy : public Ty {
public:
  sym::Symbol *array_;

  ArrayTy(location_t loc, sym::Symbol *array) : Ty(loc), array_(array) {}
  ~ArrayTy() override;

  void Print(FILE *out, int d) const override;
#ifndef TIGER_NO_BACKEND
  type::Ty *SemAnalyze(env::TEnvPtr tenv,
                       err::ErrorMsg *errormsg) const override;
#ifdef TIGER_LAB5
  type::Ty *Translate(env::TEnvPtr tenv,
                      err::ErrorMsg *errormsg) const override;
#endif
#endif
};

/**
 * Linked lists and nodes of lists
 */

class Field {
public:
  location_t loc_;
  sym::Symbol *name_, *typ_;
  bool escape_;

  Field(location_t loc, sym::Symbol *name, sym::Symbol *typ)
      : loc_(loc), name_(name), typ_(typ), escape_(true) {}

  void Print(FILE *out, int d) const;
};

class FieldList {
public:
  FieldList() = default;
  explicit FieldList(Field *field) : field_list_({field}) { assert(field); }

  FieldList *Prepend(Field *field) {
    field_list_.push_front(field);
    return this;
  }
  [[nodiscard]] const std::list<Field *> &GetList() const {
    return field_list_;
  }
  void Print(FILE *out, int d) const;
#ifndef TIGER_NO_BACKEND
  type::TyList *MakeFormalTyList(env::TEnvPtr tenv,
                                 err::ErrorMsg *errormsg) const;
  type::FieldList *MakeFieldList(env::TEnvPtr tenv,
                                 err::ErrorMsg *errormsg) const;
#endif

private:
  std::list<Field *> field_list_;
};

class ExpList {
public:
  ExpList() = default;
  explicit ExpList(Exp *exp) : exp_list_({exp}) { assert(exp); }

  ExpList *Prepend(Exp *exp) {
    exp_list_.push_front(exp);
    return this;
  }
  [[nodiscard]] const std::list<Exp *> &GetList() const { return exp_list_; }
  void Print(FILE *out, int d) const;

private:
  std::list<Exp *> exp_list_;
};

class FunDec {
public:
  location_t loc_;
  sym::Symbol *name_;
  FieldList *params_;
  sym::Symbol *result_;
  Exp *body_;

  FunDec(location_t loc, sym::Symbol *name, FieldList *params, sym::Symbol *result,
         Exp *body)
      : loc_(loc), name_(name), params_(params), result_(result), body_(body) {
    assert(params);
  }

  void Print(FILE *out, int d) const;
};

class FunDecList {
public:
  explicit FunDecList(FunDec *fun_dec) : fun_dec_list_({fun_dec}) {
    assert(fun_dec);
  }

  FunDecList *Prepend(FunDec *fun_dec) {
    fun_dec_list_.push_front(fun_dec);
    return this;
  }
  [[nodiscard]] const std::list<FunDec *> &GetList() const {
    return fun_dec_list_;
  }
  void Print(FILE *out, int d) const;

private:
  std::list<FunDec *> fun_dec_list_;
};

class DecList {
public:
  DecList() = default;
  explicit DecList(Dec *dec) : dec_list_({dec}) { assert(dec); }

  DecList *Prepend(Dec *dec) {
    dec_list_.push_front(dec);
    return this;
  }
  [[nodiscard]] const std::list<Dec *> &GetList() const { return dec_list_; }
  void Print(FILE *out, int d) const;

private:
  std::list<Dec *> dec_list_;
};

class NameAndTy {
public:
  sym::Symbol *name_;
  Ty *ty_;

  NameAndTy(sym::Symbol *name, Ty *ty) : name_(name), ty_(ty) {}

  void Print(FILE *out, int d) const;
};

class NameAndTyList {
public:
  explicit NameAndTyList(NameAndTy *name_and_ty)
      : name_and_ty_list_({name_and_ty}) {}

  NameAndTyList *Prepend(NameAndTy *name_and_ty) {
    name_and_ty_list_.push_front(name_and_ty);
    return this;
  }
  [[nodiscard]] const std::list<NameAndTy *> &GetList() const {
    return name_and_ty_list_;
  }
  void Print(FILE *out, int d) const;

private:
  std::list<NameAndTy *> name_and_ty_list_;
};

class EField {
public:
  sym::Symbol *name_;
  Exp *exp_;

  EField(sym::Symbol *name, Exp *exp) : name_(name), exp_(exp) {}
  EField(const EField &efield) = delete;
  EField(EField &&efield) = delete;
  EField &operator=(const EField &efield) = delete;
  EField &operator=(EField &&efield) = delete;
  ~EField();

  void Print(FILE *out, int d) const;
};

class EFieldList {
public:
  EFieldList() = default;
  explicit EFieldList(EField *efield) : efield_list_({efield}) {}

  EFieldList *Prepend(EField *efield) {
    efield_list_.push_front(efield);
    return this;
  }
  [[nodiscard]] const std::list<EField *> &GetList() const {
    return efield_list_;
  }
  void Print(FILE *out, int d) const;

private:
  std::list<EField *> efield_list_;
};

}; // namespace absyn

#endif // TIGER_ABSYN_ABSYN_H_
