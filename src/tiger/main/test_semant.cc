#include <cstdio>
#include <fstream>

#include "tiger/absyn/absyn.h"
#include "tiger/errormsg/errormsg.h"
#include "tiger/frontend/driver.h"
#include "tiger/semant/semant.h"

// REVIEW: any other elegant resolutions?
// define here to pass compilation
llvm::IRBuilder<> *ir_builder;
llvm::Module *ir_module;

int main(int argc, char **argv) {
  std::unique_ptr<absyn::AbsynTree> absyn_tree;

  err::ErrorMsg errormsg{};

  if (argc < 2) {
    fprintf(stderr, "usage: %s filename\n", argv[0]);
    exit(1);
  }

  {
    TigerFrontendDriver driver(argv[1], errormsg);
    int res = driver.parse();
    if (res != 0) {
      return res;
    }
    absyn_tree.reset(driver.parse_result);
  }

  {
    sem::ProgSem program_sem_analyzer(std::move(absyn_tree), errormsg);
    program_sem_analyzer.SemAnalyze();
  }
  if (errormsg.AnyErrors()) {
    return 1;
  }
  return 0;
}
