#!/usr/bin/env bash

WORKDIR=$(dirname "$(dirname "$(readlink -f "$0")")")

error_printf() {
  local fmt="$1"
  shift
  # shellcheck disable=SC2059
  printf "\033[31m$fmt\033[0m" "$@" >&2
}

output_score() {
  # output_score <lab> <score>
  if (( "$2" == 100 )); then
    printf "\033[1;32m"
    printf "[^_^]: Pass\n"
  else
    printf "\033[1;31m"
  fi
  printf "LAB %s SCORE: %d\n" "$1" "$2"
  printf "\033[0m"
}

build() {
  build_target=$1
  cd "$WORKDIR" || exit 1
  cmake -S . -B build >/dev/null && cd build && cmake --build . --target "$build_target" -j >/dev/null
  if [[ $? != 0 ]]; then
    error_printf "Error: fail to build %s! Try to build it manually to see verbose error message.\n" "$build_target"
    exit 1
  fi
}

test_lab1() {
  local test_num=$(((RANDOM % 2)))
  local ref_dir=${WORKDIR}/testdata/lab1/refs
  local ref=${ref_dir}/ref-${test_num}.txt

  build test_slp
  ./test_slp $test_num >&/tmp/output.txt
  diff -w /tmp/output.txt "${ref}"
  if [[ $? != 0 ]]; then
    echo "Error: Output mismatch"
    output_score 1 0
    exit 1
  fi

  output_score 1 100
}

test_lab2() {
  local testcase_dir=${WORKDIR}/testdata/lab2/testcases
  local ref_dir=${WORKDIR}/testdata/lab2/refs
  local testcase_name

  build test_lex
  for testcase in "$testcase_dir"/*.tig; do
    testcase_name=$(basename "$testcase" | cut -f1 -d".")
    local ref=${ref_dir}/${testcase_name}.out

    ./test_lex "$testcase" >&/tmp/output.txt
    diff /tmp/output.txt "${ref}"
    if [[ $? != 0 ]]; then
      error_printf "Fail to pass testcase \`%s'!\n" "$testcase_name"
      output_score 2 0
      exit 1
    fi
  done

  output_score 2 100
}

test_lab3() {
  local testcase_dir=${WORKDIR}/testdata/lab3/testcases
  local ref_dir=${WORKDIR}/testdata/lab3/refs
  local testcase_name

  build test_parse
  for testcase in "$testcase_dir"/*.tig; do
    testcase_name=$(basename "$testcase" | cut -f1 -d".")
    local ref=${ref_dir}/${testcase_name}.out

    ./test_parse "$testcase" >&/tmp/output.txt
    res_run=$?

    # Check result of the run
    if [[ $testcase_name == "test49" ]]; then
      # A negative testcase
      if [[ $res_run == 0 ]]; then
        error_printf "Error: This testcase should incur syntax error [$testcase_name]\n"
        output_score 3 0
        exit 1
      fi
      # Check output
      local error_message='test49.tig:5.18-20: syntax error'
      grep "$error_message" /tmp/output.txt >&/dev/null
      if [[ $? != 0 ]]; then
        error_printf "Error: Output mismatch [%s] (expect \`${error_message}' found)\n" "$testcase_name"
        output_score 3 0
        exit 1
      fi
    else
      # Positive testcases
      if [[ $res_run != 0 ]]; then
        error_printf "Error: This testcase should not incur syntax error [$testcase_name]\n"
        output_score 3 0
        exit 1
      fi

      # Check output
      diff /tmp/output.txt "${ref}"
      if [[ $? != 0 ]]; then
        error_printf "Error: Output mismatch [$testcase_name]\n"
        output_score 3 0
        exit 1
      fi
    fi
  done

  output_score 3 100
}

test_lab4() {
  local testcase_dir=${WORKDIR}/testdata/lab4/testcases
  local ref_dir=${WORKDIR}/testdata/lab4/refs
  local testcase_name

  build test_semant
  for testcase in "$testcase_dir"/*.tig; do
    testcase_name=$(basename "$testcase" | cut -f1 -d".")
    local ref=${ref_dir}/${testcase_name}.out

    ./test_semant "$testcase" >&/tmp/output.txt

    # Only check the error message part
    awk -F: '{ print substr($3, 2) }' "$ref" >/tmp/ref.txt
    while IFS= read -r line; do
      if ! grep -Fq -- "$line" /tmp/output.txt; then
        error_printf "[$testcase_name] Error: output not found \`%s'\n" "$line"
        output_score 4 0
        exit 1
      fi
    done </tmp/ref.txt
  done

  output_score 4 100
}

test_lab5_part1() {
  local testcase_dir=${WORKDIR}/testdata/lab5or6/testcases
  local ref_dir=${WORKDIR}/testdata/lab5or6/refs-part1
  local testcase_name

  build test_escape_analysis
  for testcase in "$testcase_dir"/*.tig; do
    testcase_name=$(basename "$testcase" | cut -f1 -d".")
    local ref=${ref_dir}/${testcase_name}.out

    ./test_escape_analysis "$testcase" >&/tmp/output.txt

    if ! diff /tmp/output.txt "${ref}"; then
      error_printf "Fail to pass testcase \`%s'!\n" "$testcase_name"
      output_score "5 (PART 1)" 0
      exit 1
    fi
  done
  output_score "5 (PART 1)" 100
}

main() {
  local scope=$1

  if [[ ! $(pwd) == "$WORKDIR" ]]; then
    echo "Error: Please run this grading script in the root dir of the project"
    exit 1
  fi

  if [[ ! $(uname -s) == "Linux" ]]; then
    echo "Error: Please run this grading script in a Linux system"
    exit 1
  fi

  if [[ $scope == "lab1" ]]; then
    echo "========== Lab1 Test =========="
    test_lab1
  elif [[ $scope == "lab2" ]]; then
    echo "========== Lab2 Test =========="
    test_lab2
  elif [[ $scope == "lab3" ]]; then
    echo "========== Lab3 Test =========="
    test_lab3
  elif [[ $scope == "lab4" ]]; then
    echo "========== Lab4 Test =========="
    test_lab4
  elif [[ $scope == "lab5-part1" ]]; then
    echo "========== Lab5 part-1 Test =========="
    test_lab5_part1
  elif [[ $scope == "lab5" ]]; then
    echo "========== Lab5 Test =========="
    test_lab5
  elif [[ $scope == "lab6" ]]; then
    echo "========== Lab6 Test =========="
    test_lab6
  elif [[ $scope == "all" ]]; then
    echo "========== Lab1 Test =========="
    test_lab1
    echo "========== Lab2 Test =========="
    test_lab2
    echo "========== Lab3 Test =========="
    test_lab3
    echo "========== Lab4 Test =========="
    test_lab4
    echo "========== Lab5 part-1 Test =========="
    test_lab5_part1
    echo "========== Lab5 Test =========="
    test_lab5
    echo "========== Lab6 Test =========="
    test_lab6
  else
    echo "Wrong test scope: Please specify the part you want to test"
    echo -e "\tscripts/grade.sh [lab1|lab2|lab3|lab4|lab5-part1|lab5|lab6|all]"
    echo -e "or"
    echo -e "\tmake [gradelab1|gradelab2|gradelab3|gradelab4|gradelab5|gradelab5-1|gradelab6|gradeall]"
  fi
}

main "$1"
