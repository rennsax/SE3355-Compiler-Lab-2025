; ModuleID = 'lightir'
source_filename = "lightir"
target triple = "x86_64-pc-linux-gnu"

%string = type { i32, i8* }
%MyStruct = type { i32, %MyStruct*, %MyStruct* }

@tigermain_framesize_global = constant i64 48
@insert_framesize_global = constant i64 32
@printint_framesize_global = constant i64 24
@f_framesize_global = constant i64 24
@0 = private unnamed_addr constant [2 x i8] c"0\00", align 1
@str = constant %string { i32 1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @0, i32 0, i32 0) }
@1 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@str.1 = constant %string { i32 1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @1, i32 0, i32 0) }
@2 = private unnamed_addr constant [2 x i8] c"0\00", align 1
@str.2 = constant %string { i32 1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @2, i32 0, i32 0) }
@3 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@str.3 = constant %string { i32 1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @3, i32 0, i32 0) }
@printtree_framesize_global = constant i64 24
@getnode_framesize_global = constant i64 16

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
  %6 = inttoptr i64 %5 to i64*
  store i64 0, i64* %6, align 4
  %7 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 25)
  %8 = ptrtoint %MyStruct* %7 to i64
  %9 = load i64, i64* @tigermain_framesize_global, align 4
  %10 = add i64 %9, -16
  %11 = add i64 %tigermain_sp, %10
  %12 = inttoptr i64 %11 to i64*
  store i64 %8, i64* %12, align 4
  %13 = load i64, i64* @tigermain_framesize_global, align 4
  %14 = add i64 %13, -8
  %15 = add i64 %tigermain_sp, %14
  %tigermain_root_ptr = inttoptr i64 %15 to %MyStruct**
  %16 = load i64, i64* @tigermain_framesize_global, align 4
  %17 = add i64 %16, -8
  %18 = add i64 %tigermain_sp, %17
  %tigermain_root_ptr1 = inttoptr i64 %18 to %MyStruct**
  %actual_parm = load %MyStruct*, %MyStruct** %tigermain_root_ptr1, align 8
  %19 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 50)
  %20 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm, %MyStruct* %19)
  store %MyStruct* %20, %MyStruct** %tigermain_root_ptr, align 8
  %21 = load i64, i64* @tigermain_framesize_global, align 4
  %22 = add i64 %21, -8
  %23 = add i64 %tigermain_sp, %22
  %tigermain_root_ptr2 = inttoptr i64 %23 to %MyStruct**
  %24 = load i64, i64* @tigermain_framesize_global, align 4
  %25 = add i64 %24, -8
  %26 = add i64 %tigermain_sp, %25
  %tigermain_root_ptr3 = inttoptr i64 %26 to %MyStruct**
  %actual_parm4 = load %MyStruct*, %MyStruct** %tigermain_root_ptr3, align 8
  %27 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 75)
  %28 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm4, %MyStruct* %27)
  store %MyStruct* %28, %MyStruct** %tigermain_root_ptr2, align 8
  %29 = load i64, i64* @tigermain_framesize_global, align 4
  %30 = add i64 %29, -16
  %31 = add i64 %tigermain_sp, %30
  %tigermain_node25_ptr = inttoptr i64 %31 to %MyStruct**
  %32 = load i64, i64* @tigermain_framesize_global, align 4
  %33 = add i64 %32, -16
  %34 = add i64 %tigermain_sp, %33
  %tigermain_node25_ptr5 = inttoptr i64 %34 to %MyStruct**
  %actual_parm6 = load %MyStruct*, %MyStruct** %tigermain_node25_ptr5, align 8
  %35 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 5)
  %36 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm6, %MyStruct* %35)
  store %MyStruct* %36, %MyStruct** %tigermain_node25_ptr, align 8
  %37 = load i64, i64* @tigermain_framesize_global, align 4
  %38 = add i64 %37, -16
  %39 = add i64 %tigermain_sp, %38
  %tigermain_node25_ptr7 = inttoptr i64 %39 to %MyStruct**
  %40 = load i64, i64* @tigermain_framesize_global, align 4
  %41 = add i64 %40, -16
  %42 = add i64 %tigermain_sp, %41
  %tigermain_node25_ptr8 = inttoptr i64 %42 to %MyStruct**
  %actual_parm9 = load %MyStruct*, %MyStruct** %tigermain_node25_ptr8, align 8
  %43 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 40)
  %44 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm9, %MyStruct* %43)
  store %MyStruct* %44, %MyStruct** %tigermain_node25_ptr7, align 8
  %45 = load i64, i64* @tigermain_framesize_global, align 4
  %46 = add i64 %45, -8
  %47 = add i64 %tigermain_sp, %46
  %tigermain_root_ptr10 = inttoptr i64 %47 to %MyStruct**
  %48 = load i64, i64* @tigermain_framesize_global, align 4
  %49 = add i64 %48, -8
  %50 = add i64 %tigermain_sp, %49
  %tigermain_root_ptr11 = inttoptr i64 %50 to %MyStruct**
  %actual_parm12 = load %MyStruct*, %MyStruct** %tigermain_root_ptr11, align 8
  %51 = load i64, i64* @tigermain_framesize_global, align 4
  %52 = add i64 %51, -16
  %53 = add i64 %tigermain_sp, %52
  %tigermain_node25_ptr13 = inttoptr i64 %53 to %MyStruct**
  %actual_parm14 = load %MyStruct*, %MyStruct** %tigermain_node25_ptr13, align 8
  %54 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm12, %MyStruct* %actual_parm14)
  store %MyStruct* %54, %MyStruct** %tigermain_root_ptr10, align 8
  %55 = load i64, i64* @tigermain_framesize_global, align 4
  %56 = add i64 %55, -8
  %57 = add i64 %tigermain_sp, %56
  %tigermain_root_ptr15 = inttoptr i64 %57 to %MyStruct**
  %58 = load i64, i64* @tigermain_framesize_global, align 4
  %59 = add i64 %58, -8
  %60 = add i64 %tigermain_sp, %59
  %tigermain_root_ptr16 = inttoptr i64 %60 to %MyStruct**
  %actual_parm17 = load %MyStruct*, %MyStruct** %tigermain_root_ptr16, align 8
  %61 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 80)
  %62 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm17, %MyStruct* %61)
  store %MyStruct* %62, %MyStruct** %tigermain_root_ptr15, align 8
  %63 = load i64, i64* @tigermain_framesize_global, align 4
  %64 = add i64 %63, -8
  %65 = add i64 %tigermain_sp, %64
  %tigermain_root_ptr18 = inttoptr i64 %65 to %MyStruct**
  %66 = load i64, i64* @tigermain_framesize_global, align 4
  %67 = add i64 %66, -8
  %68 = add i64 %tigermain_sp, %67
  %tigermain_root_ptr19 = inttoptr i64 %68 to %MyStruct**
  %actual_parm20 = load %MyStruct*, %MyStruct** %tigermain_root_ptr19, align 8
  %69 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 60)
  %70 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm20, %MyStruct* %69)
  store %MyStruct* %70, %MyStruct** %tigermain_root_ptr18, align 8
  %71 = load i64, i64* @tigermain_framesize_global, align 4
  %72 = add i64 %71, -8
  %73 = add i64 %tigermain_sp, %72
  %tigermain_root_ptr21 = inttoptr i64 %73 to %MyStruct**
  %74 = load i64, i64* @tigermain_framesize_global, align 4
  %75 = add i64 %74, -8
  %76 = add i64 %tigermain_sp, %75
  %tigermain_root_ptr22 = inttoptr i64 %76 to %MyStruct**
  %actual_parm23 = load %MyStruct*, %MyStruct** %tigermain_root_ptr22, align 8
  %77 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 55)
  %78 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm23, %MyStruct* %77)
  store %MyStruct* %78, %MyStruct** %tigermain_root_ptr21, align 8
  %79 = load i64, i64* @tigermain_framesize_global, align 4
  %80 = add i64 %79, -8
  %81 = add i64 %tigermain_sp, %80
  %tigermain_root_ptr24 = inttoptr i64 %81 to %MyStruct**
  %82 = load i64, i64* @tigermain_framesize_global, align 4
  %83 = add i64 %82, -8
  %84 = add i64 %tigermain_sp, %83
  %tigermain_root_ptr25 = inttoptr i64 %84 to %MyStruct**
  %actual_parm26 = load %MyStruct*, %MyStruct** %tigermain_root_ptr25, align 8
  %85 = call %MyStruct* @getnode(i64 %tigermain_sp, i64 %tigermain_sp, i32 33)
  %86 = call %MyStruct* @insert(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm26, %MyStruct* %85)
  store %MyStruct* %86, %MyStruct** %tigermain_root_ptr24, align 8
  %87 = load i64, i64* @tigermain_framesize_global, align 4
  %88 = add i64 %87, -8
  %89 = add i64 %tigermain_sp, %88
  %tigermain_root_ptr27 = inttoptr i64 %89 to %MyStruct**
  %actual_parm28 = load %MyStruct*, %MyStruct** %tigermain_root_ptr27, align 8
  call void @printtree(i64 %tigermain_sp, i64 %tigermain_sp, %MyStruct* %actual_parm28)
  ret i32 0
}

define %MyStruct* @insert(i64 %0, i64 %1, %MyStruct* %2, %MyStruct* %3) {
insert:
  %insert_local_framesize = load i64, i64* @insert_framesize_global, align 4
  %insert_sp = sub i64 %0, %insert_local_framesize
  %4 = load i64, i64* @insert_framesize_global, align 4
  %5 = add i64 %4, 8
  %6 = add i64 %insert_sp, %5
  %sl_ptr = inttoptr i64 %6 to i64*
  store i64 %1, i64* %sl_ptr, align 4
  %7 = load i64, i64* @insert_framesize_global, align 4
  %8 = add i64 %7, 16
  %9 = add i64 %insert_sp, %8
  %10 = inttoptr i64 %9 to %MyStruct**
  store %MyStruct* %2, %MyStruct** %10, align 8
  %11 = load i64, i64* @insert_framesize_global, align 4
  %12 = add i64 %11, 24
  %13 = add i64 %insert_sp, %12
  %14 = inttoptr i64 %13 to %MyStruct**
  store %MyStruct* %3, %MyStruct** %14, align 8
  br label %if_test

if_test:                                          ; preds = %insert
  %15 = load i64, i64* @insert_framesize_global, align 4
  %16 = add i64 %15, 16
  %17 = add i64 %insert_sp, %16
  %insert_t1_ptr = inttoptr i64 %17 to %MyStruct**
  %18 = load %MyStruct*, %MyStruct** %insert_t1_ptr, align 8
  %19 = ptrtoint %MyStruct* %18 to i64
  %20 = icmp eq i64 %19, 0
  br i1 %20, label %if_then, label %if_else

if_then:                                          ; preds = %if_test
  %21 = load i64, i64* @insert_framesize_global, align 4
  %22 = add i64 %21, 24
  %23 = add i64 %insert_sp, %22
  %insert_t2_ptr = inttoptr i64 %23 to %MyStruct**
  %24 = load %MyStruct*, %MyStruct** %insert_t2_ptr, align 8
  br label %if_next

if_else:                                          ; preds = %if_test
  br label %if_test1

if_next:                                          ; preds = %if_next4, %if_then
  %25 = phi %MyStruct* [ %24, %if_then ], [ %101, %if_next4 ]
  ret %MyStruct* %25

if_test1:                                         ; preds = %if_else
  %26 = load i64, i64* @insert_framesize_global, align 4
  %27 = add i64 %26, 16
  %28 = add i64 %insert_sp, %27
  %insert_t1_ptr5 = inttoptr i64 %28 to %MyStruct**
  %29 = load %MyStruct*, %MyStruct** %insert_t1_ptr5, align 8
  %30 = getelementptr %MyStruct, %MyStruct* %29, i32 0, i32 0
  %31 = load i64, i64* @insert_framesize_global, align 4
  %32 = add i64 %31, 24
  %33 = add i64 %insert_sp, %32
  %insert_t2_ptr6 = inttoptr i64 %33 to %MyStruct**
  %34 = load %MyStruct*, %MyStruct** %insert_t2_ptr6, align 8
  %35 = getelementptr %MyStruct, %MyStruct* %34, i32 0, i32 0
  %36 = load i32, i32* %30, align 4
  %37 = load i32, i32* %35, align 4
  %38 = icmp sgt i32 %36, %37
  br i1 %38, label %if_then2, label %if_else3

if_then2:                                         ; preds = %if_test1
  %39 = call i64 @alloc_record(i32 24)
  %40 = inttoptr i64 %39 to %MyStruct*
  %41 = load i64, i64* @insert_framesize_global, align 4
  %42 = add i64 %41, 16
  %43 = add i64 %insert_sp, %42
  %insert_t1_ptr7 = inttoptr i64 %43 to %MyStruct**
  %44 = load %MyStruct*, %MyStruct** %insert_t1_ptr7, align 8
  %45 = getelementptr %MyStruct, %MyStruct* %44, i32 0, i32 0
  %46 = getelementptr %MyStruct, %MyStruct* %40, i32 0, i32 0
  %47 = load i32, i32* %45, align 4
  store i32 %47, i32* %46, align 4
  %48 = load i64, i64* @insert_framesize_global, align 4
  %49 = add i64 %48, 16
  %50 = add i64 %insert_sp, %49
  %insert_t1_ptr8 = inttoptr i64 %50 to %MyStruct**
  %51 = load %MyStruct*, %MyStruct** %insert_t1_ptr8, align 8
  %52 = getelementptr %MyStruct, %MyStruct* %51, i32 0, i32 1
  %actual_parm = load %MyStruct*, %MyStruct** %52, align 8
  %53 = load i64, i64* @insert_framesize_global, align 4
  %54 = add i64 %53, 24
  %55 = add i64 %insert_sp, %54
  %insert_t2_ptr9 = inttoptr i64 %55 to %MyStruct**
  %actual_parm10 = load %MyStruct*, %MyStruct** %insert_t2_ptr9, align 8
  %56 = load i64, i64* @insert_framesize_global, align 4
  %57 = add i64 %56, 8
  %58 = add i64 %insert_sp, %57
  %59 = inttoptr i64 %58 to i64*
  %60 = load i64, i64* %59, align 4
  %61 = call %MyStruct* @insert(i64 %insert_sp, i64 %60, %MyStruct* %actual_parm, %MyStruct* %actual_parm10)
  %62 = getelementptr %MyStruct, %MyStruct* %40, i32 0, i32 1
  store %MyStruct* %61, %MyStruct** %62, align 8
  %63 = load i64, i64* @insert_framesize_global, align 4
  %64 = add i64 %63, 16
  %65 = add i64 %insert_sp, %64
  %insert_t1_ptr11 = inttoptr i64 %65 to %MyStruct**
  %66 = load %MyStruct*, %MyStruct** %insert_t1_ptr11, align 8
  %67 = getelementptr %MyStruct, %MyStruct* %66, i32 0, i32 2
  %68 = getelementptr %MyStruct, %MyStruct* %40, i32 0, i32 2
  %69 = load %MyStruct*, %MyStruct** %67, align 8
  store %MyStruct* %69, %MyStruct** %68, align 8
  br label %if_next4

if_else3:                                         ; preds = %if_test1
  %70 = call i64 @alloc_record(i32 24)
  %71 = inttoptr i64 %70 to %MyStruct*
  %72 = load i64, i64* @insert_framesize_global, align 4
  %73 = add i64 %72, 16
  %74 = add i64 %insert_sp, %73
  %insert_t1_ptr12 = inttoptr i64 %74 to %MyStruct**
  %75 = load %MyStruct*, %MyStruct** %insert_t1_ptr12, align 8
  %76 = getelementptr %MyStruct, %MyStruct* %75, i32 0, i32 0
  %77 = getelementptr %MyStruct, %MyStruct* %71, i32 0, i32 0
  %78 = load i32, i32* %76, align 4
  store i32 %78, i32* %77, align 4
  %79 = load i64, i64* @insert_framesize_global, align 4
  %80 = add i64 %79, 16
  %81 = add i64 %insert_sp, %80
  %insert_t1_ptr13 = inttoptr i64 %81 to %MyStruct**
  %82 = load %MyStruct*, %MyStruct** %insert_t1_ptr13, align 8
  %83 = getelementptr %MyStruct, %MyStruct* %82, i32 0, i32 1
  %84 = getelementptr %MyStruct, %MyStruct* %71, i32 0, i32 1
  %85 = load %MyStruct*, %MyStruct** %83, align 8
  store %MyStruct* %85, %MyStruct** %84, align 8
  %86 = load i64, i64* @insert_framesize_global, align 4
  %87 = add i64 %86, 16
  %88 = add i64 %insert_sp, %87
  %insert_t1_ptr14 = inttoptr i64 %88 to %MyStruct**
  %89 = load %MyStruct*, %MyStruct** %insert_t1_ptr14, align 8
  %90 = getelementptr %MyStruct, %MyStruct* %89, i32 0, i32 2
  %actual_parm15 = load %MyStruct*, %MyStruct** %90, align 8
  %91 = load i64, i64* @insert_framesize_global, align 4
  %92 = add i64 %91, 24
  %93 = add i64 %insert_sp, %92
  %insert_t2_ptr16 = inttoptr i64 %93 to %MyStruct**
  %actual_parm17 = load %MyStruct*, %MyStruct** %insert_t2_ptr16, align 8
  %94 = load i64, i64* @insert_framesize_global, align 4
  %95 = add i64 %94, 8
  %96 = add i64 %insert_sp, %95
  %97 = inttoptr i64 %96 to i64*
  %98 = load i64, i64* %97, align 4
  %99 = call %MyStruct* @insert(i64 %insert_sp, i64 %98, %MyStruct* %actual_parm15, %MyStruct* %actual_parm17)
  %100 = getelementptr %MyStruct, %MyStruct* %71, i32 0, i32 2
  store %MyStruct* %99, %MyStruct** %100, align 8
  br label %if_next4

if_next4:                                         ; preds = %if_else3, %if_then2
  %101 = phi %MyStruct* [ %40, %if_then2 ], [ %71, %if_else3 ]
  br label %if_next
}

define void @printint(i64 %0, i64 %1, i32 %2) {
printint:
  %printint_local_framesize = load i64, i64* @printint_framesize_global, align 4
  %printint_sp = sub i64 %0, %printint_local_framesize
  %3 = load i64, i64* @printint_framesize_global, align 4
  %4 = add i64 %3, 8
  %5 = add i64 %printint_sp, %4
  %sl_ptr = inttoptr i64 %5 to i64*
  store i64 %1, i64* %sl_ptr, align 4
  %6 = load i64, i64* @printint_framesize_global, align 4
  %7 = add i64 %6, 16
  %8 = add i64 %printint_sp, %7
  %9 = inttoptr i64 %8 to i32*
  store i32 %2, i32* %9, align 4
  br label %if_test

if_test:                                          ; preds = %printint
  %10 = load i64, i64* @printint_framesize_global, align 4
  %11 = add i64 %10, 16
  %12 = add i64 %printint_sp, %11
  %printint_i_ptr = inttoptr i64 %12 to i32*
  %13 = load i32, i32* %printint_i_ptr, align 4
  %14 = icmp slt i32 %13, 0
  br i1 %14, label %if_then, label %if_else

if_then:                                          ; preds = %if_test
  call void @print(%string* @str.1)
  %15 = load i64, i64* @printint_framesize_global, align 4
  %16 = add i64 %15, 16
  %17 = add i64 %printint_sp, %16
  %printint_i_ptr1 = inttoptr i64 %17 to i32*
  %18 = load i32, i32* %printint_i_ptr1, align 4
  %19 = sub i32 0, %18
  call void @f(i64 %printint_sp, i64 %printint_sp, i32 %19)
  br label %if_next

if_else:                                          ; preds = %if_test
  br label %if_test2

if_next:                                          ; preds = %if_next5, %if_then
  call void @print(%string* @str.3)
  ret void

if_test2:                                         ; preds = %if_else
  %20 = load i64, i64* @printint_framesize_global, align 4
  %21 = add i64 %20, 16
  %22 = add i64 %printint_sp, %21
  %printint_i_ptr6 = inttoptr i64 %22 to i32*
  %23 = load i32, i32* %printint_i_ptr6, align 4
  %24 = icmp sgt i32 %23, 0
  br i1 %24, label %if_then3, label %if_else4

if_then3:                                         ; preds = %if_test2
  %25 = load i64, i64* @printint_framesize_global, align 4
  %26 = add i64 %25, 16
  %27 = add i64 %printint_sp, %26
  %printint_i_ptr7 = inttoptr i64 %27 to i32*
  %actual_parm = load i32, i32* %printint_i_ptr7, align 4
  call void @f(i64 %printint_sp, i64 %printint_sp, i32 %actual_parm)
  br label %if_next5

if_else4:                                         ; preds = %if_test2
  call void @print(%string* @str.2)
  br label %if_next5

if_next5:                                         ; preds = %if_else4, %if_then3
  br label %if_next
}

define void @printtree(i64 %0, i64 %1, %MyStruct* %2) {
printtree:
  %printtree_local_framesize = load i64, i64* @printtree_framesize_global, align 4
  %printtree_sp = sub i64 %0, %printtree_local_framesize
  %3 = load i64, i64* @printtree_framesize_global, align 4
  %4 = add i64 %3, 8
  %5 = add i64 %printtree_sp, %4
  %sl_ptr = inttoptr i64 %5 to i64*
  store i64 %1, i64* %sl_ptr, align 4
  %6 = load i64, i64* @printtree_framesize_global, align 4
  %7 = add i64 %6, 16
  %8 = add i64 %printtree_sp, %7
  %9 = inttoptr i64 %8 to %MyStruct**
  store %MyStruct* %2, %MyStruct** %9, align 8
  br label %if_test

if_test:                                          ; preds = %printtree
  %10 = load i64, i64* @printtree_framesize_global, align 4
  %11 = add i64 %10, 16
  %12 = add i64 %printtree_sp, %11
  %printtree_t_ptr = inttoptr i64 %12 to %MyStruct**
  %13 = load %MyStruct*, %MyStruct** %printtree_t_ptr, align 8
  %14 = ptrtoint %MyStruct* %13 to i64
  %15 = icmp ne i64 %14, 0
  br i1 %15, label %if_then, label %if_next

if_then:                                          ; preds = %if_test
  %16 = load i64, i64* @printtree_framesize_global, align 4
  %17 = add i64 %16, 16
  %18 = add i64 %printtree_sp, %17
  %printtree_t_ptr1 = inttoptr i64 %18 to %MyStruct**
  %19 = load %MyStruct*, %MyStruct** %printtree_t_ptr1, align 8
  %20 = getelementptr %MyStruct, %MyStruct* %19, i32 0, i32 1
  %actual_parm = load %MyStruct*, %MyStruct** %20, align 8
  %21 = load i64, i64* @printtree_framesize_global, align 4
  %22 = add i64 %21, 8
  %23 = add i64 %printtree_sp, %22
  %24 = inttoptr i64 %23 to i64*
  %25 = load i64, i64* %24, align 4
  call void @printtree(i64 %printtree_sp, i64 %25, %MyStruct* %actual_parm)
  %26 = load i64, i64* @printtree_framesize_global, align 4
  %27 = add i64 %26, 16
  %28 = add i64 %printtree_sp, %27
  %printtree_t_ptr2 = inttoptr i64 %28 to %MyStruct**
  %29 = load %MyStruct*, %MyStruct** %printtree_t_ptr2, align 8
  %30 = getelementptr %MyStruct, %MyStruct* %29, i32 0, i32 0
  %actual_parm3 = load i32, i32* %30, align 4
  %31 = load i64, i64* @printtree_framesize_global, align 4
  %32 = add i64 %31, 8
  %33 = add i64 %printtree_sp, %32
  %34 = inttoptr i64 %33 to i64*
  %35 = load i64, i64* %34, align 4
  call void @printint(i64 %printtree_sp, i64 %35, i32 %actual_parm3)
  %36 = load i64, i64* @printtree_framesize_global, align 4
  %37 = add i64 %36, 16
  %38 = add i64 %printtree_sp, %37
  %printtree_t_ptr4 = inttoptr i64 %38 to %MyStruct**
  %39 = load %MyStruct*, %MyStruct** %printtree_t_ptr4, align 8
  %40 = getelementptr %MyStruct, %MyStruct* %39, i32 0, i32 2
  %actual_parm5 = load %MyStruct*, %MyStruct** %40, align 8
  %41 = load i64, i64* @printtree_framesize_global, align 4
  %42 = add i64 %41, 8
  %43 = add i64 %printtree_sp, %42
  %44 = inttoptr i64 %43 to i64*
  %45 = load i64, i64* %44, align 4
  call void @printtree(i64 %printtree_sp, i64 %45, %MyStruct* %actual_parm5)
  br label %if_next

if_next:                                          ; preds = %if_then, %if_test
  ret void
}

define %MyStruct* @getnode(i64 %0, i64 %1, i32 %2) {
getnode:
  %getnode_local_framesize = load i64, i64* @getnode_framesize_global, align 4
  %getnode_sp = sub i64 %0, %getnode_local_framesize
  %3 = load i64, i64* @getnode_framesize_global, align 4
  %4 = add i64 %3, 8
  %5 = add i64 %getnode_sp, %4
  %sl_ptr = inttoptr i64 %5 to i64*
  store i64 %1, i64* %sl_ptr, align 4
  %6 = load i64, i64* @getnode_framesize_global, align 4
  %7 = add i64 %6, 16
  %8 = add i64 %getnode_sp, %7
  %9 = inttoptr i64 %8 to i32*
  store i32 %2, i32* %9, align 4
  %10 = call i64 @alloc_record(i32 24)
  %11 = inttoptr i64 %10 to %MyStruct*
  %12 = load i64, i64* @getnode_framesize_global, align 4
  %13 = add i64 %12, 16
  %14 = add i64 %getnode_sp, %13
  %getnode_i_ptr = inttoptr i64 %14 to i32*
  %15 = getelementptr %MyStruct, %MyStruct* %11, i32 0, i32 0
  %16 = load i32, i32* %getnode_i_ptr, align 4
  store i32 %16, i32* %15, align 4
  %17 = getelementptr %MyStruct, %MyStruct* %11, i32 0, i32 1
  %18 = bitcast %MyStruct** %17 to i64*
  store i64 0, i64* %18, align 4
  %19 = getelementptr %MyStruct, %MyStruct* %11, i32 0, i32 2
  %20 = bitcast %MyStruct** %19 to i64*
  store i64 0, i64* %20, align 4
  ret %MyStruct* %11
}

define void @f(i64 %0, i64 %1, i32 %2) {
f:
  %f_local_framesize = load i64, i64* @f_framesize_global, align 4
  %f_sp = sub i64 %0, %f_local_framesize
  %3 = load i64, i64* @f_framesize_global, align 4
  %4 = add i64 %3, 8
  %5 = add i64 %f_sp, %4
  %sl_ptr = inttoptr i64 %5 to i64*
  store i64 %1, i64* %sl_ptr, align 4
  %6 = load i64, i64* @f_framesize_global, align 4
  %7 = add i64 %6, 16
  %8 = add i64 %f_sp, %7
  %9 = inttoptr i64 %8 to i32*
  store i32 %2, i32* %9, align 4
  br label %if_test

if_test:                                          ; preds = %f
  %10 = load i64, i64* @f_framesize_global, align 4
  %11 = add i64 %10, 16
  %12 = add i64 %f_sp, %11
  %f_i_ptr = inttoptr i64 %12 to i32*
  %13 = load i32, i32* %f_i_ptr, align 4
  %14 = icmp sgt i32 %13, 0
  br i1 %14, label %if_then, label %if_next

if_then:                                          ; preds = %if_test
  %15 = load i64, i64* @f_framesize_global, align 4
  %16 = add i64 %15, 16
  %17 = add i64 %f_sp, %16
  %f_i_ptr1 = inttoptr i64 %17 to i32*
  %18 = load i32, i32* %f_i_ptr1, align 4
  %19 = sdiv i32 %18, 10
  %20 = load i64, i64* @f_framesize_global, align 4
  %21 = add i64 %20, 8
  %22 = add i64 %f_sp, %21
  %23 = inttoptr i64 %22 to i64*
  %24 = load i64, i64* %23, align 4
  call void @f(i64 %f_sp, i64 %24, i32 %19)
  %25 = load i64, i64* @f_framesize_global, align 4
  %26 = add i64 %25, 16
  %27 = add i64 %f_sp, %26
  %f_i_ptr2 = inttoptr i64 %27 to i32*
  %28 = load i64, i64* @f_framesize_global, align 4
  %29 = add i64 %28, 16
  %30 = add i64 %f_sp, %29
  %f_i_ptr3 = inttoptr i64 %30 to i32*
  %31 = load i32, i32* %f_i_ptr3, align 4
  %32 = sdiv i32 %31, 10
  %33 = mul i32 %32, 10
  %34 = load i32, i32* %f_i_ptr2, align 4
  %35 = sub i32 %34, %33
  %36 = call i32 @ord(%string* @str)
  %37 = add i32 %35, %36
  %38 = call %string* @chr(i32 %37)
  call void @print(%string* %38)
  br label %if_next

if_next:                                          ; preds = %if_then, %if_test
  ret void
}

; ===== Frame Information =====
; tigermain -16 48
; insert 0 32
; printint 0 24
; printtree 0 24
; getnode 0 16
; f 0 24
