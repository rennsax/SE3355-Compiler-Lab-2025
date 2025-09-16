set(SLP_SOURCES slp.cc prog1.cc test_slp.cc)

add_executable(test_slp ${SLP_SOURCES})
set_target_properties(test_slp PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
