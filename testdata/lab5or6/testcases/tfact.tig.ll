; ModuleID = 'tiger-program'
source_filename = "tfact.tig"

declare void @flush()

declare void @exit(i32)

declare ptr @chr(i32)

declare ptr @__wrap_getchar()

declare void @print(ptr)

declare void @printi(i32)

declare i32 @ord(ptr)

declare i32 @size(ptr)

declare ptr @concat(ptr, ptr)

declare ptr @substring(ptr, i32, i32)

declare i64 @alloc_record(i32)

declare i64 @init_array(i32, i64)

declare i1 @string_equal(ptr, ptr)

declare ptr @tiger.allocai(i64, i64)

declare i64 @tiger.readsp()

define i32 @tigermain(i64 %0, i64 %1) {
tigermain:
  %sl_to_pass = call i64 @tiger.readsp()
  %2 = call i32 @nfactor(i64 %sl_to_pass, i32 10)
  call void @printi(i32 %2)
  ret i32 0
}

define i32 @nfactor(i64 %0, i32 %1) {
nfactor:
  %sl = call ptr @tiger.allocai(i64 8, i64 0)
  store i64 %0, ptr %sl, align 4
  %n = call ptr @tiger.allocai(i64 8, i64 8)
  store i32 %1, ptr %n, align 4
  br label %if_test

if_test:                                          ; preds = %nfactor
  %2 = load i32, ptr %n, align 4
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %if_then, label %if_else

if_then:                                          ; preds = %if_test
  br label %if_next

if_else:                                          ; preds = %if_test
  %sl_to_pass = load i64, ptr %sl, align 4
  %4 = load i32, ptr %n, align 4
  %5 = sub i32 %4, 1
  %6 = call i32 @nfactor(i64 %sl_to_pass, i32 %5)
  %7 = load i32, ptr %n, align 4
  %8 = mul i32 %7, %6
  br label %if_next

if_next:                                          ; preds = %if_else, %if_then
  %9 = phi i32 [ 1, %if_then ], [ %8, %if_else ]
  ret i32 %9
}
