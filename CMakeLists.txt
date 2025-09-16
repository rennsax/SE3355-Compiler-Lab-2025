cmake_minimum_required(VERSION 3.10)

project(tiger-compiler)

if ("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
    message(FATAL_ERROR "In-source builds are not allowed.")
endif ()

set(CMAKE_CXX_STANDARD 17)

# lab 1
add_subdirectory(src/straightline)
