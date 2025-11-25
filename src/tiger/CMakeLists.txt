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

# Find LLVM library
find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})

llvm_map_components_to_libnames(llvm_libs support core irreader)

include_directories(${PROJECT_SOURCE_DIR}/src)

# lab 2
add_executable(test_lex main/test_lex.cc
  symbol/symbol.cc
  absyn/absyn.cc
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Scanner_OUTPUTS})
target_compile_definitions(test_lex PUBLIC TIGER_NO_BACKEND)
set_target_properties(test_lex PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

# lab 3
add_executable(test_parse main/test_parse.cc
  symbol/symbol.cc
  absyn/absyn.cc
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Scanner_OUTPUTS})
target_compile_definitions(test_parse PUBLIC TIGER_NO_BACKEND)
set_target_properties(test_parse PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

# lab 4
add_executable(test_semant main/test_semant.cc
  symbol/symbol.cc
  absyn/absyn.cc
  env/env.cc
  semant/types.cc
  semant/semant.cc
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Scanner_OUTPUTS})
target_link_libraries(test_semant ${llvm_libs})
set_target_properties(test_semant PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

# lab5 part 1
add_executable(test_escape_analysis main/test_escape_analysis.cc
  symbol/symbol.cc
  absyn/absyn.cc
  env/env.cc
  semant/types.cc
  semant/semant.cc
  escape/escape.cc
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Scanner_OUTPUTS})
target_compile_definitions(test_escape_analysis PUBLIC TIGER_LAB5_1)
target_link_libraries(test_escape_analysis ${llvm_libs})
set_target_properties(test_escape_analysis PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

add_library(TigerInstSelectPass SHARED llvm-pass/pass.cc)
set_target_properties(TigerInstSelectPass PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

# lab 5 part 2
add_executable(test_translate main/test_translate.cc
  symbol/symbol.cc
  absyn/absyn.cc
  env/env.cc
  semant/types.cc
  semant/semant.cc
  escape/escape.cc
  translate/translate.cc
  frame/x64frame.cc
  frame/temp.cc
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Scanner_OUTPUTS})
target_compile_definitions(test_translate PUBLIC TIGER_LAB5)
target_link_libraries(test_translate ${llvm_libs})
set_target_properties(test_translate PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
