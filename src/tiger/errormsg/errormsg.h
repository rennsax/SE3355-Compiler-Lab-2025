#ifndef TIGER_ERRORMSG_ERROMSG_H_
#define TIGER_ERRORMSG_ERROMSG_H_

#include <iostream>
#include <sstream>
#include <string>

#include "tiger/absyn/absyn.h"

namespace err {

class ErrorMsg {
public:
  explicit ErrorMsg() {}

  /**
   * Output an error message with C-style format string.
   *
   * @param pos The position where the error should be reported.
   *
   * @param fmt C-style format for error message. A newline character is
   * automatically appended.
   */
  // REVIEW: Should we migrate to C++ 20 @c std::format?
  template <typename... Args>
  void Error(const absyn::location_t &loc, const std::string &fmt,
             Args &&...args) {
    this->any_errors_ = true;

    std::ostringstream oss {};
    oss << loc;
    int sz = 0; // the length of the constructed error message
    std::string rel_fmt = "%s: " + fmt + '\n';
    sz = std::snprintf(nullptr, 0, rel_fmt.c_str(), oss.str().c_str(), args...);
    std::vector<char> buf(sz + 1);
    std::sprintf(buf.data(), rel_fmt.c_str(), oss.str().c_str(), args...);

    std::cerr << buf.data();
  }

  /**
   * Getter for `any_errors`
   */
  [[nodiscard]] bool AnyErrors() const { return any_errors_; }

private:
  bool any_errors_ = false; // flag indicating if any error occurrs
};
} // namespace err

#endif // TIGER_ERRORMSG_ERROMSG_H_
