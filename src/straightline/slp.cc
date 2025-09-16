#include <iostream>

#include "slp.h"

namespace absyn {
int absyn::CompoundStm::MaxArgs() const {
  // TODO: put your code here (lab1).
  return 0;
}

Table *absyn::CompoundStm::Interp(Table *t) const {
  // TODO: put your code here (lab1).
  return nullptr;
}

int absyn::AssignStm::MaxArgs() const {
  // TODO: put your code here (lab1).
  return 0;
}

Table *absyn::AssignStm::Interp(Table *t) const {
  // TODO: put your code here (lab1).
  return nullptr;
}

int absyn::PrintStm::MaxArgs() const {
  // TODO: put your code here (lab1).
  return 0;
}

Table *absyn::PrintStm::Interp(Table *t) const {
  // TODO: put your code here (lab1).
  return nullptr;
}

int Table::Lookup(const std::string &key) const {
  // TODO: put your code here (lab1).
  return 0;
}

Table *Table::Update(const std::string &key, int val) const {
  // TODO: put your code here (lab1).
  return nullptr;
}
} // namespace absyn
