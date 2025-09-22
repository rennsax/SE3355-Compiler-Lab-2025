#include <iomanip>
#include "tiger/frontend/driver.h"

int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "usage: %s filename\n", argv[0]);
    exit(1);
  }

  err::ErrorMsg errormsg {};

  auto driver = std::make_unique<TigerFrontendDriver>(argv[1], errormsg);
  driver->scan_begin();

  using SKind = TigerFrontendDriver::SKind;

  for (;;) {
    try {
      auto token = driver->lex();
      if (token.kind() == SKind::S_YYEOF) {
        break;
      }

      // Print the token kind and the beginning position.
      auto pos = token.location.begin;
      std::cout << std::right << std::setw(10) << token.name()
                << std::right << std::setw(5) << pos.line << ':'
                << std::left << std::setw(5) << pos.column;

      // Print the semantic value.
      std::cout << std::left;
      switch (token.kind()) {
      case SKind::S_ID:
        std::cout << ' ' << token.value.as<sym::Symbol*>()->Name();
        break;
      case SKind::S_INT:
        std::cout << ' ' << token.value.as<int>();
        break;
      case SKind::S_STRING: {
        auto str_content = token.value.as<std::string>();
        std::cout << ' ' << (str_content.empty() ? "(null)" : str_content);
        break;
      }
      default:
        break;
      }

      std::cout << '\n';

    } catch (TigerFrontendDriver::syntax_error &ex) {
      std::cerr << ex.what() << std::endl;
      break;
    }
  }

  driver->scan_end();
  return 0;
}
