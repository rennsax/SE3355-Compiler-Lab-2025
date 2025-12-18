#ifndef TIGER_FRAME_FRAME_H_
#define TIGER_FRAME_FRAME_H_

#include <list>
#include <memory>
#include <string>

#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Value.h>

#include "tiger/frame/temp.h"

namespace frame {

class RegManager {
public:
  RegManager() : temp_map_(temp::Map::Empty()) {}

  temp::Temp *GetRegister(int regno) { return regs_[regno]; }

  /**
   * Get general-purpose registers except RSI
   * NOTE: returned temp list should be in the order of calling convention
   * @return general-purpose registers
   */
  [[nodiscard]] virtual temp::TempList *Registers() = 0;

  /**
   * Get registers which can be used to hold arguments
   * NOTE: returned temp list must be in the order of calling convention
   * @return argument registers
   */
  [[nodiscard]] virtual temp::TempList *ArgRegs() = 0;

  /**
   * Get caller-saved registers
   * NOTE: returned registers must be in the order of calling convention
   * @return caller-saved registers
   */
  [[nodiscard]] virtual temp::TempList *CallerSaves() = 0;

  /**
   * Get callee-saved registers
   * NOTE: returned registers must be in the order of calling convention
   * @return callee-saved registers
   */
  [[nodiscard]] virtual temp::TempList *CalleeSaves() = 0;

  /**
   * Get return-sink registers
   * @return return-sink registers
   */
  [[nodiscard]] virtual temp::TempList *ReturnSink() = 0;

  /**
   * Get word size
   */
  [[nodiscard]] virtual int WordSize() = 0;

  [[nodiscard]] virtual temp::Temp *FramePointer() = 0;

  temp::Map *temp_map_;

protected:
  std::vector<temp::Temp *> regs_;
};

class Access {
public:
  virtual llvm::Value *ToLLVMVal(llvm::Value *frame_addr_ptr) const = 0;
  virtual ~Access() = default;
};

class Frame {
public:
  int outgo_size_;
  int offset_;
  temp::Label *name_;
  std::list<frame::Access *> *formals_;

  Frame(int outgo_size, int offset, temp::Label *name,
        std::list<frame::Access *> *formals)
      : outgo_size_(outgo_size), offset_(offset), name_(name),
        formals_(formals) {}

  [[nodiscard]] virtual std::string GetLabel() const = 0;
  [[nodiscard]] virtual temp::Label *Name() const = 0;
  [[nodiscard]] virtual std::list<frame::Access *> *Formals() const = 0;
  virtual frame::Access *AllocLocal(bool escape) = 0;
};

frame::Frame *NewFrame(temp::Label *name, std::list<bool> formals);

#ifdef TIGER_CODEGEN
/**
 * Fragments
 */

class Frag {
public:
  virtual ~Frag() = default;

  enum OutputPhase {
    Proc,
    String,
  };

  /**
   *Generate assembly for main program
   * @param out FILE object for output assembly file
   */
  virtual void OutputAssem(FILE *out, OutputPhase phase,
                           bool need_ra) const = 0;
};

class StringFrag : public Frag {
public:
  llvm::Value *str_val_;
  std::string str_;

  StringFrag(llvm::Value *str_val, std::string str)
      : str_val_(str_val), str_(std::move(str)) {}

  void OutputAssem(FILE *out, OutputPhase phase, bool need_ra) const override;
};

class ProcFrag : public Frag {
public:
  llvm::Function *body_;

  ProcFrag(llvm::Function *body) : body_(body) {}

  void OutputAssem(FILE *out, OutputPhase phase, bool need_ra) const override;
};

class Frags {
public:
  Frags() = default;
  void PushBack(Frag *frag) {
    frags_.push_back(frag);
  }
  const std::list<Frag *> &GetList() { return frags_; }

private:
  std::list<Frag *> frags_;
};

/* TODO: put your lab6 code here (declaration of ProcEntryExit{1,2,3}) */
#endif

} // namespace frame

#endif
