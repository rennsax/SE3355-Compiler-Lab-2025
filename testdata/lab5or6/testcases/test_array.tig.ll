; ModuleID = 'lightir'
source_filename = "lightir"
target triple = "x86_64-pc-linux-gnu"

%string = type { i32, i8* }
%MyStruct = type { i32, i32 }

@tigermain_framesize_global = constant i64 48
@0 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@str = constant %string { i32 1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @0, i32 0, i32 0) }

declare void @flush()

declare void @exit(i32)

declare %string* @chr(i32)

declare %string* @__wrap_getchar()

declare void @print(%string*)

declare void @printi(i32)

declare i32 @ord(%string*)

declare i32 @size(%string*)

declare %string* @concat(%string*, %string*)

declare %string* @substring(%string*, i32, i32)

declare i64 @alloc_record(i32)

declare i64 @init_array(i32, i64)

declare i1 @string_equal(%string*, %string*)

define i32 @tigermain(i64 %0, i64 %1) {
tigermain:
  %2 = load i64, i64* @tigermain_framesize_global, align 4
  %tigermain_sp = sub i64 %0, %2
  %3 = load i64, i64* @tigermain_framesize_global, align 4
  %4 = add i64 %3, -8
  %5 = add i64 %tigermain_sp, %4
  %6 = inttoptr i64 %5 to i32*
  store i32 8, i32* %6, align 4
  %7 = load i64, i64* @tigermain_framesize_global, align 4
  %8 = add i64 %7, -8
  %9 = add i64 %tigermain_sp, %8
  %tigermain_N_ptr = inttoptr i64 %9 to i32*
  %10 = load i32, i32* %tigermain_N_ptr, align 4
  %11 = call i64 @init_array(i32 %10, i64 ptrtoint (%string* @str to i64))
  %12 = inttoptr i64 %11 to i64*
  %13 = ptrtoint i64* %12 to i64
  %14 = load i64, i64* @tigermain_framesize_global, align 4
  %15 = add i64 %14, -16
  %16 = add i64 %tigermain_sp, %15
  %17 = inttoptr i64 %16 to i64*
  store i64 %13, i64* %17, align 4
  %18 = load i64, i64* @tigermain_framesize_global, align 4
  %19 = add i64 %18, -8
  %20 = add i64 %tigermain_sp, %19
  %tigermain_N_ptr1 = inttoptr i64 %20 to i32*
  %21 = call i64 @alloc_record(i32 16)
  %22 = inttoptr i64 %21 to %MyStruct*
  %23 = getelementptr %MyStruct, %MyStruct* %22, i32 0, i32 0
  store i32 1, i32* %23, align 4
  %24 = getelementptr %MyStruct, %MyStruct* %22, i32 0, i32 1
  store i32 2, i32* %24, align 4
  %25 = load i32, i32* %tigermain_N_ptr1, align 4
  %26 = ptrtoint %MyStruct* %22 to i64
  %27 = call i64 @init_array(i32 %25, i64 %26)
  %28 = inttoptr i64 %27 to i64*
  %29 = ptrtoint i64* %28 to i64
  %30 = load i64, i64* @tigermain_framesize_global, align 4
  %31 = add i64 %30, -24
  %32 = add i64 %tigermain_sp, %31
  %33 = inttoptr i64 %32 to i64*
  store i64 %29, i64* %33, align 4
  %34 = load i64, i64* @tigermain_framesize_global, align 4
  %35 = add i64 %34, -16
  %36 = add i64 %tigermain_sp, %35
  %tigermain_row_ptr = inttoptr i64 %36 to %string***
  %37 = load %string**, %string*** %tigermain_row_ptr, align 8
  %38 = getelementptr %string*, %string** %37, i32 0
  %actual_parm = load %string*, %string** %38, align 8
  call void @print(%string* %actual_parm)
  %39 = load i64, i64* @tigermain_framesize_global, align 4
  %40 = add i64 %39, -24
  %41 = add i64 %tigermain_sp, %40
  %tigermain_x_ptr = inttoptr i64 %41 to %MyStruct***
  %42 = load %MyStruct**, %MyStruct*** %tigermain_x_ptr, align 8
  %43 = getelementptr %MyStruct*, %MyStruct** %42, i32 0
  %44 = load %MyStruct*, %MyStruct** %43, align 8
  %45 = getelementptr %MyStruct, %MyStruct* %44, i32 0, i32 0
  %actual_parm2 = load i32, i32* %45, align 4
  call void @printi(i32 %actual_parm2)
  %46 = load i64, i64* @tigermain_framesize_global, align 4
  %47 = add i64 %46, -24
  %48 = add i64 %tigermain_sp, %47
  %tigermain_x_ptr3 = inttoptr i64 %48 to %MyStruct***
  %49 = load %MyStruct**, %MyStruct*** %tigermain_x_ptr3, align 8
  %50 = getelementptr %MyStruct*, %MyStruct** %49, i32 1
  %51 = load %MyStruct*, %MyStruct** %50, align 8
  %52 = getelementptr %MyStruct, %MyStruct* %51, i32 0, i32 1
  %actual_parm4 = load i32, i32* %52, align 4
  call void @printi(i32 %actual_parm4)
  ret i32 0
}

; ===== Frame Information =====
; tigermain -24 48
