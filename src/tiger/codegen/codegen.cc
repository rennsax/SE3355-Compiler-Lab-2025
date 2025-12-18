#include <cassert>
#include <iostream>
#include <sstream>

#include "tiger/codegen/codegen.h"
#include "tiger/frame/x64frame.h"

namespace cg {

void CodeGen::Codegen() {
  /* TODO: put your lab6 code here */
}

void AssemInstr::Print(FILE *out, temp::Map *map) const {
  for (auto instr : instr_list_->GetList())
    instr->Print(out, map);
  fprintf(out, "\n");
}

} // namespace cg
