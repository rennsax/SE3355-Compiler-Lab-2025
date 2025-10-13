#include <cstdio>
#include <fstream>

#include "tiger/frontend/driver.h"

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: %s filename\n", argv[0]);
    exit(1);
  }
  err::ErrorMsg errormsg {};
  auto driver = std::make_unique<TigerFrontendDriver>(argv[1], errormsg);

  int res = driver->parse();
  if (res != 0) {
    return 1;
  }
  auto ast = driver->parse_result;
  if (ast == nullptr) {
    std::cerr << "Unexpected error occurs: parse result is null!" << std::endl;
  }
  ast->Print(stdout);
  fprintf(stdout, "\n");
  return 0;
}
