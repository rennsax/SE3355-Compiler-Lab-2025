#include <cstdio>
#include <iostream>
#include <algorithm>
#include <map>

#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/raw_ostream.h>

#include "tiger/output/output.h"
#include "tiger/canon/canon.h"
#include "tiger/codegen/codegen.h"
#include "tiger/frame/frame.h"

#ifdef TIGER_RA
#include "tiger/regalloc/regalloc.h"
#endif

extern frame::RegManager *reg_manager;
extern frame::Frags *frags;
extern llvm::IRBuilder<> *ir_builder;
extern llvm::Module *ir_module;
std::map<std::string, std::pair<int, int>> frame_info_map;

namespace output {
void AssemGen::LoadllvmAndGen(bool need_ra) {
  llvm::LLVMContext context;
  llvm::SMDiagnostic error;

  std::unique_ptr<llvm::Module> mod =
    llvm::parseIRFile(filename + ".ll", error, context);

  if (!mod) {
    error.print("output", llvm::errs());
    return;
  }

  for (auto &func : mod->getFunctionList()) {
    if (func.isDeclaration())
      continue;
    frags->PushBack(new frame::ProcFrag(&func));
  }

  std::for_each(mod->global_begin(), mod->global_end(), [](llvm::GlobalVariable &global) {
    if (global.hasInitializer()) {
      auto *init = global.getInitializer();
      if (auto *str_struct = llvm::dyn_cast<llvm::ConstantStruct>(init)) {
        if (str_struct->getType()->getName() == "string") {
          llvm::Constant *strArrayPtr =
            llvm::cast<llvm::Constant>(str_struct->getOperand(1));
          llvm::GlobalVariable *strArray =
            llvm::cast<llvm::GlobalVariable>(strArrayPtr->getOperand(0));

          if (auto str_init = llvm::dyn_cast<llvm::ConstantDataArray>(
                strArray->getInitializer()) == nullptr) {
            frags->PushBack(new frame::StringFrag(&global, ""));
            return;
          }
          std::string strContent =
            static_cast<llvm::ConstantDataArray *>(strArray->getInitializer())
            ->getAsCString()
            .str();
          frags->PushBack(new frame::StringFrag(&global, strContent));
        }
      }
    }
  });

  GenAssem(need_ra);
}

void AssemGen::GenAssem(bool need_ra) {
  // Output proc
  fprintf(out_, ".text\n");
  for (auto &&frag : frags->GetList())
    frag->OutputAssem(out_, frame::Frag::Proc, need_ra);

  // Output string
  fprintf(out_, ".section .rodata\n");
  for (auto &&frag : frags->GetList())
    frag->OutputAssem(out_, frame::Frag::String, need_ra);
}

} // namespace output

namespace frame {

void ProcFrag::OutputAssem(FILE *out, OutputPhase phase, bool need_ra) const {
  std::unique_ptr<canon::Traces> traces;
  std::unique_ptr<cg::AssemInstr> assem_instr;

  // When generating proc fragment, do not output string assembly
  if (phase != Proc)
    return;

  {
    // Canonicalize
    canon::Canon canon(body_);

    // Group list into basic blocks
    // make all basic block name unique
    canon::BasicBlockList *basicblock_list = canon.BasicBlocks();

    // Order basic blocks into traces_
    traces = canon.TransferTraces();
  }

  temp::Map *color =
    temp::Map::LayerMap(reg_manager->temp_map_, temp::Map::Name());
  {
    // Lab 6: code generation
    cg::CodeGen code_gen(std::move(traces));
    code_gen.Codegen();
    assem_instr = code_gen.TransferAssemInstr();
  }

  assem::InstrList *il = assem_instr.get()->GetInstrList();

#ifdef TIGER_RA
  if (need_ra) {
    // Lab 7: register allocation
    std::unique_ptr<ra::Result> allocation;
    ra::RegAllocator reg_allocator(body_->getName().str(),
                                   std::move(assem_instr));
    reg_allocator.RegAlloc();
    allocation = reg_allocator.TransferResult();
    il = allocation->il_;
    color = temp::Map::LayerMap(reg_manager->temp_map_, allocation->coloring_);
  }
#endif

  /* TODO: put your lab6 code here */
}

void StringFrag::OutputAssem(FILE *out, OutputPhase phase, bool need_ra) const {
  // When generating string fragment, do not output proc assembly
  if (phase != String)
    return;

  fprintf(out, "%s:\n", str_val_->getName().data());
  int length = static_cast<int>(str_.size());
  // It may contain zeros in the middle of string. To keep this work, we need
  // to print all the charactors instead of using fprintf(str)
  fprintf(out, ".long %d\n", length);
  fprintf(out, ".string \"");
  for (int i = 0; i < length; i++) {
    if (str_[i] == '\n') {
      fprintf(out, "\\n");
    } else if (str_[i] == '\t') {
      fprintf(out, "\\t");
    } else if (str_[i] == '\"') {
      fprintf(out, "\\\"");
    } else {
      fprintf(out, "%c", str_[i]);
    }
  }
  fprintf(out, "\"\n");
}

} // namespace frame
