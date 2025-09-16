; ModuleID = 'lightir'
source_filename = "lightir"
target triple = "x86_64-pc-linux-gnu"

%string = type { i32, i8* }

@tigermain_framesize_global = constant i64 80
@patchtest_framesize_global = constant i64 16
@0 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
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
  %3 = call i32 @patchtest(i64 %tigermain_sp, i64 %tigermain_sp, i32 9, i32 4, i32 3, i32 2, i32 11, i32 11, i32 23, i32 45)
  call void @printi(i32 %3)
  call void @print(%string* @str)
  %4 = call i32 @patchtest(i64 %tigermain_sp, i64 %tigermain_sp, i32 4, i32 9, i32 3, i32 2, i32 11, i32 11, i32 23, i32 23)
  call void @printi(i32 %4)
  ret i32 0
}

define i32 @patchtest(i64 %0, i64 %1, i32 %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7, i32 %8, i32 %9) {
patchtest:
  %patchtest_local_framesize = load i64, i64* @patchtest_framesize_global, align 4
  %patchtest_sp = sub i64 %0, %patchtest_local_framesize
  %10 = load i64, i64* @patchtest_framesize_global, align 4
  %11 = add i64 %10, 8
  %12 = add i64 %patchtest_sp, %11
  %sl_ptr = inttoptr i64 %12 to i64*
  store i64 %1, i64* %sl_ptr, align 4
  %13 = load i64, i64* @patchtest_framesize_global, align 4
  %14 = add i64 %13, 16
  %15 = add i64 %patchtest_sp, %14
  %16 = inttoptr i64 %15 to i32*
  store i32 %2, i32* %16, align 4
  %17 = load i64, i64* @patchtest_framesize_global, align 4
  %18 = add i64 %17, 24
  %19 = add i64 %patchtest_sp, %18
  %20 = inttoptr i64 %19 to i32*
  store i32 %3, i32* %20, align 4
  %21 = load i64, i64* @patchtest_framesize_global, align 4
  %22 = add i64 %21, 32
  %23 = add i64 %patchtest_sp, %22
  %24 = inttoptr i64 %23 to i32*
  store i32 %4, i32* %24, align 4
  %25 = load i64, i64* @patchtest_framesize_global, align 4
  %26 = add i64 %25, 40
  %27 = add i64 %patchtest_sp, %26
  %28 = inttoptr i64 %27 to i32*
  store i32 %5, i32* %28, align 4
  %29 = load i64, i64* @patchtest_framesize_global, align 4
  %30 = add i64 %29, 48
  %31 = add i64 %patchtest_sp, %30
  %32 = inttoptr i64 %31 to i32*
  store i32 %6, i32* %32, align 4
  %33 = load i64, i64* @patchtest_framesize_global, align 4
  %34 = add i64 %33, 56
  %35 = add i64 %patchtest_sp, %34
  %36 = inttoptr i64 %35 to i32*
  store i32 %7, i32* %36, align 4
  %37 = load i64, i64* @patchtest_framesize_global, align 4
  %38 = add i64 %37, 64
  %39 = add i64 %patchtest_sp, %38
  %40 = inttoptr i64 %39 to i32*
  store i32 %8, i32* %40, align 4
  %41 = load i64, i64* @patchtest_framesize_global, align 4
  %42 = add i64 %41, 72
  %43 = add i64 %patchtest_sp, %42
  %44 = inttoptr i64 %43 to i32*
  store i32 %9, i32* %44, align 4
  br label %if_test

if_test:                                          ; preds = %patchtest
  %45 = load i64, i64* @patchtest_framesize_global, align 4
  %46 = add i64 %45, 16
  %47 = add i64 %patchtest_sp, %46
  %patchtest_a_ptr = inttoptr i64 %47 to i32*
  %48 = load i64, i64* @patchtest_framesize_global, align 4
  %49 = add i64 %48, 24
  %50 = add i64 %patchtest_sp, %49
  %patchtest_b_ptr = inttoptr i64 %50 to i32*
  %51 = load i32, i32* %patchtest_a_ptr, align 4
  %52 = load i32, i32* %patchtest_b_ptr, align 4
  %53 = icmp sgt i32 %51, %52
  br i1 %53, label %opor_next, label %opor_right_test

if_then:                                          ; preds = %opor_next2
  %54 = load i64, i64* @patchtest_framesize_global, align 4
  %55 = add i64 %54, 16
  %56 = add i64 %patchtest_sp, %55
  %patchtest_a_ptr3 = inttoptr i64 %56 to i32*
  %57 = load i64, i64* @patchtest_framesize_global, align 4
  %58 = add i64 %57, 40
  %59 = add i64 %patchtest_sp, %58
  %patchtest_d_ptr4 = inttoptr i64 %59 to i32*
  %60 = load i32, i32* %patchtest_a_ptr3, align 4
  %61 = load i32, i32* %patchtest_d_ptr4, align 4
  %62 = add i32 %60, %61
  %63 = load i64, i64* @patchtest_framesize_global, align 4
  %64 = add i64 %63, 48
  %65 = add i64 %patchtest_sp, %64
  %patchtest_e_ptr5 = inttoptr i64 %65 to i32*
  %66 = load i32, i32* %patchtest_e_ptr5, align 4
  %67 = add i32 %62, %66
  %68 = load i64, i64* @patchtest_framesize_global, align 4
  %69 = add i64 %68, 72
  %70 = add i64 %patchtest_sp, %69
  %patchtest_h_ptr6 = inttoptr i64 %70 to i32*
  %71 = load i32, i32* %patchtest_h_ptr6, align 4
  %72 = add i32 %67, %71
  br label %if_next

if_else:                                          ; preds = %opor_next2
  %73 = load i64, i64* @patchtest_framesize_global, align 4
  %74 = add i64 %73, 32
  %75 = add i64 %patchtest_sp, %74
  %patchtest_c_ptr7 = inttoptr i64 %75 to i32*
  %76 = load i64, i64* @patchtest_framesize_global, align 4
  %77 = add i64 %76, 24
  %78 = add i64 %patchtest_sp, %77
  %patchtest_b_ptr8 = inttoptr i64 %78 to i32*
  %79 = load i32, i32* %patchtest_c_ptr7, align 4
  %80 = load i32, i32* %patchtest_b_ptr8, align 4
  %81 = add i32 %79, %80
  %82 = load i64, i64* @patchtest_framesize_global, align 4
  %83 = add i64 %82, 64
  %84 = add i64 %patchtest_sp, %83
  %patchtest_g_ptr9 = inttoptr i64 %84 to i32*
  %85 = load i32, i32* %patchtest_g_ptr9, align 4
  %86 = add i32 %81, %85
  %87 = load i64, i64* @patchtest_framesize_global, align 4
  %88 = add i64 %87, 56
  %89 = add i64 %patchtest_sp, %88
  %patchtest_f_ptr10 = inttoptr i64 %89 to i32*
  %90 = load i32, i32* %patchtest_f_ptr10, align 4
  %91 = add i32 %86, %90
  br label %if_next

if_next:                                          ; preds = %if_else, %if_then
  %92 = phi i32 [ %72, %if_then ], [ %91, %if_else ]
  ret i32 %92

opor_right_test:                                  ; preds = %if_test
  %93 = load i64, i64* @patchtest_framesize_global, align 4
  %94 = add i64 %93, 32
  %95 = add i64 %patchtest_sp, %94
  %patchtest_c_ptr = inttoptr i64 %95 to i32*
  %96 = load i64, i64* @patchtest_framesize_global, align 4
  %97 = add i64 %96, 40
  %98 = add i64 %patchtest_sp, %97
  %patchtest_d_ptr = inttoptr i64 %98 to i32*
  %99 = load i32, i32* %patchtest_c_ptr, align 4
  %100 = load i32, i32* %patchtest_d_ptr, align 4
  %101 = icmp slt i32 %99, %100
  br i1 %101, label %opand_right_test, label %opand_next

opor_next:                                        ; preds = %opand_next, %if_test
  %102 = phi i1 [ true, %if_test ], [ %112, %opand_next ]
  br i1 %102, label %opor_next2, label %opor_right_test1

opand_right_test:                                 ; preds = %opor_right_test
  %103 = load i64, i64* @patchtest_framesize_global, align 4
  %104 = add i64 %103, 48
  %105 = add i64 %patchtest_sp, %104
  %patchtest_e_ptr = inttoptr i64 %105 to i32*
  %106 = load i64, i64* @patchtest_framesize_global, align 4
  %107 = add i64 %106, 56
  %108 = add i64 %patchtest_sp, %107
  %patchtest_f_ptr = inttoptr i64 %108 to i32*
  %109 = load i32, i32* %patchtest_e_ptr, align 4
  %110 = load i32, i32* %patchtest_f_ptr, align 4
  %111 = icmp eq i32 %109, %110
  br label %opand_next

opand_next:                                       ; preds = %opand_right_test, %opor_right_test
  %112 = phi i1 [ false, %opor_right_test ], [ %111, %opand_right_test ]
  br label %opor_next

opor_right_test1:                                 ; preds = %opor_next
  %113 = load i64, i64* @patchtest_framesize_global, align 4
  %114 = add i64 %113, 64
  %115 = add i64 %patchtest_sp, %114
  %patchtest_g_ptr = inttoptr i64 %115 to i32*
  %116 = load i64, i64* @patchtest_framesize_global, align 4
  %117 = add i64 %116, 72
  %118 = add i64 %patchtest_sp, %117
  %patchtest_h_ptr = inttoptr i64 %118 to i32*
  %119 = load i32, i32* %patchtest_g_ptr, align 4
  %120 = load i32, i32* %patchtest_h_ptr, align 4
  %121 = icmp ne i32 %119, %120
  br label %opor_next2

opor_next2:                                       ; preds = %opor_right_test1, %opor_next
  %122 = phi i1 [ true, %opor_next ], [ %121, %opor_right_test1 ]
  br i1 %122, label %if_then, label %if_else
}

; ===== Frame Information =====
; tigermain 0 80
; patchtest 0 16
