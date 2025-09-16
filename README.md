# Lab 1: Straight-line Program Interpreter

## Introduction

In this lab, you need to implement a dead-simple program analyzer and interpreter for the straight-line programming language. This exercise serves as an introduction to environments (symbol tables mapping variable-names to information about the variables); to abstract syntax (data structures representing the phrase structure of programs); to recursion over tree data structures, useful in many parts of a compiler; and to a functional style of programming without assignment statements.

It also serves as a “warm-up” exercise in C programming. Programmers experienced in other languages but new to C++ should be able to do this exercise, but will need supplementary material on C++.

Also, it's the best chance for you to test your development environment while working with the first lab. You can get yourself familiar with our build system and project structure (even the grading script), which will save you more time in the future.

## Requirements

In this lab, you should modify the file `slp.{h,cc}`. We have already given some hints for you in the comments.

Notice: Before you start this lab, you should carefully read the chapter 1 of the textbook. And if you have any question about this lab, feel free to contact TA.

## Development Environment

We have provided the guidance to build the development environment with Docker. See [our official website](http://ipads.se.sjtu.edu.cn/courses/compilers/labs/Environment.html).

You can also inspect the dependencies in the [Dockerfile](./Dockerfile) and configure your local environment.

## Test the Lab

Use `make`
```bash
make gradelab1
```
or run the script manually
```bash
./scripts/grade.sh lab1 # e.g. `./scripts/grade.sh lab1`
```

## Submit

You should get 100 point with the grading script, and push your answer to the `lab1` branch of your GitLab repository.

Note: Remember to keep your Git history clean and readable. Your commit history may serve as one of the references for grading.

## Formatting Your Codes

We provide an LLVM-style .clang-format file in the project directory. You can use it to format your code.

Use `clang-format` command:
```
find . \( -name "*.h" -o -iname "*.cc" \) | xargs clang-format -i -style=file  # or make format
```

or config the clang-format file in your IDE and use the built-in format feature in it.
