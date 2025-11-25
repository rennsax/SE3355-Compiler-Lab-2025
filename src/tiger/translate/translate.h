#ifndef TIGER_TRANSLATE_TRANSLATE_H_
#define TIGER_TRANSLATE_TRANSLATE_H_

#include <list>
#include <memory>

#include "tiger/absyn/absyn.h"
#include "tiger/env/env.h"
#include "tiger/errormsg/errormsg.h"
#include "tiger/frame/frame.h"

namespace tr {

// Function index used by `tr::TigerIntrinsics`.
enum TigerIntrinsicsName {
  ALLOC_RECORD,
  INIT_ARRAY,
  STRING_EQUAL,
  TIGER_ALLOCAI,
  TIGER_READSP,
  INTRINSICSCNT,
};

class ValAndTy {
public:
  type::Ty *ty_;
  llvm::Value *val_;

  ValAndTy(llvm::Value *val, type::Ty *ty) : val_(val), ty_(ty) {}
};

class Level;

class Access {
public:
  Level *level_;
  frame::Access *access_;

  Access(Level *level, frame::Access *access)
      : level_(level), access_(access) {}
};

// Predefined LLVM functions that are used in the Tiger compiler.
extern std::array<llvm::Function*, INTRINSICSCNT> TigerIntrinsics;

class Level {
public:
  Level(frame::Frame *frame, Level *parent) : frame_(frame), parent_(parent) {}

private:
  frame::Frame *frame_;
  Level *parent_;
};

class ProgTr {
public:
  ProgTr(std::unique_ptr<absyn::AbsynTree> absyn_tree,
         err::ErrorMsg *errormsg)
      : absyn_tree_(std::move(absyn_tree)), errormsg_(errormsg),
        main_level_(std::make_unique<Level>(
            frame::NewFrame(temp::LabelFactory::NamedLabel("tigermain"),
                            std::list<bool>()),
            nullptr)),
        tenv_(std::make_unique<env::TEnv>()),
        venv_(std::make_unique<env::VEnv>()) {}

  /**
   * Translate IR tree
   */
  void Translate();

  void OutputIR(std::string_view filename);

private:
  std::unique_ptr<absyn::AbsynTree> absyn_tree_;
  err::ErrorMsg *errormsg_;
  std::unique_ptr<Level> main_level_;
  std::unique_ptr<env::TEnv> tenv_;
  std::unique_ptr<env::VEnv> venv_;

  // Fill base symbol for var env and type env
  void FillBaseVEnv();
  void FillBaseTEnv();
};

} // namespace tr

#endif
