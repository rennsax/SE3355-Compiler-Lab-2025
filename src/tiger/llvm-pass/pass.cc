#include <iostream>
#include <sstream>

#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/Pass.h>
#include <llvm/IR/Intrinsics.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/InlineAsm.h>
#include <llvm/IR/PassManager.h>
#include <llvm/Passes/PassPlugin.h>
#include <llvm/Passes/PassBuilder.h>

#define PASS_NAME TigerInstSelectPass
#define PASS_NAME_STR "TigerInstSelectPass"

namespace llvm {

class PASS_NAME : public PassInfoMixin<PASS_NAME> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
    for (auto &F : M.functions()) {
      if (F.isDeclaration()) continue;
      std::size_t frame_size = 0;
      for (auto &BB : F) {
        for (auto II = BB.begin(), IE = BB.end(); II != IE; ) {
          Instruction *I = &*II++;
          if (auto *CI = dyn_cast<CallInst>(I)) {
            Function *Callee = CI->getCalledFunction();
            if (!Callee) continue;
            IRBuilder<> Builder(CI);

            // @tiger.allocai
            if (Callee->getName() == "tiger.allocai") {
              Value *size = CI->getArgOperand(0);
              Value *offset = CI->getArgOperand(1);

              std::size_t size_v = llvm::dyn_cast<llvm::ConstantInt>(size)->getSExtValue();
              frame_size += size_v;

              // TODO
              std::size_t offset_v = llvm::dyn_cast<llvm::ConstantInt>(offset)->getSExtValue();

              Value *RSP = Builder.CreateCall(
                InlineAsm::get(
                  FunctionType::get(Builder.getInt64Ty(), {}, false),
                  "movq %rsp, $0", "=r", true),
                {});
              Value *TargetAddr = Builder.CreateAdd(RSP, offset);
              Value *TargetPtr = Builder.CreateIntToPtr(TargetAddr, Builder.getPtrTy(), CI->getName());
              CI->replaceAllUsesWith(TargetPtr);
              CI->eraseFromParent();
            }
            // @tiger.read_sp
            else if (Callee->getName() == "tiger.readsp") {
              FunctionType *ft = FunctionType::get(Builder.getInt64Ty(), false);
              InlineAsm *rdrsp = InlineAsm::get(ft, "movq %rsp, $0", "=r", true);
              Value *rsp = Builder.CreateCall(rdrsp, {}, "sp");
              CI->replaceAllUsesWith(rsp);
              CI->eraseFromParent();
            }
          }
        }
      }
      if (frame_size != 0) {
        auto &BB = F.getEntryBlock();
        IRBuilder<> Builder(&BB, BB.begin());
        std::stringstream ss{};
        ss << "subq $$" << frame_size << ", %rsp";
        Builder.CreateCall(
          InlineAsm::get(FunctionType::get(Builder.getVoidTy(), false),
                         ss.str(), "~{rsp}", true),
          {});
        ss.str("");
        ss << "addq $$" << frame_size << ", %rsp";
        for (auto &BB : F) {
          for (auto II = BB.begin(), IE = BB.end(); II != IE;) {
            Instruction *I = &*II++;
            if (auto *RI = dyn_cast<ReturnInst>(I)) {
              IRBuilder<> Builder(RI);
              Builder.CreateCall(
                InlineAsm::get(
                  FunctionType::get(Builder.getVoidTy(), {}, false),
                  ss.str(), "~{rsp}", true),
                {});
            }
          }
        }
      }
    }
    return PreservedAnalyses::all();
  }
};
}

using namespace llvm;

llvm::PassPluginLibraryInfo getTigerInstSelectPassPluginInfo() {
  return {
    LLVM_PLUGIN_API_VERSION, PASS_NAME_STR, LLVM_VERSION_STRING,
    [](PassBuilder &PB) {
      PB.registerPipelineParsingCallback(
        [](StringRef Name, ModulePassManager &MPM,
           ArrayRef<PassBuilder::PipelineElement>) -> bool {
          if (Name == "tiger-pass") {
            MPM.addPass(TigerInstSelectPass());
            return true;
          } else {
            return false;
          }
        });
    }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getTigerInstSelectPassPluginInfo();
}
