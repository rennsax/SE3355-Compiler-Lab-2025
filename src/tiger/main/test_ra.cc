#include "tiger/absyn/absyn.h"
#include "tiger/frame/x64frame.h"
#include "tiger/escape/escape.h"
#include "tiger/frontend/driver.h"
#include "tiger/output/output.h"
#include "tiger/semant/semant.h"
#include "tiger/translate/translate.h"

frame::RegManager *reg_manager;
frame::Frags *frags;
llvm::IRBuilder<> *ir_builder;
llvm::Module *ir_module;

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: %s file.tig\n", argv[0]);
    exit(1);
  }

  std::string_view fname;
  std::unique_ptr<absyn::AbsynTree> absyn_tree;
  reg_manager = new frame::X64RegManager();
  llvm::LLVMContext context;
  ir_builder = new llvm::IRBuilder<>(context);
  frags = new frame::Frags();

  fname = std::string_view(argv[1]);
  ir_module = new llvm::Module("tiger-program", context);
  ir_module->setSourceFileName(fname);

  std::string ir_tmp_fname = std::tmpnam(nullptr);

  {
    err::ErrorMsg errormsg{};

    {
      // Lab 2-3: scan and parse
      TigerFrontendDriver driver(argv[1], errormsg);
      int res = driver.parse();
      if (res != 0) {
        std::cerr << "Parse file `"<< driver.file  <<"' error!" << std::endl;
        return res;
      }
      absyn_tree.reset(driver.parse_result);
    }
    {
      // Lab 4: type checking
      sem::ProgSem program_sem_analyzer(std::move(absyn_tree), errormsg);
      program_sem_analyzer.SemAnalyze();
      absyn_tree = program_sem_analyzer.TransferAbsynTree();
      if (errormsg.AnyErrors()) {
        std::cerr << "warning: type checking not passed" << std::endl;
      }
    }

    {
      // Lab 5-1: escape analysis
      esc::EscFinder esc_finder(std::move(absyn_tree));
      esc_finder.FindEscape();
      absyn_tree = esc_finder.TransferAbsynTree();
    }

    {
      // Lab 5: translate IR tree
      tr::ProgTr prog_tr(std::move(absyn_tree), &errormsg);
      prog_tr.Translate();
      prog_tr.OutputIR(ir_tmp_fname);
    }
  }

  {
    // Output assembly
    output::AssemGen assem_gen(ir_tmp_fname, stdout);
    assem_gen.LoadllvmAndGen(true);
  }

  return 0;
}
