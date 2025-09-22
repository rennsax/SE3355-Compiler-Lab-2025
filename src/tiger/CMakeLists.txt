# Generated sources

# Bison and Flex targets
# flex: https://westes.github.io/flex/manual/
# bison: https://www.gnu.org/software/bison/manual/html_node/index.html

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

make_directory(${CMAKE_CURRENT_BINARY_DIR}/frontend)
flex_target(Scanner frontend/scanner.lex ${CMAKE_CURRENT_BINARY_DIR}/frontend/scanner.cc)
bison_target(Parser frontend/parser.y ${CMAKE_CURRENT_BINARY_DIR}/frontend/parser.cc)
add_flex_bison_dependency(Scanner Parser)

include_directories(${CMAKE_CURRENT_BINARY_DIR}/frontend)

include_directories(${PROJECT_SOURCE_DIR}/src)

# lab 2
add_executable(test_lex main/test_lex.cc
  symbol/symbol.cc
  absyn/absyn.cc
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Scanner_OUTPUTS})
target_compile_definitions(test_lex PUBLIC TIGER_NO_BACKEND)
set_target_properties(test_lex PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
