#include "tiger/absyn/absyn.h"
#include "tiger/escape/escape.h"
#include "tiger/frontend/driver.h"
#include "tiger/translate/translate.h"

// REVIEW: any other elegant resolutions?
// define here to pass compilation
llvm::IRBuilder<> *ir_builder;
llvm::Module *ir_module;

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: %s file.tig\n", argv[0]);
    exit(1);
  }

  std::string_view fname;
  std::unique_ptr<absyn::AbsynTree> absyn_tree;

  fname = std::string_view(argv[1]);

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
      // Lab 5-1: escape analysis
      esc::EscFinder esc_finder(std::move(absyn_tree));
      esc_finder.FindEscape();
      absyn_tree = esc_finder.TransferAbsynTree();
      absyn_tree->Print(stdout);
    }
  }

  return 0;
}
